#!/bin/bash

# Array to store the user's choices
declare -A choices

# Function to prompt user for installation
install_prompt() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in 
        y|Y ) choices[$1]=1;;
        n|N ) choices[$1]=0;;
        * ) echo "Invalid input. Please enter y or n."; install_prompt $1;;
    esac
}

# Prompt for all installations
install_prompt "git"
install_prompt "vim"
install_prompt "Homebrew"
install_prompt "GCC via Homebrew"
install_prompt "Node.js"
install_prompt "Golang"
install_prompt "Python"
install_prompt "Docker"
install_prompt "Miniconda"
install_prompt "Geany code editor"

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install git
if [ "${choices[git]}" -eq 1 ]; then
    sudo apt install -y git
fi

# Install vim
if [ "${choices[vim]}" -eq 1 ]; then
    sudo apt install -y vim
fi

# Install Homebrew
if [ "${choices[Homebrew]}" -eq 1 ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
fi

# Install GCC via Homebrew
if [ "${choices[GCC via Homebrew]}" -eq 1 ]; then
    brew install gcc
fi

# Install Node.js (using nvm for managing Node.js versions)
if [ "${choices[Node.js]}" -eq 1 ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
fi

# Install Golang
if [ "${choices[Golang]}" -eq 1 ]; then
    sudo apt install -y golang-go
fi

# Install Python
if [ "${choices[Python]}" -eq 1 ]; then
    sudo apt install -y python3 python3-pip
fi

# Install Docker
if [ "${choices[Docker]}" -eq 1 ]; then
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce
    sudo usermod -aG docker ${USER}
    newgrp docker
fi

# Install Miniconda (a smaller version of Anaconda)
if [ "${choices[Miniconda]}" -eq 1 ]; then
    cd /tmp
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.zshrc
fi

# Install Geany code editor
if [ "${choices[Geany code editor]}" -eq 1 ]; then
    sudo apt install -y geany
fi

# Verify installations
echo "Verifying installations..."
if command -v git &> /dev/null; then git --version; fi
if command -v vim &> /dev/null; then vim --version; fi
if command -v brew &> /dev/null; then brew --version; fi
if command -v gcc &> /dev/null; then gcc --version; fi
if command -v node &> /dev/null; then node --version; fi
if command -v go &> /dev/null; then go version; fi
if command -v python3 &> /dev/null; then python3 --version; fi
if command -v docker &> /dev/null; then docker --version; fi
if command -v conda &> /dev/null; then conda --version; fi
if command -v geany &> /dev/null; then geany --version; fi

echo "Installation complete!"
