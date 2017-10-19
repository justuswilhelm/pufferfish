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

## Install on macOS

Make sure to install
- Homebrew: [https://brew.sh/](https://brew.sh/), and
- Ansible: [https://www.ansible.com/](https://www.ansible.com/) by running

```
brew install ansible
```

Then, run the following in your terminal

```
git clone git@github.com:justuswilhelm/dotfiles "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
printf "[darwin]\nlocalhost ansible_connection=local" > ansible/hosts
ansible-playbook ansible/site.yml -i ansible/hosts -l darwin -e git_email=$YOUR_EMAIL
```
