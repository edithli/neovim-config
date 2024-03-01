-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- neotree
vim.keymap.set("n", "<leader>ft", ":Neotree filesystem reveal left<CR>", {})
vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
vim.keymap.set("n", "<leader>nr", ":Neotree reveal<CR>", {})

-- telescope
local tlbuiltin = require("telescope.builtin")
local function telescope_live_grep_open_files()
	tlbuiltin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end
local function telescope_buffer_fuzzy_find()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	tlbuiltin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end
-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
	[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end
vim.keymap.set("n", "<leader>fr", tlbuiltin.oldfiles, { desc = "[F]ind [R]ecently opened files" })
vim.keymap.set("n", "<leader>ff", tlbuiltin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader><space>", function()
	tlbuiltin.buffers({ sort_lastused = true, ignore_current_buffer = true })
end, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", telescope_buffer_fuzzy_find, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>s/", telescope_live_grep_open_files, { desc = "[S]earch [/] in Open Files" })
vim.keymap.set("n", "<leader>sh", tlbuiltin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", tlbuiltin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", tlbuiltin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by grep on [G]it Root" })
vim.keymap.set("n", "<leader>sh", tlbuiltin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>rp", ":Telescope neovim-project history<CR>", { desc = "[R]ecent [P]roject" })
vim.keymap.set("n", "<leader>rp", ":Telescope neovim-project history<CR>", { desc = "[R]ecent [P]roject" })

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- auto format
vim.keymap.set("n", "<leader>fb", function()
	vim.lsp.buf.format()
end, { desc = "[F]ormat [B]uffer" })

-- workspaces
vim.keymap.set("n", "<leader>wa", ":WorkspacesAdd<CR>", { desc = "[W]orkspace [A]dd" })
vim.keymap.set("n", "<leader>wr", ":WorkspacesRename", { desc = "[W]orkspace [R]ename" })
vim.keymap.set("n", "<leader>wo", ":WorkspacesOpen", { desc = "[W]orkspace [O]pen" })
vim.keymap.set("n", "<leader>wl", ":WorkspacesList", { desc = "[W]orkspace [L]ist" })

vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "[T]erm [V]ertical" })
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "[T]erm [H]orizontal" })
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "[T]erm [F]loat" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bpre<CR>", { desc = "[B]uffer [P]revious" })
vim.keymap.set("n", "<leader>bc", ":bpre <bar> bd #<CR>zz", { desc = "[B]uffer [C]lose current" })

-- select all
vim.keymap.set("n", "<leader>a", "<esc>gg0VG$<CR>")

vim.keymap.set("n", "<leader>nh", ":noh<CR>", {})

-- Center the view after jumping up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- term mode
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	-- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	-- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	-- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	-- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	-- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	-- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- vim.keymap.set("i", "<C-f>", "<Right>", {})
-- vim.keymap.set("i", "<C-b>", "<Left>", {})
-- vim.keymap.set("i", "<C-n>", "<Down>", {})
-- vim.keymap.set("i", "<C-p>", "<Up>", {})

-- backward-char
vim.keymap.set("!", "<C-b>", "<Left>", { silent = true })
-- forward-char
vim.keymap.set("!", "<C-f>", "<Right>", { silent = true })
-- previous-line
vim.keymap.set("i", "<C-p>", "<Up>", { silent = true })
-- next-line
vim.keymap.set("i", "<C-n>", "<Down>", { silent = true })
-- move-beginning-of-line
vim.keymap.set("!", "<C-a>", "<Home>", { silent = true })
-- move-end-of-line
vim.keymap.set("!", "<C-e>", "<End>", { silent = true })
-- backward-sentence
vim.keymap.set("i", "<M-a>", "<C-o>(", { silent = true })
-- forward-sentence
vim.keymap.set("i", "<M-e>", "<C-o>)", { silent = true })
-- backward-word
vim.keymap.set("i", "<M-b>", "<C-Left>", { silent = true })
vim.keymap.set("c", "<M-b>", "<S-Left>", { silent = true })
-- forward-word
vim.keymap.set("i", "<M-f>", "<C-o>e<Right>", { silent = true })
vim.keymap.set("c", "<M-f>", "<S-Right>", { silent = true })
-- delete-char
vim.keymap.set("!", "<C-d>", "<Del>", { silent = true })
-- kill-line
vim.keymap.set("i", "<C-k>", "<esc>ld$a", { silent = true })
-- vim.keymap.set("c", "<C-k>", "<C-f>d$<C-c><End>", { silent = true })
