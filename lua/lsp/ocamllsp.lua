-- ================================================================================================
-- TITLE : ocamllsp (OCaml Language Server) LSP Setup
-- ABOUT : installed with `opam install ocaml-lsp-server` (see lsp/init.lua for how it gets on PATH)
-- LINKS :
--   > github: https://github.com/ocaml/ocaml-lsp
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	-- filetypes and root markers (dune-project, *.opam, ...) come from nvim-lspconfig's defaults
	vim.lsp.config("ocamllsp", {
		capabilities = capabilities,
		settings = {
			extendedHover = { enable = true },
			syntaxDocumentation = { enable = true },
			inlayHints = {
				hintPatternVariables = true,
				hintLetBindings = true,
				hintFunctionParams = true,
			},
		},
	})
end
