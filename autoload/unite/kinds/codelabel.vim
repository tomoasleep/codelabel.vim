let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#codelabel#define() "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'codelabel',
      \ 'default_action' : 'open',
      \ 'action_table': {},
      \ 'alias_table': {},
      \ 'parents': ['jump_list'],
      \}

let s:super = unite#get_kinds('jump_list')

" Actions "{{{
let s:kind.action_table.open = {
      \ 'description' : 'open the file and label',
      \ }
function! s:kind.action_table.open.func(candidate) "{{{
  call s:super.action_table.open.func([a:candidate])
  let label_path = a:candidate.action__label_path
  execute join(['pedit', label_path], ' ')
endfunction "}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
