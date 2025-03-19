# Save existing settings.
if [ -f ~/.zshrc ]
    cp ~/.zshrc ~/.zshrc.old
fi
if [ -f ~/.bashrc ]
    cp ~/.bashrc ~/.bashrc.old
fi
if [ -f ~/.vimrc ]
    cp ~/.vimrc ~/.vimrc.old
fi
cat vimrc > ~/.vimrc
if [ -f ~/.tmux.conf ]
    cp ~/.tmux.conf ~/.tmux.conf.old
fi
if [ -f ~/.aliases ]
    cp ~/.aliases ~/.aliases.old
fi
cat aliases > ~/.aliases

name="$(uname -s)"
case "${name}" in
    Linux*)
        if apt list &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y tmux vim xclip build-essential gitk git docker.io ncdu
            sudo touch /etc/vim/vimrc.local
            sudo cat vimrc > /etc/vim/vimrc.local
        elif dnf &> /dev/null; then
            sudo dnf install -y tmux vim xclip gitk git ncdu dnf-plugins-core
            sudo dnf-3 -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo touch /etc/vimrc
            sudo cp vimrc /etc/vimrc
        fi
        sudo systemctl start docker.socket
        cat bashrc > ~/.bashrc
        cat vimrc > ~/.vimrc
        cat tmux.conf > ~/.tmux.conf
        echo >> 'alias gk="gitk"'
        echo >> 'alias gka="gitk --all"'
        source ~/.bashrc
        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp
        newgrp docker
        chmod 777 /var/run/docker.sock
        sudo systemctl start docker.socket
        echo "Linux Setup";;

    Darwin*)
        xcode-select --install
        /bin/bash "$curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo: echo 'eval "$/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "($/opt/homebrew/bin/brew shellenv)"
        brew install tmux vim xclip git gitx docker ncdu -q
        cat zshrc > ~/.zshrc
        cat tmuxApple.conf > ~/.tmux.conf
        echo 'alias gk="gitx"' >> ~/.aliases
        echo 'alias gka="gitx --all"' >> ~/.aliases
        source ~/.zshrc
        echo "Mac Setup";;
esac

tmux source ~/.tmux.conf
