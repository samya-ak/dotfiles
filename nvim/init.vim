runtime ./plug.vim
if !exists('g:vscode')
  " Fundamentals "{{{
  " ---------------------------------------------------------------------

  " init autocmd
  autocmd!
  " set script encoding
  scriptencoding utf-8
  " stop loading config if it's on tiny or small
  if !1 | finish | endif
  :set number
  :set relativenumber
  :set autoindent
  :set tabstop=4
  :set shiftwidth=4
  :set smarttab
  :set softtabstop=4
  :set nocompatible
  syntax enable
  :set encoding=utf-8
  :set title
  :set background=dark
  :set nobackup
  :set hlsearch
  :set showcmd
  :set cmdheight=1
  :set laststatus=2
  :set scrolloff=10
  :set expandtab
  " incremental substitution (neovim)
  if has('nvim')
    :set inccommand=split
  endif

  " Suppress appending <PasteStart> and <PasteEnd> when pasting
  :set t_BE=

  :set nosc noru nosm
  " Don't redraw while executing macros (good performance config)
  :set lazyredraw
  "set showmatch
  " How many tenths of a second to blink when matching brackets
  "set mat=2
  " Ignore case when searching
  :set ignorecase
  " Be smart when using tabs ;)
  :set smarttab
  " indents
  filetype plugin indent on
  :set shiftwidth=2
  :set tabstop=2
  :set ai "Auto indent
  :set si "Smart indent
  :set nowrap "No Wrap lines
  :set backspace=start,eol,indent
  " Finding files - Search down into subfolders
  :set path+=**
  :set wildignore+=*/node_modules/*
  " Turn off paste mode when leaving insert
  autocmd InsertLeave * set nopaste

  " Add asterisks in block comments
  :set formatoptions+=r

  "}}}


  " Highlights "{{{
  " ---------------------------------------------------------------------
  set cursorline
  "set cursorcolumn

  " Set cursor line color on visual mode
  highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

  highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

  augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
  augroup END

  if &term =~ "screen"
    autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
    autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
  endif

  "}}}

  " File types "{{{
  " ---------------------------------------------------------------------
  " JavaScript
  au BufNewFile,BufRead *.es6 setf javascript
  " TypeScript
  au BufNewFile,BufRead *.tsx setf typescriptreact
  " Markdown
  au BufNewFile,BufRead *.md set filetype=markdown
  au BufNewFile,BufRead *.mdx set filetype=markdown
  " Flow
  au BufNewFile,BufRead *.flow set filetype=javascript
  " Fish
  au BufNewFile,BufRead *.fish set filetype=fish

  set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

  autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
  autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

  "}}}

  " Imports "{{{
  " ---------------------------------------------------------------------

  if has("unix")
    let s:uname = system("uname -s")
    " Do Mac stuff
    if s:uname == "Darwin\n"
      runtime ./macos.vim
    endif
  endif
  if has('win32')
    runtime ./windows.vim
  endif

  runtime ./maps.vim
  "}}}

  " Syntax theme "{{{
  " ---------------------------------------------------------------------

  " true color
  if exists("&termguicolors") && exists("&winblend")
    syntax enable
    set termguicolors
    set winblend=0
    set wildoptions=pum
    set pumblend=5
    set background=dark
    " Use NeoSolarized
    let g:neosolarized_termtrans=1
    runtime ./colors/NeoSolarized.vim
    colorscheme NeoSolarized
  endif

  "}}}

  " Extras "{{{
  " ---------------------------------------------------------------------
  set exrc
  "}}}

  " vim: set foldmethod=marker foldlevel=0:
else

  function! s:split(...) abort
    let direction = a:1
    let file = a:2
    call VSCodeCall(direction == 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if file != ''
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
  endfunction

  function! s:splitNew(...)
      let file = a:2
      call s:split(a:1, file == '' ? '__vscode_new__' : file)
  endfunction

  function! s:closeOtherEditors()
      call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
      call VSCodeNotify('workbench.action.closeOtherEditors')
  endfunction

  function! s:manageEditorSize(...)
      let count = a:1
      let to = a:2
      for i in range(1, count ? count : 1)
          call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
      endfor
  endfunction

  command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
  command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
  command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
  command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
  command! -bang Only if <q-bang> == '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

  nnoremap <silent> <C-w>s :call <SID>split('h')<CR>
  xnoremap <silent> <C-w>s :call <SID>split('h')<CR>

  nnoremap <silent> <C-w>v :call <SID>split('v')<CR>
  xnoremap <silent> <C-w>v :call <SID>split('v')<CR>

  nnoremap <silent> <C-w>n :call <SID>splitNew('h', '__vscode_new__')<CR>
  xnoremap <silent> <C-w>n :call <SID>splitNew('h', '__vscode_new__')<CR>


  nnoremap <silent> <C-w>= :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
  xnoremap <silent> <C-w>= :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>

  nnoremap <silent> <C-w>> :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
  xnoremap <silent> <C-w>> :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
  nnoremap <silent> <C-w>+ :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
  xnoremap <silent> <C-w>+ :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
  nnoremap <silent> <C-w>< :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  xnoremap <silent> <C-w>< :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  nnoremap <silent> <C-w>- :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  xnoremap <silent> <C-w>- :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>

  " Better Navigation
  nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
  xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
  nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
  xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
  nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
  xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
  nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
  xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

  " Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
  xnoremap <silent> <C-/> :call Comment()<CR>
  nnoremap <silent> <C-/> :call Comment()<CR>

  nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

  nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
  xnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
endif
