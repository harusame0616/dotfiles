# tac 用
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

## zsh 設定
### vim like キーバインド
bindkey -v
### エディタをvimに設定
export EDITOR=vim

### コマンドの履歴設定
#### 履歴ファイルの保存先
HISTFILE=$HOME/.zsh_history
#### メモリに保存される履歴の件数
HISTSIZE=100000
#### HISTFILE で指定したファイルに保存される履歴の件数
SAVEHIST=100000
#### 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
#### 古い方のヒストリを削除
setopt hist_save_no_dups
#### ヒストリへの追加時に余計なスペースを削除
setopt hist_reduce_blanks
#### 履歴をすぐに追加する
setopt inc_append_history
#### zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
#### 他のシェルのヒストリを共有
setopt share_history
#### 関数定義のためのコマンドは履歴から削除する
setopt hist_no_functions
#### 履歴参照のコマンドは履歴に登録しない
setopt hist_no_store

function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

### タブ
setopt auto_menu

### 補完 
#### --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

### cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr


## zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# 非同期処理できるようになる
zplug "mafredri/zsh-async"
# テーマ(ここは好みで。調べた感じpureが人気)
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zplug "zsh-users/zsh-history-substring-search"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"
# 補完強化
zplug "zsh-users/zsh-completions"
# 256色表示にする
zplug "chrissicool/zsh-256color"
# コマンドライン上の文字リテラルの絵文字を emoji 化する
zplug "mrowa44/emojify", as:command
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load

## アプリケーション設定
### github cli
eval "$(gh completion -s zsh)"

### fnm
eval "$(fnm env --use-on-cd)"


### GHQ
function peco-ghq-look () {
    local ghq_root=`ghq root`
    local selected_dir=`ghq list | peco --prompt="cd-ghq >"`
    echo "${ghq_root}/${selected_dir}"
    cd "${ghq_root}/${selected_dir}"
    zle clear-screen
}

zle -N peco-ghq-look
bindkey '^G^G' peco-ghq-look
