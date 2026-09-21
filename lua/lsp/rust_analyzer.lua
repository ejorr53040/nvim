-- ================================================================================================
-- TITLE : rust-analyzer (Rust Language Server) LSP Setup
-- LINKS :
--   > website: https://rust-analyzer.github.io/
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config("rust_analyzer", {
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				-- run clippy instead of `cargo check` when it is installed
				check = { command = vim.fn.executable("cargo-clippy") == 1 and "clippy" or "check" },
			},
		},
	})
end
