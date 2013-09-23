
scriptencoding utf-8

if exists("g:loaded_timer")
  finish
endif
let g:loaded_timer = 1

let s:save_cpo = &cpo
set cpo&vim

let g:timer#updatetime = get(g:,'g:timer#updatetime',1000)

let &cpo = s:save_cpo
finish

