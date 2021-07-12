verbose nnoremap <buffer> <silent> <Leader>h :Flogjump HEAD<CR>
command! -buffer Hash let @+ = trim(execute('call flog#run_command("Git rev-parse %h")'))
