" To use fancy symbols wherever possible, change this setting from 0 to 1
" and use a font from https://github.com/ryanoasis/nerd-fonts in your terminal 
" (if you aren't using one of those fonts, you will see funny characters here. 
" Turst me, they look nice when using one of those fonts).
let fancy_symbols_enabled = 0


set encoding=utf-8
let using_neovim = has('nvim')
let using_vim = !using_neovim

" ============================================================================
" Vim-plug initialization
" Avoid modifying this section, unless you are very sure of what you are doing

let vim_plug_just_installed = 0
if using_neovim
    let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
else
    let vim_plug_path = expand('~/.vim/autoload/plug.vim')
endif
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    if using_neovim
        silent !mkdir -p ~/.config/nvim/autoload
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        silent !mkdir -p ~/.vim/autoload
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" Obscure hacks done, you can now modify the rest of the config down below 
" as you wish :)
" IMPORTANT: some things in the config are vim or neovim specific. It's easy 
" to spot, they are inside `if using_vim` or `if using_neovim` blocks.

" ============================================================================
" Active plugins
" You can disable or add new ones here:

" this needs to be here, so vim-plug knows we are declaring the plugins we
" want to use
if using_neovim
    call plug#begin("~/.config/nvim/plugged")
else
    call plug#begin("~/.vim/plugged")
endif

" Now the actual plugins:

" Override configs by directory
Plug 'arielrossanigo/dir-configs-override.vim'
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Better file browser
Plug 'scrooloose/nerdtree'
" Class/module browser
Plug 'majutsushi/tagbar'
" Search results counter
Plug 'vim-scripts/IndexedSearch'
" A couple of nice colorschemes
" Plug 'fisadev/fisa-vim-colorscheme'
Plug 'patstockwell/vim-monokai-tasty'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Code and files fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Pending tasks list
Plug 'fisadev/FixedTaskList.vim'

Plug 'flazz/vim-colorschemes'



" Async autocompletion
if using_neovim && vim_plug_just_installed
    Plug 'Shougo/deoplete.nvim', {'do': ':autocmd VimEnter * UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
endif
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
" Python autocompletion
Plug 'deoplete-plugins/deoplete-jedi'
" Completion from other opened files
Plug 'Shougo/context_filetype.vim'
" Just to add the python go-to-definition and similar features, autocompletion
" from this plugin is disabled
Plug 'davidhalter/jedi-vim'
" Automatically close parenthesis, etc
Plug 'Townk/vim-autoclose'
" Surround
Plug 'tpope/vim-surround'
" Indent text object
Plug 'michaeljsmith/vim-indent-object'
" Indentation based movements
Plug 'jeetsukumaran/vim-indentwise'
" Better language packs
Plug 'sheerun/vim-polyglot'
" Ack code search (requires ack installed in the system)
Plug 'mileszs/ack.vim'
" Paint css colors with the real color
Plug 'lilydjwg/colorizer'
" Window chooser
Plug 't9md/vim-choosewin'
" Automatically sort python imports
Plug 'fisadev/vim-isort'
" Highlight matching html tags
Plug 'valloric/MatchTagAlways'
" Generate html in a simple way
Plug 'mattn/emmet-vim'
" Git integration
Plug 'tpope/vim-fugitive'
" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'
" Linters
Plug 'neomake/neomake'
" Relative numbering of lines (0 is the current line)
" (disabled by default because is very intrusive and can't be easily toggled
" on/off. When the plugin is present, will always activate the relative
" numbering every time you go to normal mode. Author refuses to add a setting
" to avoid that)
Plug 'myusuf3/numbers.vim'
" Nice icons in the file explorer and file type status line.
Plug 'ryanoasis/vim-devicons'

if using_vim
    " Consoles as buffers (neovim has its own consoles as buffers)
    Plug 'rosenfeld/conque-term'
    " XML/HTML tags navigation (neovim has its own)
    Plug 'vim-scripts/matchit.zip'
endif

" Code searcher. If you enable it, you should also configure g:hound_base_url 
" and g:hound_port, pointing to your hound instance
" Plug 'mattn/webapi-vim'
" Plug 'jfo/hound.vim'

" Tell vim-plug we finished declaring plugins, so it can load them
call plug#end()

" ============================================================================
" Install plugins the first time vim runs

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" ============================================================================
" Vim settings and mappings
" You can edit them as you wish
 
if using_vim
    " A bunch of things that are set by default in neovim, but not in vim

    " no vi-compatible
    set nocompatible

    " allow plugins by file type (required for plugins!)
    filetype plugin on
    filetype indent on

    " always show status bar
    set ls=2

    " incremental search
    set incsearch
    " highlighted search results
    set hlsearch

    " syntax highlight on
    syntax on

    " better backup, swap and undos storage for vim (nvim has nice ones by
    " default)
    set directory=~/.vim/dirs/tmp     " directory to place swap files in
    set backup                        " make backup files
    set backupdir=~/.vim/dirs/backups " where to put backup files
    set undofile                      " persistent undos - undo after you re-open the file
    set undodir=~/.vim/dirs/undos
    set viminfo+=n~/.vim/dirs/viminfo
    " create needed directories if they don't exist
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, "p")
    endif
    if !isdirectory(&directory)
        call mkdir(&directory, "p")
    endif
    if !isdirectory(&undodir)
        call mkdir(&undodir, "p")
    endif
