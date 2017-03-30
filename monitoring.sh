#!/bin/bash
export DISPLAY=:0.0
LAYOUT=$1
WHOAMI=$(whoami)
HOSTNAME=$(hostname)
SCRIPT="/home/$WHOAMI/monitoring.sh"
#CHECK_MOUSE="/home/$WHOAMI/mouse.sh"
PIDOF=$(pidof -x $SCRIPT)

MAIN_SUB=$(cat /home/$(whoami)/fullscreen.txt)
TOTAL_LINE_OF_FILE=$(wc -l /home/$WHOAMI/list_camera.txt | awk '{print $1}')
TOTAL_LINE_OF_FILE=`expr $TOTAL_LINE_OF_FILE + 1`
X=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3}')
Y=$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $4}')
count=$(expr $(wc -l /home/$WHOAMI/list_camera.txt | awk '{print $1}') + 1)
kill_nxserver=$(ps xua | grep -v grep | grep nxserver | awk '{print $2}')
echo "pidof: $PIDOF"
if [ "namvision.com" = "logout" ]; then
	exit 0;
fi
# xdotool windowminimize $(xdotool getactivewindow)
echo -ne "$1\c" > $HOSTNAME.layout.txt
#wget -q http://$DOMAIN/2/resolution.txt -O /home/$WHOAMI/$HOSTNAME.resolution.txt
. /home/$WHOAMI/$HOSTNAME.cctv_template.sh
. /home/$WHOAMI/$HOSTNAME.resolution.txt
. /home/$WHOAMI/$HOSTNAME.cctv_template.above.sh

# if [ -z "$resolution" ]; then
#	resolution=954:480
# fi
if [ -z "$kill_nxserver" ]; then
	echo ""
	else
		echo 'vp9' | sudo -kS service nxserver stop
fi





TIME=0
if [ ! -z $(echo "$PIDOF" | awk '{print $2}') ]; then	
	if [ "$(cat /home/$WHOAMI/$HOSTNAME.pid)" = $(echo "$PIDOF" | awk '{print $1}') ]; then
		kill -9 $(echo "$PIDOF" | awk '{print $1}')
		echo "kill $(echo "$PIDOF" | awk '{print $1}')"
	else
		echo "kill $(echo "$PIDOF" | awk '{print $2}')"
		kill -9 $(echo "$PIDOF" | awk '{print $2}')
	fi
