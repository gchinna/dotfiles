# startup script setup for both bash and zsh

## only load it if `-n` succeeds ...
#if $BASH -n "$HOME/work_bashrc.sh" >& /dev/null
#then
#    printf "sourcing $HOME/work_bashrc.sh ...\n" >&2
#    source ~/work_bashrc.sh
#else
#    printf "Error in $HOME/work_bashrc.sh; not sourcing it!\n" >&2
#fi

# add user scripts paths when exists
if [[ -d ~/tools/bin ]] ; then
    export PATH=~/tools/bin:${PATH}
fi
if [[ -d ~/bin ]] ; then
    export PATH=~/bin:${PATH}
fi
if [[ -d ~/scripts ]] ; then
    export PATH=~/scripts:${PATH}
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX stat options seem different 
    # skip PROMPT_COMMAND hook for now.
    echo "skip PROMPT_COMMAND for Mac OSX ..."
else
    # customize shell prompt
    #export PS1='$(whoami)@$(hostname) $(pwd) '
    export PS1='\[\033[02;32m\]$(pwd)\n\[\033[00m\]${PWD/*\//} \# $ '

    # use bash's PROMPT_COMMAND hook to auto-source .bashrc whenever modified.
    _prompt_command() {
        # initialize the timestamp, if it isn't already
        _bashrc_timestamp=${_bashrc_timestamp:-$(stat -c %Y "$HOME/.bashrc")}
        # work_bashrc_timestamp=${work_bashrc_timestamp:-$(stat -c %Y "$HOME/work_bashrc.sh")}
    
        # if it's been modified, test and load it
        # if [[ $(stat -c %Y "$HOME/.bashrc") -gt $_bashrc_timestamp || $(stat -c %Y "$HOME/work_bashrc.sh") -gt $work_bashrc_timestamp ]]
        if [[ $(stat -c %Y "$HOME/.bashrc") -gt $_bashrc_timestamp ]]
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
          # work_bashrc_timestamp=$(stat -c %Y "$HOME/work_bashrc.sh")
        fi
    }
    
    PROMPT_COMMAND='_prompt_command'
fi


source $HOME/dotfiles/gchinna.aliases


## OS specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then # Mac OSX
    source $HOME/dotfiles/gchinna.aliases_osx
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
    :
    # echo "no linux-gnu specific aliases"
elif [[ "$OSTYPE" == "cygwin" ]]; then # POSIX compatibility layer and Linux environment emulation for Windows
    :
    # echo "no cygwin specific aliases"
elif [[ "$OSTYPE" == "msys" ]]; then # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    :
    # echo "no MinGW specific aliases"
elif [[ "$OSTYPE" == "win32" ]]; then # I'm not sure this can happen.
    :
    # echo "no win32 specific aliases"
elif [[ "$OSTYPE" == "freebsd"* ]]; then  # freebsd
    :
    # echo "no freebsd specific aliases"
else # Unknown.
    echo "Unknown ostype=$OSTYPE!"
fi


# functions
# ref: https://shinglyu.com/web/2018/12/25/counting-your-contribution-to-a-git-repository.html
mystats(){
    git log --author="`whoami`" --pretty=tformat: --numstat --no-merges | grep -v '^-' | awk '{inserted+=$1; deleted+=$2; delta+=$1-$2; ratio=deleted/inserted} END {printf "Commit stats:\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", inserted, deleted, delta, ratio }'
}

# find file
ff(){
	echo Finding file: "$1" ...
	\find . -type f -name "$1"
}

# find dir
fd(){
	echo Finding file: "$1" ...
	\find . -type d -name "$1"
}

# find link
fl(){
	echo Finding file: "$1" ...
	\find . -type l -name "$1"
}
# grep for matching pattern recursively
gp(){
	echo Finding pattern: "$1" ...
	grep -r "$1" .
}

# ffg: find files with matching pattern 
# print the file name after the matching lines.
ffg(){
	echo Finding files: "$1" with pattern: "$2" ...
	\find . -name "$1" -type f -exec grep "$2" {} \; -print 
}


# ffg: find and remove files with matching pattern 
ffrm(){
	echo Finding files: "$1" and remove ...
	\find . -name "$1" -type f -print -exec rm {} \;
}

# ff1*m/g: find files by size
ff10m() {
	echo "Finding files with size >10MB ..."
    \find "$1" -type f -size +10M
}
ff100m() {
	echo "Finding files with size >100MB ..."
    \find "$1" -type f -size +100M
}
ff1g() {
	echo "Finding files with size >1GB ..."
    \find "$1" -type f -size +1G
}
ff10g() {
	echo "Finding files with size >10GB ..."
    \find "$1" -type f -size +10G
}
ff50g() {
	echo "Finding files with size >50GB ..."
    \find "$1" -type f -size +50G
}
ff100g() {
	echo "Finding files with size >100GB ..."
    \find "$1" -type f -size +100G
}


## du aliases - bash aliases dont accept args
function dug() {
  \du "$1" -sh | grep "G[[:space:]]"
}
function dusort() {
  \du "$1" -sh | sort -rh
}


### mail single file as attachment
#alias mail2me   '\mail -a \!* -s "see attachment" ${MY_EMAIL} < /dev/null'
### mail multiple attachments using multiple -a switches: eg: mailm2me  -a file1 -a file2
#alias mailm2me   '\mail \!* -s "see attachment" ${MY_EMAIL} < /dev/null'
