#!/bin/bash

# Function to prompt user for installation
install_prompt() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in 
        y|Y ) echo "yes";;
        n|N ) echo "no";;
        * ) echo "Invalid input. Please enter y or n."; install_prompt $1;;
    esac
}

# Prompt for all installations upfront
INSTALL_GIT=$(install_prompt "git")
INSTALL_VIM=$(install_prompt "vim")
INSTALL_NODEJS=$(install_prompt "Node.js")
INSTALL_GOLANG=$(install_prompt "Golang")
INSTALL_PYTHON=$(install_prompt "Python")
INSTALL_DOCKER=$(install_prompt "Docker")
INSTALL_MINICONDA=$(install_prompt "Miniconda")
INSTALL_GEANY=$(install_prompt "Geany code editor")

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install git
if [ "$INSTALL_GIT" == "yes" ]; then
    sudo apt install -y git
fi

# Install vim
if [ "$INSTALL_VIM" == "yes" ]; then
    sudo apt install -y vim
fi

# Install Node.js (using nvm for managing Node.js versions)
if [ "$INSTALL_NODEJS" == "yes" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
fi

# Install Golang
if [ "$INSTALL_GOLANG" == "yes" ]; then
    sudo apt install -y golang-go
fi

# Install Python
if [ "$INSTALL_PYTHON" == "yes" ]; then
    sudo apt install -y python3 python3-pip
fi

# Install Docker
if [ "$INSTALL_DOCKER" == "yes" ]; then
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce
    sudo usermod -aG docker ${USER}
    newgrp docker
fi

# Install Miniconda (a smaller version of Anaconda)
if [ "$INSTALL_MINICONDA" == "yes" ]; then
    cd /tmp
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.zshrc
fi

# Install Geany code editor
if [ "$INSTALL_GEANY" == "yes" ]; then
    sudo apt install -y geany
fi

# Verify installations
echo "Verifying installations..."
if command -v git &> /dev/null; then git --version; fi
if command -v vim &> /dev/null; then vim --version; fi
if command -v node &> /dev/null; then node --version; fi
if command -v go &> /dev/null; then go version; fi
if command -v python3 &> /dev/null; then python3 --version; fi
if command -v docker &> /dev/null; then docker --version; fi
if command -v conda &> /dev/null; then conda --version; fi
if command -v geany &> /dev/null; then geany --version; fi

echo "Installation complete!"
