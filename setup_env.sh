sudo apt-get install -y tmux vim xclip build-essential gitk git
cat bashrc > ~/.bashrc
cat vimrc > ~/.vimrc
sudo touch /etc/vim/vimrc.local
sudo cat vimrc > /etc/vim/vimrc.local
cat tmux.conf > ~/.tmux.conf
source ~/.bashrc
tmux source ~/.tmux.conf
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp
newgrp docker
chmod 777 /var/run/docker.sock
