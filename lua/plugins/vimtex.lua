return {
  "lervag/vimtex",
  lazy = false, -- vimtex needs to load before a .tex file is opened for ftplugin/syntax to attach
  init = function()
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_quickfix_mode = 0 -- don't yank focus to the quickfix window on warnings

    -- No external PDF viewer configured - this machine already has an in-Neovim
    -- PDF renderer (basola21/PDFview, see plugins/pdfview.lua) built on the same
    -- image.nvim/sixel pipeline used for markdown images, so we reuse that
    -- instead of shelling out to zathura/mupdf/etc.
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = ""
  end,
  config = function()
    -- After a successful compile, open the resulting PDF in PDFview automatically.
    vim.api.nvim_create_autocmd("User", {
      pattern = "VimtexEventCompileSuccess",
      callback = function()
        pcall(function()
          require("pdfview").open(vim.fn["vimtex#compiler#output"]())
        end)
      end,
    })
  end,
}
