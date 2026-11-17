-- ================================================================================================
-- TITLE : sniprun
-- ABOUT : Run a visual selection (or line) in place; output shows as virtual text / float.
--         Look up a selection on the web with <leader>sl (vim.ui.open, no plugin needed).
-- LINKS :
--   > github : https://github.com/michaelb/sniprun
-- ================================================================================================

return {
	"michaelb/sniprun",
	branch = "master",
	build = "sh install.sh", -- downloads a prebuilt binary, compiles with cargo only as a fallback
	opts = {
		display = { "VirtualTextOk", "VirtualTextErr", "Floating" },
	},
	keys = {
		{ "<leader>sr", "<Plug>SnipRun", mode = "v", desc = "Run selected snippet" },
		{ "<leader>sr", "<Plug>SnipRun", desc = "Run current line" },
		{ "<leader>sc", "<Plug>SnipClose", desc = "Clear snippet output" },
		{
			"<leader>sl",
			function()
				local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }), " ")
				vim.ui.open("https://duckduckgo.com/?q=" .. vim.uri_encode(vim.bo.filetype .. " " .. text, "rfc3986"))
			end,
			mode = "v",
			desc = "Look up selection on the web",
		},
	},
}
