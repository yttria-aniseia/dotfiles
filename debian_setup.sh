# assumes debian 12 (bookworm) from windows store
sudo echo 'deb-src https://deb.debian.org/debian bookworm main' >> /etc/apt/sources.list
sudo apt update
sudo apt-get install ca-certificates build-essential wget git

cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases

cp .nanorc ~/.nanorc

# build emacs from source
mkdir src; cd src
wget http://mirrors.ibiblio.org/gnu/emacs/emacs-29.1.tar.xz
tar -xf emacs-29.1.tar.xz
cd emacs-29.1
sudo apt-get install zlib1g-dev libgccjit-12-dev pkgconf libgnutls28-dev libxml2-dev libjansson-dev libtree-sitter-dev libncurses-dev
# we may also want to patch docs destination directories for debian according to
# https://sources.debian.org/patches/emacs/1:28.2%2B1-15/0001-Prefer-usr-share-info-emacs.patch/
./configure --enable-link-time-optimization --with-native-compilation=yes --without-x --with-x-toolkit=no --without-xft --without-lcms2 --without-rsvg --without-jpeg --without-gif --without-tiff --without-png --without-toolkit-scroll-bars --without-xaw3d --without-cairo --with-sound=no --with-xml2 --with-tree-sitter
make
sudo make install
# clean up after emacs install
make clean
sudo apt-get autoremove libgnutls28-dev libxml2-dev libjansson-dev libtree-sitter-dev libncurses-dev zlib1g-dev libgccjit-12-dev
cd ..
rm -rf emacs-29.1*
cd ..

