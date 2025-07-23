" Syntax file for RedDust
" Maintainer: Syntax Echonomics

if exists("b:current_syntax")
  finish
endif

syntax match reddustKeyword /^\s*[0-9A-F]\ze;/
syntax match reddustNumber /\v\<[0-9A-F]\>/
syntax match reddustComment "//.*$"

highlight def link reddustKeyword Keyword
highlight def link reddustNumber Number
highlight def link reddustComment Comment

let b:current_syntax = "reddust"
