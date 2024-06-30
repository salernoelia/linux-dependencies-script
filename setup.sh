#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install git
sudo apt install -y git

# Install vim
sudo apt install -y vim

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Ensure Homebrew is added to PATH in all future shell sessions
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc

# Install GCC via Homebrew
brew install gcc

# Install Node.js (using nvm for managing Node.js versions)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

# Install Golang
sudo apt install -y golang-go

# Install Python
sudo apt install -y python3 python3-pip

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce

# Add current user to the docker group to run docker without sudo
sudo usermod -aG docker ${USER}
newgrp docker

# Verify installations
git --version
vim --version
brew --version
gcc --version
node --version
go version
python3 --version
docker --version

echo "Installation complete!"
