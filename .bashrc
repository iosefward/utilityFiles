source ~/utilityScripts/qstatFunctions.sh

alias ll='ls -lah'
alias lt='ls -ltrh'
alias checkRuns='sh ~/bin/runAlert.sh'
alias vi='/sw/opt/bin/vim'
alias qme='qstat -u gsupipe-x'
alias qless="qstat -u '*' |less"
alias qj='qstat -j'

#for Chris' analysis stuff in analysis/exomeAnalysis/
PERL5LIB="/homes/gsupipe-x/perl-lib/share/perl5:/sw/opt/lib/bcl2fastq-1.8.4/perl:/sw/perl/5.10/lib/perl5:/sw/perl/5.10/lib/perl5/x86_64-linux-thread-multi:/homes/ccole/lib"
export PERL5LIB

export R_LIBS="/homes/gsupipe-x/r-lib"

alias galaxystop='sh ~/galaxy/galaxy-dist/run.sh --stop-daemon'
#alias galaxystart='sh ~/galaxy/galaxy-dist/run.sh --log-file=/homes/gsupipe-x/galaxy/galaxy-dist/logFile'
alias galaxystart='sh ~/galaxy/galaxy-dist/run.sh --daemon --log-file=/homes/gsupipe-x/galaxy/galaxy-dist/logFile'
alias misostart='JAVA_OPTS="$JAVA_OPTS -Dsecurity.method=jdbc -Xmx768M" ~/miso/tomcat7/bin/startup.sh'
alias eclipe='vim -w ~/.vimlog "$@"'
alias qwa='watch -n 60 qstat -u gsupipe-x'

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
