sudo echo 'deb-src https://deb.debian.org/debian bookworm main' >> /etc/apt/sources.list
sudo apt update
sudo apt-get install git
git clone 
cd dotfiles
./debian_setup.sh
