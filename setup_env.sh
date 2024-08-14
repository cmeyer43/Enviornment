sudo apt-get install -y tmux vim xclip build-essential gitk git docker.io
cp ~/.bashrc ~/.bashrc.old
cat bashrc > ~/.bashrc
cp ~/.vimrc ~/.vimrc.old
cat vimrc > ~/.vimrc
sudo touch /etc/vim/vimrc.local
sudo cat vimrc > /etc/vim/vimrc.local
cp ~/.tmux.conf ~/.tmux.conv.old
cat tmux.conf > ~/.tmux.conf
source ~/.bashrc
tmux source ~/.tmux.conf
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp
newgrp docker
chmod 777 /var/run/docker.sock
