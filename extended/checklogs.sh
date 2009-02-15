#!/bin/sh

## Usage: getlogs.sh [DATE [FORCE]]

proto="http"
baseurl="autobuild.pure-data.info/auto-build"

#wget_quiet_flags="-q"
#wget_quiet_flags="-nv"
wget_quiet_flags=""

logdate="$1"
test $# -gt 0 && shift
test -z "$logdate" -o "$logdate" = "-" && logdate=`date +%Y-%m-%d`

if [ $# -gt 0 ]; then
  force="$1"
  shift;
fi

##-- get full log url
logdir="${baseurl}/${logdate}/logs"
logurl="${proto}://${logdir}"

##-- get logs
if [ -d "$logdir" -a "$force" != "force" ]; then
  echo "$0: logdir $logdir exists and 'force' was not specified"
  echo "$0: NOT retrieving logs from $logurl"
else
  echo "$0: retrieving logs from $logurl to $logdir"
  wget $wget_quiet_flags -r -np -A ".html,_pd-extended_run-automated-builder.txt" "$logurl/"
fi

##-- parse logs
for logfile in ${logdir}/*_pd-extended_*.txt; do
  #echo "$0: parsing logfile $logfile"
  ./parselog.perl "$logfile" > "$logfile.moo"
done
