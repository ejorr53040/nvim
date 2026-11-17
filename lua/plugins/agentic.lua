-- ================================================================================================
-- TITLE : agentic
-- ABOUT : Claude Code chat sidebar (right side, collapsible) via the Agent Client Protocol. Edits
--         are shown as live diffs to accept/reject. Needs the ACP adapter on PATH:
--           npm i -g @agentclientprotocol/claude-agent-acp
-- LINKS :
--   > github : https://github.com/carlos-algms/agentic.nvim
-- ================================================================================================

return {
	"carlos-algms/agentic.nvim",
	opts = {
		provider = "claude-agent-acp",
	},
	keys = {
		{
			"<C-\\>",
			function()
				require("agentic").toggle()
			end,
			mode = { "n", "v", "i" },
			desc = "Toggle Claude chat",
		},
		{
			"<C-'>",
			function()
				require("agentic").add_selection_or_file_to_context()
			end,
			mode = { "n", "v" },
			desc = "Add file/selection to Claude context",
		},
		{
			"<C-,>",
			function()
				require("agentic").new_session()
			end,
			mode = { "n", "v", "i" },
			desc = "New Claude session",
		},
		{
			"<leader>as",
			function()
				require("agentic").stop_generation()
			end,
			desc = "Stop Claude generation",
		},
	},
}
