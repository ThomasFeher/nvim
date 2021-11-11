verbose nnoremap <buffer> <Leader>/ :VimwikiAg<Space>
verbose nnoremap <buffer> <Leader>w/ :VimwikiSearch<Space>
command! -buffer -nargs=1 VimwikiAg :execute "AgIn" fnameescape(vimwiki#vars#get_wikilocal('path')) "<args> "
" search for open TODO items in the complete wiki
" copied from https://github.com/vimwiki/vimwiki/issues/515#issuecomment-672913673
command! -buffer -bang -nargs=* VimwikiTodo
			\ call fzf#vim#grep(
			\     join(['rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape('^- \[[ X]\] .+'),
			\         fnameescape(vimwiki#vars#get_wikilocal('path'))]),
			\     1,
			\     fzf#vim#with_preview(),
			\     <bang>0)
" do not use tabs in markdown documents, because that would give inconsistent
" indentation
" example:
" * something long that has to be broken into several lines and is already
"   indented
" ^^ here we need spaces, having tabs for indentation in front of it would be
" messy
setlocal expandtab
setlocal spell spelllang=en,de
