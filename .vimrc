if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Use spaces instead of tabs
set expandtab

" 1 tab == 2 spaces
set shiftwidth=2
set softtabstop=2

" Enable filetype plugins
filetype plugin on
filetype indent on

set ai "Auto indent
set wrap "Wrap lines

" Set to auto read when a file is changed from the outside
set autoread

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable syntax highlighting
syntax enable 

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac
set fdm=indent
set foldlevel=2
set nofoldenable

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%

" More natural splitting
set splitbelow
set splitright

" Smarter searching (case insensitive search unless a capital letter in query)
set ignorecase
set smartcase

" Default to g flag with find+replace (:s/foo/bar/)
set gdefault

" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

set number
filetype plugin indent on
syntax on

" vim-plug code
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Linting + fixing
Plug 'w0rp/ale'

" Style
Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'
Plug 'editorconfig/editorconfig-vim'

" Rails
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-bundler'

" Initialize plugin system
call plug#end()

set background=dark
colorscheme palenight

highlight LineNr guifg=#606080

set showtabline=2
let g:bufferline_echo = 0
let g:bufferline_modified = '*'

let g:lightline = {
  \ 'colorscheme': 'palenight',
  \ 'tabline': {
  \   'left': [ ['bufferline'] ]
  \ },
  \ 'component_expand': {
  \  'tabs': 'LightlineTabs',
  \  'bufferline': 'LightlineBufferline',
  \ },
  \ 'component_type': {
  \   'bufferline': 'tabsel',
  \ },
  \ 'component_function': {
  \   'filename': 'LightlineFilename'
  \ },
\ }

" Match the terminal background
" hi DiffAdd guibg=green
" hi DiffChange guibg=black
" hi DiffDelete guibg=red
" hi DiffText guibg=yellow

function! LightlineTabs() abort
  let [x, y, z] = [[], [], []]
  let nr = tabpagenr()
  let cnt = tabpagenr('$')
  for i in range(1, cnt)
    call add(i < nr ? x : i == nr ? y : z,
          \ '%' . i . '%%{lightline#onetab(' . i . ',' . (i == nr) . ')}'
          \ . (i == cnt ? '%T' : ''))
  endfor
  if len(x) > 3
    let x = x[len(x)-3:]
    let x[0] = '<' . x[0]
  endif
  if len(z) > 3
    let z = z[:2]
    let z[len(z)-1] = z[len(z)-1] . '>'
  endif
  return [x, y, z]
endfunction

function! LightlineFilename()
  return expand('%')
endfunction

function! LightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']

noremap <Space> <Nop>
let mapleader = " "
noremap <leader>ne :NERDTreeFind<cr>
noremap <leader>p :Files<CR>
noremap <leader>f :Ag<CR>
noremap <leader>l :bnext<CR>
noremap <leader>h :bprev<CR>
noremap <leader>a :ALEFix<CR>
noremap <leader>y "+y
noremap <leader>v "+p
nnoremap ; :
noremap <leader>/ "+yiw:Ag<CR><D-v>

" Make Ag only search file contents
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

function! fzf#vim#ag_raw(command_suffix, ...) 
  return call('fzf#vim#grep', extend(['ag --nogroup --column --color '.a:command_suffix, 1], a:000)) 
endfunction 

command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

command LS Buffers

NERDTree
NERDTreeClose
