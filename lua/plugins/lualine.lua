-- Styled after herdr's "terminal" theme: transparent bars, active item = dark text on a blue block.
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local blue, black, dim, fg = '#83a598', '#282828', '#7c6f64', '#ebdbb2'
    local active = { fg = black, bg = blue, gui = 'bold' }
    local plain = { fg = fg, bg = 'NONE' }
    local muted = { fg = dim, bg = 'NONE' }

    local theme = {}
    for _, m in ipairs({ 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }) do
      theme[m] = { a = active, b = plain, c = muted, x = muted, y = muted, z = plain }
    end
    theme.inactive.a = muted

    require('lualine').setup {
      options = {
        theme = theme,
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { { 'mode', padding = { left = 1, right = 1 } } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress', 'location' },
        lualine_z = { function() return vim.uv.os_gethostname() end },
      },
      -- herdr tab bar: tabs on the left (active one highlighted), hostname on the right
      tabline = {
        lualine_a = { { 'tabs', mode = 2, tabs_color = { active = active, inactive = muted } } },
        lualine_z = { function() return vim.uv.os_gethostname() end },
      },
    }

    -- thin single-line dividers, no frame (pane_gaps / pane_outer_borders = false)
    vim.opt.laststatus = 3
    vim.opt.fillchars:append({ vert = '│', horiz = '─', horizup = '┴', horizdown = '┬', vertleft = '┤', vertright = '├', verthoriz = '┼' })
    local function seps()
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = dim, bg = 'NONE' })
    end
    seps()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = seps })
  end,
}
