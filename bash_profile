# sets up custom prompt
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "

# activates colors
export CLICOLOR=1

# ls custom colors
export LSCOLORS=ExFxBxDxCxegedabagacad


# activates tab completion for homebrew
source `brew --repository`/Library/Contributions/brew_bash_completion.sh

# activates tab completion for git
source ~/bin/git-completion.bash

# correctly sets the $PATH so tools installed by homebrew get loaded correctly
export PATH=/usr/local/bin:$PATH

# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Quickly navigate the filesystem using new jump and mark functions.
# To add a new bookmark, cd into the directory and mark it with a name.
export MARKPATH=$HOME/.marks
function jump { 
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Adds tab completion for jump and unmark functions
_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark

# Function for transfer.sh
transfer() { curl --upload-file $1 https://transfer.sh/$(basename $1); }
alias transfer=transfer
