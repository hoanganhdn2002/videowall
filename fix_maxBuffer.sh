#!/bin/bash
WHOAMI=$(whoami)
count=0
time=30
CHECK_TIME="/home/$WHOAMI/time.txt"
if [ -f ${CHECK_TIME} ]; then
		echo "Nothing"
			else
				echo -ne "3" > time.txt
fi
time=$(sed '3d' time.txt)
# Define function
function videowall_fix_crash() {
    if [ -z "$CHECK_VIDEOWALL_FIX_CRASH" ]; then
		killall node 
		sleep 1
		kill $(ps xua | grep monitoring.sh  | grep -v grep | awk '{print $2}' ORS=' ')
		sleep 1
		killall mpv feh
		sleep 1
		tmux send-keys -t videowall:0 "DISPLAY=:0.0 /home/$WHOAMI/videowall_fix_crash.sh" C-m
		sleep 30
	fi
}
# End define function
while true
do
		CHECK_VIDEOWALL_FIX_CRASH=$(pgrep -f "/bin/bash ./videowall_fix_crash.sh")	
		monitoring=$(ps xua | grep -v grep | grep -v "/bin/sh" | grep "bash monitoring.sh" | wc -l)
		# videowall_fix_crash
		if [ $monitoring -eq 0 ]; then
			killall node
			killall ffplay 
			killall feh
			sleep 30
                else
	                         if [ $count -eq 0 ]; then
	                				echo "First time! "
	                				count=$(($count+1))
	                        	elif [ $count -eq $time ]; then
	                                count=1
	                        	else
	                                count=$(($count+1))
	                        fi
	                    sleep 1
                        echo "$count "
        fi

done
