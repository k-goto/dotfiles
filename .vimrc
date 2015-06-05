"source /etc/vimrc

set nocompatible
filetype off

" neobundle
if has('vim_starting')
  set runtimepath+=~/dotvims/vundle/neobundle.vim/
  set runtimepath+=~/.vim/bundle/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" neobundleによるプラグイン管理
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
  \ 'build': {
  \   'windows' : 'make -f make_mingw32.mak',
  \   'cygwin'  : 'make -f make_cygwin.mak',
  \   'mac'     : 'make -f make_mac.mak',
  \   'unix'    : 'make -f make_unix.mak',
  \ },
  \ }
NeoBundle 'Shougo/vimshell'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-rails'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'superbrothers/vim-quickrun-markdown-gfm'
NeoBundle 'tpope/vim-endwise'
NeoBundleCheck

" 文字コード自動判別
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

" オートインデント
set ai
" インクリメンタルサーチ
set is

" タブ文字無効
set expandtab
" ただしPHPはタブ文字を入れる
" autocmd FileType php set noexpandtab

" タブ文字表示
set list

" 開いたファイルタブの描画する空白の数
set tabstop=2

" オートインデントなどが挿入する文字幅
set shiftwidth=2

" キーボードで入力したTABが変換される空白文字数
" 0はイコールtabstop
set softtabstop=0
colorscheme desert

" シンタックスハイライト
syntax on

" 折り返し（無効に）
set nowrap

" 保存時に行末スペースを取り除く
"autocmd BufWritePre * :%s/\s\+$//ge

" マウス
"set mouse=a
"set ttymouse=xterm2

" 大文字小文字を区別しないで検索する
set ignorecase

" 検索語を強調表示（<C-L>を押すと現在の強調表示を解除する）
set hlsearch

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみは線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup end
highlight CursorLine ctermbg=black guibg=black
" 全角スペースの表示
highlight ZenkakuSpace cterm=reverse ctermfg=darkgray guibg=darkgray
match ZenkakuSpace /　/

" ステータス行を表示
set laststatus=2

" コマンドライン補完表示
set wildmenu

" ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

" insert mode での移動
imap  <C-e> <END>
imap  <C-a> <HOME>

" 辞書
imap <C-J> <C-X><C-K>

" ファイルタイプによるインデント制御の有効化
filetype on
filetype indent on
filetype plugin on

" 自動補完
setlocal omnifunc=syntaxcomplete#Complete

hi Pmenu ctermbg=lightgray
hi PmenuSel ctermbg=cyan
hi PmenuSbar ctermbg=blue

" neocomplcache
" 起動時に有効にする
let g:neocomplcache_enable_at_startup = 1
" 1番目の候補を自動選択
let g:neocomplcache_enable_auto_select = 1
" key-mappings for neocomplcache
" 補完ポップアップを閉じる
inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<BS>"
" タブにて次の候補へ
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" C-nでneocomplcache補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" 補完候補の共通部分までを補完する
inoremap <expr><C-l> neocomplcache#complete_common_string()
" 日本語をキャッシュしない
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" Eclipseのようなキャメルの大文字のみによる補完(Java書くわけじゃないし重いし)
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" Enable onmi completion
autocmd FileType * let g:acp_completeOption = '.,w,b,u,t,i'
" perl
autocmd FileType perl let g:acp_completeOption = '.,w,b,u,t,'
" php
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType php :set makeprg=php\ -l\ %
" ruby
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby :set makeprg=ruby\ -c\ %
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:rails_level = 4
" other
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd filetype xml set omnifunc=xmlcomplete#completetags
autocmd filetype c set omnifunc=ccomplete#complete
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

" vim-ref
" let g:ref_phpmanual_path = "/home/keita/.vim/bundle/vim-ref/manual/php-chunked-xhtml/"

" vimshell
let g:vimproc_dll_path = "//Users/keita/.vim/bundle/vimproc/autoload/vimproc_mac.so"
nnoremap <silent> ,is :VimShell<CR>

" unite
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru file<CR>

" タグリストの設定あれこれ
" とりあえず Tlist 打ちましょう
command -nargs=0 Form :tabedit %<Form.pm
command -nargs=0 Tag :set tags=tags
" taglist
let Tlist_Ctags_Cmd = "/usr/bin/ctags"    "ctagsのパス
let Tlist_Show_One_File = 1               "現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1             "taglistのウィンドーが最後のウィンドーならばVimを閉じる
let Tlist_Use_Right_Window = 1            "右側でtaglistのウィンドーを表示
let Tlist_Use_SingleClick = 1            "シングルクリックでジャンプ

" NERDTree
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

nnoremap <silent> <S-t> :<C-u>NERDTree<CR>

" quickrun_config
let g:quickrun_config = {
\   'markdown': {
\     'type': 'markdown/gfm',
\     'outputter': 'browser'
\   }
\ }

set foldenable
set foldmethod=syntax

autocmd InsertEnter * if !exists('w:last_fdm')
            \| let w:last_fdm=&foldmethod
            \| setlocal foldmethod=manual
            \| endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm')
            \| let &l:foldmethod=w:last_fdm
            \| unlet w:last_fdm
            \| endif
