if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })

if has("nvim")
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'cohama/lexima.vim'

"  Plug 'hoob3rt/lualine.nvim'
"  Plug 'kristijanhusak/defx-git'
"  Plug 'kristijanhusak/defx-icons'
"  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
"  Plug 'williamboman/nvim-ls-installer'
"  Plug 'tami5/lspsaga.nvim'
"  Plug 'folke/lsp-colors.nvim'
"  Plug 'L3MON4D3/LuaSnip'
"  Plug 'hrsh7th/cmp-nvim-lsp'
"  Plug 'hrsh7th/cmp-buffer'
"  Plug 'hrsh7th/nvim-cmp'
"  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
"  Plug 'kyazdani42/nvim-web-devicons'
"  Plug 'onsails/lspkind-nvim'
"  Plug 'nvim-lua/popup.nvim'
"  Plug 'nvim-lua/plenary.nvim'
"  Plug 'nvim-telescope/telescope.nvim'
"  Plug 'windwp/nvim-autopairs'
"  Plug 'windwp/nvim-ts-autotag'
endif
"
"Plug 'groenewege/vim-less', { 'for': 'less' }
"Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
