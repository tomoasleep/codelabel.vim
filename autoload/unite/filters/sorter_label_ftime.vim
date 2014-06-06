let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_label_ftime#define() "{{{
  return s:sorter
endfunction "}}}

let s:sorter = {
      \ 'name' : 'sorter_label_ftime',
      \ 'description' : 'sort labels by getftime() order',
      \ }

function! s:sorter.filter(candidates, context) "{{{
  return unite#util#sort_by(a:candidates, "
      \   has_key(v:val, 'action__label_path') ? getftime(v:val.action__label_path) : 0
      \ ")
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
