-- ================================================================================================
-- TITLE : nvim-lspconfig
-- ABOUT : Quickstart configurations for the built-in Neovim LSP client.
-- LINKS :
--   > github                  : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)        : https://github.com/mason-org/mason.nvim
--   > efmls-configs-nvim (dep): https://github.com/creativenull/efmls-configs-nvim
-- ================================================================================================

return {
	"neovim/nvim-lspconfig",
	lazy = false, -- servers must be configured and enabled at startup
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} }, -- LSP/DAP/Linter installer & manager
		"creativenull/efmls-configs-nvim", -- Preconfigured EFM Language Server setups
	},
	config = function()
		require("utils.diagnostics").setup()
		require("lsp")
	end,
}