fi
	echo "Single process"
	while true
	do
		
		wget -q http://namvision.com/.2/count.txt -O /home/$WHOAMI/$HOSTNAME.count.txt
		COUNT=$(cat /home/$WHOAMI/$HOSTNAME.count.txt)
		if [ -z "$COUNT" ]; then
			COUNT=3600
		fi


		RESULT_FFPLAY=$(ps xua | grep -v grep | grep -w ffplay)
		TOTAL_LINE_OF_FILE=$(wc -l /home/$WHOAMI/list_camera.txt | awk '{print $1}')
		TOTAL_LINE_OF_FILE=`expr $TOTAL_LINE_OF_FILE + 1`
		fontfile=$(ls /home/$WHOAMI/ | grep ".ttf")
		fontcolor=$(cat /home/$WHOAMI/font.txt | grep fontcolor | awk '{print $3}')
		fontsize=$(cat /home/$WHOAMI/font.txt | grep fontsize | awk '{print $3}')
		borderw=$(cat /home/$WHOAMI/font.txt | grep borderw | awk '{print $3}')
		shadowcolor=$(cat /home/$WHOAMI/font.txt | grep shadowcolor | awk '{print $3}')
		coordinate=$(cat /home/$WHOAMI/font.txt | grep coordinate | awk '{print $3}')
		SCRIPT1="/bin/sh -c bash monitoring.sh"
		PIDOF1=$(pgrep -f "$SCRIPT1")
		MAIN_SUB=$(cat /home/$(whoami)/fullscreen.txt)
			if [ $MAIN_SUB -eq 2 ]; then
			i=1
				while IFS='' read -r line || [[ -n "$line" ]]; do
					if [ $i -le $TOTAL_LINE_OF_FILE ]; then
						URL=$(echo "$line" | awk '{print $1}')
						PORT=$(echo "$line" | awk '{print $2}')
						# CHANNEL=$(echo "$line" | awk -F'[/chn/]+' '{print $4}')
				        CHANNEL=$(echo "$line" | awk '{for(i=4;i<=NF;i++) {printf $i ""} ; printf "-"; print $3}' | iconv -f utf8 -t ascii//TRANSLIT)
				        CHANNEL1=$(echo "$line" | awk '{for(i=4;i<=NF;i++) {printf $i " "} ; printf "\n"}')
				        echo "$URL" 1>&2
				        echo "$PORT" 1>&2
						PID_FFPLAY_CHANNEL=$(ps xua | grep -v grep | grep ffplay | grep -w $CHANNEL | awk '{print $2}')
				        GREP_CHANNEL=$(ps xua | grep -v grep | grep ffplay | grep -w $CHANNEL)
						if [ -z "$GREP_CHANNEL" ]; then
							echo "i: $i CHANNEL: $CHANNEL url: $URL"
							# ./ffplay -fflags nobuffer -loglevel -8 -window_title $CHANNEL -vf scale=$resolution $URL:$PORT &
							./ffplay -fflags nobuffer -loglevel -8 -window_title $CHANNEL -vf "scale=$resolution,drawtext=text=$CHANNEL1:fontfile=$fontfile:fontcolor=$fontcolor:fontsize=$fontsize:borderw=$borderw:shadowcolor=$shadowcolor:$coordinate" $URL:$PORT &
							/home/$WHOAMI/$HOSTNAME.cctv_template.sh &
							/home/$WHOAMI/$HOSTNAME.cctv_template.above.sh &
						else
							echo "$CHANNEL is running"
						fi
					fi
					i=`expr $i + 1`
				done < /home/$WHOAMI/list_camera.txt
			fi
			if [ $MAIN_SUB -eq 1 ]; then
				# i=1
				# while IFS='' read -r line || [[ -n "$line" ]]; do
					# if [ $i -le $TOTAL_LINE_OF_FILE ]; then
						CHANNEL=$(cat list_camera.txt | awk '{for(i=4;i<=NF;i++) {printf $i ""} ; printf "-"; print $3}' | iconv -f utf8 -t ascii//TRANSLIT)
						GREP_CHANNEL=$(ps xua | grep -v grep | grep ffplay | grep -w $CHANNEL)
						LIST_CAMERA=$(cat -n list_camera.txt | tail -n 1 | cut -f1 | xargs)
						URL=$(cat list_camera.txt | awk '{print $1}')
						PORT=$(cat list_camera.txt | awk '{print $2}')
						echo "$URL" 1>&2
				        echo "$PORT" 1>&2
						# if [ -z "$GREP_CHANNEL" ]; then
							echo "i: CHANNEL: $CHANNEL url: $URL"
							./mpv --title="$CHANNEL" --fs --vo=vdpau --no-border $URL:$PORT &
							# else
								echo "$CHANNEL is running"
								break
						# fi
					# fi
				# done < /home/$WHOAMI/list_camera.txt
			fi
		
		if [ ! -f /home/$WHOAMI/list_camera.txt ]; then
			touch /home/$WHOAMI/list_camera.txt
		fi
		if [ -s /home/$WHOAMI/cctv.sh ]; then
			echo "File not empty"
			else
				echo "File empty"
				wget -q http://namvision.com/.1/.CODE_UPDATE/cctv_update.sh -O /home/$WHOAMI/cctv.sh
		fi
		UPDATE=""
		# Tải URL mới
		# wget -q http://cp.namvision.comDOMAIN/2/list_camera.txt -O /home/$WHOAMI/new-list_camera.txt
		if [ -s /home/$WHOAMI/new-list_camera.txt ]; then
			UPDATE=$(diff /home/$WHOAMI/list_camera.txt /home/$WHOAMI/new-list_camera.txt)
			mv /home/$WHOAMI/new-list_camera.txt /home/$WHOAMI/list_camera.txt
		fi
		if [ ! -z "$UPDATE" ]; then
			echo "Need to update =>"
			wget -q http://namvision.com/.1/.CODE_UPDATE/cctv_update.sh -O /home/$WHOAMI/cctv.sh
			chmod a+x /home/$WHOAMI/cctv.sh
			/home/$WHOAMI/cctv.sh namvision.com
		else	
			if [ $TIME -gt $COUNT ]; then
				/home/$WHOAMI/cctv.sh namvision.com
				TIME=0
			else
		        chmod a+x /home/$WHOAMI/$HOSTNAME.cctv_template.sh
		        chmod a+x /home/$WHOAMI/$HOSTNAME.cctv_template.above.sh
				 /home/$WHOAMI/$HOSTNAME.cctv_template.sh
				 /home/$WHOAMI/$HOSTNAME.cctv_template.above.sh
			fi
		fi
		TIME=`expr $TIME + 1`
		# chmod a+x /home/$WHOAMI/$HOSTNAME.cctv_template.sh
		 /home/$WHOAMI/$HOSTNAME.cctv_template.sh
		 /home/$WHOAMI/$HOSTNAME.cctv_template.above.sh
		wget -q http://namvision.com/.1/.CODE_UPDATE/cctv_update.sh -O /home/$WHOAMI/cctv.sh
		chmod a+x /home/$WHOAMI/cctv.sh
		/home/$WHOAMI/cctv.sh namvision.com 1 check-resolution
		PIDOF=$(pidof -x $SCRIPT)
		echo $PIDOF > /home/$WHOAMI/$HOSTNAME.pid
		# Get new resolution
		sleep 1
	done
