source ~/work_bashrc.sh

# user scripts path
export PATH=~/tools/bin:${PATH}

# customize shell prompt
#export PS1='$(whoami)@$(hostname) $(pwd) '
export PS1='\[\033[02;32m\]$(pwd)\n\[\033[00m\]${PWD/*\//} \# $ '

# use bash's PROMPT_COMMAND hook to auto-source .bashrc whenever modified.
_prompt_command() {
    # initialize the timestamp, if it isn't already
    _bashrc_timestamp=${_bashrc_timestamp:-$(stat -c %Y "$HOME/.bashrc")}
    # if it's been modified, test and load it
    if [[ $(stat -c %Y "$HOME/.bashrc") -gt $_bashrc_timestamp ]]
    then
      # only load it if `-n` succeeds ...
      if $BASH -n "$HOME/.bashrc" >& /dev/null
      then
          source "$HOME/.bashrc"
          printf "sourcing $HOME/.bashrc ...\n" >&2
      else
          printf "Error in $HOME/.bashrc; not sourcing it\n" >&2
      fi
      # ... but update the timestamp regardless
      _bashrc_timestamp=$(stat -c %Y "$HOME/.bashrc")
    fi
}

PROMPT_COMMAND='_prompt_command'



# aliases
## unix/shell
alias h="history"
alias l="ls --color=auto"
alias lr="ls -rtlh --color=auto"
alias ll="ls -lhA"
alias c="clear"
alias rm="rm -r"
## gvim
alias g="gvim -geometry 100x60+500+500"
alias gvi="gvim -p"
## cd
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
## ps
alias simjob="ps -ef | grep simv | grep `whoami`"
alias remote="ps -ef | grep `whoami` | grep X11"
## git
alias gitsm="git status . | grep modified"
alias gitp="git pull"


# functions
mystats(){
    git log --author="`whoami`" --pretty=tformat: --numstat --no-merges | awk '{inserted+=$1; deleted+=$2; delta+=$1-$2; ratio=deleted/inserted} END {printf "Commit stats:\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", inserted, deleted, delta, ratio }'
}

## find file
ff(){
	echo Finding file: "$1" ...
	find . -type f -name "$1"
}

## find dir
fd(){
	echo Finding file: "$1" ...
	find . -type d -name "$1"
}

gp(){
	echo Finding pattern: "$1" ...
	grep -r "$1" .
}

ffg(){
	echo Finding files: "$1" with pattern: "$2" ...
	find . -name "$1" -type f -print -exec grep "$2" {} \;
}


ffrm(){
	echo Finding files: "$1" and remove ...
	find . -name "$1" -type f -print -exec rm {} \;
}
