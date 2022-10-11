command! -buffer Hash let @+ = trim(execute('call flog#run_command("Git rev-parse %h")'))