end

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" show line numbers
set nu

" remove ugly vertical lines on window division
set fillchars+=vert:\ 

" needed so deoplete can auto select the first suggestion
set completeopt+=noinsert
" comment this line to enable autocompletion preview window
" (displays documentation related to the selected completion option)
" disabled by default because preview makes the window flicker
set completeopt-=preview

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" save as sudo
ca w!! w !sudo tee "%"

" tab navigation mappings
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" clear search results
nnoremap <silent> // :noh<CR>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/bash 

" Ability to add python breakpoints
" (I use ipdb, but you can change it to whatever tool you use for debugging)
au FileType python map <silent> <leader>b Oimport ipdb; ipdb.set_trace()<esc>

" ============================================================================
" Plugins settings and mappings
" Edit them as you wish.

" Tagbar -----------------------------

" toggle tagbar display
map <F4> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

" NERDTree -----------------------------

" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" Enable folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" Fix directory colors
highlight! link NERDTreeFlags NERDTreeDir

" Remove expandable arrow
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeNodeDelimiter = "\x07"

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" Tasklist ------------------------------

" show pending tasks list
map <F2> :TaskList<CR>

" Neomake ------------------------------

" Run linter on write
autocmd! BufWritePost * Neomake

" Check code as python3 by default
let g:neomake_python_python_maker = neomake#makers#ft#python#python()
let g:neomake_python_flake8_maker = neomake#makers#ft#python#flake8()
let g:neomake_python_python_maker.exe = 'python3 -m py_compile'
let g:neomake_python_flake8_maker.exe = 'python3 -m flake8'

" Disable error messages inside the buffer, next to the problematic line
let g:neomake_virtualtext_current_error = 0

" Fzf ------------------------------

" file finder mapping
nmap ,e :Files<CR>
" tags (symbols) in current file finder mapping
nmap ,g :BTag<CR>
" the same, but with the word under the cursor pre filled
nmap ,wg :execute ":BTag " . expand('<cword>')<CR>
" tags (symbols) in all files finder mapping
nmap ,G :Tags<CR>
" the same, but with the word under the cursor pre filled
nmap ,wG :execute ":Tags " . expand('<cword>')<CR>
" general code finder in current file mapping
nmap ,f :BLines<CR>
" the same, but with the word under the cursor pre filled
nmap ,wf :execute ":BLines " . expand('<cword>')<CR>
" general code finder in all files mapping
nmap ,F :Lines<CR>
" the same, but with the word under the cursor pre filled
nmap ,wF :execute ":Lines " . expand('<cword>')<CR>
" commands finder mapping
nmap ,c :Commands<CR>

