return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "gopls", "pyright", "ruff", "efm" },
			-- servers are enabled explicitly in lua/lsp/init.lua; jdtls is installed and enabled by nvim-java
			automatic_enable = { exclude = { "jdtls" } },
		},
	},
	{
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  opts = {
    inlay_hints = {
      inline = false,
    },
    ast = {
      --These require codicons (https://github.com/microsoft/vscode-codicons)
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
      kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
    },
  },
},
}

