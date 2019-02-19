" DEV: we'll do it by hand

" setup some basics for the vim plugins
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath

" source ~/.vimrc

"""""""""""""""""""""""""""""""""""""""""""""""
" plugin section

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "javascript,php,python,ruby,go,rust,typescript"
let g:vim_bootstrap_editor = "nvim" " nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'eugen0329/vim-esearch' " search files
Plug 'Yggdroot/LeaderF' " another fuzzy search
Plug 'itchyny/lightline.vim' " better status bar
Plug 'dracula/vim' " colorscheme
Plug 'nathanaelkane/vim-indent-guides' " guides for the indent lines
Plug 'bling/vim-bufferline' " buffer tabs on the status
Plug 'scrooloose/nerdcommenter' " automatic comment of lines
Plug 'HerringtonDarkholme/yats.vim' " typescript syntax
Plug 'Shougo/deoplete.nvim' " autocompletion plugin
Plug 'Shougo/denite.nvim' " ...
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' } " javascript plugin
" Plug 'carlitux/deoplete-ternjs' " linker between tern and deoplete
" Plug 'Quramy/tsuquyomi', { 'do': 'npm install -g typescript' }
" Plug 'mhartington/deoplete-typescript'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'} " typescript plugin for neovim
Plug 'jiangmiao/auto-pairs' " sets automatically parenthesis, brackets...

" linters
Plug 'editorconfig/editorconfig-vim' " editorconfig related
Plug 'neomake/neomake' " general linter for neovim

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""
" config settings

set nocompatible
filetype plugin on
set clipboard=unnamed,unnamedplus " default the clipboard

" disable ruby, no need for now
let g:loaded_ruby_provider = 1

" set the clipboard right
set clipboard+=unnamedplus

" set layout colors
syntax on 
" colorscheme darkblueA
set t_Co=256
set background=dark
colorscheme dracula

" fix backgrounds on terminal
hi Normal ctermbg=none
highlight NonText ctermbg=none

" keep N lines/columns when scrolling
set scrolloff=4
set sidescroll=4

" set general settings for vim
set number "line numbers
set cursorline "color the cursorline
" set autoindent "auto indenting
set incsearch "search as characters are entered
set hlsearch "higlight matches

" set backspace
set backspace=indent,eol,start

" let g:autofmt_autosave = 1 " auto fmt the file

" old settings
set hidden
set title
set number
set history=1000
set nofoldenable
set laststatus=2
set encoding=utf-8
set showmatch
set shiftwidth=2
set softtabstop=2
set expandtab
set mouse=nvic

set t_ut=

"""""""""""""""""""""""""""""""""""""""""""""""
" plugin settings

" setup netrw, the file explorer
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
" augroup END

" enable deoplete at startup and configure it
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
""let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
""let g:deoplete#deoplete_omni_patterns = get(g:, 'deoplete#force_omni_input_patterns', {})
""let g:deoplete#deoplete_omni_patterns.javascript = '[^. \t]\.\w*'
""let g:deoplete#deoplete_omni_patterns.typescript = '[^. \t]\.\w*'
""inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"  "let g:deoplete#sources = {}
"  "let g:deoplete#sources._=['omni', 'buffer', 'member', 'tag', 'ultisnips', 'file']
"  "set omnifunc=syntaxcomplete#Complete
""autocmd FileType typescript nmap <buffer> <Leader>T : <C-u>echo tsuquyomi#hint()<CR>
""aug omnicomplete
""au!
""  au FileType css,sass,scss,stylus,less setl omnifunc=csscomplete#CompleteCSS
""  au FileType html,htmldjango,jinja,markdown setl omnifunc=emmet#completeTag
""  au FileType javascript,jsx setl omnifunc=tern#Complete
""  au FileType python setl omnifunc=pythoncomplete#Complete
""  au FileType xml setl omnifunc=xmlcomplete#CompleteTags
""aug END

" let g:tern_request_timeout = 1
" let g:tern_request_timeout = 6000
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]

let g:deoplete#sources#tss#javascript_support = 1
let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_javascript_support = 1
let g:tsuquyomi_auto_open = 1
let g:tsuquyomi_disable_quickfix = 1

" neomake to auto open
let g:neomake_open_list = 2
" let g:neomake_javascript_enabled_makers = ['eslint']
" let g:neomake_typescript_enabled_makers = ['tslint']
call neomake#configure#automake('nrwi', 500)
autocmd! BufWritePost,BufEnter * Neomake

" lightline
let g:lightline = {}
let g:lightline.tabline = { 'left': [ ['tabs'] ], 'right': [ ['close'] ] }
set showtabline=2

"""""""""""""""""""""""""""""""""""""""""""""""
" mapping section

" DEV: no need for nerdtree on neovim
" map <Leader>o :NERDTreeToggle<CR>
map <Leader>o :Vexplore<CR>

" TODO: key binding not working...
" map <Leader>c <plug>NERDComComment 
map <Leader>p :LeaderfFile<CR>

" Start esearch prompt autofilled with one of g:esearch.use initial patterns
call esearch#map('<Leader>f', 'esearch')

" Buffer

" To open a new empty buffer
" \ + t
nmap <leader>t :tabnew<cr>
" \ + n
nmap <leader>n :enew<cr>

" To open a new vertical split
" \ + 2
nmap <leader>2 :vsplit<cr>

" Move to the next buffer
" Instead of next buffer, set next tab
" \ + l
" nmap <leader>l :bnext<CR>
nmap <leader>l :tabl<CR>

" Move to the previous buffer
" \ + h
" Instead of next buffer, set next tab
" nmap <leader>h :bprevious<CR>
nmap <leader>h :tabr<CR>

" easier navigation between split windows
" nnoremap <c-j> <c-w>j
" \ + Down
nnoremap <leader><Down> <c-w>j
" nnoremap <c-k> <c-w>k
" \ + Up
nnoremap <leader><Up> <c-w>k
" nnoremap <c-h> <c-w>h
" \ + Left
nnoremap <leader><Left> <c-w>h
" nnoremap <c-l> <c-w>l
" \ + Right
nnoremap <leader><Right> <c-w>l

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
" \ + w
nmap <leader>w :bp <BAR> bd #<CR>

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy)
noremap Y y$