" Deoplete -----------------------------

" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'ignore_case': v:true,
\   'smart_case': v:true,
\})
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" Jedi-vim ------------------------------

" Disable autocompletion (using deoplete instead)
let g:jedi#completions_enabled = 0

" All these mappings work only for python code:
" Go to definition
let g:jedi#goto_command = ',d'
" Find ocurrences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>

" Ack.vim ------------------------------

" mappings
nmap ,r :Ack 
nmap ,wr :execute ":Ack " . expand('<cword>')<CR>

" Window Chooser ------------------------------

" mapping
nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1

" Signify ------------------------------

" this first setting decides in which order try to guess your current vcs
" UPDATE it to reflect your preferences, it will speed up opening files
let g:signify_vcs_list = ['git', 'hg']
" mappings to jump to changed blocks
nmap <leader>sn <plug>(signify-next-hunk)
nmap <leader>sp <plug>(signify-prev-hunk)
" nicer colors
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert
"  mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Yankring -------------------------------

if using_neovim
    let g:yankring_history_dir = '~/.config/nvim/'
    " Fix for yankring and neovim problem when system has non-text things
    " copied in clipboard
    let g:yankring_clipboard_monitor = 0
else
    let g:yankring_history_dir = '~/.vim/dirs/'
endif

" Airline ------------------------------

let g:airline_powerline_fonts = 0
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Fancy Symbols!!

if fancy_symbols_enabled
    let g:webdevicons_enable = 1

    " custom airline symbols
    if !exists('g:airline_symbols')
       let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
else
    let g:webdevicons_enable = 0
endif

" Custom configurations ----------------

" Include user's custom nvim configurations
if using_neovim
    let custom_configs_path = "~/.config/nvim/custom.vim"
else
    let custom_configs_path = "~/.vim/custom.vim"
endif
if filereadable(expand(custom_configs_path))
  execute "source " . custom_configs_path
endif

" Настройки табов для Python, согласно рекоммендациям
set tabstop=4 
set shiftwidth=4
set smarttab
set expandtab "Ставим табы пробелами
set softtabstop=4 "4 пробела в табе
" Автоотступ
set autoindent
" Перед сохранением вырезаем пробелы на концах (только в .py файлах)
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

set showtabline=1
" Переносим на другую строчку, разрываем строки
set wrap
set linebreak


" ===============================================================
" OceanicNext
" Author: Mike Hartington
" ===============================================================

" {{{ Setup
  set background=dark
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
  let g:colors_name="OceanicNext"
" }}}
" {{{ Italics
  let g:oceanic_next_terminal_italic = get(g:, 'oceanic_next_terminal_italic', 0)
  let s:italic = ""
  if g:oceanic_next_terminal_italic == 1
    let s:italic = "italic"
  endif
"}}}
" {{{ Bold
  let g:oceanic_next_terminal_bold = get(g:, 'oceanic_next_terminal_bold', 0)
  let s:bold = ""
  if g:oceanic_next_terminal_bold == 1
   let s:bold = "bold"
  endif
"}}}
" {{{ Colors
  let s:base00 = ['#1b2b34', '235']
  let s:base01 = ['#343d46', '237']
  let s:base02 = ['#4f5b66', '240']
  let s:base03 = ['#65737e', '243']
  let s:base04 = ['#a7adba', '145']
  let s:base05 = ['#c0c5ce', '251']
  let s:base06 = ['#cdd3de', '252']
  let s:base07 = ['#d8dee9', '253']
  let s:red    = ['#ec5f67', '203']
  let s:orange = ['#f99157', '209']
  let s:yellow = ['#fac863', '221']
  let s:green  = ['#99c794', '114']
  let s:cyan   = ['#62b3b2', '73']
  let s:blue   = ['#6699cc', '68']
  let s:purple = ['#c594c5', '176']
  let s:brown  = ['#ab7967', '137']
  let s:white  = ['#ffffff', '15']
  let s:none   = ['NONE',    'NONE']

