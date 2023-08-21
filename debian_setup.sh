# assumes debian 12 (bookworm) from windows store
function add_deb_src () {
	sudo echo 'deb-src https://deb.debian.org/debian bookworm main' >> /etc/apt/sources.list
	sudo apt update
}
function install_basic () {
	sudo apt-get install ca-certificates build-essential wget curl git gpg
}

# windows terminal/wsl terminfo
function add_terminfo () {
	sudo apt-get install ncurses-term
	tic -sx wt.term
}

# shell settings
function shell_config () {
	gcc -O3 __git_branch.c -o ~/.__git_branch
	cp .bashrc ~/.bashrc
	cp .bash_aliases ~/.bash_aliases

	cp .nanorc ~/.nanorc
}

# build emacs from source
function install_emacs_29 () {
	mkdir src; cd src
	wget http://mirrors.ibiblio.org/gnu/emacs/emacs-29.1.tar.xz
	tar -xf emacs-29.1.tar.xz
	cd emacs-29.1
	sudo apt-get install zlib1g-dev libgccjit-12-dev libgnutls28-dev libjansson-dev libtree-sitter-dev libncurses-dev pkgconf
	sudo apt-get install pkgconf libxml2 libgccjit0 libjansson4 libtree-sitter0
	# we may also want to patch docs destination directories for debian according to
	# https://sources.debian.org/patches/emacs/1:28.2%2B1-15/0001-Prefer-usr-share-info-emacs.patch/
	./configure --enable-link-time-optimization --with-native-compilation=yes --without-x --with-x-toolkit=no --without-xft --without-lcms2 --without-rsvg --without-jpeg --without-gif --without-tiff --without-png --without-toolkit-scroll-bars --without-xaw3d --without-cairo --with-sound=no --with-xml2 --with-tree-sitter --without-x
	make
	sudo make install
	# clean up after emacs install
	make clean
	sudo apt-get autoremove libgnutls28-dev libxml2-dev libjansson-dev libtree-sitter-dev libncurses-dev zlib1g-dev libgccjit-12-dev
	cd ..
	rm -rf emacs-29.1*
	cd ..

	cp -r .emacs.d ~/.emacs.d
}

# install micromamba
function install_micromamba () {
	curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
	./bin/micromamba shell init -s bash -p ~/micromamba
	source ~/.bashrc
}

# install nextflow
function install_nextflow () {
	# adoptium temurin/openjdk
	sudo apt install apt-transport-https
	wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
	echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
	sudo apt update
	# adoptium-ca-certificates alsa-topology-conf alsa-ucm-conf fonts-dejavu-extra java-common libasound2 libasound2-data libxi6 libxrender1 libxtst6 p11-kit p11-kit-modules temurin-17-jdk x11-common
	sudo apt install temurin-17-jdk
	wget -qO- https://get.nextflow.io | bash
	chmod +rx nextflow
	sudo mv nextflow /usr/local/bin
	# note: nextflow self-update won't work because /usr/local/bin is restricted and if we run as su we change nextflow bin permissions
}

#add_deb_src
#install_basic
#add_terminfo
#shell_config
#install_emacs_29
#install_micromamba
install_nextflow
