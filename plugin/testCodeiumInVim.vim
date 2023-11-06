if exists("g:loaded_codeium")
    "finish
endif
let g:loaded_codeium = 1
"write list a symbols A O W E I
"in a global list named bmf_symb
let g:bmf_symb = ['A', 'O', 'W', 'E', 'I']
"write a global dictionary named bmf_dict with keys alert ok warning error info
"and values bmf_symb
let g:bmf_dict = {'alert': g:bmf_symb[0], 'ok': g:bmf_symb[1], 'warning': g:bmf_symb[2], 'error': g:bmf_symb[3], 'info': g:bmf_symb[4]}


"sign define -> sign_define({list})
function! SignDefine()
    echo "make a list of signs"
    let g:listofsignsdefine = []
    "make a list of signs
    " write below a loop that populate listofsignsdefine with  dictionaries name and text keys from bmf_dict items
    for [key, symb] in g:bmf_dict->items()
        call add(g:listofsignsdefine,{'name': key, 'text': symb})
    endfor
call sign_define(g:listofsignsdefine)
endfunction

"write a function to add to gutter a symbol from bmf_dict
"to the current line and current buffer
function! AddToGutter(keySymbol) "as: alert ok warning error info
echo "Add to gutter"
    let l:current_line = line('.')
    let l:current_buffer = bufnr('%')
    if !empty(g:bmf_dict[a:keySymbol])
        let l:current_symbol = a:keySymbol
        "search in list g:listofsignsdefine 'name' key = l:current_symbol
         let index = g:listofsignsdefine->indexof({i,v -> v.name ==# a:keySymbol})
         if index != -1
            call sign_place(0, 'Codeium', g:listofsignsdefine[index].name, l:current_buffer, {'lnum': l:current_line})
        endif
    endif
endfunction

"write a function to remove from gutter a symbol from bmf_dict
"from the current line and current buffer
function! RemoveFromGutter()
    let l:current_line = line('.')
    let l:current_buffer = bufnr('%')
    " get id du sign de la ligne courante
    let l:sign_id = sign_getplaced(l:current_buffer, {'lnum': l:current_line, 'group': 'Codeium'})[0]['id']
    echo "sign id: " . l:sign_id
    call sign_unplace('Codeium', {'id': l:sign_id, 'buffer': l:current_buffer})
endfunction

"write a function to get the list sorted of symbols from bmf_dict
function! GetKeysSymbols(A, L, P)
    return keys(g:bmf_dict)->sort()
endfunction

function! TestEcho()
    echo "test echo from *testCodeiumInVim* plugin"
    call SignDefine()
endfunction

"Commands
command! -nargs=? -complete=customlist,GetKeysSymbols AddToGutter call AddToGutter(<f-args>)
command! RemoveFromGutter call RemoveFromGutter()

" write a command to call TestEcho function
command! TestEcho call TestEcho()
" write a mapping nmap to execute TestEcho command above
nmap <Leader>te :TestEcho<CR>

"Mappings
"add to gutter
execute "nnoremap <Leader>ta :AddToGutter<space><tab>"
"remove from gutter
nmap <Leader>tr :RemoveFromGutter<CR>