" }}}
" {{{ Highlight function
function! s:hi(group, fg, bg, attr, attrsp)
  " fg, bg, attr, attrsp
  if !empty(a:fg)
    exec "hi " . a:group . " guifg=" .  a:fg[0]
    exec "hi " . a:group . " ctermfg=" . a:fg[1]
  endif
  if !empty(a:bg)
    exec "hi " . a:group . " guibg=" .  a:bg[0]
    exec "hi " . a:group . " ctermbg=" . a:bg[1]
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" .   a:attr
    exec "hi " . a:group . " cterm=" . a:attr
  endif
  if !empty(a:attrsp)
    exec "hi " . a:group . " guisp=" . a:attrsp[0]
  endif
endfunction
" }}}
" {{{ call s::hi(group, fg, bg, gui, guisp)
  call s:hi('Bold',                               '',       '',       s:bold,      '')
  call s:hi('Debug',                              s:red,    '',       '',          '')
  call s:hi('Directory',                          s:blue,   '',       '',          '')
  call s:hi('ErrorMsg',                           s:red,    s:base00, '',          '')
  call s:hi('Exception',                          s:red,    '',       '',          '')
  call s:hi('FoldColumn',                         s:blue,   s:base00, '',          '')
  call s:hi('Folded',                             s:base03, s:base01, s:italic,    '')
  call s:hi('IncSearch',                          s:base01, s:orange, 'NONE',      '')
  call s:hi('Italic',                             '',       '',       s:italic,    '')

  call s:hi('Macro',                              s:red,    '',       '',          '')
  call s:hi('MatchParen',                         s:base05, s:base03, '',          '')
  call s:hi('ModeMsg',                            s:green,  '',       '',          '')
  call s:hi('MoreMsg',                            s:green,  '',       '',          '')
  call s:hi('Question',                           s:blue,   '',       '',          '')
  call s:hi('Search',                             s:base03, s:yellow, '',          '')
  call s:hi('SpecialKey',                         s:base03, '',       '',          '')
  call s:hi('TooLong',                            s:red,    '',       '',          '')
  call s:hi('Underlined',                         s:red,    '',       '',          '')
  call s:hi('Visual',                             '',       s:base02, '',          '')
  call s:hi('VisualNOS',                          s:red,    '',       '',          '')
  call s:hi('WarningMsg',                         s:red,    '',       '',          '')
  call s:hi('WildMenu',                           s:base07, s:blue,   '',          '')
  call s:hi('Title',                              s:blue,   '',       '',          '')
  call s:hi('Conceal',                            s:blue,   s:base00, '',          '')
  call s:hi('Cursor',                             s:base00, s:base05, '',          '')
  call s:hi('NonText',                            s:base03, '',       '',          '')
  call s:hi('Normal',                             s:base07, s:base00, '',          '')
  call s:hi('EndOfBuffer',                        s:base05, s:base00, '',          '')
  call s:hi('LineNr',                             s:base03, s:base00, '',          '')
  call s:hi('SignColumn',                         s:base00, s:base00, '',          '')
  call s:hi('StatusLine',                         s:base01, s:base03, '',          '')
  call s:hi('StatusLineNC',                       s:base03, s:base01, '',          '')
  call s:hi('VertSplit',                          s:base00, s:base02, '',          '')
  call s:hi('ColorColumn',                        '',       s:base01, '',          '')
  call s:hi('CursorColumn',                       '',       s:base01, '',          '')
  call s:hi('CursorLine',                         '',       s:base01, 'None',      '')
  call s:hi('CursorLineNR',                       s:base00, s:base00, '',          '')
  call s:hi('CursorLineNr',                       s:base03, s:base01, '',          '')
  call s:hi('PMenu',                              s:base04, s:base01, '',          '')
  call s:hi('PMenuSel',                           s:base07, s:blue,   '',          '')
  call s:hi('PmenuSbar',                          '',       s:base02, '',          '')
  call s:hi('PmenuThumb',                         '',       s:base07, '',          '')
  call s:hi('TabLine',                            s:base03, s:base01, '',          '')
  call s:hi('TabLineFill',                        s:base03, s:base01, '',          '')
  call s:hi('TabLineSel',                         s:green,  s:base01, '',          '')
  call s:hi('helpExample',                        s:yellow, '',       '',          '')
  call s:hi('helpCommand',                        s:yellow, '',       '',          '')

  " Standard syntax highlighting
  call s:hi('Boolean',                            s:orange, '',       '',          '')
  call s:hi('Character',                          s:red,    '',       '',          '')
  call s:hi('Comment',                            s:base03, '',       s:italic,    '')
  call s:hi('Conditional',                        s:purple, '',       '',          '')
  call s:hi('Constant',                           s:orange, '',       '',          '')
  call s:hi('Define',                             s:purple, '',       '',          '')
  call s:hi('Delimiter',                          s:brown,  '',       '',          '')
  call s:hi('Float',                              s:orange, '',       '',          '')
  call s:hi('Function',                           s:blue,   '',       '',          '')

  call s:hi('Identifier',                         s:cyan,   '',       '',          '')
  call s:hi('Include',                            s:blue,   '',       '',          '')
  call s:hi('Keyword',                            s:purple, '',       '',          '')

  call s:hi('Label',                              s:yellow, '',       '',          '')
  call s:hi('Number',                             s:orange, '',       '',          '')
  call s:hi('Operator',                           s:base05, '',       '',          '')
  call s:hi('PreProc',                            s:yellow, '',       '',          '')
  call s:hi('Repeat',                             s:yellow, '',       '',          '')
  call s:hi('Special',                            s:cyan,   '',       '',          '')
  call s:hi('SpecialChar',                        s:brown,  '',       '',          '')
  call s:hi('Statement',                          s:red,    '',       '',          '')
  call s:hi('StorageClass',                       s:yellow, '',       '',          '')
  call s:hi('String',                             s:green,  '',       '',          '')
  call s:hi('Structure',                          s:purple, '',       '',          '')
  call s:hi('Tag',                                s:yellow, '',       '',          '')
  call s:hi('Todo',                               s:yellow, s:base01, '',          '')
  call s:hi('Type',                               s:yellow, '',       '',          '')
  call s:hi('Typedef',                            s:yellow, '',       '',          '')

  " LSP
  call s:hi('LspDiagnosticsDefaultError',         '',       '',       '',          '')
  call s:hi('LspDiagnosticsSignError',            s:red,    '',       '',          '')
  call s:hi('LspDiagnosticsUnderlineError',       '',       '',       'undercurl', '')

  call s:hi('LspDiagnosticsDefaultWarning',       '',       '',       '',          '')
  call s:hi('LspDiagnosticsSignWarning',          s:yellow, '',       '',          '')
  call s:hi('LspDiagnosticsUnderlineWarning',     '',       '',       'undercurl', '')

  call s:hi('LspDiagnosticsDefaultInformation',   '',       '',       '',          '')
  call s:hi('LspDiagnosticsSignInformation',      s:blue,   '',       '',          '')
  call s:hi('LspDiagnosticsUnderlineInformation', '',       '',       'undercurl', '')

  call s:hi('LspDiagnosticsDefaultHint',          '',       '',       '',          '')
  call s:hi('LspDiagnosticsSignHint',             s:cyan,   '',       '',          '')
  call s:hi('LspDiagnosticsUnderlineHint',        '',       '',       'undercurl', '')


  " TreeSitter stuff
  call s:hi('TSInclude',                          s:cyan,   '',       '',          '')
  call s:hi('TSPunctBracket',                     s:cyan,   '',       '',          '')
  call s:hi('TSPunctDelimiter',                   s:base07, '',       '',          '')
  call s:hi('TSParameter',                        s:base07, '',       '',          '')
  call s:hi('TSType',                             s:blue,   '',       '',          '')
  call s:hi('TSFunction',                         s:cyan,   '',       '',          '')

  call s:hi('TSTagDelimiter',                     s:cyan,   '',       '',          '')
  call s:hi('TSProperty',                         s:yellow, '',       '',          '')
  call s:hi('TSMethod',                           s:blue,   '',       '',          '')
  call s:hi('TSParameter',                        s:yellow, '',       '',          '')
  call s:hi('TSConstructor',                      s:base07, '',       '',          '')
  call s:hi('TSVariable',                         s:base07, '',       '',          '')
  call s:hi('TSOperator',                         s:base07, '',       '',          '')
  call s:hi('TSTag',                              s:base07, '',       '',          '')
  call s:hi('TSKeyword',                          s:purple, '',       '',          '')
  call s:hi('TSKeywordOperator',                  s:purple, '',       '',          '')
  call s:hi('TSVariableBuiltin',                  s:red,    '',       '',          '')
  call s:hi('TSLabel',                            s:cyan,   '',       '',          '')

  call s:hi('SpellBad',                           '',       '',       'undercurl', '')
  call s:hi('SpellLocal',                         '',       '',       'undercurl', '')
  call s:hi('SpellCap',                           '',       '',       'undercurl', '')
  call s:hi('SpellRare',                          '',       '',       'undercurl', '')

  call s:hi('csClass',                            s:yellow, '',       '',          '')
  call s:hi('csAttribute',                        s:yellow, '',       '',          '')
  call s:hi('csModifier',                         s:purple, '',       '',          '')
  call s:hi('csType',                             s:red,    '',       '',          '')
  call s:hi('csUnspecifiedStatement',             s:blue,   '',       '',          '')
  call s:hi('csContextualStatement',              s:purple, '',       '',          '')
  call s:hi('csNewDecleration',                   s:red,    '',       '',          '')
  call s:hi('cOperator',                          s:cyan,   '',       '',          '')
  call s:hi('cPreCondit',                         s:purple, '',       '',          '')

  call s:hi('cssColor',                           s:cyan,   '',       '',          '')
  call s:hi('cssBraces',                          s:base05, '',       '',          '')
  call s:hi('cssClassName',                       s:purple, '',       '',          '')


  call s:hi('DiffAdd',                            s:green,  s:base01, s:bold,      '')
  call s:hi('DiffChange',                         s:base03, s:base01, '',          '')
  call s:hi('DiffDelete',                         s:red,    s:base01, '',          '')
  call s:hi('DiffText',                           s:blue,   s:base01, '',          '')
  call s:hi('DiffAdded',                          s:base07, s:green,  s:bold,      '')
  call s:hi('DiffFile',                           s:red,    s:base00, '',          '')
  call s:hi('DiffNewFile',                        s:green,  s:base00, '',          '')
  call s:hi('DiffLine',                           s:blue,   s:base00, '',          '')
  call s:hi('DiffRemoved',                        s:base07, s:red,    s:bold,      '')

  call s:hi('gitCommitOverflow',                  s:red,    '',       '',          '')
  call s:hi('gitCommitSummary',                   s:green,  '',       '',          '')

  call s:hi('htmlBold',                           s:yellow, '',       '',          '')
  call s:hi('htmlItalic',                         s:purple, '',       '',          '')
  call s:hi('htmlTag',                            s:cyan,   '',       '',          '')
  call s:hi('htmlEndTag',                         s:cyan,   '',       '',          '')
  call s:hi('htmlArg',                            s:yellow, '',       '',          '')
  call s:hi('htmlTagName',                        s:base07, '',       '',          '')

  call s:hi('javaScript',                         s:base05, '',       '',          '')
  call s:hi('javaScriptNumber',                   s:orange, '',       '',          '')
  call s:hi('javaScriptBraces',                   s:base05, '',       '',          '')

  call s:hi('jsonKeyword',                        s:green,  '',       '',          '')
  call s:hi('jsonQuote',                          s:green,  '',       '',          '')

  call s:hi('markdownCode',                       s:green,  '',       '',          '')
  call s:hi('markdownCodeBlock',                  s:green,  '',       '',          '')
  call s:hi('markdownHeadingDelimiter',           s:blue,   '',       '',          '')
  call s:hi('markdownItalic',                     s:purple, '',       s:italic,    '')
  call s:hi('markdownBold',                       s:yellow, '',       s:bold,      '')
  call s:hi('markdownCodeDelimiter',              s:brown,  '',       s:italic,    '')
  call s:hi('markdownError',                      s:base05, s:base00, '',          '')

  call s:hi('typescriptParens',                   s:base05, s:none,   '',          '')

  call s:hi('NeomakeErrorSign',                   s:red,    s:base00, '',          '')
  call s:hi('NeomakeWarningSign',                 s:yellow, s:base00, '',          '')
  call s:hi('NeomakeInfoSign',                    s:white,  s:base00, '',          '')
  call s:hi('NeomakeError',                       s:red,    '',       'underline', s:red)
  call s:hi('NeomakeWarning',                     s:red,    '',       'underline', s:red)

  call s:hi('ALEErrorSign',                       s:red,    s:base00, s:bold,      '')
  call s:hi('ALEWarningSign',                     s:yellow, s:base00, s:bold,      '')
  call s:hi('ALEInfoSign',                        s:white,  s:base00, s:bold,      '')

  call s:hi('NERDTreeExecFile',                   s:base05, '',       '',          '')
  call s:hi('NERDTreeDirSlash',                   s:blue,   '',       '',          '')
  call s:hi('NERDTreeOpenable',                   s:blue,   '',       '',          '')
  call s:hi('NERDTreeFile',                       '',       s:none,   '',          '')
  call s:hi('NERDTreeFlags',                      s:blue,   '',       '',          '')

  call s:hi('phpComparison',                      s:base05, '',       '',          '')
  call s:hi('phpParent',                          s:base05, '',       '',          '')
  call s:hi('phpMemberSelector',                  s:base05, '',       '',          '')

  call s:hi('pythonRepeat',                       s:purple, '',       '',          '')
  call s:hi('pythonOperator',                     s:purple, '',       '',          '')

  call s:hi('rubyConstant',                       s:yellow, '',       '',          '')
  call s:hi('rubySymbol',                         s:green,  '',       '',          '')
  call s:hi('rubyAttribute',                      s:blue,   '',       '',          '')
  call s:hi('rubyInterpolation',                  s:green,  '',       '',          '')
  call s:hi('rubyInterpolationDelimiter',         s:brown,  '',       '',          '')
  call s:hi('rubyStringDelimiter',                s:green,  '',       '',          '')
  call s:hi('rubyRegexp',                         s:cyan,   '',       '',          '')

  call s:hi('sassidChar',                         s:red,    '',       '',          '')
  call s:hi('sassClassChar',                      s:orange, '',       '',          '')
  call s:hi('sassInclude',                        s:purple, '',       '',          '')
  call s:hi('sassMixing',                         s:purple, '',       '',          '')
  call s:hi('sassMixinName',                      s:blue,   '',       '',          '')

  call s:hi('vimfilerLeaf',                       s:base05, '',       '',          '')
  call s:hi('vimfilerNormalFile',                 s:base05, s:base00, '',          '')
  call s:hi('vimfilerOpenedFile',                 s:blue,   '',       '',          '')
  call s:hi('vimfilerClosedFile',                 s:blue,   '',       '',          '')

  call s:hi('GitGutterAdd',                       s:green,  s:base00, s:bold,      '')
  call s:hi('GitGutterChange',                    s:blue,   s:base00, s:bold,      '')
  call s:hi('GitGutterDelete',                    s:red,    s:base00, s:bold,      '')
  call s:hi('GitGutterChangeDelete',              s:purple, s:base00, s:bold,      '')

  call s:hi('SignifySignAdd',                     s:green,  s:base00, s:bold,      '')
  call s:hi('SignifySignChange',                  s:blue,   s:base00, s:bold,      '')
  call s:hi('SignifySignDelete',                  s:red,    s:base00, s:bold,      '')
  call s:hi('SignifySignChangeDelete',            s:purple, s:base00, s:bold,      '')
  call s:hi('SignifySignDeleteFirstLine',         s:red,    s:base00, s:bold,      '')

  call s:hi('xmlTag',                             s:cyan,   '',       '',          '')
  call s:hi('xmlTagName',                         s:base05, '',       '',          '')
  call s:hi('xmlEndTag',                          s:cyan,   '',       '',          '')
  call s:hi('Defx_filename_directory',            s:blue,   '',       '',          '')

  call s:hi('CocErrorSign',                       s:red,    '',       '',          '')
  call s:hi('CocWarningSign',                     s:yellow, '',       '',          '')
  call s:hi('CocInfoSign',                        s:blue,   '',       '',          '')
  call s:hi('CocHintSign',                        s:cyan,   '',       '',          '')
  call s:hi('CocErrorFloat',                      s:red,    '',       '',          '')
  call s:hi('CocWarningFloat',                    s:yellow, '',       '',          '')
  call s:hi('CocInfoFloat',                       s:blue,   '',       '',          '')
  call s:hi('CocHintFloat',                       s:cyan,   '',       '',          '')
  call s:hi('CocDiagnosticsError',                s:red,    '',       '',          '')
  call s:hi('CocDiagnosticsWarning',              s:yellow, '',       '',          '')
  call s:hi('CocDiagnosticsInfo',                 s:blue,   '',       '',          '')
  call s:hi('CocDiagnosticsHint',                 s:cyan,   '',       '',          '')
  call s:hi('CocSelectedText',                    s:purple, '',       '',          '')
  call s:hi('CocCodeLens',                        s:base04, '',       '',          '')
