
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('codelabel')
let s:BM = s:V.import('Vim.BufferManager')
let s:FP = s:V.import('System.Filepath')

let s:BufferManager = s:BM.new()

" Public functions {{{

function! codelabel#new() "{{{
  let buf_info = codelabel#current_buffer_info()
  let bname = s:gen_buffer_name(buf_info.fname_abs, buf_info.linepos)
  let codeinfo = s:gen_codeinfo(buf_info.fname_abs, buf_info.linepos, buf_info.line)
  call s:open_codelabel_buffer(bname, codeinfo)
endfunction "}}}

function! codelabel#add_label(label) "{{{
  if exists('s:labellist')
    call add(codelabel#confirm_labellist(), a:label)
  else
    call add(s:labellist, a:label)
  endif
  call s:unlet('s:labelmap')
endfunction "}}}

function! codelabel#build_labellist() "{{{
  let flist = split(globpath(g:codelabel_save_dir, '*.md'), '\n')
  let list = []
  for fname in flist
    call add(list, codelabel#parse_labelfile(fname))
  endfor
  return list
endfunction "}}}

function! codelabel#build_labelmap() "{{{
  let labellist = codelabel#confirm_labellist()
  let labelmap = {}
  for label in labellist
    if !has_key(labelmap, label.code_path)
      let labelmap[label.code_path] = []
    endif
    call add(labelmap[label.code_path], label)
  endfor
  return labelmap
endfunction "}}}

function! codelabel#parse_labelfile(fname) "{{{
  let fhead = readfile(a:fname, '', 3)
  if len(fhead) > 1
    let content = fhead[1:]
  else
    let content = []
  endif
  let labelinfo = s:parse_labelheader(fhead[0])
  return { 'label_path': a:fname,
         \ 'code_path': labelinfo.path,
         \ 'linepos': labelinfo.linepos,
         \ 'line': labelinfo.line,
         \ 'content': join(content, '\n') }
endfunction "}}}

function! codelabel#open_preview(fname) "{{{
  execute join(['pedit', a:fname], ' ')
endfunction "}}}

function! codelabel#search_by_file(fname) "{{{
  let labelmap = codelabel#confirm_labelmap()
  if has_key(labelmap, a:fname)
    return labelmap[a:fname]
  else
    return []
  endif
endfunction "}}}

function! codelabel#confirm_labellist() "{{{
  if !exists('s:labellist')
    let s:labellist = codelabel#build_labellist()
    call s:unlet('s:labelmap')
  endif
  return s:labellist
endfunction "}}}

function! codelabel#confirm_labelmap() "{{{
  if !exists('s:labelmap')
    let s:labelmap = codelabel#build_labelmap()
    call codelabel#diff#on_change_labelmap(s:labelmap)
  endif
  return s:labelmap
endfunction "}}}

function! codelabel#current_buffer_info() "{{{
  let linepos = line('.')
  let fname_relative = resolve(bufname(''))
  let fname_abs = fnamemodify(fname_relative, ':p')
  let current_line = getline('.')
  return { 'fname_relative' : fname_relative,
         \ 'fname_abs' : fname_abs,
         \ 'linepos' : linepos,
         \ 'line' : current_line }
endfunction "}}}

" }}}

" Private functions {{{

function! s:parse_labelheader(header) "{{{
  let infos = split(a:header, '	')
  return { 'path': infos[0],
         \ 'linepos': infos[1],
         \ 'line': join(infos[2:], '	') }
endfunction "}}}

function! s:gen_buffer_name(fname, linepos) "{{{
  let fsp = s:FP.split(a:fname)
  let names = [s:FP.basename(a:fname), '-', a:linepos, '-']
  for name in fsp
    call add(names, name[0 : 1])
  endfor
  call add(names, '.md')
  return join(names, '')
endfunction "}}}

function! s:gen_codeinfo(fname, linepos, current_line) "{{{
  let infos = [a:fname, a:linepos, '/^' . a:current_line, '$/']
  return join(infos, '	')
endfunction "}}}

function! s:open_codelabel_buffer(bname, codeinfo) "{{{
  if empty(glob(g:codelabel_save_dir))
    call mkdir(g:codelabel_save_dir, 'p')
  endif
  let buffer = s:BufferManager.open(s:FP.join(g:codelabel_save_dir, a:bname))
  call setline(1, a:codeinfo)
endfunction "}}}

function! s:unlet(vname) "{{{
  if exists(a:vname)
    execute 'unlet ' . a:vname
  endif
endfunction "}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo

