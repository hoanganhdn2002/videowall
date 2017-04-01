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
videowall_fix_crash() {
CHECK_VIDEOWALL_FIX_CRASH=$(pgrep -f "/bin/bash ./videowall_fix_crash.sh" | wc -l)
	if [ $CHECK_VIDEOWALL_FIX_CRASH -gt 0 ]; then
		echo "Running videowall_fix_crash"
		else
			killall node 
			sleep 1
			kill $(ps xua | grep monitoring.sh  | grep -v grep | awk '{print $2}' ORS=' ')
			sleep 1
			killall ffplay
			sleep 1
			killall mpv feh
			sleep 1
			tmux send-keys -t videowall:0 "DISPLAY=:0.0 ./videowall_fix_crash.sh" C-m
	fi
}
time=$(sed '3d' time.txt)
while true
do
		monitoring=$(pgrep -f "/bin/sh -c bash monitoring.sh" | wc -l)
		videowall_fix_crash
		if [ $monitoring -eq 0 ]; then

			killall node
			killall ffplay 
			killall feh
			sleep 5
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
