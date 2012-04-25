" This must be first, because it changes other options as side effect
set nocompatible


" change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
" ,sv Recarga la configuracion del vimrc
" ,ev Edita el vimrc
" ,/  Limpia los campos resaltados por la busqurda
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> ,/ :nohlsearch<CR>


"set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
set expandtab

" Para que no cree los archivos de backup y no joda la vida
set nobackup
set noswapfile


" Por ahora no tuve ningun problema en usar esta configurascion
" pero bue... Sino se puede poner en el .bashrc lo siguiente:
" TERM=xterm-256color
set t_Co=256

if &t_Co >= 256 || has("gui_running")
   color mustang
   " color torte
endif

if &t_Co > 2 || has("gui_running")
   " switch syntax highlighting on, when the terminal has colors
   syntax on
endif

" Control+space abre la ventana del omni-complete
" Control+j abre la ventana de autocompletado de vim
" Las dos opciones de abajo son para que cierre la ventana
" abierta por el omnicomplete cuando ya se eligio una opcion
inoremap <Nul> <C-x><C-o>
inoremap <C-j> <C-x><C-n>
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif 
autocmd InsertLeave * if pumvisible() == 0|pclose|endif 

" Para poder usar el pydoc
" :Pydoc re.compile Tira la documentacion
let g:pydoc_cmd = "/usr/bin/pydoc"
let g:pydoc_highlight=0


" Para mostrar y ocultar el numero de linea
" Por default lo muestra, y con F2 oculta o muestra segun corresponda
set number
map <F2> :set nonumber!<CR>:set foldcolumn=0<CR>



" Activar navegador de archivos
map <F3> :NERDTreeToggle<CR>


" Muestra la estructura del modulo
nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>

" Con F5 activo el modo paste. No lo activo por default,
" porque cuando lo activo me deja de funcionar el 
" Omnicomplete
" le tengo que volver a set ruler porque sino en modo paste
" no me la muestra
set ruler
map <F5> :set paste!<CR>:set ruler<CR>

" Con F6 abro el listado de los ultimos archivos abiertos
" MRU = Most Recently Used files.
" http://www.vim.org/scripts/script.php?script_id=521
" Si lo abre en una subventa (hsplit), entonces
" es que el archivo actual tiene modificaciones no grabadas.
map <F6> :MRU<CR>


" Para poder grabar usando sudo
" En caso de que sea necesario una password la va a pedir
" De todas formas pregunta para recargar el archivo, pero
" no encontre una solucion mejor
map <F7> :w !sudo tee > /dev/null %

" Muestra la columna y linea actual (abajo a la derecha).
" Esto es importate porque sino cuando se esta en modo
" paste no se muestran estos valores.
set ruler


" Permite escrolear con el mouse
" set mouse=a

" La dejo deshabilitada porque resulta lento y pesado...
" autocmd FileType python setlocal omnifunc=pysmell#Complete

let g:ctags_statusline=1
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" Para hacer cosas depeniendo del tipo de archivo que es
" si es un archivo de python, bash, etc...
filetype plugin indent on

" Para que muestre los diferentes parentesis con colores
" TODO ver si se lo puede hacer funcion para que lo haga tambien
" con las llaves
autocmd Syntax * runtime plugin/RainbowParenthsis.vim


" borra los espacios extras al final de las lineas
" (guarda antes la posición y la restablece luego)
autocmd BufWritePre *.py mark z | %s/ *$//e | 'z

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

let g:SuperTabDefaultCompletionType = "context"

" Function to activate a virtualenv in the embedded interpreter for
" omnicomplete and other things like that.
function LoadVirtualEnv(path)
    let activate_this = a:path . '/bin/activate_this.py'
    if getftype(a:path) == "dir" && filereadable(activate_this)
        python << EOF
import vim
activate_this = vim.eval('l:activate_this')
execfile(activate_this, dict(__file__=activate_this))
EOF
    endif
endfunction

" Load up a 'stable' virtualenv if one exists in ~/.virtualenv
let defaultvirtualenv = $HOME . "/.virtualenvs/stable"

" Only attempt to load this virtualenv if the defaultvirtualenv
" actually exists, and we aren't running with a virtualenv active.
if has("python")
    if ! empty($VIRTUAL_ENV)
        call LoadVirtualEnv($VIRTUAL_ENV)
    endif
endif
