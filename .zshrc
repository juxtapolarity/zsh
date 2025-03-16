# Add folders to PATH
export PATH="$HOME/bin:$HOME/local/bin:$HOME/.fzf/bin:$PATH"

# Define two history files
HISTORY_FILE1="$HOME/.zsh_history"
HISTORY_FILE2="$HOME/.zsh_history_viax"

# Create a function to switch history files
switch_history() {
    if [[ $1 == "1" ]]; then
        export HISTFILE=$HISTORY_FILE1
        echo "Switched to history file 1: $HISTORY_FILE1"
    elif [[ $1 == "2" ]]; then
        export HISTFILE=$HISTORY_FILE2
        echo "Switched to history file 2: $HISTORY_FILE2"
    else
        echo "Usage: switch_history 1|2"
    fi
}

# Set the default history file
HISTFILE=$HISTORY_FILE1

# HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
setopt NO_BEEP
set visualbell

# Append to the history file, don't overwrite it
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE

# Enable true color support
export COLORTERM=truecolor

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# zoxide
eval "$(zoxide init zsh)"

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats 'on branch %b '

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_}> '

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jux/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jux/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jux/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jux/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias for navigation
alias cdp='cd ~/repos/PORTAL'

# Plugins
plugins=(
    git
    you-should-use
)

# Zsh configuration
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bind keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Use custom Oh-My-Posh theme
eval "$(oh-my-posh init zsh --config ~/.config/.poshthemes/jux.omp.json)"

# Memory overview for all users
alias memuser="ps aux --sort=-%mem | awk 'NR==1{print \$1, \$4\"%\", \$6/1024 \"MB\"} {user[\$1]+=\$6} END {for (i in user) print i, user[i]/1024 \"MB\"}' | sort -k2 -hr"

# Define the search_directory function
search_directory() {
    local selectedDir=$(find . -type d 2> /dev/null | fzf)
    if [ -n "$selectedDir" ]; then
        LBUFFER+="$selectedDir"
    fi
}

# Create a zle widget
zle -N search_directory

# Bind Ctrl-D to the search_directory widget
bindkey '^D' search_directory

# adsf - a tool version manager. For proton-ge.
. "$HOME/.asdf/asdf.sh"

# wezterm
alias wezterm='flatpak run org.wezfurlong.wezterm'

# Alias to open all images recursively in a folder with nsxiv
# alias img='find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | nsxiv -i -'
alias img='find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0 | xargs -0 nsxiv -i'

# Alias to take one image from each folder in the current directory, and put it
# into nsxiv.
alias thumb="zsh ~/thumbnails.sh"

if [ -e /home/jux/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jux/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
