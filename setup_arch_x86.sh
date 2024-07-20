#!/bin/bash

# Function to prompt user for installation
install_prompt() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in 
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo "Invalid input. Please enter y or n."; install_prompt $1;;
    esac
}

# Update and upgrade the system
sudo pacman -Syu --noconfirm

# Install git
if install_prompt "git"; then
    sudo pacman -S --noconfirm git
fi

# Install vim
if install_prompt "vim"; then
    sudo pacman -S --noconfirm vim
fi

# Install Homebrew
if install_prompt "Homebrew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
fi

# Install GCC via Homebrew
if install_prompt "GCC via Homebrew"; then
    brew install gcc
fi

# Install Node.js (using nvm for managing Node.js versions)
if install_prompt "Node.js"; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
fi

# Install Golang
if install_prompt "Golang"; then
    sudo pacman -S --noconfirm go
fi

# Install Python
if install_prompt "Python"; then
    sudo pacman -S --noconfirm python python-pip
fi

# Install Docker
if install_prompt "Docker"; then
    sudo pacman -S --noconfirm docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ${USER}
    newgrp docker
fi

# Install Miniconda (a smaller version of Anaconda)
if install_prompt "Miniconda"; then
    cd /tmp
    curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.bashrc
    echo ". $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.zshrc
fi

# Install Geany code editor
if install_prompt "Geany code editor"; then
    sudo pacman -S --noconfirm geany
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
