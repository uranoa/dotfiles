set nocompatible
syntax on

"----------------------------------------------------------------------------------------------------
"plugin - vim-pathogen
"----------------------------------------------------------------------------------------------------
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
filetype plugin on

set encoding=utf-8                          "vim内の文字処理
set termencoding=utf-8                      "端末の文字コード
set fileencoding=utf-8                      "ファイル文字コード
set fileencodings=iso-2022-jp,euc-jp,utf-8,cp932    "使用可能な文字コード
set fileformat=unix
set fileformats=unix,dos,mac


" 文字コード関連
" " from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" " 文字コードの自動認識
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','.  s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
           let &fileencodings = &fileencodings .','.  s:enc_euc
       endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function!  AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8

set clipboard+=unnamed                       "ヤンクした文字は、システムのクリップボードへ"
set title
set formatoptions=lmoq                      "テキスト整形オプションにマルチバイト系を追加
set scrolloff=5                             "スクロール時の余白
set textwidth=0                             "自動折り返しさせない
set nobackup                                "バックアップファイルを取らない
set showcmd                                 "コマンドをステータスラインに表示(sc)
set autoread                                "他で書き換えられたら自動で読みなおす
set vb t_vb=                                "ビープ音を鳴らさない
set whichwrap=b,s,h,l,<,>,[,]               "カーソルを行頭や行末で止まらないようにする
"set smartindent
set showmatch                               "対応する括弧を表示
set hidden                                  "編集中の内容を保ったまま、他のファイルを開けるようにする
set mouse=a                                 "Enable mouse usage (all modes) in terminals
set mousehide                               "入力を開始したらカーソルを隠す(mh)
set number                                  "行番号の表示(nu)
set cmdheight=1                             "コマンドライン行数(ch)
set background=light                        "背景色を教え、見やすいカラーにさせる
set shm=I
set backspace=indent,eol,start              "バックスペースで消す
set modeline            "(ml)
set modelines=2         "(mls)
set nolist
"set listchars=eol:<,extends:<,trail:-
"set wildchar=<Tab>
"set wildmode=list:full
set laststatus=2                            "ステータスラインを表示
set ruler                                   "カーソルが何行目にあるか表示
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l%L

command! Ev edit $MYVIMRC
command! Rv edit $MYVIMRC

"ステータスラインに文字コードと改行文字を表示する
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

" help eval-examples The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc
" The function String2Hex() converts each character in a string to a two character Hex string.
func! String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunc

augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
    autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

set expandtab                               "タブの代わりにスペースを挿入(et)
set tabstop=4                               "タブが対応する空白の数(ts)
set shiftwidth=4                            "自動インデントの各段階に使われる空白の数(sw)
set softtabstop=4                           "タブの挿入やバックスペース使用時にタブが対応する空白の数(sts)
set cursorline
"カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

colorschem desertEx

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

"保存時に行末の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge
"保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/    /ge
"保存時にdos改行をunix改行へ変換
autocmd BufWritePre * :%s/\r+$//ge

"全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

set autoindent      "自動インデント
set smartindent     "新しい行のインデントを現在行と同じにする

set wildmenu            "コマンド補完を強化
set wildchar=<tab>      "コマンド補完を開始するキー
set wildmode=list:full  "リスト表示、最長マッチ
set history=1000        "コマンドや検索パターンの履歴数
set complete+=k


""
"search
""
set wrapscan            "最後まで検索したら先頭へ
set ignorecase        "検索時に大文字小文字を区別しない(ic) <-> noignorecase
set smartcase          "検索パターンに大文字が含まれていたら区別する(scs) <-> nosmartcase
set incsearch        "インクリメントサーチ(is)
set hlsearch          "ハイライトする(hls) <-> nohlsearch
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap <DOWN> <ESC>
nmap <RIGHT> <ESC>
nmap <UP> <ESC>
nmap <LEFT> <ESC>
"Escの2回押しでハイライト消去
nnoremap <ESC><ESC> :nohlsearch<CR>
"Ctrl-hjklでウインドウ移動
nnoremap <C-j> ; <C-w>j
nnoremap <C-k> ; <C-k>j
nnoremap <C-l> ; <C-l>j
nnoremap <C-h> ; <C-h>j

"insert mode での移動
imap  <C-e> <END>
imap  <C-a> <HOME>
"インサートモードでもhjklで移動（Ctrl押すけどね）
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

"フレームサイズをテンキーの+ & -で変更  動作せず...
"map <kPlus> <C-W>+
"map <kMinus> <C-W>-

"inoremap  (   ()<LEFT>
"inoremap  [   []<LEFT>
"inoremap  {   {}<LEFT>
"inoremap  '   ''<LEFT>
"inoremap  "   ""<LEFT>

"-----------------------------------------------------------------------------
"key bind
"-----------------------------------------------------------------------------
"map  = all (normal, visual, operator waiting)
"nmap = normal mode
"vmap = visual mode
"imap = insert mode
"map! = insert mode and command line
"omap = operator waiting
"cmap = command line
"noremap
"nnoremap
"vnoremap
"inoremap
"noremap!
"onoremap
"cnoremap

"------------------------------------
"" neocomplecache
"------------------------------------
" AutoComplPopを無効にする
let g:acp_enableAtStartup = 0
" NeoComplCacheを有効にする
let g:neocomplcache_enable_at_startup = 1
" smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
let g:neocomplcache_enable_camel_case_completion = 1
" _(アンダーバー)区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
" neocomplcacheを自動的にロックするバッファ名のパターン
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" -入力による候補番号の表示
"let g:neocomplcache_enable_quick_match = 1
" 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
let g:neocomplcache_enable_auto_select = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell': $HOME.'/.vimshell_hist',
    \ 'scala'   : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java'    : $HOME.'/.vim/dict/java.dict',
    \ 'c'       : $HOME.'/.vim/dict/c.dict',
    \ 'cpp'     : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml'   : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl'    : $HOME.'/.vim/dict/perl.dict',
    \ 'php'     : $HOME.'/.vim/dict/php.dict',
    \ 'scheme'  : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm'      : $HOME.'/.vim/dict/vim.dict'
\ }


"------------------------------------
"" vim-ref
"------------------------------------
let g:ref_phpmanual_path = $HOME.'/manual/php-chunked-xhtml/'




""
"filetype
""
filetype indent on
au BufNewFile,BufRead *.php  set filetype=php fileencoding=utf-8
au BufNewFile,BufRead *.inc  set filetype=php
au BufNewFile,BufRead *.tpl  set filetype=html fileencoding=utf-8
au BufNewFile,BufRead *.html set filetype=php
au BufNewFile,BufRead *.js   set filetype=javascript

