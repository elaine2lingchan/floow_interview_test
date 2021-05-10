
#!/bin/bash
DIR="./"

if [ $# -eq 0 ]
then
  echo $DIR"size_check.sh [URL]"
  exit
fi

THRESHOLD_CFG=$DIR"size_check_threshold.cfg"
if [[ ! -f $THRESHOLD_CFG ]]
then
        echo "UNKNOWN- Threshold configuration file ($THRESHOLD_CFG) is missing."
        exit 3
fi
. $THRESHOLD_CFG

URL=$1
#SIZE=`curl -s $URL | grep '"size":' | awk '{print $2}' | tr -d ,`
URL_OUT=$DIR"size_check.tmp"
wget -q $URL -O $URL_OUT
SIZE=`cat $URL_OUT | grep '"size":' | awk '{print $2}' | tr -d ,`
rm -f $URL_OUT

if [ $SIZE -gt $WARN_BORDER ]
then
  echo "OK- The size is $SIZE"
  exit 0
else
  if [ $SIZE -gt $CRIT_BORDER ]
  then
    echo "WARNING- The size is $SIZE"
    exit 1
  else
    echo "CRITICAL- The size is $SIZE"
    exit 2
  fi
fi
