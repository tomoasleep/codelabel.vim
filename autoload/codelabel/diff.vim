let s:save_cpo = &cpo
set cpo&vim

" Public functions "{{{

function! codelabel#diff#on_change_labelmap(new_labelmap) "{{{
  if !exists('s:old_labelmap')
    let s:old_labelmap = {}
  endif
  call s:mark_map_updates(s:old_labelmap, a:new_labelmap)
  let s:old_labelmap = a:new_labelmap
endfunction "}}}

function! codelabel#diff#map_updates() "{{{
  if !exists('s:map_updates_hash')
    let s:map_updates_hash = {}
  endif
  return s:map_updates_hash
endfunction "}}}

" }}}

" Private functions "{{{

function! s:mark_map_updates(oldmap, newmap) "{{{
  let new_map_keys = keys(a:newmap)
  for key in new_map_keys
    let updates = codelabel#diff#map_updates()
    if !has_key(a:oldmap, key) && has_key(a:newmap, key)
      let updates[key] = 1
    elseif has_key(a:oldmap, key) && !has_key(a:newmap, key)
      let updates[key] = 1
    elseif s:has_diff(a:oldmap[key], a:newmap[key])
      let updates[key] = 1
    endif
  endfor
endfunction "}}}

function! s:has_diff(old_labels, new_labels) "{{{
  if len(a:old_labels) == len(a:new_labels)
    return 1
  endif

  let old_fname_map = {}
  for label in a:old_labels
    let old_fname_map[label.label_path] = 1
  endfor

  for label in a:new_labels
    if has_key(old_fname_map, label.label_path)
      return 1
    endif
  endfor
  return 0
endfunction "}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
