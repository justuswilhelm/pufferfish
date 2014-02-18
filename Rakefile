require 'rake'
task :default => ["install"]

desc "Installs dotfiles"
task :install do
	unless `ps -p $$`.match /zsh/
		puts "Changing to zsh"
		system %Q{chsh -s $(which zsh)}
	end

	puts "Creating temp and swap folder for vim"
	system %Q{mkdir $PWD/vim/backup}
	system %Q{mkdir $PWD/vim/swap}

	puts "Creating Symbolic Links"
	puts ".vimrc"
	system %Q{ln -sf $PWD/vimrc ~/.vimrc}

	puts ".vim/"
	system %Q{ln -sf $PWD/vim ~/.vim}
	puts ".zshrc"
	system %Q{ln -sf $PWD/zshrc ~/.zshrc}
	
	bundleclean
	bundleinstall
end

task :cleanup do
	bundleclean
	bundleinstall
end

def bundleclean
	puts "Cleaning up bundle repositories"
	system %Q{rm -rf $PWD/vim/bundle}

	puts "Getting newest vundle"
	system %Q{git clone https://github.com/gmarik/vundle.git $PWD/vim/bundle/vundle}
end

def bundleinstall
	puts "Pulling All Bundles"
	system %Q{git submodule foreach git pull}

	puts "Bundle Install"
	system %Q{vim +BundleInstall +qall}
end
