return {
	{
		"goolord/alpha-nvim",
		enabled = true,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.startify")

			dashboard.section.header.val = {
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                     ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
				[[                                                                       ]],
				[[                                                                       ]],
				[[                                                                       ]],
			}

			-- dashboard.section.buttons.val = {
			-- 	dashboard.button("e", "  New file", "<cmd>ene <CR>"),
			-- 	dashboard.button("SPC f f", "󰈞  Find file"),
			-- 	dashboard.button("SPC f r", "󰊄  Recently opened files"),
			-- 	dashboard.button("SPC s g", "󰈬  Find word"),
			-- 	-- dashboard.button("SPC f m", "  Jump to bookmarks"),
			-- 	-- dashboard.button("SPC s l", "  Open last session"),
			-- 	dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
			-- }

			alpha.setup(dashboard.opts)
		end,
	},
}
