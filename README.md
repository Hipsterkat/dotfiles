<div align="center">

<img src="https://raw.githubusercontent.com/Hipsterkat/dotfiles/main/nixos.png" width="200" />

<br/>

[![Static Badge](https://camo.githubusercontent.com/da30b5ea9ba12bc7a6a400f7b6d085d9457c9d4367a95881a2f99d23a70cc9b6/68747470733a2f2f696d672e736869656c64732e696f2f7374617469632f76313f6c6162656c3d487970726c616e64266d6573736167653d537461626c65267374796c653d666c6174266c6f676f3d687970726c616e6426636f6c6f72413d32343237334126636f6c6f72423d384141444634266c6f676f436f6c6f723d434144334635)](https://nixos.org)
![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue?style=flat&logo=nixos&logoColor=white)
</div>

```
# ~/.config/bash/bashrc
# Bash-specific configuration

# Starship configuration
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init bash)"

eval "$(thefuck --alias)"

# Source the central configuration
if [ -f ~/.config/shell.env ]; then
    source ~/.config/shell.env
fi

# Bash-specific settings
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Bash-specific prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# Bash-specific aliases
alias bashconfig='$EDITOR ~/.config/bash/bashrc'
alias rebuild='sudo nixos-rebuild switch --flake ~/Documents/Dotfiles/hosts/legion/home-manager#legion'
alias clean='nix-collect-garbage; nix-collect-garbage -d'
alias config='code ~/Documents/Dotfiles/configuration.nix'


alias commit='git add . & git commit -m "Add files from host" & git pull origin main --rebase & git push origin main'

```

