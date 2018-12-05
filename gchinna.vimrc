
" Reference(s):
"     https://dougblack.io/words/a-good-vimrc.html
"     http://vim.wikia.com/wiki/Indenting_source_code


"################## Colors ##################
"colorscheme evening     " evening colorscheme
colorscheme morning     " morning colorscheme
syntax enable           " enable syntax processing

"################## Spaces & Tabs ###########
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " tabs are spaces
set shiftwidth=4        " number of spaces for intending - affects >>, << or == and autoindent
set autoindent          " unintrusive auto indent - copy the indentation from the previous line

"################## UI Config ###############
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

if has("win32")
    " winddows only, default font too small in 4k+ res monitors
    "set guifont=Consolas:h11
    set guifont=Lucida_Sans_Typewritter:h10
else 
    " unix/linux only, default font/size (Monospace:h10) does not display underscores properly
    " _ and : do not work on unix/linux
    "set guifont=Monospace 11
    set guifont=Liberation\ Mono\ 10
endif


"################## Searching ###############
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight - map :nohlsearch to ,<space>
nnoremap <leader><space> :nohlsearch<CR>

"################## ctags ###############
"set tags=tags; " upward search and locate tags file from working directory - works well with 'set autochdir'
set tags=./tags; " upward search and locate tags file from current file directory - works well with 'set noautochdir'
set tags+=~/tmp/uvm-1.2/src/tags;


"################## Folding ###############
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" map <space> to toggle (open/close) folds. other fold commands: zo -> open, zc -> close
nnoremap <space> za
set foldmethod=indent   " fold based on indent level



"################## Command/Key Mappings ###############
" map :E to :Explore command
cabbrev E Explore
" map Shift+Tab to real Tab since tabs are expanded to spaces w/ expandtab
inoremap <S-Tab> <C-V><Tab>
