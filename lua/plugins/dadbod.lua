-- ================================================================================================
-- TITLE : vim-dadbod-ui
-- ABOUT : Database browser/query UI (:DBUI, <leader>D). Opening a .db/.sqlite file shows it in the drawer.
-- LINKS :
--   > github : https://github.com/kristijanhusak/vim-dadbod-ui
-- ================================================================================================

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		"tpope/vim-dadbod",
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
	},
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	keys = {
		{ "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle database UI" },
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1

		-- SQLite files are binary: instead of showing garbage, register the file as a connection and open DBUI.
		vim.api.nvim_create_autocmd("BufReadCmd", {
			pattern = { "*.db", "*.sqlite", "*.sqlite3" },
			callback = function(ev)
				local path = vim.fn.fnamemodify(ev.file, ":p")
				local dbs = vim.g.dbs or {}
				dbs[vim.fn.fnamemodify(path, ":t")] = "sqlite:" .. path
				vim.g.dbs = dbs
				vim.schedule(function()
					pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
					pcall(vim.fn["db_ui#reset_state"]) -- re-read g:dbs if DBUI was already open
					vim.cmd("DBUI")
				end)
			end,
		})
	end,
}
