set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
" 设置包括vundle和初始化相关的runtime path
" 判断操作系统类型
if has("mac")
    set rtp+=~/.vim/bundle/Vundle.vim
    let path='~/.vim/bundle'
else
    set rtp+=$VIM/vimfiles/bundle/Vundle.vim
    let path=$VIM+'vimfiles/bundle'
endif

call vundle#begin(path)
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" common
Plugin 'https://github.com/altercation/vim-colors-solarized.git'
Plugin 'https://github.com/tomasr/molokai.git'
Plugin 'https://github.com/gosukiwi/vim-atom-dark.git'
Plugin 'https://github.com/majutsushi/tagbar.git'
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'https://github.com/scrooloose/syntastic.git'
Plugin 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plugin 'https://github.com/Valloric/YouCompleteMe.git' 
"Plugin 'https://github.com/Shougo/neocomplete.vim.git'
Plugin 'https://github.com/vim-airline/vim-airline.git'
Plugin 'https://github.com/vim-airline/vim-airline-themes.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'https://github.com/tpope/vim-repeat.git'
Plugin 'https://github.com/SirVer/ultisnips.git'
Plugin 'https://github.com/tpope/vim-commentary.git'
" clojure
" Plugin 'https://github.com/Lokaltog/vim-powerline.git'
" Plugin 'https://github.com/vim-scripts/VimClojure.git'
Plugin 'https://github.com/tpope/vim-fireplace.git'
Plugin 'https://github.com/guns/vim-sexp.git'
Plugin 'git://github.com/tpope/vim-sexp-mappings-for-regular-people.git'
Plugin 'https://github.com/guns/vim-clojure-static.git'
Plugin 'https://github.com/kien/rainbow_parentheses.vim.git'
" markdown
Plugin 'https://github.com/plasticboy/vim-markdown.git'
" golang
Plugin 'https://github.com/fatih/vim-go.git'
" javascript
Plugin 'https://github.com/pangloss/vim-javascript.git'
Plugin 'https://github.com/mattn/emmet-vim.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to upate or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set fencs=utf-8
set fileencodings=utf-8,bg18030,gbk,big5

syntax enable				" 启用语法高亮度
syntax on

:let maplocalleader = ","
:let mapleader = "\\"
" 配色方案vim-colors-solarized相关配置 地址:https://github.com/altercation/vim-colors-solarized
set background=dark
" colorscheme solarized
" colorscheme molokai
colorscheme atom-dark
let g:molokai_original = 1
let g:rehash256 = 1
" 设置状态栏主题风格
let g:Powerline_colorscheme='solarized256'

" 基于缩进或语法进行代码折叠
" set foldmethod=indent
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable
" 操作：za，打开或关闭当前折叠；zM，关闭所有折叠；zR，打开所有折叠。

set nobackup				" 不备份文件
set noswapfile
set number					" 显示行号
set relativenumber
set incsearch				" 查找并且高亮
set ignorecase smartcase	" 搜索时忽略大小写，但在有一个或以上大写字母时仍大小写敏感
set showmatch				" 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set expandtab				" 将tab扩展为空
set softtabstop=4			" 使得按退格键时可以一次删掉 4 个空格
set tabstop=4				" 设定 tab 长度为 4
set wildmenu 				" 启用文本模式的菜单
set guioptions-=m 			" 关闭菜单栏
set guioptions-=T 			" 关闭工具栏
set cursorline 				" 高亮光标所在行
set cursorcolumn			" 高亮光标所在列
set hlsearch				" 搜索关键词高亮
set nowrap					" 不自动折行
set magic					" 显示括号配对情况
set laststatus=2
set history=1000			" 历史记录数

" NERDTreeToggle
nmap <Leader>fl :NERDTreeToggle<CR>
let NERDTreeWinSize=35
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
"let NERDChristmasTree=0
"let NERDTreeChDirMode=2
"let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
"let NERDTreeShowBookmarks=1
" Automatically open a NERDTree if no files where specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open a NERDTree
nmap <F2> :NERDTreeToggle<cr>

" vim-clojure
" let vimclojure#NailgunClient = '~/.vim/vimclojure/client/ng'
" let vimclojure#WantNailgun = 1
" let g:vimclojure#HighlightBuiltins = 1
" let g:vimclojure#ParenRainbow = 1

" syntastic
" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme="luna" 
"这个是安装字体后 必须设置此项" 
" let g:airline_powerline_fonts = 1
"设置切换Buffer快捷键"
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>m :bp<CR>

" Tagbar
let g:tagbar_width=35
let g:tagbar_autofocus=1
let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
nmap <F5> :TagbarToggle<CR>

" vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" rainbow_parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

autocmd FileType clojure setlocal omnifunc=neoclojure#complete#omni
cd ~/Documents

