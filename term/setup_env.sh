touch ~/.vimrc
touch ~/.tmux.conf
cp ~/.vimrc ~/.vimrc.old
cp ~/.tmux.conf ~/.tmux.conf.old
name="$(uname -s)"
case "${name}" in
    Linux*)
        if [ apt &> /dev/null ]; then
            sudo apt-get update
            sudo apt-get install -y tmux vim xclip build-essential gitk git docker.io ncdu
        elif [ dnf &> /dev/null ]; then
            sudo dnf install -y tmux vim xclip gitk git ncdu dnf-plugins-core
            sudo dnf-3 -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        fi
        sudo systemctl start docker.socket
        touch ~/.bashrc
        cp ~/.bashrc ~/.bashrc.old
        cat bashrc > ~/.bashrc
        cat vimrc > ~/.vimrc
        sudo touch /etc/vim/vimrc.local
        sudo cat vimrc > /etc/vim/vimrc.local
        cat tmux.conf > ~/.tmux.conf
        source ~/.bashrc
        cat bashrc > ~/.bashrc
        sudo touch /etc/vim/vimrc.local
        sudo cat vimrc > /etc/vim/vimrc.local
        cat tmux.conf > ~/.tmux.conf
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
        touch ~/.zshrc
        cp ~/.zshrc ~/.zshrc.old
        cat zshrc > ~/.zshrc
        cat tmuxApple.conf >~/.tmux.conf
        source ~/.zshrc
        echo "Mac Setup";;
esac
cat vimrc > ~/.vimrc
tmux source ~/.tmux.conf
