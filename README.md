# Dotfiles

## Requirements

+ ansible
+ git

## Install on fresh Debian

```
git clone git@github.com:justuswilhelm/dotfiles "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
printf "[debian]\nlocalhost ansible_connection=local" > ansible/hosts
ansible-playbook ansible/site.yml -i ansible/hosts -l debian -e git_email=$YOUR_EMAIL
```
