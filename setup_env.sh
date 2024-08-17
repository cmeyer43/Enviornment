touch ~/.vimrc
cp ~/.vimrc ~/.vimrc.old
cp ~/.tmux.conf ~/.tmux.conf.old
name="$(uname -s)"
case "${name}" in
    Linux*)
        sudo apt-get install -y tmux vim xclip build-essential gitk git docker.io ncdu
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
        echo "Linux";;
    Darwin*)
        brew install tmux vim xclip git gitx docker ncdu -q
        touch ~/.zshrc
        cp ~/.zshrc ~/.zshrc.old
        cat zshrc > ~/.zshrc
        cat tmuxApple.conf >~/.tmux.conf
        source ~/.zshrc
        echo "mac";;
esac
cat vimrc > ~/.vimrc
tmux source ~/.tmux.conf
