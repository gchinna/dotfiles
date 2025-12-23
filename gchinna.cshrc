# startup script setup for cshrc

# add user scripts paths when exists
# tools/bin
if ( -d ~/tools/bin ) then
    setenv PATH "$HOME/tools/bin:$PATH"
endif

# bin
if ( -d ~/bin ) then
    setenv PATH "$HOME/bin:$PATH"
endif

# scripts
if ( -d ~/scripts ) then
    setenv PATH "$HOME/scripts:$PATH"
endif

source $HOME/dotfiles/gchinna.aliases.csh


# functions
# ref: https://shinglyu.com/web/2018/12/25/counting-your-contribution-to-a-git-repository.html
# git commit line stats for your commits (no merges)
alias mystats 'git log --author="`whoami`" --pretty=tformat: --numstat --no-merges | awk '\''$1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ {inserted+=$1; deleted+=$2; delta+=$1-$2} END {ratio=(inserted?deleted/inserted:0); printf "Commit stats:\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", inserted, deleted, delta, ratio }'\'''


# find file
alias ff 'echo "Finding file: \!:1 ..."; \find . -type f -name "\!:1"'

# find dir
alias fd 'echo "Finding dir: \!:1 ..."; \find . -type d -name "\!:1"'

# find link
alias fl 'echo "Finding link: \!:1 ..."; \find . -type l -name "\!:1"'


# grep for matching pattern recursively
alias gp 'echo "Finding pattern: \!:1 ..."; grep -r "\!:1" .'



# ffg: find files with matching pattern
alias ffg 'echo "Finding files: \!:1 with pattern: \!:2 ..."; \
\find . -name "\!:1" -type f -exec grep "\!:2" {} \; -print'


# ffrm: find and remove files
alias ffrm 'echo "Finding files: \!:1 and remove ..."; \
\find . -name "\!:1" -type f -print -ok rm {} \;'


# ff1*m/g: find files by size
alias ff10m  'echo "Finding files with size >10MB ...";  \find "\!:1" -type f -size +10M'
alias ff100m 'echo "Finding files with size >100MB ..."; \find "\!:1" -type f -size +100M'
alias ff1g   'echo "Finding files with size >1GB ...";   \find "\!:1" -type f -size +1G'
alias ff10g  'echo "Finding files with size >10GB ...";  \find "\!:1" -type f -size +10G'
alias ff50g  'echo "Finding files with size >50GB ...";  \find "\!:1" -type f -size +50G'
alias ff100g 'echo "Finding files with size >100GB ..."; \find "\!:1" -type f -size +100G'


# du entries in GB only
alias dug '\du "\!:1" -sh | grep "G[[:space:]]"'
# du sorted by size (human-readable, reverse)
alias dusort '\du "\!:1" -sh | sort -rh'


### mail single file as attachment
#alias mail2me   '\mail -a \!* -s "see attachment" ${MY_EMAIL} < /dev/null'
### mail multiple attachments using multiple -a switches: eg: mailm2me  -a file1 -a file2
#alias mailm2me   '\mail \!* -s "see attachment" ${MY_EMAIL} < /dev/null'
