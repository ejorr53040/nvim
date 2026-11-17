-- ================================================================================================
-- TITLE : herdr session restore
-- ABOUT : when nvim runs straight from a shell in a herdr pane, keep a :mksession file for it and
--         report `nvim -S <file>` to herdr as the pane's resume command, so a herdr server restart
--         reopens nvim with the same buffers, splits and tabs. Uses herdr's "report the resume
--         command" API (herdr >= 0.9.2); older herdr is detected and left alone.
-- ================================================================================================
local M = {}

local SOURCE = "nvim-session"
local AGENT = "nvim"
local MIN_HERDR = { 0, 9, 2 }
local SHELLS = { bash = true, zsh = true, fish = true, sh = true, dash = true, ksh = true, nu = true }
local STALE_SECONDS = 30 * 24 * 3600

M.dir = vim.fn.stdpath("state") .. "/herdr-sessions"

local bin, pane = vim.env.HERDR_BIN_PATH, vim.env.HERDR_PANE_ID
local file -- session file for this nvim; nil until the pane is claimed

-- Strictly increasing across nvim restarts, as herdr requires of --seq.
local function seq()
	local sec, usec = vim.uv.gettimeofday()
	return string.format("%d%06d", sec, usec)
end

local function parent_of(pid)
	local f = io.open("/proc/" .. pid .. "/stat")
	if not f then
		return nil
	end
	local stat = f:read("*a")
	f:close()
	-- comm may contain spaces/parens, so read the fields after the last ')'
	return tonumber(stat:match("%)%s+%S+%s+(%d+)"))
end

local function comm_of(pid)
	local f = io.open("/proc/" .. pid .. "/comm")
	if not f then
		return nil
	end
	local comm = f:read("*l")
	f:close()
	return comm
end

-- True when the user typed `nvim` at a shell prompt (or herdr ran our resume command). False when
-- nvim is someone's $EDITOR (git commit, omp, herdr's edit_scrollback), which must not take over
-- the pane. The Lua side runs in nvim's embedded server, whose parent is the nvim TUI process.
function M.launched_from_shell()
	local ppid = vim.uv.os_getppid()
	if comm_of(ppid) == "nvim" then
		ppid = parent_of(ppid)
	end
	return ppid ~= nil and SHELLS[comm_of(ppid)] == true
end

function M.version_ok(version_output)
	local v = { (version_output or ""):match("(%d+)%.(%d+)%.(%d+)") }
	if #v ~= 3 then
		return false
	end
	for i = 1, 3 do
		local n = tonumber(v[i])
		if n ~= MIN_HERDR[i] then
			return n > MIN_HERDR[i]
		end
	end
	return true
end

-- Another agent (omp, claude, ...) already owns the pane: nvim was opened from inside it.
function M.pane_owned_by_other(pane_get_output)
	local ok, decoded = pcall(vim.json.decode, pane_get_output or "")
	if not ok or type(decoded) ~= "table" then
		return true
	end
	local info = vim.tbl_get(decoded, "result", "pane")
	if not info then
		return true
	end
	local agent = info.agent
	return agent ~= nil and agent ~= vim.NIL and agent ~= AGENT
end

function M.save()
	if not file then
		return
	end
	local saved = vim.o.sessionoptions
	-- no terminal/help/blank windows: they come back as empty or dead buffers
	vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize"
	pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(file))
	vim.o.sessionoptions = saved
end

local function report()
	vim.system({
		bin, "pane", "report-agent", pane,
		"--source", SOURCE,
		"--agent", AGENT,
		"--state", "idle",
		"--seq", seq(),
		"--agent-session-path", file,
		"--", "nvim", "-S", file,
	}, { timeout = 2000 })
end

local function release()
	vim.system({ bin, "pane", "release-agent", pane, "--source", SOURCE, "--agent", AGENT, "--seq", seq() })
		:wait(1000)
end

local function prune_stale()
	local now = os.time()
	for name, kind in vim.fs.dir(M.dir) do
		local path = M.dir .. "/" .. name
		local stat = kind == "file" and vim.uv.fs_stat(path)
		if stat and now - stat.mtime.sec > STALE_SECONDS then
			os.remove(path)
		end
	end
end

local function claim()
	vim.fn.mkdir(M.dir, "p")
	prune_stale()
	-- a herdr restore runs `nvim -S <file>`; keep writing to that same file
	if vim.v.this_session ~= "" and vim.startswith(vim.v.this_session, M.dir .. "/") then
		file = vim.v.this_session
	else
		file = string.format("%s/%s-%d-%d.vim", M.dir, pane:gsub("[^%w]", "_"), os.time(), vim.uv.os_getpid())
	end
	if file:find("'") then -- herdr rejects resume arguments containing apostrophes
		file = nil
		return
	end
	M.save()
	report()

	local group = vim.api.nvim_create_augroup("HerdrSession", {})
	local timer = assert(vim.uv.new_timer())
	vim.api.nvim_create_autocmd(
		{ "BufWinEnter", "BufWritePost", "WinClosed", "TabNewEntered", "TabClosed", "VimResized", "FocusLost", "CursorHold" },
		{
			group = group,
			callback = function()
				timer:start(2000, 0, vim.schedule_wrap(M.save))
			end,
		}
	)
	-- A herdr server stop closes the pty, and nvim then exits with v:dying == 0 just like a normal
	-- quit. Only a quit command (:q, :wq, :qa, :x, ZZ) fires QuitPre, so that marks a deliberate
	-- exit; the flag clears on the next loop tick when :q only closed a window.
	local quitting = false
	vim.api.nvim_create_autocmd("QuitPre", {
		group = group,
		callback = function()
			quitting = true
			vim.schedule(function()
				quitting = false
			end)
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			timer:stop()
			if not quitting then -- pane/server went away: keep the file so herdr can resume it
				M.save()
				return
			end
			release()
			os.remove(file)
		end,
	})
end

function M.setup()
	if vim.env.HERDR_ENV ~= "1" or not bin or not pane or not M.launched_from_shell() then
		return
	end
	vim.api.nvim_create_autocmd("UIEnter", {
		once = true,
		callback = function()
			vim.system({ bin, "--version" }, { text = true, timeout = 2000 }, function(v)
				if v.code ~= 0 or not M.version_ok(v.stdout) then
					return
				end
				vim.system({ bin, "pane", "get", pane }, { text = true, timeout = 2000 }, function(p)
					if p.code ~= 0 or M.pane_owned_by_other(p.stdout) then
						return
					end
					vim.schedule(claim)
				end)
			end)
		end,
	})
end

return M
