
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})
vim.lsp.config('jdtls')
--vim.lsp.config('clangd', {
--cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
  --init_options = {
    --fallbackFlags = { '-std=c++17' },
  --},
--})

--vim.lsp.config('cmake-language-server')
vim.lsp.config('docker-language-server')
vim.lsp.config('gopls')
vim.lsp.config('vscode-html-languageserver')
vim.lsp.config('Java Compiler (javac) API-based Java support')
vim.lsp.config('Pyright')
vim.lsp.config('rust_analyzer')
vim.lsp.config['lua_ls'] = {
       -- Command and arguments to start the server.
      cmd = { 'lua-language-server' },
       -- Filetypes to automatically attach to.
       filetypes = { 'lua' },
       -- Sets the "workspace" to the directory where any of these files is found.
       -- Files that share a root directory will reuse the LSP server connection.
       -- Nested lists indicate equal priority, see |vim.lsp.Config|.
       root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
       -- Specific settings to send to the server. The schema is server-defined.
       -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
       settings = {
         Lua = {
           runtime = {
             version = 'LuaJIT',
           }
         }
       }
     }

