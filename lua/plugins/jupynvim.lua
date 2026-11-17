-- ================================================================================================
-- TITLE : jupynvim
-- ABOUT : Opens .ipynb files as real notebooks: bordered cells, saved outputs, inline plots
--         (kitty graphics, unicode placeholders), and Jupyter kernels. :w writes nbformat JSON.
--         Kernel comes from a .venv next to the notebook that has ipykernel installed.
--         Keys (buffer-local): <S-CR> run+next, <C-CR> run, <leader>nR run all, ]c/[c cells.
-- LINKS :
--   > github : https://github.com/sheng-tse/jupynvim
-- ================================================================================================

return {
	"sheng-tse/jupynvim",
	version = "*", -- latest stable tag; the build hook fetches the backend binary matching it
	lazy = false, -- must be loaded before an .ipynb buffer is read
	build = function(plugin)
		-- downloads the prebuilt Rust backend (SHA256-checked), cargo build only as a fallback
		loadfile(plugin.dir .. "/lua/jupynvim/install.lua")().run(plugin)
	end,
	opts = {
		-- placeholders anchor images to buffer text, which is what herdr's kitty compositor tracks
		image_renderer = "placeholder",
	},
}
