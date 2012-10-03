"--------------------------------------------------------------------------
"基本設定 Basics
"--------------------------------------------------------------------------
let mapleader=","                 "キーマップリーダー
set scrolloff=5                   "スクロール時の余白確保
set textwidth=0                   "一行に長い文章を書いても自動折り返ししない
set nobackup                      "バックアップを取らない
set autoread                      "他で書き換えられたら自動で読み返す
set noswapfile                    "スワップファイルを作らない
set hidden                        "編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start    "バックスペースで何でも消せるように
set formatoptions=lmoq            "テキスト整形オプション、マルチバイト系を追加
set vb t_vb=                      "ビープを鳴らさない
set browsedir=buffer              "Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]     "カーソルを行頭、行末で止まらないようにする
set showcmd                       "コマンドをステータス行に表示
set showmode                      "現在のモードを表示
set viminfo='50,<1000,s100,\"50   "viminfoファイル設定
set modelines=0                   "モードラインは無効

"$CDPATHを適当な形に修正
:let &cdpath = ',' . substitute(substitute($CDPATH, '[, ]', '\\\0', 'g'), ':', ',', 'g')

"OSのクリップボードを利用する
set clipboard+=unnamed
"ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

"ヤンクした文字はシステムのクリップボードに入れる
set clipboard=unnamed
"挿入モードでCtrl+kを押すとクリップボードの内容を貼りつけられるようにする
imap <C-K> <ESC>"*pa

"Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

" NeoBundleために一度ファイルタイプ判定をoff
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

"NeoBundle
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'

NeoBundle 'tpope/vim-endwise.git'
NeoBundle 'vim-scripts/dbext.vim'

NeoBundle 'tpope/vim-rails'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'taq/vim-rspec'

" ファイルタイプ判定をon
filetype plugin indent on
filetype indent on
syntax on

"quickrun設定
let g:quickrun_config = {}
let g:quickrun_config['coffee'] = {'command' : 'coffee', 'exec' : ['%c -cbp %s']}

"--------------------------------------------------------------------------
"ステータス StatusLine
"--------------------------------------------------------------------------
set laststatus=2  "常にステータスラインを表示
set ruler         "カーソルが何行目の何列目に置かれているかを表示

"ステータスラインに文字コードと改行文字を表示する
if winwidth( 0 ) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"--------------------------------------------------------------------------
"表示設定 Apperance
"--------------------------------------------------------------------------
set showmatch                                      "カッコ対応をハイライト
set number                                         "行番号表示
set list                                           "不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:<  "不可視文字の表示形式
set display=uhex                                   "印字不可能文字を16進数で表示

"全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

"カーソル行のハイライト
set cursorline
"カレントウィンドウにのみ罫線を引く
augroup cch
 autocmd! cch
 autocmd WinLeave * set nocursorline
 autocmd WinEnter,Bufread * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

"コマンド実行中は再描画しない
:set lazyredraw
"高速ターミナル接続を行う
:set ttyfast

"--------------------------------------------------------------------------
"インデント Indent
"--------------------------------------------------------------------------
set autoindent  "自動でインデント
set smartindent "新しい行を開始したとき新しい行のインデントを現在行と同じ量にする。
"インデント量を調整
set tabstop=2 shiftwidth=2 softtabstop=0

"--------------------------------------------------------------------------
"補完設定 Complete
"--------------------------------------------------------------------------
set wildmenu             "コマンド補完を強化
set wildchar=<Tab>       "コマンド補完を開始するキー
set wildmode=list:full   "リスト表示、最長マッチ
set history=1000         "コマンド・検索パターンの履歴数
set complete+=k          "補完に辞書ファイル追加

"cdpathを考慮した引数補完を可能にする
command! -complete=customlist,CompleteCD -nargs=? CD cd <args>
function! CompleteCD(arglead, cmdline, cursorpos)
  let pattern = join(split(a:cmdline, '\s', !0)[1:], ' '). '*/'
  return split(globpath(&cdpath, pattern), "\n")
endfunction

":cdを:CDに置き換える
cnoreabbrev <expr> cd
      \ (getcmdtype() == ':' && getcmdline() ==# 'cd') ? 'CD' : 'cd'

"--------------------------------------------------------------------------
"検索設定 Search
"--------------------------------------------------------------------------
set wrapscan    "最後まで検索したら先頭に戻る
set ignorecase  "大文字小文字無視
set smartcase   "検索文字列に大文字が含まれている場合は区別して検索する
set incsearch   "インクリメンタルサーチ
set hlsearch    "検索文字をハイライト

"ESC２回押しでハイライト消去
nnoremap <ESC><ESC> :nohlsearch<CR><ESC>

"Ctrl+hでヘルプ
nnoremap <C-h> :<C-u>help<Space>
"カーソル下のキーワードのヘルプ
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><Enter>

"--------------------------------------------------------------------------
"移動設定 Move
"--------------------------------------------------------------------------
"カーソルを表示行で移動
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

"0,9で行頭、行末へ
nmap 1 0
nmap 0 ^
nmap 9 $

"indert mode での移動
imap <C-e> <END>
imap <C-a> <HOME>
"insert mode でもCtrl+hjklで移動
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

"最後に変更されたテキストを選択する
nnoremap gc `[V`]
vnoremap gc :<C-u>normal gc<Enter>
onoremap gc :<C-u>normal gc<Enter>

"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac " 改行文字
set encoding=utf-8 " デフォルトエンコーディング

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
" iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
" iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
" fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
" 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8
autocmd FileType yml :set fileencoding=utf-8
autocmd FileType haml :set fileencoding=utf-8
autocmd FileType rb :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

"--------------------------------------------------------------------------
"カラー設定 Colors
"--------------------------------------------------------------------------
"ターミナルタイプによるカラー設定
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-256color"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

"ハイライトオン
syntax enable
"カラースキーマ
colorscheme desert

"補完候補の色付け
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9

"--------------------------------------------------------------------------
"編集設定 Edit
"--------------------------------------------------------------------------
"insert mode を抜けるとIMEオフ
"set noimdisable
"set iminsert=0 imsearch=0
"set noimcmdline
"inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
"ESCでIMEを確実にOFF
inoremap <ESC> <ESC>:set iminsert=0<CR>

"Tabキーを空白に変換
set expandtab

"XMLの閉じタグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

"insert mode 中で単語単位/行単位の削除をアンドゥ可能にする
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

"y0,y9で行頭、行末までヤンク
nmap y9 y$
nmap y0 y^

"保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
"保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge

"日時の自動入力
inoremap <expr> ,df strftime('%Y-%m-%dT%H:%M:%S')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

"-------------------------------------------------------------------------------
" その他 Misc
"-------------------------------------------------------------------------------

" ;でコマンド入力( ;と:を入れ替)
noremap ; :
noremap : ;

