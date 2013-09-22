
let s:obj = {
\   'status' : 'stop',
\   'counter' : 0,
\   'interval_functions' : {
\   },
\ }

function! timer#clear()
  let s:obj.interval_functions = {}
endfunction
function! timer#start()
  if s:obj.status !=# 'running'
    let s:obj.status = 'running'
    augroup timer
      autocmd!
      autocmd CursorHold,CursorHoldI * call s:caller()
    augroup END
  endif
endfunction
function! timer#stop()
  augroup timer
    autocmd!
  augroup END
  let s:obj.status = 'stop'
endfunction
function! timer#regist_interval(funcname,interval_ms)
  let key = printf('_%d_%s', a:interval_ms, a:funcname)
  let s:obj.interval_functions[key] = {
  \   'funcname' : a:funcname,
  \   'interval_ms' : (a:interval_ms / 100 * 100),
  \ }
  return key
endfunction
function! timer#unregist_interval(key)
  if has_key(s:obj.interval_functions, a:key)
    call remove(s:obj.interval_functions, a:key)
  endif
endfunction
function! s:caller()
  if &updatetime != 1000
    call timer#stop()
    throw '[timer.vim] Please set &updatetime to 1000.'
  endif
  let s:obj.counter += &updatetime
  for key in keys(s:obj.interval_functions)
    if s:obj.counter % s:obj.interval_functions[key].interval_ms < 1000
      call function(s:obj.interval_functions[key].funcname)()
    endif
  endfor
  call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
endfunction

" call timer#stop()
" call timer#regist_interval('timer#test',1000)
" call timer#regist_interval('timer#test',3000)
" let s:key = timer#regist_interval('timer#test',700)
" call timer#unregist_interval(s:key)
" call timer#start()

"  vim: set ts=2 sts=2 sw=2 ft=vim fdm=manual ff=unix :
