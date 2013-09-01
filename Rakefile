require 'rake'
task :default => ["install"]

desc "Installs dotfiles"
task :install do
	puts "Creating Symbolic Links"
	puts ".vimrc"
	system %Q{ln -s ./vimrc ~/.vimrc}

	puts ".vim/"
	system %Q{ln -s vim ~/.vim}
	puts ".zshrc"
	system %Q{ln -s oh-my-zsh/zshrc ~/.zshrc}
end
