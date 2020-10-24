verbose nnoremap <buffer> <Leader>/ :VimwikiAg<Space>
verbose nnoremap <buffer> <Leader>w/ :VimwikiSearch<Space>
command! -nargs=1 VimwikiAg :execute "AgIn" fnameescape(vimwiki#vars#get_wikilocal('path')) "<args> "
" search for open TODO items in the complete wiki
" copied from https://github.com/vimwiki/vimwiki/issues/515#issuecomment-672913673
command! -buffer -bang -nargs=* VimwikiTodo
			\ call fzf#vim#grep(
			\     join(['rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape('^- \[[ X]\] .+'),
			\         fnameescape(vimwiki#vars#get_wikilocal('path'))]),
			\     1,
			\     fzf#vim#with_preview(),
			\     <bang>0)
