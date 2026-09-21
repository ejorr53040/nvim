-- ================================================================================================
-- TITLE : ruff (Python linter/formatter) LSP Setup
-- ABOUT : lint diagnostics, formatting and import sorting for python. Replaces flake8 + black.
-- LINKS :
--   > github: https://github.com/astral-sh/ruff
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config("ruff", {
		capabilities = capabilities,
		on_attach = function(client)
			-- let pyright provide hover
			client.server_capabilities.hoverProvider = false
		end,
	})
end
