local on_lsp_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", function()
		vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
	end, "[C]ode [A]ction")

	nmap("gd", function ()
		require("telescope.builtin").lsp_definitions{}
		vim.cmd("norm zz")
	end, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("gD", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("<leader>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
	-- nmap("<leader>fb", ":Format<CR>", "[F]ormat [B]uffer")

	-- nmap("<leader>.", require("lspimport").import, "auto import")
end

local servers = {
	-- clangd = {},
	gopls = {},
	pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},
	html = { filetypes = { "html", "twig", "hbs" } },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
	volar = { filetypes = { "javascript", "javascriptreact", "vue" } },
}

local on_null_ls_attach = function(_, bufnr)
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ async = false })
		end,
	})
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
		dependencies = {
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_lsp_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			require("lspconfig").volar.setup({
				filetypes = { "javascript", "javascriptreact", "vue" }, --"typescript", , "typescriptreact", "json"
			})
			require("lspconfig").pyright.setup({
				filetypes = { "python" },
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		enable = true,
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				on_attach = on_null_ls_attach,
				-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
				sources = {
					null_ls.builtins.formatting.stylua,

					-- frontend
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.code_actions.eslint,
					-- null_ls.builtins.formatting.rustywind, -- CLI for organizing Tailwind CSS classes

					-- golang
					null_ls.builtins.formatting.gofmt,
					-- null_ls.builtins.formatting.goimports_reviser,
					null_ls.builtins.diagnostics.golangci_lint,
					-- null_ls.builtins.diagnostics.gospel,
					-- null_ls.builtins.diagnostics.revive,
					-- null_ls.builtins.code_actions.gomodifytags,
					-- null_ls.builtins.code_actions.impl,

					-- python
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					-- null_ls.builtins.formatting.pyflyby,
					-- null_ls.builtins.formatting.autoflake,
					-- null_ls.builtins.diagnostics.flake8,
					null_ls.builtins.diagnostics.ruff,

					null_ls.builtins.formatting.json_tool,

					-- common
					null_ls.builtins.code_actions.refactoring,
				},
			})
		end,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({})
		end,
	},
	-- { "stevanmilic/nvim-lspimport", name = "nvim-lspimport" },
	{"yaegassy/coc-volar"}
}
