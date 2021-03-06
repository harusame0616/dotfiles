# recognize os
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
  PACKAGER='brew'
  INSTALL='install'
  OPT=''
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
  PACKAGER='apt'
  INSTALL='install'
  OPT='-y'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi


${PACKAGER} ${INSTALL} ${OPT} zsh tmux peco  git ghq lazydocker lazygit lsd


# 設定ファイルのリンク作成
dir=`pwd`
files=(.zshrc .tmux.conf .vimrc)
for file in $files; do
  ln -s $dir/$file ~/$file
done
