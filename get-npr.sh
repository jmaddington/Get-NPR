#Download info

#The URL of the progam to download should be passed as the only argument. The generic show
#or a specific date can be entered
#
#i.e., ./get-npr.sh https://www.npr.org/programs/all-things-considered/
#or ./get-npr.sh https://www.npr.org/programs/all-things-considered/2020/07/24/894981617?showDate=2020-07-24
url=$1

#The direcotry that downloads should be put into
dir=./downloads/

#The filename we'll download the show to.
file=npr.html

cd $dir

wget -O $file $1

#Find the mp3 links in the file
cat $file|grep audio-tool-download|awk '{print $4}'|sed 's/\"/\ /g'|sed 's/\href=/\ /g'|while read -r mp3
do

  #Download the mp3
  echo "Downloading" $mp3
  wget $mp3

   title=`echo $mp3|sed 's/\?/\ /g'|awk '{print $1}'`

done

#This should eventually be included in above, to avoid re-processing all MP3s
find|grep \?|while read -r mp3
do

  #Put dates into variables
  year=`date +"%Y"`
  month=`date +"%m"`
  day=`date +"%d"`

  folder="$year-$month-$day"

  case $mp3 in

  *"_me_"*)
    program="Morning Edition"
    ;;

  *"_atc_"*)
    program="All Things Considered"
    ;;

  *"_wesat_"*)
    program="Weekend Edition Saturday"
    ;;

  *"_wesun_"*)
    program="Weekend Edition Sunday"
    ;;

    *)
      program="other"
      ;;

esac

  #Give MP3s sensible filenames
  newFn=`echo $mp3|sed 's/\?/\ /g'|awk '{print $1}'`
  echo Moving $mp3 to $newFn

  mkdir -p "$program/$folder/"
  mv $mp3 "$program/$folder/$newFn"

done
