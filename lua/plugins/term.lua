return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-`>]],
				hide_numbers = true,
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float',
				start_in_insert = true,
				close_on_exit = true,
				auto_scroll = true, -- automatically scroll to the bottom on terminal output

				-- size can be a number or function which is passed the current terminal
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					else
						return 20
					end
				end,

				autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
			})
		end,
	},
}
