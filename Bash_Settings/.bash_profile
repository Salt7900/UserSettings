function sourceFiles() {
  # get machine specific vars
  local bash_profile_directory=$(dirname $(realpath ~/.bash_profile))
  local machine_directory=$bash_profile_directory/machine-specific/*
  for f in $machine_directory; do
    source $f
  done
  # load git completion
  source $bash_profile_directory/.git-completion.bash
  source $bash_profile_directory/.git-shortcuts
}

#RUBY
# Load RVM into a shell session *as a function*
# Path for RVM
test -d "$HOME/.rvm" && export PATH="$PATH:$HOME/.rvm/bin"
if [ -f ~/.profile ]; then
  source ~/.profile
fi

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node/NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Postgres Command Line tools
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# Path for brew on X86
test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
# Path for brew on apple silicon
test -d /opt/homebrew/bin && export PATH="/opt/homebrew/bin:$PATH"
export PATH=$PATH:~/bin

# Machine Specific && git-completion
sourceFiles

# A more colorful prompt
# \[\e[0m\] resets the color to default color
c_reset='\[\e[0m\]'
c_path='\[\e[0;31m\]'
path_green='\[\e[0;32m\]'
path_red='\[\e[0;31m\]'

# PS1 is the variable for the prompt you see everytime you hit enter
PROMPT_COMMAND=$PROMPT_COMMAND' PS1="${c_path}\W${c_reset}$(git_prompt) :> "'

export PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(git_prompt)\[\033[0m\]:> '

# determines if the git branch you are on is clean or dirty
git_prompt ()
{
  # Is this a git directory?
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  # Grab working branch name
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  # Clean or dirty branch
  if git diff --quiet 2>/dev/null >&2; then
    git_color="${path_green}"
  else
    git_color=${path_red}
  fi
  echo -e " [$git_color$git_branch${c_reset}]"
}

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=always'

alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias c="clear"
alias ls='ls -Gh'
alias lsa="ls -a"
alias lsla="ls -la"

# alias for accessing docker containers
alias dlf="docker logs --follow"
alias da="docker exec -it $1 bash"
alias dockerkillall="docker kill $(docker ps -q)"
alias df="docker restart"
