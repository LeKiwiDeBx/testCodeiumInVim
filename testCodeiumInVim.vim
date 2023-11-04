if exists("g:loaded_codeium") 
    finish 
endif
let g:loaded_codeium = 1
"write list a symbols A O W E I
"in a global list named bmf_symb
let g:bmf_symb = ['A', 'O', 'W', 'E', 'I']
"write a global dictionary named bmf_dict with keys alert ok warning error info
"and values bmf_symb
let g:bmf_dict = {'alert': bmf_symb[0], 'ok': bmf_symb[1], 'warning': bmf_symb[2], 'error': bmf_symb[3], 'info': bmf_symb[4]}

"write a function to add to gutter a symbol from bmf_dict
"to the current line and current buffer
function! AddToGutter(keySymbol)
    let l:current_line = line('.')
    let l:current_buffer = bufnr('%')
    if !empty(bmf_dict[a:keySymbol])
        let l:current_symbol = bmf_dict[a:keySymbol]
        let sign_id = sign_place(0, 'Codeium', l:current_symbol, l:current_buffer, {'lnum': l:current_line})
    endif
endfunction

"write a function to remove from gutter a symbol from bmf_dict
"from the current line and current buffer
function! RemoveFromGutter()
    let l:current_line = line('.')
    let l:current_buffer = bufnr('%')
    call sign_unplace('Codeium', {'lnum': l:current_line, 'buffer': l:current_buffer})
endfunction

"write a function to get the list sorted of symbols from bmf_dict
function! GetKeysSymbols(A, L, P)
    return keys(g:bmf_dict)->sort()
endfunction

"Commands
command! -nargs=? -complete=customlist,GetKeysSymbols AddToGutter call AddToGutter(<f-args>)
command! RemoveFromGutter call RemoveFromGutter()

"Mappings
"add to gutter
if !hasmapto('<Plug>AddToGutter')
    execute 'nmap <Leader>ba <Plug>AddToGutter<CR>'
endif
"remove from gutter
if !hasmapto('<Plug>RemoveFromGutter')
    execute 'nmap <Leader>br <Plug>RemoveFromGutter<CR>'
endif
