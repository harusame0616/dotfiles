export PATH="/usr/local/opt/curl/bin:$PATH" >> ~/.zshrc

PROMPT='%~'

# vim like キーバインド
bindkey -v
# エディタをvimに設定
export EDITOR=vim

# ヒストリ設定
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

## 補完機能の強化
autoload -Uz compinit && compinit -u


## 色を使う
autoload -Uz colors
setopt prompt_subst

# gitのカラー表示
git config --global color.ui auto

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## 補完候補を一覧表示
setopt auto_list

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## ヒストリへの追加時に余計なスペースを削除
setopt hist_reduce_blanks

# 履歴をすぐに追加する
setopt inc_append_history

## cd 時に自動で pushd
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## ヒストリを共有
setopt share_history

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## 自動でpushd
setopt auto_pushd
## pushdで重複を記録しない
setopt pushd_ignore_dups

## スペルチェック
setopt correct


# peco history
function select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle -R -c
}
zle -N select-history
bindkey '^r' select-history

function status-prompt {
  local branch
  reset='%{\e[0m%}'   # reset
  sharp="\uE0B0"      # triangle

  set_text_color='%{\e[38;5;'    # set text color
  set_back_color='%{\e[30;48;5;' # set background color
# カラー見本がみたい場合は以下のコマンドをシェルで実行 # for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
  text_color_1="230m%}"
  text_color_2="230m%}"
  text_color_3="230m%}"
  back_color_1="035m%}"
  back_color_2="067m%}"
  back_color_3="209m%}"
  clean_color="154m%}"
  conflict_color="160m%}"
  unstaged_color="220m%}"
  untracked_color="090m%}"
  uncommited_color="025m%}"


  icon_clean="️${set_text_color}${clean_color}\uf00c "
  icon_conflict="${set_text_color}${conflict_color}\uf0e7 "
  icon_unstaged="️${set_text_color}${unstaged_color}\uf044 "
  icon_untracked="${set_text_color}${untracked_color}\uf05b "
  icon_uncommited="${set_text_color}${uncommited_color}\uf0c7 "

  color_setting_1="${set_back_color}${back_color_1}${set_text_color}${text_color_1}"
  color_setting_2="${set_back_color}${back_color_2}${set_text_color}${text_color_2}"
  color_setting_3="${set_back_color}${back_color_3}${set_text_color}${text_color_3}"

  triangle_1="${set_back_color}${back_color_2}${set_text_color}${back_color_1}${sharp}"
  triangle_2="${set_back_color}${back_color_3}${set_text_color}${back_color_2}${sharp}"
  triangle_3="${reset}${set_text_color}${back_color_3}${sharp}"

  text_1=" %n@%m "
  text_2=" %~ "

  a1="${color_setting_1}${text_1}${triangle_1}"
  a2="${color_setting_2}${text_2}${triangle_2}"



  # ブランチマーク
  branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  git_status=''
  if [ -n "${branch}" ]; then
    st=`git status 2> /dev/null`

    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
      git_status+=${icon_clean}
    fi
    if [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
      git_status+=${icon_untracked}
    fi
    if [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
      git_status+=${icon_unstaged}
    fi
    if [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
      git_status+=${icon_uncommited}
    fi
    if [[ -n `echo "$st" | grep "fix conflicts"` ]]; then
      git_status+=${icon_conflict}
    fi

    text_3=" ${branch} ${git_status}"
  fi
  a3="${color_setting_3}${text_3} ${triangle_3}"

  echo "${a1}${a2}${a3}"
  echo "${set_text_color}${back_color_1}›${set_text_color}${back_color_2}›${set_text_color}${back_color_3}›${reset} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
PROMPT='`status-prompt`'

# -- TMUX ------------------
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | peco | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi

# -- GHQ -------------------
function peco-ghq-look () {
    local ghq_root=`ghq root`
    local selected_dir=`ghq list | peco --prompt="cd-ghq >"`
    echo "${ghq_root}/${selected_dir}"
    cd "${ghq_root}/${selected_dir}"
    zle clear-screen
}

zle -N peco-ghq-look
bindkey '^g^g' peco-ghq-look

# -- HOOK ------------------
# コマンドの実行ごとに改行
function precmd() {
  # 改行
  if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
      NEW_LINE_BEFORE_PROMPT=1
  elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
      echo ""
  fi
}

# ディレクトリ移動後
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ lsd }

# --- CDR -------------------
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cdr-history"
zstyle ':chpwd:*' recent-dirs-pushd true
function cd_recents(){
  dir=`cdr -l | peco --prompt "recent dirs > " | sed -re "s/([0-9]+ +)|\n//g"`
  BUFFER="${dir}"
  zle accept-line
}

zle -N cd_recents
bindkey '^e' cd_recents


# --- git -------------------
function select_branch(){
  branch=`git branch ${1}| peco --prompt "branch${1} >" | sed -re "s/ +|^\*|\r\n//g"`
  if [ -z $branch ]; then
    return
  fi
  BUFFER+=" $branch"
  CURSOR+=${#branch}+1
  zle redisplay
}

function select_branch_remote(){
  select_branch --remote
}

zle -N select_branch
zle -N select_branch_remote
bindkey '^g^b' "select_branch"
bindkey '^g^r' "select_branch_remote"

# -- ALIAS ------------------
alias ls=lsd
