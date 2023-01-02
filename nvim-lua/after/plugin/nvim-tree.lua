-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end
nvimtree.setup({
-- disable window_picker for
-- explorer to work well with
-- window splits
actions = {
    open_file = {
        window_picker = {
            enable = false,
        },
    },
},
})

local keymap = vim.keymap.set
keymap("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
