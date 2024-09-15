"==============================================================================
"                                   VIM CONFIG
"==============================================================================

"----------------------------------- GENERAL ----------------------------------
filetype plugin indent on         " Enable file type detection and indentation
syntax enable                     " Enable syntax highlighting
colorscheme onehalfdark            " Set colorscheme

set nocompatible                   " Disable vi compatibility
set signcolumn=yes                 " Always show sign column
set noexpandtab                    " Use tabs instead of spaces
set tabstop=4                      " Set tab width to 4 spaces
set shiftwidth=4                   " Indent/outdent by 4 spaces
set mouse=a                        " Enable mouse support
set number                         " Show line numbers
set cursorline                     " Highlight the current line
set foldmethod=manual              " Enable manual code folding
set incsearch                      " Incremental search
set hlsearch                       " Highlight search matches
set splitbelow                     " Horizontal splits open below
set splitright                     " Vertical splits open to the right
set hidden                         " Allow background buffers
set history=200                    " Set command history limit
set scrolloff=8                    " Keep 8 lines above/below the cursor
set wildmenu                       " Enable command-line completion

"--------------------------------- 42 SETTINGS --------------------------------
let g:user42 = 'jeportie'          " 42 username
let g:mail42 = 'jeportie@student.42.fr'  " 42 email

"==============================================================================
"                                 MAPPINGS
"==============================================================================

"------------------------------- VIM SHORTCUTS -------------------------------
nnoremap <leader>u :NERDTreeRefreshRoot<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>vs :vertical split<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>vt :vertical terminal<CR>
nnoremap <leader>r :set relativenumber<CR>
nnoremap <leader>nr :set norelativenumber<CR>
nnoremap <Leader>cc :set colorcolumn=80<CR>
nnoremap <Leader>ncc :set colorcolumn-=80<CR>
nnoremap <leader>L :set list!<CR> 
nnoremap <c-h> :set hlsearch!<CR>

"-------------------------------- PLUGIN MAPS ---------------------------------
nnoremap <F2> :NERDTreeToggle<CR>
nmap <F3> :TagbarToggle<CR>
nnoremap <F4> :Files<CR>
nnoremap <C-M> :bnext<CR>
nnoremap <C-N> :bprev<CR>

"==============================================================================
"                                 PLUGIN SETTINGS
"==============================================================================

"------------------------------ PLUGIN MANAGER -------------------------------
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugged')
Plugin 'VundleVim/Vundle.vim'      " Let Vundle manage itself

"----------------------------- PLUGIN LIST ------------------------------------
Plugin 'tyru/open-browser.vim'
Plugin 'aklt/plantuml-syntax'
Plugin 'scrooloose/vim-slumlord'
Plugin 'weirongxu/plantuml-previewer.vim'
Plugin 'itchyny/calendar.vim'      " Calendar plugin
Plugin 'sheerun/vim-polyglot'      " Language support
Plugin 'dense-analysis/ale'        " Linter
Plugin 'ap/vim-buftabline'         " Buffer tab line
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'          " FZF fuzzy finder
Plugin 'airblade/vim-rooter'       " Auto change working directory
Plugin 'jiangmiao/auto-pairs'      " Auto-closing pairs
let g:AutoPairsShortcutToggle = '<C-P>'  " Auto-pairs toggle shortcut
Plugin 'mattn/emmet-vim'           " Emmet for HTML/CSS
let g:user_emmet_leader_key=','     " Emmet leader key
Plugin 'preservim/nerdtree'        " NERDTree file explorer
Plugin 'preservim/tagbar'          " Tagbar for code navigation

call vundle#end()                  " Finish Vundle initialization

"==============================================================================
"                                 PLUGIN SETTINGS
"==============================================================================

"------------------------------- NERDTree CONFIG ------------------------------
let NERDTreeShowBookmarks = 1      " Show bookmarks in NERDTree
let NERDTreeShowHidden = 1         " Show hidden files in NERDTree
let NERDTreeShowLineNumbers = 0    " Hide line numbers in NERDTree
let NERDTreeMinimalMenu = 1        " Use minimal menu in NERDTree
let NERDTreeWinSize = 31           " Set NERDTree panel width

function! DisableNERDTreeForSpecificFiles()
  " Disable NERDTree for .todo.md files
  if expand('%:e') == 'md' && expand('%:t') =~ '\.todo\.md$'
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
      execute "NERDTreeClose"
    endif
    let g:NERDTreeHijackNetrw = 0
    let g:NERDTreeQuitOnOpen = 1
    return
  endif

  " Get the full path of the file relative to the current directory
  let file_path = expand('%:p')

  " Disable NERDTree for files inside a local ".calendar" directory
  if file_path =~# '\v/calendar/.*\.calendar$'
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
      execute "NERDTreeClose"
    endif
    let g:NERDTreeHijackNetrw = 0
    return
  endif

  " For all other files, enable NERDTree normally
  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeQuitOnOpen = 0
endfunction

" Call the function on entering the buffer to control NERDTree
autocmd BufEnter * call DisableNERDTreeForSpecificFiles()

" Start NERDTree only if no file is provided, and NERDTree is enabled
autocmd VimEnter * if argc() == 0 && g:NERDTreeHijackNetrw | NERDTree | endif

" Open the existing NERDTree on each new tab (if allowed)
autocmd BufWinEnter * if getcmdwintype() == '' && g:NERDTreeHijackNetrw | silent NERDTreeMirror | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"------------------------------ TAGBAR SETTINGS ------------------------------
let g:tagbar_autofocus = 1         " Auto-focus tagbar
let g:tagbar_autoshowtag = 1       " Highlight active tag
let g:tagbar_position = 'botright vertical'

autocmd BufReadPost,BufNewFile *.uml :PlantumlOpen
let g:plantuml_executable_script = "~/bin/plantuml.sh"
"==============================================================================
"                            OTHER SETTINGS / AUTOCOMMANDS
"==============================================================================

" Norminette auto-load for 42 files
autocmd BufRead,BufNewFile *.c,*.h source ~/.vim/syntax/norminette.vim
autocmd BufRead,BufNewFile *.c,*.h source ~/.vim/plugin/norminette.vim
nnoremap <Leader>n :NorminetteRun<CR>

