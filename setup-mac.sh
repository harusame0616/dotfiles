# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# for zx
brew install node
npm update && npm install

npx ts-node --esm ./config/deploy.ts

# app install
xcode-select --install
npx ts-node --esm ./app-installer/main.ts
