return {
-- add this to the file where you setup your other plugins:
{
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()
    vim.keymap.set("i", "<leader><Tab>", neocodeium.accept)
		-- NeoCodeium Configuration
		end,
	}

}
