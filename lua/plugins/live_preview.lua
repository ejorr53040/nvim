return {
{
    'brianhuster/live-preview.nvim',
    dependencies = {
        -- You can choose one of the following pickers
        'nvim-telescope/telescope.nvim',
        'ibhagwan/fzf-lua',
        'echasnovski/mini.pick',
		'folke/snacks.nvim',
    },
	keys = {
		{ "<leader>mp", "<cmd>LivePreview start<cr>", desc = "Markdown live preview: start" },
		{ "<leader>ms", "<cmd>LivePreview stop<cr>", desc = "Markdown live preview: stop" },
	},
	}
}
