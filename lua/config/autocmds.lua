-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================
local on_attach = require("utils.lsp").on_attach

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

-- format on save. Languages with a native formatter use their own server, everything else goes
-- through efm langserver and its configured formatters. Java is left out (jdtls would apply
-- Eclipse's default style); format it on demand with vim.lsp.buf.format().
local formatter_for = {
	python = "ruff",
	c = "clangd",
	cpp = "clangd",
	objc = "clangd",
	objcpp = "clangd",
	rust = "rust_analyzer",
	ocaml = "ocamllsp",
}
local lsp_fmt_group = vim.api.nvim_create_augroup("FormatOnSaveGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "java" then
			return
		end
		-- ocamlformat refuses to run outside a project that has a .ocamlformat file
		if ft == "ocaml" and not vim.fs.root(args.buf, ".ocamlformat") then
			return
		end
		local name = formatter_for[ft] or "efm"
		if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = args.buf, name = name })) then
			return
		end
		-- must be synchronous: an async format would land after the buffer has already been written
		vim.lsp.buf.format({ bufnr = args.buf, name = name, timeout_ms = 2000 })
	end,
})

-- on attach function shortcuts
local lsp_on_attach_group = vim.api.nvim_create_augroup("LspMappings", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_on_attach_group,
	callback = on_attach,
})

-- custom options for text/markdown files
local markdown_options = vim.api.nvim_create_augroup("MardownOptions", {})
vim.api.nvim_create_autocmd("FileType", {
	group = markdown_options,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.cursorline = false
		vim.opt_local.colorcolumn = ""
		vim.opt_local.signcolumn = "no"
	end,
})
