"Global options
set nocp vb is ru ai hls ml nospell wmnu sc

"localization (English)
set langmenu=en_US.UTF-8 enc=utf-8
lan mes en_US.UTF-8

"Code style enforcement
set tw=80 et sts=4 ts=4 sw=4

if exists("+colorcolumn")
    set cc=80,120
    au FileType qf setl cc=
endif

"colors
set bg=dark
syn on

" Nice looking gui
if has("gui_running")
    if !has("unix")
        set guifont=consolas:h10
    else
        set guifont="Deja Vu Sans Mono":h9
    endif
    set guioptions= mousemodel=extend
    color wombat256mod
    set spell
else
    "TODO: should check whether the current term supports 256 colors
    if $TERM != "linux"
        set t_Co=256
        color wombat256mod
    endif
endif

"Highlight groups for :match
hi hl1		ctermfg=0		ctermbg=11		guifg=#222222	guibg=#F7F416
hi hl2		ctermfg=7		ctermbg=9		guifg=#dddddd	guibg=#F71616

"filetype specific options
filetype plugin on
filetype indent on
set ofu=syntaxcomplete#Complete

"Tags handling
set tags=./tags;/,tags;/

"Search path
set path+=include;/,

"Preview height
set pvh=5

"Better history
set hi=128

"Backup directory
if !has("unix")
    let mybkdir=$TEMP . "/vimbk"
    let myundodir=$TEMP . "/vimundo"
else
    let mybkdir=$HOME . "/.vim/tmp"
    let myundodir=$HOME . "/.vim/tmp/undo"
endif

if !isdirectory(mybkdir)
    call mkdir(mybkdir, "p", 0700)
endif

exe "set dir=" . mybkdir
exe "set backupdir=" . mybkdir

if has("persistent_undo")
    if !isdirectory(myundodir)
        call mkdir(myundodir, "p", 0700)
    endif

    set undofile
    exe "set undodir=" . myundodir
    set undoreload=1000 "maximum number lines to save for undo on a buffer reload
endif

"Use a default directory that makes sense
if has("win32") && (getcwd() == 'C:\Windows\system32') && (expand("%") == '')
    cd ~
endif

"Load plugins
call pathogen#infect()

" Plugins configuration
let g:session_autosave=1
let g:tex_flavor="latex"
let g:tex_fold_enabled=1
let g:vimwiki_list=[{'path': '~/scratch'}]
let g:vimwiki_use_calendar=0
"Handle Calendar
function! CalInsert(day,month,year,week,dir)
         " day   : day you actioned
         " month : month you actioned
         " year  : year you actioned
         " week  : day of week (Mo=1 ... Su=7)
         " dir   : direction of calendar
         let l:days = [ 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su' ]
         let l:m2  = substitute(a:month, '^\d$', '0\0',"")
         let l:d2  = substitute(a:day, '^\d$', '0\0',"")

         exe "normal qa<" . l:days[a:week - 1] . " " . a:year . "-" .
                     \l:m2 . "-" . l:d2 . ">"
endfunction
let calendar_action = 'CalInsert'

"Xml helper functions
function! s:XmlTidy(...)
    silent execute '%!xmllint ' . a:0 . ' --format -'

    if (len(a:000) < 2)
        set ft=xml
    else
        set ft=a:1
    endif
endfunction

command! XML call s:XmlTidy ()
command! HTML call s:XmlTidy (' --html', 'html')
command! Clear 1,$d

"Trailing whitespace removal
function! RemoveTrailingWS()
    let l:winview = winsaveview()
    silent! %s/\s\+$//e
    call winrestview(l:winview)
endfunction

au FileType c,cpp,java,vim au BufWritePre <buffer> call RemoveTrailingWS()

"Custom digs
dig .1 8321 .2 8322 .3 8323 .4 8324 .a 8336 .e 8337 .i 7522 .s 8347 ^1 185 ^2 178 ^3 179 ^- 8315

"Custom key bindings
"  calendar
noremap <Leader>c   :CalendarH<CR>
inoremap <M-,>      <Esc>:CalendarH<CR>
"  vimwiki
map <Leader>\       \ww
