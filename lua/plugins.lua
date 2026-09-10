return {
{
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
	config = function()
	local config = require("nvim-treesitter")
	config.setup({
		auto_install = true,
		highlight = {enable = true},
		indent = {enable = true},
	})
end
},

{
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup(--[[optional config]])
  end,
},
{
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false, -- NOTE: NO NEED to Lazy load
  -- Optional. You can also set your own keybindings
  keys = {
    -- Global Minimap Controls
    { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
    { "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
    { "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
    { "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

    -- Window-Specific Minimap Controls
    { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
    { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
    { "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
    { "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

    -- Tab-Specific Minimap Controls
    { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
    { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
    { "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
    { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

    -- Buffer-Specific Minimap Controls
    { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
    { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
    { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
    { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

    ---Focus Controls
    { "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
    { "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
    { "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
  },
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36 -- Set a large value

    --- Put your configuration here
    vim.g.neominimap = {
      auto_enable = true,
    }
  end,
},

{
  {
    "nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false
				}
			}
		},
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
},

{
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
},
{
"nvim-telescope/telescope-ui-select.nvim",
config = function()
-- This is your opts table
require("telescope").setup ({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
})
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
end
},
{
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[                                                                    
	                                                                                                    
                 ░▒▒▒▒▒▒▒▒▒▒▒▒▒▓         ░                                                          
                 ▒░▒▒▓▓▒▒▒▒▒▒▒▓▓▒▒▓                                                                 
                 ▒▒▒▒▒▒▓▓▒▒▒▒▒▓▓▓▒▒▒   ▒▒▒▒▒▒▒                                                      
                 ▒▒▒▒▒▓▓▓▓▓▒▒▒▒▒▓▒▒▒▒   ░▒▒▓▓▒▒▒▓                                    ░              
                ▒▒▒▒▒▒▒▒▓░▓▓▒▒▓▓▒░░░░   ░░▒▓▓▓▒▒▓▓  ▒            ░                                  
                ▒▒▒▒▒▒▒▒▒▓▓▓▒▓▓▓▒▓▒▒▒   ▒░░▒▓▓▓▒▓▓  ▒▒▒▒▒▒▒                                         
                ▒▒▒▒▒▒▒▒▒▒▒▓▒▓▓▒▓▓▓▓▒    ░░▒▓▓▒▒▓▓  ▒▒▓░▒▒░░░                                       
                   ▒▒▒▒▒░▒▒▒▓▓▓▒▓▓▓▒▓    ▒▒▓▓▓▒▓▓  ▒▒▒▓▓▒░░░░░▒  ▒░▒                                
               ▒         ░░░░░▓░▓▓▓▒▓▓  ▓▓▓▓█▓▓▒▓  ░▒▒▓▓▒░░░░░░   ░░░▒▒▒                            
              ▒▒▓▓▓▒        ▒▓▓▓░▓▓▓▓▓▓▓▓▓▓█▓▓▓▓  ▒░░▒▓▓▒░░░░░░   ░░░░▒▒░▓                          
              ▒▒▒▓▓▓▓▒░      ▓▓▓▓▓░▓▓▒▒░▓▒▒█▓▓▓▓   ▒░▒▓▓░░░░░░   ▒░░░▒▒▒▒▒▒                         
             ▒▒▒▒▒▒▒▓▓▓▒▒▒▒▒▒▒▓▓▓▓▓░▒▒▒░▓▓▓▓▓▓▓    ▓▒▒▒▓▒░░░░░   ░░░░▒▒▒▒▓▓▓                        
             ▒▒▒▒▓░▒▓▒░▒▓▒▓▓▓▓▓▓▓▓▓▓▒▒▒░▓░▓▓▓▓     ▓▒▓▒░░░░░░    ░░░░░▒▓▒▓▓▓                        
             ▒▒▒░▒▒▒▒▒▒▒▒▒▒░░▒▓▓▓▓▓▓▓▓░▒░▒▒▓▓▓     █▓▓▓▒░░░░     ▒░░▒░▓▓▓▒▒▒  ▒▒▒                   
               ░▒░▒▒▒▒▒▒▒▒▒▒▓▒▒▒▓▓▒▒▒░░░▒░▒▒▓▓▓    ▓▓▓░░░░      ▒▒░░░▒▒▒▒▒▒   ░░░░                  
                 ▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▓▒▓▒▓▓▓▓▒░░░░▒▓▓▓▓▓▓▓▓▒░░       ▓▒░▒░░▒▒▒▒   ░▒░░░░░                
            ░▓▓      ▒▒▒▒▒▒▒▒▒░▒▒▓▓▓▓▓▓▓▓▓░░░░▒░▓▓▓▓▓░░░░      ▓▓▒▒▒▒░▒▒▒   ▒▒▒▒░░░░░               
             ▒▓▓▓▒▒▓             ▒▓▓▓▓▓▓▓▓▓░░░░░░▒▒▒░▒▒░   ░  ▓▓▓▒▒░░░░▒   ▒░▒▒░░░░░░░              
             ▒▒▒▓▓▓▒▒▒▒▒▒            ▓▓▓▓░▓▓▒░░▒░░▒░▒▒░▒     ▓▓▒▒▒░░░░    ▒░▒▒▒░░░░░░░░             
             ▒▒▒▒▒░▒▓▓▒▒▒▒▒▒░▒     ▓▒▓▓▓▓▓▓░▒▓░▒░░░▒▒░░▒    ▓▓▓░▒░░░     ▒▒▒▒▒░░░░░░░░░             
            ▒▒▒▒▓▓▓▓▓▒░▒▒▒▒▒▒▒▒▒▒▒▒▓▒▓░▒▓▒▒▒▒▒▓░░░▒▒░░▒▒▒▒▒▓▓▒░▒░░░     ▓▓▒▒▒▒░░░░░░░░              
             ▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒▒░░░░░░░▒▒▒▒▓░▒░░░    ▓▓▓▓▓▒▒░░░░░░░                
             ▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓░░░░░▒░░▒░▒▒▒░░░▒▒▓▓▓▓░▓▓▒▒░░░░░     ▒░           
              ▒▒▒▒▒▒▒░░░░░░░░░░░░░▒▒▒▒░░░░░▒▓░▓▓▓▓▓▒░▒░░░▒░▒░▒░░▒▒▓▓▓▓░▓▓▓▓▒▒▒       ▒▒▒░░          
                ▒▒▒▒░░░░░░░░▒░           ░▒░▓▒▓▓▓▓▓▓▓░░░▒░▒▒▒░░░▒▓▓▓░▓▓▓▓▓        ▓▓▓▒▒░░░          
   ░                                    ▒▒▓▓▒▒▓▓▒▓▓▓▓▓░░░▒░░░░░░▒▓▒▓█▓▓▓      ▓▓▓▓▓▓▓░▒░░░░         
               ▒▓                   ▒▒▒▒▒▒▒▒▒▒░▒▒░░░▒▓▒▓▒░▒░░░░░▒░▓█▓█▓▓▓▓▓▓▓▓▓▓▓▓░▓▒▒▒░░░░         
                ▓▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░▒▒▒▒░░░░░▒▒▒▒▒▒▒▒▓▓█▓░░░░░░░▓█▓▓▓██▓█▓▓▓▒▓▓▓▒▒▒▒░░░░░░         
                ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░▒▒▒░░░░░░░░▒▒▓███▓▓░░░▓█▓█▓███▒▒▓▓▓▓▒▓▓▒▒▒░░░░░░░          
                 ▒▒▒▒▒▒▒▒▒░░░░░▒░░░░░░░░░▒▒▒▒░░░░▒▒░▒▓▓▓██▓░░░░▒▒▓██▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░░░░░░░          
                  ▒▒▒▒░░░░░░░░░░░░░░░░░     ▒▒▒▒▒▒▒▒░▒▓▒░▓░▓▓▓▓▓░░▒▓▓█▓▓▓▓▓▓▓▓▓▓▒▒▒░░░░░░           
                   ▒▒▒░░░░░░░░░░░░░▒        ▒▒▒▒▒░▒▒░░▒▓▓▒▓██▓██▓▒░░ ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒░░░░            
                     ▒▒░░░░░░░░░░         ▒▒▒▒▒▒░░▒▒▒▒▓█▓▓▓▓▒█▓███ ▒░░▒▓▓▓▓▓▓▓▓▒▒▒▒▒░░              
                                     ▒▒▒░░░▒▒░▒▒▒░░▒▒▓▓▓░▓▓▓▓█▓████  ▒░░▓▓▓▓▒▒▒▒▒▒▒▒                
                               ░▓▒▒▒░░░░░░░▒░░░░░░▒▒▓▓▓░▒▓▓▓▒███████  ▒░░  ▓▒▒▒▒                    
                         ▓  ▓▒▒▒▒▒▒░░▒░░░░░░░     ▒▒▓▓░▒░▓▒▓▒▓█▓█████   ▒░                          
                           ░▒▒▒▒░▒░░░░░░░░░▒     ▒▒▒▓░░░░▓▓▓▓▓▓▓█████    ▒░                         
                            ▒▒▒░░░░░░░░░░░░     ▒▒▒▓░▒░▒▒▒▓▒▓▓▓▓▓███▓     ░░                        
                              ░░░░░░░░░░░▒    ▓▒▒▒▒░▒▒░▒  ▓▓▓▒▓▓▓▓▓▓▓      ░░                       
                                ▒░░░░░     ▓▓▓▓▒▒▒▒▒▒▒▒▒   ▒▓▓▓▓▓▓▓▓▓      ▒░                       
                                        ▓▓▓▓▓▓▓░░░░░░░░░    ▒▒▓▓▓▓▓▒        ▒░                      
                                     ▒▒▒▒▓▓▓▓▓▒▒▒░░░░▒▒▒   ▒▒▒▒▓▓▒▓         ▒░                      
                                  ░     ░░░░▒▒▒▒░░░░▒▒▒▒   ▒▒▒▒▒▒▓           ░                      
           ░                              ░░▒▒▒▒▒▒▒░▒▒▒    ▒▒▒ ░             ▒░                     
                                              ▒▒▒▒▒▒▒                        ▒░                     
        ░                                                                    ▓░                     
                                                                                                    
	]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" ..	" Commands: <C-s> terminal  <leader>fs file_tree  <leader>ff find_file"}
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
},
{
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required

    -- Only one of these is needed.
    "sindrets/diffview.nvim",        -- optional
    "esmuellert/codediff.nvim",      -- optional

    -- For a custom log pager
    "m00qek/baleia.nvim",            -- optional

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
    "nvim-mini/mini.pick",           -- optional
    "folke/snacks.nvim",             -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  }
},
{ "akinsho/toggleterm.nvim", event = "VeryLazy", version = "*",
  opts = {
    size = 10,
    open_mapping = "<c-s>",
  }
},
{
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
},
	{
  'nvim-java/nvim-java',
  config = function()
    require('java').setup()
    vim.lsp.enable('jdtls')
  end,
},
	{ "tarides/ocaml.nvim",
    config = function()
      require("ocaml").setup()
    end
  },
	{
    'brianhuster/live-preview.nvim',
    dependencies = {
        -- You can choose one of the following pickers
        'nvim-telescope/telescope.nvim',
        'ibhagwan/fzf-lua',
        'echasnovski/mini.pick',
		'folke/snacks.nvim',
    },
	},
	{
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
    },
},
}
