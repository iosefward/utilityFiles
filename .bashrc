source ~/utilityFiles/qstatFunctions.sh

alias ll='ls -lah'
alias lt='ls -ltrh'
alias vi='vim'
alias qme='qstat -u $(whoami)'
alias qless="qstat -u '*' |less"
alias qj='qstat -j'

alias qwa='watch -n 60 qstat -u gsupipe-x'
alias cluster='ssh jw279@marvin.st-andrews.ac.uk'

export MARKPATH=$HOME/.marks
function jump { 
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark { 
    rm -i $MARKPATH/$1 
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

#historyLogging
HOSTNAME="$(hostname)" 
HOSTNAME_SHORT="${HOSTNAME%%.*}"
HISTFILE="${HOME}/.history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"

