local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

return {
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth", name = "vim-sleuth" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
		name = "nvim-autopairs",
	},
	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
		name = "Comment",
	},
	-- {
	-- 	"coffebar/neovim-project",
	-- 	enabled = false,
	-- 	opts = {
	-- 		last_session_on_startup = false,
	-- 		session_manager_opts = {
	-- 			autosave_ignore_dirs = {
	-- 				vim.fn.expand("~"), -- don't create a session for $HOME/
	-- 				"/tmp",
	-- 			},
	-- 			autosave_ignore_filetypes = {
	-- 				-- All buffers of these file types will be closed before the session is saved
	-- 				"ccc-ui",
	-- 				"gitcommit",
	-- 				"gitrebase",
	-- 				"qf",
	-- 				"toggleterm",
	-- 			},
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		{ "nvim-lua/plenary.nvim" },
	-- 		{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
	-- 		{ "Shatur/neovim-session-manager" },
	-- 	},
	-- 	-- lazy = false,
	-- 	-- priority = 100,
	-- 	name = "neovim-project",
	-- 	init = function()
	-- 		-- enable saving the state of plugins in the session
	-- 		vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
	-- 	end,
	-- },
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	opts = {},
	-- 	config = function()
	-- 		require("ibl").setup()
	-- 	end,
	-- },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
}
