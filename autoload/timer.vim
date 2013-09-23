
let s:obj = {
      \   'status' : 'stop',
      \   'counter' : 0,
      \   'interval_functions' : {
      \   },
      \ }

function! timer#clear() " {{{
  let s:obj.interval_functions = {}
endfunction " }}}
function! timer#start() " {{{
  if s:obj.status !=# 'running'
    let s:obj.status = 'running'
    augroup timer
      autocmd!
      autocmd CursorHold,CursorHoldI * call s:caller()
    augroup END
  endif
endfunction " }}}
function! timer#stop() " {{{
  augroup timer
    autocmd!
  augroup END
  let s:obj.status = 'stop'
endfunction " }}}
function! timer#regist_interval(funcname,interval_ms) " {{{
  let key = printf('_%d_%s', a:interval_ms, a:funcname)
  let s:obj.interval_functions[key] = {
        \   'funcname' : a:funcname,
        \   'interval_ms' : (a:interval_ms / 100 * 100),
        \ }
  return key
endfunction " }}}
function! timer#unregist_interval(key) " {{{
  if has_key(s:obj.interval_functions, a:key)
    call remove(s:obj.interval_functions, a:key)
  endif
endfunction " }}}
function! s:caller() " {{{
  if s:obj.status ==# 'running'
    let tmp_updatetime = &updatetime
    try
      let &updatetime = g:timer#updatetime

      let s:obj.counter += &updatetime
      for key in keys(s:obj.interval_functions)
        if s:obj.counter % s:obj.interval_functions[key].interval_ms < g:timer#updatetime
          call function(s:obj.interval_functions[key].funcname)()
        endif
      endfor
    catch /.*/
      call timer#stop()
    finally
      let &updatetime = tmp_updatetime
      call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
    endtry
  endif
endfunction " }}}

"  vim: set ts=2 sts=2 sw=2 ft=vim fdm=marker ff=unix :
