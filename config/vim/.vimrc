" ==============================================================================
" BASIC SETTINGS
" ==============================================================================

set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set fileencoding=utf-8

" ==============================================================================
" APPEARANCE
" ==============================================================================

set number
set relativenumber
set cursorline
set showcmd
set laststatus=2
set showmatch
set t_Co=256
set background=dark
set ruler
set colorcolumn=80

" Relative line numbers toggle
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" ==============================================================================
" INDENTATION
" ==============================================================================

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent

" ==============================================================================
" SEARCH
" ==============================================================================

set hlsearch
set incsearch
set ignorecase
set smartcase

" ==============================================================================
" EDITING
" ==============================================================================

set backspace=indent,eol,start
set mouse=a
set ttymouse=xterm2
set nowrap
set scrolloff=8

" Show whitespace
set list
set listchars=tab:→\ ,trail:·,nbsp:·

" Undo settings
set undofile
set undodir=~/.vim/undodir

" Backup settings
set nobackup
set nowritebackup
set noswapfile

" ==============================================================================
" PERFORMANCE
" ==============================================================================

set ttyfast
set lazyredraw
set ttimeout
set ttimeoutlen=10

" ==============================================================================
" WHITESPACE HIGHLIGHTING
" ==============================================================================

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
match ExtraWhitespace /[^\t]\zs\t\+/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" ==============================================================================
" FILE TYPE SPECIFIC
" ==============================================================================

" YAML files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" JSON files
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab

" Terraform files
autocmd FileType terraform setlocal ts=2 sts=2 sw=2 expandtab

" Shell scripts
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

" Dockerfile
autocmd FileType dockerfile setlocal ts=2 sts=2 sw=2 expandtab

" Markdown
autocmd FileType markdown setlocal wrap linebreak

" Go files
autocmd FileType go setlocal ts=4 sts=4 sw=4 noexpandtab

" Git commit - extra ruler for first line
autocmd FileType gitcommit set colorcolumn+=51

" ==============================================================================
" KEY MAPPINGS
" ==============================================================================

let mapleader = " "

" Quick save/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Split resizing
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" System clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Indent/dedent in visual mode
vnoremap < <gv
vnoremap > >gv

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ==============================================================================
" CUSTOM COMMANDS
" ==============================================================================

command! TrimWhitespace %s/\s\+$//e
command! TabsToSpaces %s/\t/    /g
command! FormatJSON %!jq '.'
command! FormatYAML %!yq eval -P '.'

" ==============================================================================
" STATUSLINE
" ==============================================================================

set statusline=
set statusline+=\ %f
set statusline+=\ %m
set statusline+=\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding}
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" ==============================================================================
" AUTO COMMANDS
" ==============================================================================

" Return to last edit position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Create parent directories on save
autocmd BufWritePre * call mkdir(expand('<afile>:p:h'), 'p')

" Highlight TODO, FIXME, etc.
augroup vimrc_todo
  autocmd!
  autocmd Syntax * syn match MyTodo /\v<(TODO|FIXME|NOTE|HACK|XXX)/ containedin=.*Comment
  autocmd Syntax * highlight MyTodo ctermfg=Yellow guifg=Yellow
augroup END
