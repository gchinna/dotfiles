# wc
alias wcl 'command wc -l'

# grep (bypass any existing alias via leading command 
alias grep   'command grep --color=auto'
alias egrep  'command egrep --color=auto'
alias zgrep  'command zgrep --color=auto'
alias zegrep 'command zegrep --color=auto'
alias xzgrep 'command xzgrep --color=auto'
alias xzegrep 'command xzegrep --color=auto'

# gvim
alias g   'gvim'
alias gv  'gvim'
alias gvi 'gvim -p'

# cd
alias ..   'cd ..'
alias ...  'cd ../../'
alias .... 'cd ../../../'

# ps
alias simjob 'ps -ef | grep simv | grep `whoami`'
alias remote 'ps -ef | grep `whoami` | grep X11'

# git
alias gits  'git status . -unormal'                 # status in current dir
alias gitst 'git status -unormal'                   # status at repo root (git decides)
alias gitsm 'git status . -unormal | grep modified' # modified only
alias gita  'git add'
alias gitc  'git commit'
alias gitd  'git diff'
alias gitp  'git pull'
alias gith  'git rev-parse HEAD'

