return {
	"coder/claudecode.nvim",
	lazy = true,
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeSelectModel",
	},
	dependencies = { "folke/snacks.nvim" },
	opts = {
		-- terminal_cmd = "toggleterm", -- if you use toggleterm
	},
	keys = {
		{ "<leader>a",  nil,                              desc = "AI/Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",  desc = "Send selection" },
		{ "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>",     desc = "Add from tree",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
	},
}
