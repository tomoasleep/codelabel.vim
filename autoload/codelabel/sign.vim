
let s:save_cpo = &cpo
set cpo&vim

" Public functions "{{{

function! codelabel#sign#setup() "{{{
  execute 'sign define CodeLabel text=!>'
  let s:first_sign_id = 10000
  let s:next_last_sign_id = s:first_sign_id
endfunction "}}}

function! codelabel#sign#add(fname, line) "{{{
  execute 'sign place ' . s:next_last_sign_id . ' line=' . a:line . ' name=CodeLabel file=' . a:fname
  call add(s:buffer_signs(), s:next_last_sign_id)
  let s:next_last_sign_id += 1
endfunction "}}}

function! codelabel#sign#remove(sign_id) "{{{
  execute 'sign unplace '. a:sign_id
  call remove(s:buffer_signs(), index(s:buffer_signs(), a:sign_id))
endfunction "}}}

function! codelabel#sign#remove_all() "{{{
  let signs = copy(s:buffer_signs())
  for sign_id in signs
    call codelabel#sign#remove(sign_id)
  endfor
  unlet b:codelabel_signs
endfunction "}}}

function! codelabel#sign#mark_buffer() "{{{
  let buf_info = codelabel#current_buffer_info()
  call codelabel#confirm_labelmap()
  let updates = codelabel#diff#map_updates()
  if has_key(updates, buf_info.fname_abs) && updates[buf_info.fname_abs]
    call codelabel#sign#reset()
    let updates[buf_info.fname_abs] = 0
  endif
endfunction "}}}

function! codelabel#sign#mark_all() "{{{
  let buf_info = codelabel#current_buffer_info()
  let labels = codelabel#search_by_file(buf_info.fname_abs)
  for label in labels
    call codelabel#sign#add(label.code_path, label.linepos)
  endfor
endfunction "}}}

function! codelabel#sign#reset() "{{{
  call codelabel#sign#remove_all()
  call codelabel#sign#mark_all()
endfunction "}}}

" }}}

" Private functions "{{{

function! s:buffer_signs() "{{{
  if !exists('b:codelabel_signs')
      let b:codelabel_signs = []
  endif
  return b:codelabel_signs
endfunction "}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo

