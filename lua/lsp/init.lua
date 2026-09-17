local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Language Server Protocol (LSP)
require("lsp.lua_ls")(capabilities)
require("lsp.pyright")(capabilities)
require("lsp.gopls")(capabilities)
require("lsp.jsonls")(capabilities)
require("lsp.ts_ls")(capabilities)
require("lsp.bashls")(capabilities)
require("lsp.clangd")(capabilities)
require("lsp.dockerls")(capabilities)
require("lsp.yamlls")(capabilities)
require("lsp.tailwindcss")(capabilities)

-- Linters & Formatters
require("lsp.efm-langserver")(capabilities)

vim.lsp.enable({
  'lua_ls',
  'pyright',
  'gopls',
  'jsonls',
  'ts_ls',
  'bashls',
  'clangd',
  'dockerls',
  'emmet_ls',
  'yamlls',
  'tailwindcss',
  'efm',
})
