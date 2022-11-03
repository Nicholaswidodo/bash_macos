#!/bin/bash -e

# install git
echo "------------------------------------------------------"
echo -e "\e[33mInstalling git\e[m"
sudo apt update
sudo apt install git ssh software-properties-common -y

echo "------------------------------------------------------"
echo -e "\e[33mEnter your github username\e[m"
read -p "Github username: " username
git config --global user.name $username
echo -e "\e[33mEnter your github email\e[m"
read -p "Github email: " email
git config --global user.email $email
echo -e "\e[33mGenerate ssh-keygen, you will need to manually copy the key to your github account\e[m"
ssh-keygen


echo "------------------------------------------------------"
echo -e "\e[33mInstalling visual code\e[m"
sudo apt install wget gpg apt-transport-https -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code -y

echo "------------------------------------------------------"
echo -e "\e[33mInstalling visual code extensions\e[m"
code --install-extension "ms-vscode.sublime-keybindings"
code --install-extension "emmanuelbeziat.vscode-great-icons"
code --install-extension "MS-vsliveshare.vsliveshare"
code --install-extension "rebornix.ruby"
code --install-extension "dbaeumer.vscode-eslint"
code --install-extension "Rubymaniac.vscode-paste-and-indent"
code --install-extension "alexcvzz.vscode-sqlite"

echo "------------------------------------------------------"
echo -e "\e[33mInstalling gh\e[m"
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

echo "------------------------------------------------------"
echo -e "\e[33mInstalling image magick and jq\e[m"
sudo apt install imagemagick jq -y

#TODO untested from here
echo "------------------------------------------------------"
add_zshrc(){
  added=$(grep "$1" ~/.bashrc | wc -l)
  if [ $added -gt 0 ]; then
    echo -e "\e[33m '$1' already exists in .zshrc\e[m"
  else
    echo "$1" >> ~/.zshrc
  fi
}

# install openssl 1.0.2 (untested, check https://askubuntu.com/questions/1000629/how-to-install-openssl-1-0-2-with-default-openssl-1-1-1-on-ubuntu-16-04)
echo -e "\e[33mInstalling openssl 1.0.2\e[m"
sudo apt-get install php5-curl
sudo apt-get install make
curl https://www.openssl.org/source/openssl-1.0.2l.tar.gz | tar xz && cd openssl-1.0.2l && sudo ./config && sudo make && sudo make install
sudo ln -sf /usr/local/ssl/bin/openssl `which openssl`
openssl version -v

# install oh-my-zsh (this will switch shell)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling zsh\e[m"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source ~/.zshrc

# github cli (i dont use github cli so i leave this empty)
echo "------------------------------------------------------"
echo -e "\e[33mGithub cli\e[m"
exec $SHELL
source ~/.zshrc

# install ruby-build and rbenv (untested, i dont use ruby)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling rbenv and ruby-build\e[m"
rvm implode && sudo rm -rf ~/.rvm
sudo rm -rf $HOME/.rbenv /usr/local/rbenv /opt/rbenv /usr/local/opt/rbenv
sudo apt remove rbenv ruby-build
exec $SHELL
sudo apt install rbenv ruby-build -y
add_zshrc "export PATH=$HOME/.rbenv/bin:$PATH"
add_zshrc "eval '$(rbenv init -)'"
source ~/.zshrc

# install ruby (untested, i dont use ruby)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling ruby\e[m"
rbenv install 3.0.3
rbenv install 2.3.3
exec $SHELL

# install gem (untested, i dont use ruby)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling gems\e[m"
gem install rake rspec rubocop-performance pry-byebug colored http 'rails:~>6.1'
gem install bundler 1.17.3

# install node.js (untested, i have different node js installed which will collide with this)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling Node.js\e[m"
curl -o- <https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh> | zsh
exec $SHELL
nvm -v
nvm install 17.8.0
node -v
nvm cache clear

# install pyenv
echo "------------------------------------------------------"
echo -e "\e[33mInstalling pyenv\e[m"
sudo apt install -y git build-essential libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
add_zshrc "export PATH=$HOME/.pyenv/bin:$PATH"
add_zshrc "$(pyenv init --path)"

# install yarn (untested, i have different node js installed which will collide with this)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling yarn\e[m"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install --no-install-recommends yarn -y
yarn -v

# install postgresql 9.6 (untested, check https://www.rosehosting.com/blog/how-to-install-postgresql-9-6-on-ubuntu-20-04/)
echo "------------------------------------------------------"
echo -e "\e[33mInstalling PostgreSQL 9.6\e[m"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
sudo apt-get update -y
sudo apt-get install postgresql-9.6

# setup up AWS (skipping some part since i dont use AWS)
echo "------------------------------------------------------"
echo -e "\e[33mSetting up AWS vault\e[m"
sudo apt install awscli -y
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-$(dpkg --print-architecture)
sudo chmod 755 /usr/local/bin/aws-vault

echo "------------------------------------------------------"
echo -e "\e[33mFinished intallation\e[m"
