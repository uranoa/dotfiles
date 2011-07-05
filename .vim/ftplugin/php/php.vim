nmap ,l :make<CR>
nnoremap <C-P> :call PhpDoc()<CR>
autocmd filetype php :set makeprg=php\ -l\ %
autocmd filetype php :set errorformat=%m\ in\ %f\ on\ line\ %l


""
" PHPLint
"
" @author halt feits <halt.feits at gmail.com>
"nmap ,l :call PHPLint()<CR>
""
"function PHPLint()
"    let result = system( &ft . ' -l' . bufname(""))
"    echo result
"endfunction

