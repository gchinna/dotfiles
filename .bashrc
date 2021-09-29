# only load it if `-n` succeeds ...
if $BASH -n "$HOME/work_bashrc.sh" >& /dev/null
then
    printf "sourcing $HOME/work_bashrc.sh ...\n" >&2
    source ~/work_bashrc.sh
else
    printf "Error in $HOME/work_bashrc.sh; not sourcing it!\n" >&2
fi

# user scripts path
export PATH=~/tools/bin:${PATH}

# customize shell prompt
#export PS1='$(whoami)@$(hostname) $(pwd) '
export PS1='\[\033[02;32m\]$(pwd)\n\[\033[00m\]${PWD/*\//} \# $ '

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX stat options seem different 
    # skip PROMPT_COMMAND hook for now.
    echo "skip PROMPT_COMMAND for Mac OSX ..."
else
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
              printf "sourcing $HOME/.bashrc ...\n" >&2
              source "$HOME/.bashrc"
          else
              printf "Error in $HOME/.bashrc; not sourcing i!t\n" >&2
          fi
          # ... but update the timestamp regardless
          _bashrc_timestamp=$(stat -c %Y "$HOME/.bashrc")
          work_bashrc_timestamp=$(stat -c %Y "$HOME/work_bashrc.sh")
        fi
    }
    
    PROMPT_COMMAND='_prompt_command'
fi



# aliases
## unix/shell
alias h="history"
alias c="clear"
alias rmr="rm -r"
## ls aliases
alias l="ls --color=auto"
alias lr="ls -rtlh --color=auto"
alias ll="ls -lhA --color=auto"
alias lsl="ls -lhA --color=auto"
alias lld="ls -lhAd --color=auto"
alias lsld="ls -lhAd --color=auto"
## du aliases
alias dug       '\du \!* -sh | grep "G[[:space:]]"'
alias dusort    '\du \!* -sh | sort -rh'
## wc aliases
alias wcl       '\wc -l'
## grep aliases
alias grep      '\grep --color=auto'
alias egrep     '\egrep --color=auto'
alias zgrep     '\zgrep --color=auto'
alias zegrep    '\zegrep --color=auto'
alias xzgrep    '\xzgrep --color=auto'
alias xzegrep   '\xzegrep --color=auto'
## find aliases
alias findf     '\find \!* -type f'
alias findd     '\find \!* -type d'
alias findl     '\find \!* -type l'
alias findf10m  '\find \!* -type f -size +10M'
alias findf100m '\find \!* -type f -size +100M'
alias findf10g  '\find \!* -type f -size +10G'
alias findf50g  '\find \!* -type f -size +50G'
alias findf100g '\find \!* -type f -size +100G'


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

## OS specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then # Mac OSX
    source ~/.aliases_osx
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
    echo "no linux-gnu specific aliases"
elif [[ "$OSTYPE" == "cygwin" ]]; then # POSIX compatibility layer and Linux environment emulation for Windows
    echo "no cygwin specific aliases"
elif [[ "$OSTYPE" == "msys" ]]; then # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    echo "no MinGW specific aliases"
elif [[ "$OSTYPE" == "win32" ]]; then # I'm not sure this can happen.
    echo "no win32 specific aliases"
elif [[ "$OSTYPE" == "freebsd"* ]]; then  # freebsd
    echo "no freebsd specific aliases"
else # Unknown.
    echo "Unknown ostype=$OSTYPE!"
fi

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
