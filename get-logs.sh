#!/usr/bin/env bash
echo " "
echo "This script will collect all files with an ending like *.log, *.out or *.txt out of /var/log.  You will need Root permissions to run this properly."
echo "checking if $HOME/post_incident_logs exits, if so empting it, if not creating it"
echo " "
[ ! -d $HOME/post_incident_logs/ ] && mkdir -p $HOME/post_incident_logs
[ -d $HOME/post_incident_logs/ ] && rm -r $HOME/post_incident_logs/*
DIRECTORY="$HOME/post_incident_logs/"
TIME=$(date)
HOSTNAME=$(hostname)

#find /var/log/ -type f \( -name "*.log" -or -name "*.out" -or -name "*.txt" \) -exec ls -lha {} \; |awk '{ print $5 " "$9 }'|sort -h
TOTAL=$(find /var/log/ -type f \( -name "*.log" -or -name "*.out" -or -name "*.txt" \) -exec ls -la {} \; |awk '{ sum=sum+$5 } END { print (sum/1024)/1024 " MB" } ')
echo " "
echo "Total size of logs: $TOTAL. Please ensure this is will not overfill the disk."
echo "Copy the logs to $DIRECTORY. Sure to proceed? [y/n]:"
read key
if [ $key = "y" ];
then
  find /var/log/ -type f \( -name "*.log" -or -name "*.out" -or -name "*.txt" \) -exec cp --parents {} "$DIRECTORY" \;
else
  echo "EXIT"
  exit 1
fi
echo "Want to Zip the logs and sent them via Mail? [y/n]"
read key
if [ $key = "y" ];
then
  zip -r logs.zip $DIRECTORY >/dev/null
else
  echo "EXIT"
  exit 1
fi
#echo "Want a Mail with the zip file? [y/n]"
#read key
#if [ $key = "y" ];
#then
 # swaks --to t.gruen@tafmobile.de --attach logs.zip --header "Subject: Logs zur Störung auf $HOSTNAME am $TIME" --body " " >/dev/null
#else
#  echo "EXIT"
#  exit 1
#fi
