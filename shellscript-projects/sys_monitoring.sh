#!/bin/bash
#

#Create Variable 

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80


#Notification Variable

Email="puneethkumar482000@gmail.com"
WEBHOOK="https://hooks.slack.com/services/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"

#Set HostName and Date 
#
HOSTNAME=$(hostname)
DATE=$(date +"%Y-%m-%D-%H-%M")

#Using Command we will get the metric information of the OS

CPU_USEAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
MEM_USEAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
DISK_USEAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//g')


ALERT="SYSTEM HEALTH ALERT FOR HOST $HOSTNAME ON DATE: $DATE
CPU_USEAGE: ${CPU_USEAGE}%
MEM_USEAFE: ${MEM_USEAGE}%
DISK_USEAGE: ${DISK_USEAGE}%
"

if [ $CPU_USEAGE -gt $CPU_THRESHOLD ]; then 
	echo "$AlERT" | mail -s "CPU Alert on $HOSTNAME" $Email 
	curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$ALERT\"}" "$WEBHOOK"
fi


	
if [ $MEM_USEAGE -gt $MEM_THRESHOLD ]; then 
	echo "$ALERT" | mail -s "Memory Alert on $HOSTNAME" $Email
	curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$ALERT\"}" "$WEBHOOK"
fi

if  [ $DISK_USEAGE -gt $DISK_THRESHOLD ]; then 
	echo "$ALERT" | mail -s "DISK USEAGE IS FULL ON $HOSTNAME" $Email
	curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$ALERT\"}" "$WEBHOOK"
fi



echo "HEALTH CHECK COMPLETED FOR HOST $HOSTNAME ON $DATE"



