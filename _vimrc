" =============================================================================
"        需要手动进行的操作
" =============================================================================
" 推荐使用这个编译版本https://tuxproject.de/projects/vim/，这个版本对lua等支持都有，或者官方版本，官网版本暂时发现不支持lua，很多插件需要vim
" 对lua的支持，例如neocomplete
" 默认下载的vim或者vim绿色版本可以需要的文件在https://github.com/blueyi/vim_misc.git
"
" 1.建立自动备份文件夹"~/vimbak"，不管是win还是linux都创建在个人用户下。vim自动
" 生成的后缀为"~"和"un~"的备份文件和undo文件、swap文件、tags文件等将统一存放在该文件夹
"
" 2.手动创建vim插件管理器vundle的文件夹并clone vundle插件到该文件夹:
" linux下执行以下两条命令：
"   1."mkdir -p ~/.vim/bundle/Vundle.vim"
"   2."git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
"   将.vimrc放在用户根目录下即可
"
" win下使用cmd执行以下两条命令(默认cmd路径在当前用户文件夹)：
"   1."md vimfiles\bundle\Vundle.vim"
"   2."git clone https://github.com/VundleVim/Vundle.vim.git vimfiles\bundle\Vundle.vim"
"   将_vimrc放在用户根目录下，或者放在vim安装文件夹同目录，并搜索修改下面vundle配置中的rtp
"   和path将相应内容注释掉
"
"   如果想让插件和vim在同一文件夹，只需要将vimfiles文件夹与vim文件处于同一个文件夹下
"   并将_vimrc放在该文件夹下（本vimrc中的vundle默认采用这种方式）
"
" 3.打开vim，手动执行":PluginInstall"，即可自动安装vundle管理的插件
"
" 一些需要注意的默认设置：
" 1.C++程序编译时都默认加-g参数，方便gdb调试
" 2.不管源代码是否被修改，F10都会重新编译源文件，以防止头文件修改后而源代码没有修改导致不编译的情况
"
"参考https://github.com/mhinz/vim-galore
"
" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif


" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
"    source $VIMRUNTIME/mswin.vim
 "   behave mswin
    set diffexpr=MyDiff()

    set guifont=DejaVu_Sans_Mono:h12

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        set t_Co=256                   " 在终端启用256色

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" 安装方法为在终端输入如下命令
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
else
    "vimfiles文件夹与vim处于同一文件夹
    set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
    let path='$VIM/vimfiles/bundle'
    "vimfiles文件夹在用户文件夹
    "set rtp+=~/vimfiles/bundle/Vundle.vim/
    "let path='~/vimfiles/bundle'
    call vundle#begin(path)
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
""Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
""Plugin 'L9'
" Git plugin not hosted on GitHub
""Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
""Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
""Plugin 'user/L9', {'name': 'newL9'}


"********************************************
"My Plugin


    " Automated tag file generation and syntax highlighting of tags
    Plugin 'xolox/vim-easytags.git'
    Plugin 'xolox/vim-misc.git'

    " Auto complete
    Plugin 'Valloric/YouCompleteMe.git'
    "Plugin 'rdnetto/YCM-Generator.git'
"    Plugin 'Shougo/neocomplete.vim.git'

    "Speed up Vim by updating folds only when called-for.
    Plugin 'Konfekt/FastFold.git'

    " lean & mean status/tabline for vim that's light as air
    Plugin 'bling/vim-airline.git'

    " insert mode auto-completion for quotes, parens, brackets, etc.
