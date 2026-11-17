return {
  "3rd/image.nvim",
  opts = {
    backend = "sixel", -- foot only implements Sixel, not the kitty graphics protocol
    processor = "magick_cli", -- shells out to the system `magick` binary, no luarocks needed
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = { enabled = false },
      typst = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = true,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
