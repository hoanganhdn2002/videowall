#!/bin/bash
#| sed -e 's/\(,\)*$//g' (xóa ký tự cuối)
WHOAMI=$(whoami)
HOSTNAME=$(hostname)
CHECK_TIME="/tmp/time.txt"
CHECK_SET="/home/vp9/1.txt"
CHECK_VER="/home/vp9/fix_maxBuffer.sh"
# SITE_NAME_CMS2=$(cat /home/sysadmin/site_name.txt)
count=0
if [ ! -f ${CHECK_SET} ]; then
    echo -n '"' > 1.txt # mặc định 1s ghi ra file json 1 lần
fi
set=$(cat 1.txt)
#****************************Kiểm tra điều kiện kênh sống/chết và ghi ra file .json***********************************#
status_ffplay() {

        SITE_NAME=$(cat /home/vp9/videowall.site_name.json)
        channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
        channel_play_die_ffplay=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
        name_channel_num=$(cat /home/$WHOAMI/list_camera.txt | awk '{for(i=4;i<=4;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        MAIN_SUB=$(cat /home/$(whoami)/fullscreen.txt)
        channel_die=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | awk '{for(i=1;i<=NF;i++) {printf $i " "} ; printf "\n"}'| grep "window_title" | awk '{for(i=17;i<=17;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        echo -e "{\n $SITE_NAME \n error: $channel_play_die_ffplay,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
        echo -e "{\n $SITE_NAME \n error: $channel_play_die_ffplay,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
}

status_mpv() {
        SITE_NAME=$(cat /home/vp9/videowall.site_name.json)
        channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
        channel_play_die_mpv=$(ps xua | grep mpv | grep "0:00" | grep -v grep | grep "title" | awk '{print $12}' | awk 'END {print NR}')
        name_channel_num=$(cat /home/$WHOAMI/list_camera.txt | awk '{for(i=4;i<=4;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        MAIN_SUB=$(cat /home/$(whoami)/fullscreen.txt)
        channel_die=$(ps xua | grep mpv | grep "0:00" | grep -v grep | awk '{for(i=1;i<=NF;i++) {printf $i " "} ; printf "\c"}'| grep "title" | awk '{print $12}' | sed 's/--title=//g')
        echo -e "{\n $SITE_NAME \n error: $channel_play_die_mpv,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
        echo -e "{\n $SITE_NAME \n error: $channel_play_die_mpv,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
}

status_cms2() {
        SITE_NAME_CMS2=$(cat /home/sysadmin/site_name.txt)
        channel_num=$(cat -n /home/$WHOAMI/$HOSTNAME.txt | tail -n 1 | cut -f1 | xargs)
        channel_play_die_ffplay=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
        name_channel_num=$(cat /home/$WHOAMI/$HOSTNAME.txt | awk '{for(i=3;i<=3;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        channel_die=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | awk '{for(i=1;i<=NF;i++) {printf $i " "} ; printf "\n"}'| grep "window_title" | awk '{for(i=17;i<=17;i++) {printf $i ""} ; printf ","}' | rev | sed s'/,//' | rev | sed 's/,/, /g' | iconv -f utf8 -t ascii//TRANSLIT)
        echo -e "{\n $SITE_NAME_CMS2 \n error: $channel_play_die_ffplay,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
        echo -e "{\n $SITE_NAME_CMS2 \n error: $channel_play_die_ffplay,\n total: $channel_num,\n error_channels: $set$channel_die$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
}


# status
  if [ ! -f ${CHECK_TIME} ]; then
    echo -n "0.3" > /tmp/time.txt # mặc định 1s ghi ra file json 1 lần
  fi
set_time=$(cat /tmp/time.txt) # Tùy chỉnh thời gian sau mỗi lần ghi ra file json

if [ -f ${CHECK_VER} ]; then
    while true
    do
      channel_num=$(cat -n /home/$WHOAMI/list_camera.txt | tail -n 1 | cut -f1 | xargs)
      channel_play_life_ffplay=$(ps xua | grep ffplay | grep -v grep | awk 'END {print NR}')
      channel_play_die_ffplay=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
      channel_play_life_mpv=$(ps xua | grep mpv | grep -v grep | awk 'END {print NR}')
      channel_play_die_mpv=$(ps xua | grep mpv | grep "0:00" | grep -v grep | grep "title" | awk '{print $12}' | awk 'END {print NR}')
      MAIN_SUB=$(cat /home/$(whoami)/fullscreen.txt)
      # channel_play_life=12
    if [ $MAIN_SUB -eq 1 ]; then
      if [ $channel_play_life_mpv -eq $channel_num ]; then
        if [ $count -eq 0 ]; then
            count=$(($count+1))
            elif [ $count -eq 5 ]; then
              count=1
                  else
                    count=$(($count+1))
          fi
            echo "$count "
            # status_ffplay
            sleep $set_time
      fi
          
      if [ $channel_play_die_mpv -lt $channel_num ] && [ $channel_play_die_mpv -gt 1 ] ; then
            if [ $count -eq 0 ]; then
              count=$(($count+1))
              elif [ $count -eq 5 ]; then
                count=1
                    else
                      count=$(($count+1))
            fi
              echo "$count "
              status_mpv
              sleep $set_time
      fi
    fi

    if [ $MAIN_SUB -eq 2 ]; then
      if [ $channel_play_life_ffplay -eq $channel_num ]; then
        if [ $count -eq 0 ]; then
            count=$(($count+1))
            elif [ $count -eq 5 ]; then
              echo -e "{\n $SITE_NAME \n error: 0,\n total: $channel_num,\n error_channels: $set$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
              echo -e "{\n $SITE_NAME \n error: 0,\n total: $channel_num,\n error_channels: $set$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
              count=1
                  else
                    count=$(($count+1))
          fi
            echo "$count "
            sleep $set_time
      fi
          
      if [ $channel_play_die_ffplay -le $channel_num ] && [ $channel_play_die_ffplay -gt 1 ] ; then
            if [ $count -eq 0 ]; then
              count=$(($count+1))
              elif [ $count -eq 5 ]; then
                count=1
                    else
                      count=$(($count+1))
            fi
              echo "$count "
              status_ffplay
              # if [ $channel_play_life_ffplay -eq $channel_num ]; then
                
              # fi
              sleep $set_time
      fi
    fi
    done

fi

if [ ! -f ${CHECK_VER} ]; then
    while true
    do
      channel_num=$(cat -n /home/$WHOAMI/$HOSTNAME.txt | tail -n 1 | cut -f1 | xargs)
      channel_play_life_ffplay=$(ps xua | grep ffplay | grep -v grep | awk 'END {print NR}')
      channel_play_die_ffplay=$(ps xua | grep ffplay | grep "0:00" | grep -v grep | grep "window_title" | awk '{print $17}' | awk 'END {print NR}')
      if [ $channel_play_life_ffplay -eq $channel_num ]; then
        if [ $count -eq 0 ]; then
            count=$(($count+1))
            elif [ $count -eq 5 ]; then
              echo -e "{\n $SITE_NAME \n error: 0,\n total: $channel_num,\n error_channels: $set$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g'
              echo -e "{\n $SITE_NAME \n error: 0,\n total: $channel_num,\n error_channels: $set$set,\n total_channels: $set$name_channel_num$set\n}" | sed 's/error:/"error":/g' | sed 's/total:/"total":/g' | sed 's/total_channels/"total_channels"/g' | sed 's/error_channels/"error_channels"/g' > /tmp/videowall.json
              count=1
                  else
                    count=$(($count+1))
          fi
            echo "$count "
            sleep $set_time
      fi
          
      if [ $channel_play_die_ffplay -le $channel_num ] && [ $channel_play_die_ffplay -gt 1 ] ; then
            if [ $count -eq 0 ]; then
              count=$(($count+1))
              elif [ $count -eq 5 ]; then
                count=1
                    else
                      count=$(($count+1))
            fi
              echo "$count "
              status_cms2
              sleep $set_time
      fi
    done
fi
