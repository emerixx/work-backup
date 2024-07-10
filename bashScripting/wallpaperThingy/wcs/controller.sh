pth=~/.config/wallpapers/wcs
pthtw=~/.config/wallpapers/lwalpapers/wallpapers
cw=`cat $pth/curWp`
echo "type h for help"
while [ true ] ; do

  read o
  declare -l o
  o=$o
  case $o in
    h)
      echo "h - help"
      echo "d - load default wallpaper"
      echo "q - close/stop program"
      echo "b - go to last wallpaper (history)"
      echo "n - go to next wallpaper (history)"
      echo "ch - clear history"
      echo "no input - load random wallpaper"
      echo "cw - print current wallpaper id"
      echo "bcw - add current wallpaper to the list of blocked ones"
      echo "cbw - clear the file with blocked wallpapers"
      echo "lcw - like current wallpaper"
      echo "mcwd - make current wallpaper default"
      ;;
    d)
      cw=$(exec $pth/loadDef.sh)
      echo $cw > $pth/curWp
       lines=0
      while read line; do
        if [[ $line != "" ]]; then
          lines=$((lines+1))
        fi
      done < $pth/history
      if [ $lines -eq 10 ]; then
        sed -i 1d $pth/history
      fi
      printf "%s\n" $cw >> $pth/history 
      echo "Loaded default wallpaper, cw: "$cw
      ;;
    b)
      lastIH=$cw
      while read line; do
        if [[ $line != "" ]]; then
          if [[ $line = $cw ]]; then
            cw=$lastIH
            feh --bg-fill $pthtw/"b-"$cw".jpg"
            echo $cw > $pth/curWp 
          fi
          lastIH=$line
        fi
      done < $pth/history
      echo "Loaded previous wallpaper, cw: "$cw
      ;;
    n)
     isNextNext=false
      while read line; do
       
        if [[ $line != "" ]]; then
          if [ $isNextNext = true ]; then
            cw=$line
            feh --bg-fill $pthtw/"b-"$cw".jpg"
            echo $cw > $pth/curWp
            break
          fi
          if [[ $line = $cw ]]; then
            isNextNext=true
            
          fi
          

        fi
      done < $pth/history
      echo "Loaded next wallpaper (history wise), cw: "$cw
      ;;
  
    q)
      break
      ;;
    "")
      cw=$(exec $pth/randomWp.sh)
      echo $cw > $pth/curWp
      # todo: clear history if the file contains more that 10 enteries
      lines=0
      while read line; do
        if [[ $line != "" ]]; then
          lines=$((lines+1))
        fi
      done < $pth/history
      if [ $lines -eq 10 ]; then
        sed -i 1d $pth/history
      fi
      printf "%s\n" $cw >> $pth/history 
      echo "Loaded random wallpaper, cw: "$cw
      ;;
    cw)
      echo "cw: "$cw
      ;;
    ch)
      printf "%s\n" $cw > $pth/history
      echo "cleared history"
      ;;
    bcw)
      printf "%s\n" $cw >> $pth/blockIds
      echo "added current wallpaper to blocked wallpapers, cw: "$cw
      ;;
    cbw)
      echo "" > $pth/blockIds
      echo "Cleared Blocked wallpapers"
      ;;
    lcw)
      printf "%s\n" $cw >> $pth/likedIds
      echo "Liked current wallpaper, cw: "$cw
      ;;
    mcwd)
      echo $cw > $pth/defaultId
      echo "Set current wallpaper as default, cw: "$cw
      ;;
    *)
      echo "command '$o' doesnt exist, type h for help"
      ;;
  esac
done
