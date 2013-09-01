require 'rake'
task :default => ["install"]

desc "Installs dotfiles"
task :install do
	puts "Creating Symbolic Links"
	puts ".vimrc"
	system %Q{ln -sf $PWD/vimrc ~/.vimrc}

	puts ".vim/"
	system %Q{ln -sf $PWD/vim ~/.vim}
	puts ".zshrc"
	system %Q{ln -sf $PWD/oh-my-zsh/zshrc ~/.zshrc}

	puts "Pulling All Bundles"
	system %Q{git submodule foreach git pull}

	puts "Bundle Install"
	system %Q{vim +BundleInstall +qall}
end
