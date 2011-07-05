set nocompatible
syntax on

""
"plugin - vim-pathogen
""
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
filetype plugin on

set encoding=utf-8                          "vim$BFb$NJ8;z=hM}(B(enc)
set termencoding=utf-8                      "$BC<Kv$NJ8;z%3!<%I(B(tenc)
set fileencoding=utf-8                      "$B%U%!%$%kJ8;z%3!<%I(B(fenc)
set fileencodings=iso-2022-jp,euc-jp,utf-8,cp932    "$B;HMQ2DG=$JJ8;z%3!<%I(B(fencs)
set fileformat=unix
set fileformats=unix,dos

set ffs=unix,dos,mac  " $B2~9TJ8;z(B
set encoding=utf-8    " $B%G%U%)%k%H%(%s%3!<%G%#%s%0(B

" $BJ8;z%3!<%I4XO"(B
" " from $B$:$s(BWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" " $BJ8;z%3!<%I$N<+F0G'<1(B
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconv$B$,(BeucJP-ms$B$KBP1~$7$F$$$k$+$r%A%'%C%/(B
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconv$B$,(BJISX0213$B$KBP1~$7$F$$$k$+$r%A%'%C%/(B
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodings$B$r9=C[(B
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
    " $BDj?t$r=hJ,(B
    unlet s:enc_euc
    unlet s:enc_jis
endif
" $BF|K\8l$r4^$^$J$$>l9g$O(B fileencoding $B$K(B encoding $B$r;H$&$h$&$K$9$k(B
if has('autocmd')
    function!  AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" $B2~9T%3!<%I$N<+F0G'<1(B
set fileformats=unix,dos,mac
" $B""$H$+!{$NJ8;z$,$"$C$F$b%+!<%=%k0LCV$,$:$l$J$$$h$&$K$9$k(B
if exists('&ambiwidth')
    set ambiwidth=double
endif

" $B;XDjJ8;z%3!<%I$G6/@)E*$K%U%!%$%k$r3+$/(B
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8



set clipboard+=unnamed                       "$B%d%s%/$7$?J8;z$O!"%7%9%F%`$N%/%j%C%W%\!<%I$X(B"
set title
set formatoptions=lmoq                      "$B%F%-%9%H@07A%*%W%7%g%s$K%^%k%A%P%$%H7O$rDI2C(B
set scrolloff=5                             "$B%9%/%m!<%k;~$NM>Gr(B
set textwidth=0                             "$B<+F0@^$jJV$7$5$;$J$$(B
set nobackup                                "$B%P%C%/%"%C%W%U%!%$%k$r<h$i$J$$(B
set showcmd                                 "$B%3%^%s%I$r%9%F!<%?%9%i%$%s$KI=<((B(sc)
set autoread                                "$BB>$G=q$-49$($i$l$?$i<+F0$GFI$_$J$*$9(B
set vb t_vb=                                "$B%S!<%W2;$rLD$i$5$J$$(B
set whichwrap=b,s,h,l,<,>,[,]               "$B%+!<%=%k$r9TF,$d9TKv$G;_$^$i$J$$$h$&$K$9$k(B
"set smartindent
set showmatch                               "$BBP1~$9$k3g8L$rI=<((B
set hidden                                  "$BJT=8Cf$NFbMF$rJ]$C$?$^$^!"B>$N%U%!%$%k$r3+$1$k$h$&$K$9$k(B
set mouse=a                                 "Enable mouse usage (all modes) in terminals
set mousehide                               "$BF~NO$r3+;O$7$?$i%+!<%=%k$r1#$9(B(mh)
set number                                  "$B9THV9f$NI=<((B(nu)
set cmdheight=1                             "$B%3%^%s%I%i%$%s9T?t(B(ch)
set background=light                        "$BGX7J?'$r65$(!"8+$d$9$$%+%i!<$K$5$;$k(B
set shm=I
set backspace=indent,eol,start              "$B%P%C%/%9%Z!<%9$G>C$9(B
set modeline            "(ml)
set modelines=2         "(mls)
set nolist
"set listchars=eol:<,extends:<,trail:-
"set wildchar=<Tab>
"set wildmode=list:full
set laststatus=2                            "$B%9%F!<%?%9%i%$%s$rI=<((B
set ruler                                   "$B%+!<%=%k$,2?9TL\$K$"$k$+I=<((B
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l%L

"$B%9%F!<%?%9%i%$%s$KJ8;z%3!<%I$H2~9TJ8;z$rI=<($9$k(B
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

set expandtab                               "$B%?%V$NBe$o$j$K%9%Z!<%9$rA^F~(B(et)
set tabstop=4                               "$B%?%V$,BP1~$9$k6uGr$N?t(B(ts)
set shiftwidth=4                            "$B<+F0%$%s%G%s%H$N3FCJ3,$K;H$o$l$k6uGr$N?t(B(sw)
set softtabstop=4                           "$B%?%V$NA^F~$d%P%C%/%9%Z!<%9;HMQ;~$K%?%V$,BP1~$9$k6uGr$N?t(B(sts)
set cursorline
"$B%+%l%s%H%&%#%s%I%&$K$N$_7S@~$r0z$/(B
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

"$BJ]B8;~$K9TKv$N6uGr$r:o=|(B
autocmd BufWritePre * :%s/\s\+$//ge
"$BJ]B8;~$K(Btab$B$r%9%Z!<%9$KJQ49$9$k(B
"autocmd BufWritePre * :%s/\t/  /ge

"$BA43Q%9%Z!<%9$NI=<((B
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /$B!!(B/

set autoindent      "$B<+F0%$%s%G%s%H(B
set smartindent     "$B?7$7$$9T$N%$%s%G%s%H$r8=:_9T$HF1$8$K$9$k(B

set wildmenu            "$B%3%^%s%IJd40$r6/2=(B
set wildchar=<tab>      "$B%3%^%s%IJd40$r3+;O$9$k%-!<(B
set wildmode=list:full  "$B%j%9%HI=<(!":GD9%^%C%A(B
set history=1000        "$B%3%^%s%I$d8!:w%Q%?!<%s$NMzNr?t(B
set complete+=k


""
"search
""
set wrapscan            "$B:G8e$^$G8!:w$7$?$i@hF,$X(B
set ignorecase		    "$B8!:w;~$KBgJ8;z>.J8;z$r6hJL$7$J$$(B(ic) <-> noignorecase
set smartcase	        "$B8!:w%Q%?!<%s$KBgJ8;z$,4^$^$l$F$$$?$i6hJL$9$k(B(scs) <-> nosmartcase
set incsearch		    "$B%$%s%/%j%a%s%H%5!<%A(B(is)
set hlsearch          "$B%O%$%i%$%H$9$k(B(hls) <-> nohlsearch
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
"Esc$B$N(B2$B2s2!$7$G%O%$%i%$%H>C5n(B
nmap <ESC><ESC> ;nohlsearch<CR><ESC>
"Ctrl-hjkl$B$G%&%$%s%I%&0\F0(B
nnoremap <C-j> ; <C-w>j
nnoremap <C-k> ; <C-k>j
nnoremap <C-l> ; <C-l>j
nnoremap <C-h> ; <C-h>j

"insert mode $B$G$N0\F0(B
imap  <C-e> <END>
imap  <C-a> <HOME>
"$B%$%s%5!<%H%b!<%I$G$b(Bhjkl$B$G0\F0!J(BCtrl$B2!$9$1$I$M!K(B
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

inoremap  (   ()<LEFT>
inoremap  [   []<LEFT>
inoremap  {   {}<LEFT>
inoremap  '   ''<LEFT>
inoremap  "   ""<LEFT>

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
" AutoComplPop$B$rL58z$K$9$k(B
let g:acp_enableAtStartup = 0
" NeoComplCache$B$rM-8z$K$9$k(B
let g:neocomplcache_enable_at_startup = 1
" smarrt case$BM-8z2=!#(B $BBgJ8;z$,F~NO$5$l$k$^$GBgJ8;z>.J8;z$N6hJL$rL5;k$9$k(B
let g:neocomplcache_enable_smart_case = 1
" camle case$B$rM-8z2=!#BgJ8;z$r6h@Z$j$H$7$?%o%$%k%I%+!<%I$N$h$&$K?6$kIq$&(B
let g:neocomplcache_enable_camel_case_completion = 1
" _($B%"%s%@!<%P!<(B)$B6h@Z$j$NJd40$rM-8z2=(B
let g:neocomplcache_enable_underbar_completion = 1
" $B%7%s%?%C%/%9$r%-%c%C%7%e$9$k$H$-$N:G>.J8;zD9$r(B3$B$K(B
let g:neocomplcache_min_syntax_length = 3
" neocomplcache$B$r<+F0E*$K%m%C%/$9$k%P%C%U%!L>$N%Q%?!<%s(B
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" -$BF~NO$K$h$k8uJdHV9f$NI=<((B
let g:neocomplcache_enable_quick_match = 1
" $BJd408uJd$N0lHV@hF,$rA*Br>uBV$K$9$k(B(AutoComplPop$B$H;w$?F0:n(B)
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

