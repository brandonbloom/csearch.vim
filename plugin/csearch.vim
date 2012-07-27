if !exists("g:csearchprg")
	let g:csearchprg="csearch -n"
endif

function! s:CSearch(cmd, args)
    redraw
    echo "Searching ..."

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:csearchprg
        let &grepformat="%f:%l:%m"
        silent execute a:cmd . " " . l:grepargs
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif

    exec "nnoremap <silent> <buffer> q :ccl<CR>"
    exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
    exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
    exec "nnoremap <silent> <buffer> o <CR>"
    exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"
    exec "nnoremap <silent> <buffer> v <C-W><C-W><C-W>v<C-L><C-W><C-J><CR>"
    exec "nnoremap <silent> <buffer> gv <C-W><C-W><C-W>v<C-L><C-W><C-J><CR><C-W><C-J>"

    " If highlighting is on, highlight the search keyword.
    if exists("g:csearchhighlight")
        let @/=a:args
        set hlsearch
    end

    redraw!
endfunction

function! s:CSearchFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:CSearch(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file CSearch call s:CSearch('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file CSearchAdd call s:CSearch('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file CSearchFromSearch call s:CSearchFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LCSearch call s:CSearch('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LCSearchAdd call s:CSearch('lgrepadd<bang>', <q-args>)
