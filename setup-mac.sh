# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# for zx
brew install node
npm update && npm install

npx ts-node --esm ./config/deploy.ts

# app install
xcode-select --install
npx ts-node --esm ./app-installer/main.ts

# set default shell
echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/zsh
