verbose nnoremap <buffer> <Leader>/ :VimwikiAg<Space>
verbose nnoremap <buffer> <Leader>w/ :VimwikiSearch<Space>
command! -nargs=1 VimwikiAg :execute "AgIn" fnameescape(vimwiki#vars#get_wikilocal('path')) "<args> "