" }}}
" {{{ Terminal
if has('nvim')
  let g:terminal_color_0=s:base00[0]
  let g:terminal_color_8=s:base03[0]

  let g:terminal_color_1=s:red[0]
  let g:terminal_color_9=s:red[0]

  let g:terminal_color_2=s:green[0]
  let g:terminal_color_10=s:green[0]

  let g:terminal_color_3=s:yellow[0]
  let g:terminal_color_11=s:yellow[0]

  let g:terminal_color_4=s:blue[0]
  let g:terminal_color_12=s:blue[0]

  let g:terminal_color_5=s:purple[0]
  let g:terminal_color_13=s:purple[0]

  let g:terminal_color_6=s:cyan[0]
  let g:terminal_color_14=s:cyan[0]

  let g:terminal_color_7=s:base05[0]
  let g:terminal_color_15=s:base05[0]

  let g:terminal_color_background=s:base00[0]
  let g:terminal_color_foreground=s:white[0]
else
  let g:terminal_ansi_colors = [
     \ s:base00[0],
     \ s:red[0],
     \ s:green[0],
     \ s:yellow[0],
     \ s:blue[0],
     \ s:purple[0],
     \ s:cyan[0],
     \ s:white[0],
     \ s:base03[0],
     \ s:red[0],
     \ s:green[0],
     \ s:yellow[0],
     \ s:blue[0],
     \ s:purple[0],
     \ s:cyan[0],
     \ s:white[0],
     \]

endif
