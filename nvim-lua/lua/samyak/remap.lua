vim.g.mapleader = " "
local keymap = vim.keymap.set
keymap("n", "<leader>pv", vim.cmd.Ex)

-- use jk to exit insert mode
keymap("i", "jk", "<ESC>")

-- move selected block of codes up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- keep the cursor at same place when pasting on the same line
keymap("n", "J", "mzJ`z")

-- keep cursor at middle of the screen when jumping half page
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- keep search terms at middle
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- delete the pasted stuff in void register, preserving the yanked ones
keymap("x", "<leader>p", [["_dP]])
-- delete single character without copying into register
keymap("n", "x", '"_x')

-- copy stuff in your systems clipboard
keymap({"n", "v"}, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

-- switch between projects
-- keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
keymap("n", "<leader>f", vim.lsp.buf.format)

-- quick fix navigation / quick fix list [don't know what it is]
-- keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
-- keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word that you're on
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make the current file executable
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- clear search highlights
keymap("n", "<leader>nh", ":nohl<CR>")

-- increment/decrement numbers
keymap("n", "<leader>+", "<C-a>") -- increment
keymap("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap("n", "<leader>sx", ":close<CR>") -- close current split window

keymap("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap("n", "<leader>tp", ":tabp<CR>") --  go to previous tab
