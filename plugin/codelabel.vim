" codelabel.vim
" Maintainer:  Tomoya Chiba <tomo.asleep@gmail.com>
" Version:  0.0.1
"
if (exists("g:loaded_codelabel") && g:loaded_codelabel) || &cp
  finish
endif
let g:loaded_codelabel = 1

let s:cpo_save = &cpo
set cpo&vim

if !exists('g:codelabel_save_dir')
  let g:codelabel_save_dir = $HOME . "/.codelabels"
endif

function! s:on_saved_new_label()
  let buf_info = codelabel#current_buffer_info()
  if len(matchstr(buf_info.fname_abs, g:codelabel_save_dir))
    let label = codelabel#parse_labelfile(buf_info.fname_abs)
    call codelabel#add_label(label)
  endif
endfunction

command! -nargs=0 CodeLabelNew :call codelabel#new()

augroup codelabel
  autocmd! codelabel
  autocmd BufReadPost * :call codelabel#sign#mark_new_buffer()
  autocmd BufWritePost *.md :call s:on_saved_new_label()
augroup END

call codelabel#sign#setup()

let &cpo = s:cpo_save

" vim:set ft=vim ts=2 sw=2 sts=2:
