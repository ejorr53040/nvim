-- ================================================================================================
-- TITLE : clangd (C/C++ Language Server) LSP Setup
-- LINKS :
--   > website: https://clangd.llvm.org/
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	local clangd_cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--offset-encoding=utf-16",
	}

	-- Let clangd ask the installed compiler where its standard headers live.
	local compiler_drivers = {}
	for _, compiler in ipairs({ "clang++", "g++", "c++", "gcc", "cc" }) do
		local compiler_path = vim.fn.exepath(compiler)
		if compiler_path ~= "" then
			table.insert(compiler_drivers, compiler_path)
		end
	end
	if #compiler_drivers > 0 then
		table.insert(clangd_cmd, "--query-driver=" .. table.concat(compiler_drivers, ","))
	end

	vim.lsp.config("clangd", {
		capabilities = capabilities,
		cmd = clangd_cmd,
		filetypes = { "c", "cpp", "objc", "objcpp" },
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, {
				"compile_commands.json",
				"compile_flags.txt",
				".clangd",
				".git",
			})
			on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
		end,
		-- Used only when the project has no compilation database.
		fallbackFlags = { "-std=c++17" },
	})
end