""    Plugin 'Raimondi/delimitMate.git'
    Plugin 'jiangmiao/auto-pairs.git'

    " Syntax checking hacks for vim
    Plugin 'scrooloose/syntastic'

    " The ultimate snippet solution for Vim
    " Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'

    " extended % matching for HTML, LaTeX, and many other languages
    Plugin 'edsono/vim-matchit'

    " Support web develop
    " Plugin 'mattn/emmet-vim.git'

    " Fuzzy file, buffer, mru, tag, etc finder
    Plugin 'kien/ctrlp.vim'

    " a Git wrapper so awesome
    " 导致vim不能正常获取shell执行的返回结果
    Plugin 'tpope/vim-fugitive'

    " displays tags in a window, ordered by scope
    Plugin 'majutsushi/tagbar'

    " Markdown support
    Plugin 'godlygeek/tabular'
    Plugin 'plasticboy/vim-markdown'

    "intensely orgasmic commenting
    Plugin 'scrooloose/nerdcommenter'

    " visualize your Vim undo tree
    Plugin 'sjl/gundo.vim'

    "quoting/parenthesizing made simple use cs/ds
    Plugin 'tpope/vim-surround'

    "automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
    Plugin 'tpope/vim-sleuth'

    "Open URI with your favorite browser from your most favorite editor
    "Plugin 'tyru/open-browser.vim'

    "Alternate Files quickly (.c --> .h etc)
    Plugin 'blueyi/a.vim'

    "A vim plugin to display the indention levels with thin vertical lines
    Plugin 'Yggdroot/indentLine'

    "A tree explorer plugin for vim.
    Plugin 'scrooloose/nerdtree'

    "Simple templates plugin for Vim
    Plugin 'blueyi/vim-template'

    " other misc for vim running eg: ycm_extra_conf.py
    Plugin 'blueyi/vim-dep'



    "********************************************
    " Color schemes
    Plugin 'blueyi/myvimcolors'
    Plugin 'tomasr/molokai'
    Plugin 'flazz/vim-colorschemes'
    "********************************************


    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    " To ignore plugin indent changes, instead use:
    "filetype plugin on
    "
    " Brief help
    " :PluginList       - lists configured plugins
    " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    " :PluginSearch foo - searches for foo; append `!` to refresh local cache
    " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
    "
    " see :h vundle for more details or wiki for FAQ
    " Put your non-Plugin stuff after this line

    " -----------------------------------------------------------------------------
    "vim comfigure
    "

    "-- Chinese encoding support --
    " 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
    set encoding=utf-8                                    "设置gvim内部编码
    "set fileencoding=utf-8                                "设置当前文件编码
    set fileencodings=cs-bom,utf-8,cp936,gb2312,gb18030,big5,euc-jp,euc-kr,latin1     "设置支持打开的文件的编码

    "--fileformat，默认 ffs=dos,unix--
    set fileformat=unix                                   "设置新文件的<EOL>格式
    set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

    if (g:iswindows && g:isGUI)
        "解决菜单乱码
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim

        "解决consle输出乱码
        "language messages zh_CN.utf-8
        let $LANG='en' "set messages language
        set langmenu=en "set menu's language of gvim
    endif
    
    "--基本设置--
    filetype plugin on        "针对不同的文件类型加载对应的插件
    filetype plugin indent on               "启用缩进

    " Vim5 and later versions support syntax highlighting. Uncommenting the next
    " line enables syntax highlighting by default.
    if has("syntax")
        syntax on
    endif

    " 包含C++头文件
    if isdirectory('/usr/include/c++/4.8')
        set path+=/usr/include/c++/4.8
    endif

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    "--缩进设置--
    set autoindent        " 设置自动对齐(缩进)：即每行的缩进值与上一行相等；使用 noautoindent 取消设置
    "set smartindent        " 智能对齐方式
    set tabstop=4        " 设置制表符(tab键)的宽度
    set expandtab            "将Tab键转换为空格
    set softtabstop=4     " 设置软制表符的宽度
    set shiftwidth=4    " (自动) 缩进使用的4个空格
    set cindent            " 使用 C/C++ 语言的自动缩进方式
    set cinoptions={g0,0,1s,t0,p2s,(03s,=.5s,>1s,=1s,:1s     "设置C/C++语言的具体缩进方式
    set smarttab    "使tab键可以根据上下文中的tabstop,softtabstop,shiftwidth智能设置
    set shiftround

    "--backup/swap/info/undo文件相关设置--
    set backup                  "开启备份
    set backupdir=~/vimbak      "设置自动备份文件夹
    set backupext=-vimbackup    "设置备份文件的后缀
    set backupskip=             "设置需要忽略备份的文件，查看help
    set directory=~/vimbak      "设置swap文件所在文件夹，默认为文件当前目录
    set undodir=~/vimbak        "设置un~文件夹
    set undofile                "开启undo选项，即可以进行历史修改回退
    set updatecount=100         "设置每修改100个字符写入一次swap文件
    "set writebackup            "保存文件前建立备份，保存成功后删除该备份
    "set nobackup               "设置无备份文件
    "set noswapfile             "设置无临时文件

    "--导航相关设置--
    set cursorline             "突出显示当前行
    "-突出显示当前行和当前列-
    au WinLeave * set nocursorline nocursorcolumn
    au WinEnter * set cursorline cursorcolumn
    "set cursorline cursorcolumn
    "-代码折叠设置-
    "set foldenable                                        "启用折叠
    set foldmethod=syntax " 用语法高亮来定义折叠
    "set foldmethod=indent                                 "indent 折叠方式
    " set foldmethod=marker                                "marker 折叠方式
    set foldlevel=100 " 启动vim时不要自动折叠代码
    set foldcolumn=5 " 设置折叠栏宽度
    " 用空格键来开关折叠
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
    "-搜索设置-
    set hlsearch        "高亮搜索
    set incsearch       "输入字符串就显示匹配点
    set ignorecase      "搜索模式里忽略大小写
    set smartcase       "如果搜索模式包含大写字符，不使用 'ignorecase' 选项。只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用。
    set mouse=a         "在任何模式下启用鼠标
    set scrolloff=4     "当光标位于屏幕最上或最下面时保持其上面或下面有可见的4行
    set sidescroll=5    "保持左右至少有5列

    "--其他设置--
    "set autowrite      "离开当前编辑文件时，自动把修改内容写入文件（默认在buffer中）
    set noautowrite     "设置默认不写入
    set noautowriteall  "这样退出时会提示保存
    set autoread        "当文件在外部被修改，自动更新该文件
    set backspace=indent,eol,start      " 设置退格键在插入模式下可作用于这三处
    "set clipboard=unnamed   "所有的复制操作都会覆盖"*寄存器，该处存放外部粘贴板内容
    set hidden          "允许不保存buffer而切换buffer，此时buffer被暂存在内存中
    set mousemodel=popup    "设置GUI下鼠标右键显示菜单
    set history=100        "历史记录条数
    set noequalalways   "分割窗口时不自动平分大小
    set whichwrap=b,s,<,>,[,] " 光标从行首和行末时可以跳到另一行去

    "--界面配置--
    " -----------------------------------------------------------------------------
    "--通用配置--
    set number          "显示行号
    set laststatus=2    "启用状态栏信息
    set ruler           " 标尺，用于显示光标位置的行号和列号，冒号分隔。
    set cmdheight=2     "设置命令行的高度为2，默认为1
    set shortmess=atI   "去掉欢迎界面
    set showmatch       "设置匹配模式，显示匹配的括号
    set showcmd         "命令行显示最后一次输入的命令
    set showmode        " 命令行显示vim当前模式
    set gcr=a:block-blinkon0            "禁止光标闪烁o
    set list listchars=tab:»·,trail:·   "显示多余的空白字符


    " 启用每行超过80列的字符提示（字体变蓝并加下划线）
    "au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
    " set guifont=YaHei_Consolas_Hybrid:h8  "设置字体:字号（字体名称空格用下划线代替）

    "--GUI配置--
    " 设置 gVim 窗口初始位置及大小
    if g:isGUI
        " au GUIEnter * simalt ~x                           "窗口启动时自动最大化
        winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
        set lines=38 columns=100                          "指定窗口大小，lines为高度，columns为宽度
    endif

    "设置配色方案
    " set t_Co=256
    if g:isGUI
        " colorscheme Tomorrow-Night-Eighties               "Gvim配色方案
        colorscheme molokai
        " colorscheme solarized
    else
        " colorscheme Tomorrow-Night-Eighties               "终端配色方案
        colorscheme molokai
        "colorscheme desert
    endif

    " 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
    if g:isGUI
        set guioptions-=m
        set guioptions-=T
        set guioptions-=r
        set guioptions-=L
        map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
                    \set guioptions-=m <Bar>
                    \set guioptions-=T <Bar>
                    \set guioptions-=r <Bar>
                    \set guioptions-=L <Bar>
                    \else <Bar>
                    \set guioptions+=m <Bar>
                    \set guioptions+=T <Bar>
                    \set guioptions+=r <Bar>
                    \set guioptions+=L <Bar>
                    \endif<CR>
    endif

    "--其他设置--
    " -----------------------------------------------------------------------------
    set wrap            "设置不自动换行
    set linebreak        " 整词换行
    "set hidden " Hide buffers when they are abandoned
    "set previewwindow    " 标识预览窗口

    "--快捷键设置--
    " -----------------------------------------------------------------------------
    let mapleader = ';'  "将反斜扛\映射为;

    " 常规模式下输入;cS 清除整个文件行尾空格，会提示确认
    nmap ;cS :%s/\s\+$//gc<CR>:noh<CR>
    " 常规模式下输入;cSl 清除当前行尾空格
    nmap ;cSl :s/\s\+$//<CR>:noh<CR>

    " 常规模式下输入;cM 清除行尾 ^M 符号
    nmap ;cM :%s/\r$//gc<CR>:noh<CR>
    " 常规模式下输入;cMl 清除当前行尾 ^M 符号
    nmap ;cMl :s/\r$//<CR>:noh<CR>

    "标签窗口临时最大化
    function! Zoom ()
        " check if is the zoomed state (tabnumber > 1 && window == 1)
        if tabpagenr('$') > 1 && tabpagewinnr(tabpagenr(), '$') == 1
            let l:cur_winview = winsaveview()
            let l:cur_bufname = bufname('')
            tabclose

            " restore the view
            if l:cur_bufname == bufname('')
                call winrestview(cur_winview)
            endif
        else
            tab split
        endif
    endfunction

    "<leader>是反斜扛\
    nmap <leader>z :call Zoom()<CR>

    " 在不使用 MiniBufExplorer 插件时也可用<C-k,j,h,l>切换到上下左右的窗口中去
    noremap <c-k> <c-w>k
    noremap <c-j> <c-w>j
    noremap <c-h> <c-w>h
    noremap <c-l> <c-w>l

    "常规模式下输入F2调用nerdtree插件
    nmap <F2> :NERDTreeToggle<CR>

    "F3调用Tagbar插件
    nmap <F3> :TagbarToggle<CR>

    "F4调用Gundo插件
    nnoremap <F4> :GundoToggle<CR>

    "-- For C# development setting --
    " F5 compile cs file
    map <F5> :!csc % <CR>
    imap <F5> <ESC>!csc % <CR>

    "-- For java development setting --
    map <F7> :call RunJava() <CR>
    imap <F7> <ESC> :call RunJava() <CR>
    func! RunJava()
        exe ":ccl"
        exe ":update"
        if g:iswindows
            exe ':!javac %'
        else
            exe ':!javac %'
        endif
        if v:shell_error == 0
            if g:iswindows
                exe ":!java -cp . %<"
            else
                exe ":!java -cp . %<"
            endif
        endif
    endfunc


    "-- For CUDA development setting --
    " Ctrl + F8 compile, link and execute .cu file with Samples header file
    map <C-F8> :call Nvcc_S() <CR>
    imap <C-F8> <ESC> :call Nvcc_S() <CR>
    " F8 compile, link and execute .cu file without Samples header file
    map <F8> :call Nvcc() <CR>
    imap <F8> <ESC> :call Nvcc() <CR>
    "将CUDA Samples中的头文件加入编译路径
    func! Nvcc_S()
        exe ":ccl"
        exe ":update"
        if g:iswindows
            exe ':!nvcc --ptxas-options=-v % -I "C:\ProgramData\NVIDIA Corporation\CUDA Samples\v7.5\common\inc" -o %<.exe'
        else
            exe ':!nvcc --ptxas-options=-v % -I "C:\ProgramData\NVIDIA Corporation\CUDA Samples\v7.5\common\inc" -o %<.o'
        endif
        if v:shell_error == 0
            if g:iswindows
                exe ":!%<.exe"
            else
                exe ":!%<.o"
            endif
        endif
    endfunc

    func! Nvcc()
        exe ":ccl"
        exe ":update"
        if g:iswindows
            exe ':!nvcc --ptxas-options=-v % -o %<.exe'
        else
            exe ':!nvcc --ptxas-options=-v % -o %<.o'
        endif
        if v:shell_error == 0
            if g:iswindows
                exe ":!%<.exe"
            else
                exe ":!%<.o"
            endif
        endif
    endfunc

    "-- For python development setting --
    " F9 run python
    map <F9> :call Py_run() <CR>
    imap <F9> <ESC> :call Py_run() <CR>
    func! Py_run()
        exe ":ccl"
        exe ":update"
        exe ":!python %"
    endfunc

    "--For C/C++ setting--
    " F10 一键保存、编译、连接存并运行
    map <F10> :call Run()<CR>
    imap <F10> <ESC>:call Run()<CR>

    " Ctrl + F9 一键保存并编译
    map <c-F9> :call Compile()<CR>
    imap <c-F9> <ESC>:call Compile()<CR>

    " Ctrl + F10 一键保存并连接
    map <c-F10> :call Link()<CR>
    imap <c-F10> <ESC>:call Link()<CR>

    let s:LastShellReturn_C = 0
    let s:LastShellReturn_L = 0
    let s:ShowWarning = 1
    let s:Obj_Extension = '.o'
    let s:Head_Extension = '.h'
    let s:Exe_Extension = '.exe'
    let s:Sou_Error = 0

    let s:windows_CFlags = 'gcc\ -fexec-charset=gbk\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
    let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

    let s:windows_CPPFlags = 'g++\ -fexec-charset=gbk\ -Wall\ -std=gnu++11\ -g\ -O0\ -c\ %\ -o\ %<.o'
    let s:linux_CPPFlags = 'g++\ -Wall\ -std=gnu++11\ -g\ -O0\ -c\ %\ -o\ %<.o'

    func! Compile()
        exe ":ccl"
        exe ":update"
        let s:Sou_Error = 0
        let s:LastShellReturn_C = 0
        let Sou = expand("%:p")
        let v:statusmsg = ''
        if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
            let Obj = expand("%:p:r").s:Obj_Extension
            let Head = expand("%:p:r").s:Head_Extension
            let Obj_Name = expand("%:p:t:r").s:Obj_Extension
            "if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)) || (getftime(Obj) < getftime(Head)))
            if !filereadable(Obj) || (filereadable(Obj))
                redraw!
                if expand("%:e") == "c"
                    if g:iswindows
                        exe ":setlocal makeprg=".s:windows_CFlags
                    else
                        exe ":setlocal makeprg=".s:linux_CFlags
                    endif
                    echohl WarningMsg | echo " compiling..."
                    silent make
                elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                    if g:iswindows
                        exe ":setlocal makeprg=".s:windows_CPPFlags
                    else
                        exe ":setlocal makeprg=".s:linux_CPPFlags
                    endif
                    echohl WarningMsg | echo " compiling..."
                    silent make
                endif
                redraw!
                if v:shell_error != 0
                    let s:LastShellReturn_C = v:shell_error
                endif
                if g:iswindows
                    if s:LastShellReturn_C != 0
                        exe ":bo cope"
                        echohl WarningMsg | echo " compilation failed"
                    else
                        if s:ShowWarning
                            exe ":bo cw"
                        endif
                        echohl WarningMsg | echo " compilation successful"
                    endif
                else
                    if empty(v:statusmsg)
                        echohl WarningMsg | echo " compilation successful"
                    else
                        exe ":bo cope"
                    endif
                endif
            else
                echohl WarningMsg | echo ""Obj_Name"is up to date"
            endif
        else
            let s:Sou_Error = 1
            echohl WarningMsg | echo " please choose the correct source file"
        endif
        exe ":setlocal makeprg=make"
    endfunc

    func! Link()
        call Compile()
        if s:Sou_Error || s:LastShellReturn_C != 0
            return
        endif
        if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
            let s:LastShellReturn_L = 0
            let Sou = expand("%:p")
            let Obj = expand("%:p:r").s:Obj_Extension
            if g:iswindows
                let Exe = expand("%:p:r").s:Exe_Extension
                let Exe_Name = expand("%:p:t:r").s:Exe_Extension
            else
                let Exe = expand("%:p:r")
                let Exe_Name = expand("%:p:t:r")
            endif
            let v:statusmsg = ''
            if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
                redraw!
                if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
                    if expand("%:e") == "c"
                        setlocal makeprg=gcc\ -o\ %<\ %<.o
                        echohl WarningMsg | echo " linking..."
                        silent make
                    elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                        setlocal makeprg=g++\ -o\ %<\ %<.o
                        echohl WarningMsg | echo " linking..."
                        silent make
                    endif
                    redraw!
                    if v:shell_error != 0
                        let s:LastShellReturn_L = v:shell_error
                    endif
                    if g:iswindows
                        if s:LastShellReturn_L != 0
                            exe ":bo cope"
                            echohl WarningMsg | echo " linking failed"
                        else
                            if s:ShowWarning
                                exe ":bo cw"
                            endif
                            echohl WarningMsg | echo " linking successful"
                        endif
                    else
                        if empty(v:statusmsg)
                            echohl WarningMsg | echo " linking successful"
                        else
                            exe ":bo cope"
                        endif
                    endif
                else
                    echohl WarningMsg | echo ""Exe_Name"is up to date"
                endif
            endif
            setlocal makeprg=make
        endif
    endfunc

    func! Run()
        let s:ShowWarning = 0
        call Link()
        let s:ShowWarning = 1
        if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
            return
        endif
        let Sou = expand("%:p")
        if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
            let Obj = expand("%:p:r").s:Obj_Extension
            if g:iswindows
                let Exe = expand("%:p:r").s:Exe_Extension
            else
                let Exe = expand("%:p:r")
            endif
            if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                redraw!
                echohl WarningMsg | echo " running..."
                if g:iswindows
                    exe ":!%<.exe"
                else
                    if g:isGUI
                        exe ":!gnome-terminal -x bash -c './%<; echo; echo 请按 Enter 键继续; read'"
                    else
                        exe ":!clear; ./%<"
                    endif
                endif
                redraw!
                echohl WarningMsg | echo " running finish"
            endif
        endif
    endfunc

    "使用make编译
    "-- QuickFix setting --
    " 按下F6，执行make clean
    " map <F6> :make clean<CR><CR><CR>
    " 按下F7，执行make编译程序，并打开quickfix窗口，显示编译信息
    " map <F7> :make<CR><CR><CR> :copen<CR><CR>
    " 按下F8，光标移到上一个错误所在的行
    " map <F8> :cp<CR>
    " 按下F9，光标移到下一个错误所在的行
    " map <F9> :cn<CR>
    " 以下的映射是使上面的快捷键在插入模式下也能用
    " imap <F6> <ESC>:make clean<CR><CR><CR>
    " imap <F7> <ESC>:make<CR><CR><CR> :copen<CR><CR>
    " imap <F8> <ESC>:cp<CR>
    " imap <F9> <ESC>:cn<CR>

    "-- For ruby development setting --
    " install rsense
    "let g:rsenseHome = "/home/blueyi/opt/rsense-0.3"
    "If you want to start completion automatically, add the following code to .vimrc and restart Vim.
    "let g:rsenseUseOmniFunc = 1

    " F9 run ruby
    "map <F9> :!ruby -w % <CR>
    "imap <F9> <ESC>:!ruby -w % <CR>
    " F8 check ruby syntax only
    "map <F8> :w !ruby -c % <CR>
    "imap <F8> <ESC>:w !ruby -c % <CR>

    "autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
    "autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
    "autocmd FileType ruby,eruby let g:rubycomplete_rails = 1


    "--------Plugin setting start------------

    "***************
    "--neocomplete configure--
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    ""    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    ""    function! s:my_cr_function()
    ""        return neocomplete#close_popup() . "\<CR>"
    ""        " For no inserting <CR> key.
    ""        "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    ""    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    "    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


    "***************
    "--Youcompleteme configure--
    "Recompile and diagnostics withe F5
    "    nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
    " let g:ycm_use_ultisnips_completer = 1
    
    if g:islinux
        let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/vim-dep/ycm_extra_conf.py'
    else
        let g:ycm_global_ycm_extra_conf = '$VIM/vimfiles/bundle/vim-dep/ycm_extra_conf.py'
    endif
    " 设置转到定义处的快捷键为ALT + G，这个功能非常赞
    nmap <M-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>
    " 补全功能在注释中同样有效
    let g:ycm_complete_in_comments=1
    " 开启标签补全
    let g:ycm_collect_identifiers_from_tags_files = 1
    " 从第一个键入字符就开始罗列匹配项
    let g:ycm_min_num_of_chars_for_completion=1
    "离开插入模式后自动关闭预览窗口
    "autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    " 禁止缓存匹配项，每次都重新生成匹配项
    let g:ycm_cache_omnifunc=0
    " 语法关键字补全
    let g:ycm_seed_identifiers_with_syntax=1
    " 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;
    let g:ycm_key_invoke_completion = '<M-;>'
    "回车即选中当前项
    inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

    "***************
    "--vim-airline configure--
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline_powerline_fonts = 0

    "***************
    "--Syntastic configure--
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_python_python_exec = 'C:\Program Files\Python35\python.exe'
    "默认使用g++
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
    "忽略检查的文件
    let g:syntastic_mode_map = {
                \ "mode": "passive",
                \ "active_filetypes": ["c", "cpp", "py"],
                \ "passive_filetypes": ["cu"]}
    "如果使用clang++则需要以下
    "let g:syntastic_cpp_compiler = 'clang++'
    "let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
    " support html5
    "let g:syntastic_html_tidy_exec = 'tidy5'

    "***************
    "--UltiSnips configure--
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

    "***************
    "--matchit configure--
    let b:match_words='\<begin\>:\<end\>'
    let b:match_ignorecase = 1

    "***************
    "--emmet configure--
    "let g:user_emmet_mode='n'    "only enable normal mode functions.
    "let g:user_emmet_mode='inv'  "enable all functions, which is equal to
    "let g:user_emmet_mode='a'    "enable all function in all mode.
    "Enable just for html/css
    "let g:user_emmet_install_global = 0
    "autocmd FileType html,css EmmetInstall

    "***************
    "--ctrlp configure--
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'

    "***************
    "--tagbar configure--
    let g:tagbar_autofocus = 1

    "***************
    "--vim-markdown configure--
    let g:vim_markdown_folding_disabled=1
    let g:vim_markdown_conceal = 0


    "***************
    "--gundo configure--
    let g:gundo_width = 60
    let g:gundo_preview_height = 40
    let g:gundo_right = 1

    "***************
    "    "--open-browser configure--
    "    nmap gx <Plug>(openbrowser-smart-search)
    "    vmap gx <Plug>(openbrowser-smart-search)
    "    " Open URI under cursor.
    "    nmap ob <Plug>(openbrowser-open)
    "    " Open selected URI.
    "    vmap ob <Plug>(openbrowser-open)
    "    " Search word under cursor.
    "    nmap ob <Plug>(openbrowser-search)
    "    " Search selected word.
    "    vmap ob <Plug>(openbrowser-search)
    "    " If it looks like URI, Open URI under cursor.
    "    " Otherwise, Search word under cursor.
    "    nmap ob <Plug>(openbrowser-smart-search)
    "    " If it looks like URI, Open selected URI.
    "    " Otherwise, Search selected word.
    "    vmap ob <Plug>(openbrowser-smart-search)
    " In command-line
    " :OpenBrowser http://google.com/
    " :OpenBrowserSearch ggrks
    " :OpenBrowserSmartSearch http://google.com/
    " :OpenBrowserSmartSearch ggrks


    "***************
    "-- a.vim 插件配置--
    " 用于切换C/C++头文件
    " :A     ---切换头文件并独占整个窗口
    " :AV    ---切换头文件并垂直分割窗口
    " :AS    ---切换头文件并水平分割窗口

    "***************
    " -- indentLine configure--
    if g:isGUI
        let g:indentLine_char = '┊'
        let g:indentLine_color_gui = '#A4E57E'
    endif

    " 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
    let g:indentLine_color_term = 239

    " 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色


    "***************
    "--nerdtree configure--

    "***************
    " --nerdcommenter configure--
    " -----------------------------------------------------------------------------
    " 我主要用于C/C++代码注释(其它的也行)
    " 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
    " <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
    " <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
    " <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
    " <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
    " <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
    " <Leader>cA 行尾注释
    let NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格


    "***************
    " --vim-template configure--
    " -----------------------------------------------------------------------------
    "   let g:templates_plugin_loaded = 1 to skip loading of this plugin.
    "   let g:templates_no_autocmd = 1 to disable automatic insertion of template in new files.
    "   let g:templates_directory = '/path/to/directory' to specify a directory from where to search for additional global templates. See template search order below for more details. This can also be a list of paths.
    "    let g:templates_name_prefix = '.vimtemplate.' to change the name of the template files that are searched.
    "    let g:templates_global_name_prefix = 'template:' to change the prefix of the templates in the global template directory.
    "    let g:templates_debug = 1 to have vim-template output debug information
    "    let g:templates_fuzzy_start = 1 to be able to name templates with implicit fuzzy matching at the start of a template name. For example a template file named template:.c would match test.cpp.
    "    let g:templates_tr_in = [ '.', '_', '?' ] and let g:templates_tr_out = [ '\.', '.*', '\?' ] would allow you to change how template names are interpretted as regular expressions for matching file names. This might be helpful if hacking on a windows box where * is not allowed in file names. The above configuration, for example, treates underscores _ as the typical regex wildcard .*.
    "    let g:templates_no_builtin_templates = 1 to disable usage of the built-in templates. See template search order below for more details.
    "    let g:templates_user_variables = [[USERVAR, UserFunc]] to enable user-defined variable expanding. See User-defined variable expanding below for details.

    "***************
    " --delimitMate configure--
    " -----------------------------------------------------------------------------
    ""    let g:delimitMate_autoclose = 1
    ""    let g:delimitMate_matchpairs = "(:),[:],{:},<:>"
    ""    au FileType cpp,md let b:delimitMate_matchpairs = "(:),[:],{:}"
    ""
    ""    "换行自动缩进
    ""    let g:delimitMate_expand_cr = 1
    ""    "仅针对cpp和c文件生效
    ""    "au FileType cpp,c let b:delimitMate_expand_cr = 1
    ""    let g:delimitMate_jump_expansion = 1
    ""    let g:delimitMate_expand_space = 1
    ""    let g:delimitMate_expand_inside_quotes = 1
    ""    let g:delimitMate_balance_matchpairs = 1

    " --auto-pairs configure--
    " -----------------------------------------------------------------------------
    let g:AutoPairs = {'《':'》', '“':'”', '（':'）', '(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}


    " --easytags configure--
    let g:easytags_file = '~/vimbak/tags'


    "--------Plugin setting end------------

    "--其他配置--
    " -----------------------------------------------------------------------------
    "ctags工具配置 >
    " -----------------------------------------------------------------------------
    " 对浏览代码非常的方便,可以在函数,变量之间跳转等
    set tags=./tags,tags;$HOME
    set tags+=~/vimbak/tags
    "set tags+=./addtags/qt5_h
    "set tags+=./addtags/cpp_stl
    "set tags+=./addtags/qt5_cpp

    "--常用自动命令配置--
    " -----------------------------------------------------------------------------
    "自动切换目录为当前编辑文件所在目录
    au BufRead,BufNewFile,BufEnter * cd %:p:h


