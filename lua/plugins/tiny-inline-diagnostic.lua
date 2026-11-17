return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000, -- needs to load before other diagnostic config
		opts = {
			preset = "modern",
			options = {
				show_source = { enabled = false },
				multilines = { enabled = true, always_show = false },
			},
		},
	},
}
