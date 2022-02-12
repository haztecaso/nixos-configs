"vim specific configs

call EnsureDirExists($HOME . '/.vim/backup/')
call EnsureDirExists($HOME . '/.vim/swap/')
call EnsureDirExists($HOME . '/.vim/undo/')

set backupdir=$HOME/.vim/backup/
set directory=$HOME/.vim/swap/
set undodir=$HOME/.vim/undo/
