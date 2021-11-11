let b:delimitMate_expand_cr = 2
let b:delimitMate_expand_inside_quotes = 1
let b:delimitMate_expand_space = 0
let b:delimitMate_nesting_quotes = ['`']
" do not use tabs in markdown documents, because that would give inconsistent
" indentation
" example:
" * something long that has to be broken into several lines and is already
"   indented
" ^^ here we need spaces, having tabs for indentation in front of it would be
" messy
setlocal expandtab
setlocal spell spelllang=en,de
