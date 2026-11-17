-- ================================================================================================
-- TITLE : pyright (Python Language Server) LSP Setup
-- ABOUT : type checking and navigation. Linting, formatting and import sorting come from ruff.
-- LINKS :
--   > github: https://github.com/microsoft/pyright
-- ================================================================================================

-- A venv's interpreter, or nil if it is missing. fs_stat follows symlinks, so a dangling one (e.g. the system
-- python it was built on was upgraded away) counts as missing.
local function venv_python(venv)
	local python = vim.fs.joinpath(venv, "bin", "python")
	return vim.uv.fs_stat(python) and python or nil
end

-- A venv directly inside `dir`: .venv / venv first, then any child directory with a pyvenv.cfg (e.g. dbenv).
local function find_venv_in(dir)
	for _, name in ipairs({ ".venv", "venv" }) do
		local python = venv_python(vim.fs.joinpath(dir, name))
		if python then
			return python
		end
	end
	for name, type in vim.fs.dir(dir) do
		local child = vim.fs.joinpath(dir, name)
		if type == "directory" and vim.uv.fs_stat(vim.fs.joinpath(child, "pyvenv.cfg")) then
			local python = venv_python(child)
			if python then
				return python
			end
		end
	end
end

-- Walk from the file's directory up to the project root, so a venv next to the file wins over one further up.
local function find_python(start, root)
	local home = vim.uv.os_homedir()
	local dir = start
	while dir and dir ~= "/" and dir ~= home do
		local python = find_venv_in(dir)
		if python then
			return python
		end
		if dir == root then
			break
		end
		dir = vim.fs.dirname(dir)
	end
end

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil This function doesn't return a value, it configures the LSP server
return function(capabilities)
	vim.lsp.config("pyright", {
		capabilities = capabilities,
		-- Point pyright at a working virtualenv: an activated one ($VIRTUAL_ENV), else one found near the file.
		before_init = function(_, config)
			local python
			local active = vim.env.VIRTUAL_ENV
			if active and active ~= "" then
				python = venv_python(active) -- ignored when stale, so it can't shadow a usable venv
			end
			if not python then
				local name = vim.api.nvim_buf_get_name(0)
				local start = name ~= "" and vim.fs.dirname(name) or config.root_dir or vim.uv.cwd()
				python = find_python(start, config.root_dir)
			end
			-- Mutate in place: the client already holds this table and answers pyright's workspace/configuration
			-- requests from it, so assigning a fresh table to config.settings would never reach the server.
			config.settings.python = config.settings.python or {}
			config.settings.python.pythonPath = python
		end,
		settings = {
			pyright = {
				disableOrganizeImports = true, -- ruff organizes imports
			},
			-- pyright reads these from `python.analysis`, not `pyright.analysis`
			python = {
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletions = true,
				},
			},
		},
	})
end
