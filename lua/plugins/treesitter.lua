-- nvim-treesitter (main branch): only installs parsers/queries. Highlighting, indent and selection
-- are enabled below through Neovim's built-in treesitter support.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- the main branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "python",
      "java",
      "go",
      "rust",
      "ocaml",
      "ocaml_interface",
      "cpp",
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "bash",
      "json",
      "yaml",
      "toml",
      "html",
      "javascript",
      "typescript",
      "tsx",
      "regex",
      "diff",
    }

    -- no-op for parsers that are already installed; runs asynchronously
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterStart", {}),
      callback = function(args)
        -- errors when no parser exists for this filetype (help, quickfix, ...), which is fine
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- incremental selection on top of the built-in `an` / `in` treesitter selection
    vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Select node" })
    vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Select parent node" })
    vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Select child node" })
  end,
}
