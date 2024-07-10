random_number=$((RANDOM % 939)) # random number from 1 (included) to 933 (included)
wid=$((random_number))


if [ $wid -lt 10 ]; then
  wid="00"$wid
elif [ $wid -lt 100 ]; then
  wid="0"$wid
fi
while read line; do
  if [[ $line != "" ]]; then
    if [[ $line = wid ]]; then
      exec ~/.config/wallpapers/wcs/randomWp.sh
      exit
    fi
  fi
done < ~/.config/wallpapers/wcs/blockIds  
echo $wid
feh --bg-fill /home/emerix/.config/wallpapers/lwalpapers/wallpapers/"b-"$wid".jpg"

