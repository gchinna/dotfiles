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
    work_bashrc_timestamp=${work_bashrc_timestamp:-$(stat -c %Y "$HOME/work_bashrc.sh")}

    # if it's been modified, test and load it
    if [[ $(stat -c %Y "$HOME/.bashrc") -gt $_bashrc_timestamp || $(stat -c %Y "$HOME/work_bashrc.sh") -gt $work_bashrc_timestamp ]]
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
      work_bashrc_timestamp=$(stat -c %Y "$HOME/work_bashrc.sh")
    fi
}

PROMPT_COMMAND='_prompt_command'



# aliases
## unix/shell
alias h="history"
alias l="ls --color=auto"
alias lr="ls -rtlh --color=auto"
alias ll="ls -lhA --color=auto"
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
alias gits="git status .  -unormal"  ## git status on current directory
alias gitst="git status   -unormal"  ## git status on top of tree
alias gitsm="git status . -unormal | grep modified"  ## show only the modified files
alias gita="git add"
alias gitc="git commit"
alias gitd="git diff"
alias gitp="git pull"
alias gith="git rev-parse HEAD"


# functions
## ref: https://shinglyu.com/web/2018/12/25/counting-your-contribution-to-a-git-repository.html
mystats(){
    git log --author="`whoami`" --pretty=tformat: --numstat --no-merges | grep -v '^-' | awk '{inserted+=$1; deleted+=$2; delta+=$1-$2; ratio=deleted/inserted} END {printf "Commit stats:\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", inserted, deleted, delta, ratio }'
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

## grep for matching pattern recursively
gp(){
	echo Finding pattern: "$1" ...
	grep -r "$1" .
}

## ffg: find files with matching pattern 
## print the file name after the matching lines.
ffg(){
	echo Finding files: "$1" with pattern: "$2" ...
	find . -name "$1" -type f -exec grep "$2" {} \; -print 
}


## ffg: find and remove files with matching pattern 
ffrm(){
	echo Finding files: "$1" and remove ...
	find . -name "$1" -type f -print -exec rm {} \;
}
