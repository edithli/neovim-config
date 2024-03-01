return {
	{
		"JoosepAlviste/palenightfall.nvim",
		enabled = false,
		config = function()
			require("palenightfall").setup({
				transparent = false,
			})
		end,
	},
	{
		"catppuccin/nvim",
		lazy = false,
		enabled = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato", -- latte, frappe, macchiato, mocha
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				transparent = false,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	-- {
	-- 	-- Theme inspired by Atom
	-- 	"navarasu/onedark.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- 	enabled = false,
	-- 	config = function()
	-- 		require("onedark").setup({
	-- 			-- Set a style preset. 'dark' is default.
	-- 			style = "dark", -- dark, darker, cool, deep, warm, warmer, light
	-- 		})
	-- 		require("onedark").load()
	-- 	end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end,
	},
}
