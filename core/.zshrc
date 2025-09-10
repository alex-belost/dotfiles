# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export XDG_CONFIG_HOME="$HOME/.config"
export WARP_THEMES_DIR="$HOME/.warp/themes"

export NVM_DIR=~/.nvm
export PATH=$PATH:~/go/bin
export GPG_TTY=$(tty)

export GOOGLE_CLOUD_PROJECT="spry-bus-464206-m5"

source $(brew --prefix nvm)/nvm.sh

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Aliases
alias lvim!="sudo NVIM_APPNAME=LazyVim nvim"
alias cvim!="sudo NVIM_APPNAME=NvChad nvim"
alias lvim="NVIM_APPNAME=LazyVim nvim"
alias cvim="NVIM_APPNAME=NvChad nvim"
alias avim="NVIM_APPNAME=AstroNvim nvim"
alias lg="lazygit"
alias z="zoxide"
alias ls='eza'
alias e='lvim'
alias c='clear'

# Aliases paths
alias core/web="cd ~/Projects/trisk/core/web/"
alias landing="cd ~/Projects/trisk/landing/"


# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
# bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

bindkey -v
bindkey ^P history-incremental-search-backward 
bindkey ^N history-incremental-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

function e() {
    local config="default"
    local default_ide="LazyVim"
    local items=( "default" "LazyVim" "AstroNvim" )

    local is_forse=$([[ "$1" = "-f" ]]; echo $?)
    local is_forse_search=$([[ "$1" = "-fs" ]]; echo $?)
    local is_search=$([[ "$1" = "-s" ]]; echo $?)

    if [[ $is_forse == 0 || $is_search == 0 || $is_forse_search == 0 ]] then
        shift
    fi

    if [[ $is_search != 0 && $is_forse_search != 0 ]]; then
        config=$default_ide
    else
        config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Configs 󱈇  " --height=~50% --layout=reverse --border --exit-0)

        if [[ -z $config ]]; then
            echo "Nothing selected"
            return 0
        elif [[ $config == "default" ]]; then
            config=""
        fi
    fi

    if [[ $is_forse == 0 || $is_forse_search == 0 ]] then
        sudo NVIM_APPNAME=$config nvim $@
    else
        NVIM_APPNAME=$config nvim $@
    fi
}
