command! -buffer Hash let @+ = trim(execute('Git rev-parse '.flog#Format("%h")))
