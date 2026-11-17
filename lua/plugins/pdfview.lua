return {
	"basola21/PDFview",
	lazy = false,
	dependencies = { "nvim-telescope/telescope.nvim" },
	keys = {
		{ "<leader>pv", "<cmd>lua require('pdfview').telescope_open()<cr>", desc = "PDF: open viewer" },
		{ "<leader>pn", "<cmd>lua require('pdfview.renderer').next_page()<cr>", desc = "PDF: next page" },
		{ "<leader>pp", "<cmd>lua require('pdfview.renderer').previous_page()<cr>", desc = "PDF: previous page" },
	},
}
