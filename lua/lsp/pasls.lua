-- ================================================================================================
-- TITLE : pasls (Pascal Language Server) LSP Setup
-- ABOUT : completion, navigation and diagnostics for Free Pascal / Object Pascal via Lazarus
--         CodeTools. Built from source into ~/.local/bin/pasls (see ~/.local/src/pascal-language-server).
--         It has no textDocument/formatting; <leader>cf runs its Jedi Code Formatter command instead.
-- LINKS :
--   > github: https://github.com/genericptr/pascal-language-server
-- ================================================================================================

-- .pp is the FPC unit extension; neovim maps it to puppet by default
vim.filetype.add({ extension = { pp = "pascal" } })

local jcf_config = vim.fs.joinpath(vim.fn.stdpath("config"), "jcfsettings.cfg")

--- @param capabilities table LSP client capabilities
--- @return nil
return function(capabilities)
	vim.lsp.config("pasls", {
		capabilities = capabilities,
		cmd = { vim.fn.expand("~/.local/bin/pasls") },
		cmd_env = {
			FPCDIR = "/usr/lib/fpc/src", -- from the fpc-src package; CodeTools needs the RTL sources
			PP = vim.fn.exepath("fpc"),
			LAZARUSDIR = vim.fn.expand("~/.local/src/lazarus"),
		},
		filetypes = { "pascal" },
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, function(name)
				return name:match("%.lp[ik]$") or name == ".git" or name == "Makefile"
			end)
			on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
		end,
		-- lets CodeTools resolve units in the usual src/ layout; $(root) is expanded by pasls
		init_options = { fpcOptions = { "-Fu$(root)/src", "-Mobjfpc", "-Sh" } },
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>cf", function()
				vim.cmd.write() -- the formatter works on the file on disk, then applies its edits
				client:exec_cmd({
					title = "Format",
					command = "pasls.formatCode",
					arguments = { vim.uri_from_bufnr(bufnr), vim.uri_from_fname(jcf_config) },
				}, { bufnr = bufnr })
			end, { buffer = bufnr, desc = "Pascal: format (JCF)" })
		end,
	})
end
