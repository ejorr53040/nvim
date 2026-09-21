local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ocamllsp, dune, ocamlformat and earlybird live in the default opam switch. Add it to PATH so
-- neovim finds them without needing `eval $(opam env)` in the shell that launched it.
local opam_bin = vim.fn.expand("~/.opam/default/bin")
if vim.uv.fs_stat(opam_bin) and not vim.env.PATH:find(opam_bin, 1, true) then
  vim.env.PATH = vim.env.PATH .. ":" .. opam_bin
end

-- Language Server Protocol (LSP)
require("lsp.lua_ls")(capabilities)
require("lsp.pyright")(capabilities)
require("lsp.ruff")(capabilities)
require("lsp.gopls")(capabilities)
require("lsp.jsonls")(capabilities)
require("lsp.ts_ls")(capabilities)
require("lsp.bashls")(capabilities)
require("lsp.clangd")(capabilities)
require("lsp.rust_analyzer")(capabilities)
require("lsp.ocamllsp")(capabilities)
require("lsp.dockerls")(capabilities)
require("lsp.yamlls")(capabilities)
require("lsp.tailwindcss")(capabilities)

-- Linters & Formatters
require("lsp.efm-langserver")(capabilities)

-- jdtls is enabled by nvim-java (lua/plugins/java.lua), which has to configure it first
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ruff",
  "gopls",
  "jsonls",
  "ts_ls",
  "bashls",
  "clangd",
  "rust_analyzer",
  "ocamllsp",
  "dockerls",
  "emmet_ls",
  "yamlls",
  "tailwindcss",
  "efm",
})
