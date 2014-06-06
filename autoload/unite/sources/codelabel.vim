
let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#codelabel#define() "{{{
  return s:source_codelabel
endfunction "}}}

" codelabel source. "{{{
let s:source_codelabel = {
      \ 'name' : 'codelabel',
      \ 'hooks' : {},
      \ 'max_candidates': 100,
      \ 'sorters': ['sorter_label_ftime', 'sorter_reverse'],
      \ } "}}}

function! s:source_codelabel.gather_candidates(args, context) "{{{
  let labellist = codelabel#read_labellist()
  return map(labellist, '{
        \ "word": s:format_word(v:val.code_path, v:val.linepos, v:val.content, v:val.line),
        \ "source": "codelabel",
        \ "kind": "codelabel",
        \ "action__path": v:val.code_path,
        \ "action__line": v:val.linepos,
        \ "action__label_path": v:val.label_path,
        \ }')
endfunction "}}}

function! s:format_word(code_path, linepos, content, line) "{{{
  return printf(" %s: [%d] %s : %s",
        \ fnamemodify(a:code_path, ':.'), a:linepos, a:content, a:line)
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
