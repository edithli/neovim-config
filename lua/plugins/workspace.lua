return {
	{
		"natecraddock/workspaces.nvim",
		enabled = false,
		name = "workspaces",
		config = function()
			require("workspaces").setup({
				hooks = {
					open = { "Telescope find_files" },
				},
			})
		end,
	},
}
