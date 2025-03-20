# Save existing settings and copy over mine.
if [ -f ~/.zshrc ]
    cp ~/.zshrc ~/.zshrc.old
fi
cat zshrc > ~/.zshrc

if [ -f ~/.bashrc ]
    cp ~/.bashrc ~/.bashrc.old
fi
cat bashrc > ~/.bashrc

if [ -f ~/.vimrc ]
    cp ~/.vimrc ~/.vimrc.old
fi
# The non-user (etc) version of this will get written later b/c its location changes based on package manager.
cat vimrc > ~/.vimrc

if [ -f ~/.tmux.conf ]
    cp ~/.tmux.conf ~/.tmux.conf.old
fi
# Write in the correct default shell to tmux config. Also gonna source new .*rc file cause I've already detected the shell.
if [ ${ZSH_VERSION} ]; then
    source ~/.zshrc
    echo 'set-option -g default-shell "/bin/zsh"' > ~/.tmux.conf
elif [ ${BASH_VERSION} ]; then
    source ~/.bashrc
    echo 'set-option -g default-shell "/bin/bash"' > ~/.tmux.conf
fi
cat tmux.conf >> ~/.tmux.conf

if [ -f ~/.aliases ]
    cp ~/.aliases ~/.aliases.old
fi
cat aliases > ~/.aliases

# Kinda uneccesary cause this is not a custom file.
if [ -f ~/.git_prompt ]
    cp ~/.git_prompt ~/.git_prompt.old
fi
cat git_prompt > ~/.git_prompt

name="$(uname -s)"
case "${name}" in
    Linux*)
        if apt list &> /dev/null; then
            # Update apt manager.
            sudo apt-get update
            # Install system packages
            sudo apt-get install -y tmux vim xclip build-essential gitk git docker.io ncdu

            # allows vimrc to be used when super user
            sudo touch /etc/vim/vimrc.local
            sudo cat vimrc > /etc/vim/vimrc.local

        elif dnf &> /dev/null; then
            # Install system packages
            sudo dnf install -y tmux vim xclip gitk git ncdu dnf-plugins-core
            # Add docker repo.
            sudo dnf-3 -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            # Install docker packages
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

            # allows vimrc to be used when super user
            sudo touch /etc/vimrc
            sudo cp vimrc /etc/vimrc
        fi

        # TODO add yum and pacman

        # Setup docker socket and env
        sudo systemctl start docker.socket
        source ~/.bashrc
        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp
        newgrp docker
        chmod 777 /var/run/docker.sock
        sudo systemctl start docker.socket

        echo "Linux Setup";;

    Darwin*)
        # Install xcode for basic packages
        xcode-select --install
        # Brew install
        /bin/bash "$curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo: echo 'eval "$/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
        eval "($/opt/homebrew/bin/brew shellenv)"
        # Install packages
        brew install tmux vim xclip git gitx docker ncdu -q

        # Docker just works on mac no need to configure anything to use it.

        # On Mac I use gitx not gitk so fix that in aliases real quick.
        perl -pi -e 's/gitk/gitx/g' ~/.aliases

        echo "Mac Setup";;
esac

tmux source-file ~/.tmux.conf
