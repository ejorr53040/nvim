-- ================================================================================================
-- TITLE : pyright (Python Language Server) LSP Setup
-- ABOUT : type checking and navigation. Linting, formatting and import sorting come from ruff.
-- LINKS :
--   > github: https://github.com/microsoft/pyright
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil This function doesn't return a value, it configures the LSP server
return function(capabilities)
	vim.lsp.config("pyright", {
		capabilities = capabilities,
		-- Point pyright at the project's virtualenv: an activated one ($VIRTUAL_ENV) or .venv/venv in the root.
		before_init = function(_, config)
			local venv = vim.env.VIRTUAL_ENV
			if not venv or venv == "" then
				for _, name in ipairs({ ".venv", "venv" }) do
					local candidate = vim.fs.joinpath(config.root_dir or vim.uv.cwd(), name)
					if vim.uv.fs_stat(candidate) then
						venv = candidate
						break
					end
				end
			end
			if venv and venv ~= "" then
				config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
					python = { pythonPath = vim.fs.joinpath(venv, "bin", "python") },
				})
			end
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
