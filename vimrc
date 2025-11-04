scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 21-Aug-2025.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor
unlet s:path

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
"if !(has('win32') || has('mac')) && has('multi_lang')
"  if !exists('$LANG') || $LANG.'X' ==# 'X'
"    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
"      language ctype ja_JP.eucJP
"    endif
"    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
"      language messages ja_JP.eucJP
"    endif
"  endif
"endif
language messages ja_JP.eucJP

" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"

" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    set term=builtin_linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.(無効化)
"set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
endif

" vimproc: 同梱のvimprocを無効化する
if kaoriya#switch#enabled('disable-vimproc')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
endif








"★導入プラグイン
"・submode.vim
"・showmarks.vim
"・NeoComplete
"・NERDTree
"・vim-indent-guides
"・vim-easy-align(使い方:http://wonderwall.hatenablog.com/entry/2016/03/29/215904)
"・accelerated-jk
"・lightline.vim
"・surround.vim(使い方:http://vimblog.hatenablog.com/entry/vim_plugin_surround_vim)
"・caw.vim
"・vim-smartchr
"・syntastic
"・vim-ps1
"・QuickRun


"行番号を表示
set number

"画面端で改行する
set wrap

"クリップボード使用
set clipboard=unnamed,unnamedplus

"横スクロールバー表示
set guioptions+=b

"タブを常に表示
set showtabline=2

"自動生成ファイルを作成しない
set noswapfile
set nobackup
set viminfo=
set noundofile


"タブ文字の表示
set list
set listchars=tab:>-,eol:~

"タブを表示するときの幅
set tabstop=4
set expandtab
set shiftwidth=4

"挿入モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"オートインデントを無効にする
set noautoindent
set nosmartindent

"xコマンドにブラックホールレジスタ設定
noremap x "_x

"画面分割関連
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sx <C-w>x
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"左右のカーソル移動で行間移動可能にする。
set whichwrap=b,s,h,l,<,>,[,]


"検索時、正規表現に対してエスケープ文字を不要不要にする文字を常に出力
nnoremap / /\v

"ビジュアルモードで選択した値を*で検索できるようにする
vnoremap * "zy:let @/ = @z<CR>n

"ノーマルモード時、エンターキーで改行挿入
noremap <CR> o<ESC>

"F5で全選択/F6で全コピー
nmap <silent> <F5> ggVG
nmap <silent> <F6> :%y<CR>

" 自動改行オフ
set formatoptions=q

" IF/END IF間を%キーで移動できるようにする
source D:\Tool\vim\vim74\macros\matchit.vim
let b:match_words = "<if>:<end if>"
let b:match_ignorecase = 1

"メニューバー/ツールバーを非表示
set guioptions-=m
set guioptions-=T

"左スクロールバーを非表示
"下記URLの問題の解決のため
"https://github.com/vim-jp/issues/issues/779
set guioptions-=L


" マーク設定 : {{{
    " 基本マップ
    nnoremap [Mark] <Nop>
    nmap m [Mark]

    " 現在位置をマーク
    if !exists('g:markrement_char')
        let g:markrement_char = [
        \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
        \ ]
    endif
    nnoremap <silent>[Mark]m :<C-u>call <SID>AutoMarkrement()<CR>
    function! s:AutoMarkrement()
        if !exists('b:markrement_pos')
            let b:markrement_pos = 0
        else
            let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
        endif
        execute 'mark' g:markrement_char[b:markrement_pos]
        echo 'marked' g:markrement_char[b:markrement_pos]
    endfunction

    " 次/前のマーク
    nnoremap [Mark]n ]`
    nnoremap <silent> <F3> ]`
    nnoremap [Mark]p [`
    nnoremap <silent> <S-F3> [`

    " 一覧表示
    nnoremap [Mark]l :<C-u>marks<CR>

    "" 前回終了位置に移動
    "autocmd MyAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal g`"' | endif

    "" バッファ読み込み時にマークを初期化
    "autocmd MyAutoCmd BufReadPost * delmarks!

    " 起動時にマーク表示
    aug show-marks-sync
            au!
            au BufReadPost * sil! DoShowMarks
    aug END

    "マーク更新時間を1ミリ秒に設定
    set updatetime=1
" }}}





"★neocomplete設定 {{{
    " 起動時に有効化
    let g:neocomplete#enable_at_startup = 1
    " 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " _(アンダースコア)区切りの補完を有効化
"    let g:neocomplete#enable_underbar_completion = 1
"    let g:neocomplete#enable_camel_case_completion  =  1
    " ポップアップメニューで表示される候補の数
    let g:neocomplete#max_list = 20
    " シンタックスをキャッシュするときの最小文字長
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    " 補完を表示する最小文字数
    let g:neocomplete#auto_completion_start_length = 2
    " preview window を閉じない
    let g:neocomplete#enable_auto_close_preview = 0

    let g:neocomplete#max_keyword_width = 10000

    " <TAB>: 選択
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <ENTER>: 決定
    inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"


    "辞書読み込み
    let s:neco_dicts_dir = $HOME . '/vimdict'
    if isdirectory(s:neco_dicts_dir)
      let g:neocomplete#sources#dictionary#dictionaries = {
      \   'sql': s:neco_dicts_dir . '/sql.dict'
      \ }
    endif

"}}}

"★NERDTree設定
nnoremap <silent><C-e> :NERDTreeToggle<CR>

"現在のタブをカレントディレクトリに設定
set autochdir


"★全角スペースの表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif


"★vim-indent-guides設定
" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量
let g:indent_guides_start_level=2
" 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626 ctermbg=gray
" 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c ctermbg=darkgray
" ハイライト色の変化の幅
let g:indent_guides_color_change_percent = 30
" ガイドの幅
let g:indent_guides_guide_size = 1


"★vim-easy-alignの設定
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"★accelerated-jkの設定
" j/kによる移動を速くする
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)


"★lightline.vimの設定
let g:lightline = {'colorscheme': 'wombat'}


"★vim-smartchrの設定
"inoremap <buffer> <expr> = smartchr#loop(' = ', '=')
"inoremap <buffer> <expr> + smartchr#loop(' + ', '+')
"inoremap <buffer> <expr> - smartchr#loop(' - ', '-')



"末尾の空白を削除
nmap <silent> <F7> :%s/\v[ 　\t]+$//g<CR>


"★syntasticの設定
"let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['sql'] }

"★pythonファイルの実行
autocmd BufNewFile,BufRead *.py nnoremap <C-s> :!py %



"★QuickRunの設定
"エイリアス
command Qr QuickRun
"デフォルトで結果を下に表示するようにする
let g:quickrun_config = {
\   "_" : {
\       "outputter/buffer/split" : ":botright 5sp"
\       ,"runner" : "vimproc"
\       ,"runner/vimproc/updatetime" : 60
\   },
\}

"★pythonブレークポイント挿入
autocmd BufNewFile,BufRead *.py nnoremap <F9> iimport pdb; pdb.set_trace()<ESC>
