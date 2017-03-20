function git_hash
	git log -n 1 --pretty=format:"%H"
end
