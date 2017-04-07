#!/bin/bash
#| sed -e 's/\(,\)*$//g' (xóa ký tự cuối)
WHOAMI=$(whoami)
HOSTNAME=$(hostname)
CHECK_TIME="/tmp/time.txt"
count=0
#****************************Kiểm tra điều kiện kênh sống/chết và ghi ra file .json***********************************#
status() {

        channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
        channel_play=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
        name_channel_num=$(cat /home/$WHOAMI/list_camera.txt | awk '{for(i=4;i<=NF;i++) {printf $i ""} ; printf ", "}' | rev | sed s'/,/"/' | rev | sed -r -e 's/^.{0}/&"/' | iconv -f utf8 -t ascii//TRANSLIT)
        channel_die=$(echo -e "$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' ORS=', ' | rev | sed s'/,/"/' | rev | sed -r -e 's/^.{0}/&"/' )")
        echo -e "{\n error: $channel_play,\n total: $channel_num,\n error_channels: $channel_die\n total_channels: $name_channel_num\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/error_channels/"error_channels"/g' | sed 's/total_channels/"total_channels"/g' > /tmp/videowall.json
        echo -e "{\n error: $channel_play,\n total: $channel_num,\n error_channels: $channel_die\n total_channels: $name_channel_num\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/error_channels/"error_channels"/g' | sed 's/total_channels/"total_channels"/g'
}
  if [ ! -f ${CHECK_TIME} ]; then
    echo -n "1" > /tmp/time.txt # mặc định 1s ghi ra file json 1 lần
  fi
set_time=$(cat /tmp/time.txt) # Tùy chỉnh thời gian sau mỗi lần ghi ra file json
while true
do
    if [ $count -eq 0 ]; then
      count=$(($count+1))
      elif [ $count -eq 5 ]; then
        count=1
            else
              count=$(($count+1))
    fi
      status
      echo "$count "
      sleep $set_time
done
