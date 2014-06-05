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

command! -nargs=0 CodeLabelNew :call codelabel#new()

let &cpo = s:cpo_save

" vim:set ft=vim ts=2 sw=2 sts=2:
