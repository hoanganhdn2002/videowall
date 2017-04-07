#!/bin/bash
#| sed -e 's/\(,\)*$//g' (xóa ký tự cuối)
WHOAMI=$(whoami)
HOSTNAME=$(hostname)
CHECK_TIME="/tmp/time.txt"
CHECK_SET="/home/vp9/1.txt"
count=0
if [ ! -f ${CHECK_SET} ]; then
    echo -n '"' > 1.txt # mặc định 1s ghi ra file json 1 lần
fi
set=$(cat 1.txt)
#****************************Kiểm tra điều kiện kênh sống/chết và ghi ra file .json***********************************#
status() {

        channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
        channel_play_die=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
        name_channel_num=$(cat /home/$WHOAMI/list_camera.txt | awk '{for(i=4;i<=NF;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        channel_die=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | awk '{for(i=1;i<=NF;i++) {printf $i " "} ; printf "\n"}'| grep "window_title" | awk '{for(i=17;i<=17;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        echo -e "{\n error: $channel_play_die,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
        echo -e "{\n error: $channel_play_die,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
}
  if [ ! -f ${CHECK_TIME} ]; then
    echo -n "1" > /tmp/time.txt # mặc định 1s ghi ra file json 1 lần
  fi
set_time=$(cat /tmp/time.txt) # Tùy chỉnh thời gian sau mỗi lần ghi ra file json
while true
do
  channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
  channel_play_life=$(ps xua | grep ffplay | grep -v grep | awk 'END {print NR}')
  # channel_play_life=12
  if [ $channel_play_life -eq $channel_num ]; then
    if [ $count -eq 0 ]; then
        count=$(($count+1))
        elif [ $count -eq 5 ]; then
          count=1
              else
                count=$(($count+1))
      fi
        echo "$count "
        sleep $set_time
  fi
      
if [ $channel_play_life -ne $channel_num ]; then
      if [ $count -eq 0 ]; then
        count=$(($count+1))
        elif [ $count -eq 5 ]; then
          count=1
              else
                count=$(($count+1))
      fi
        echo "$count "
        status
        sleep $set_time
fi

done



