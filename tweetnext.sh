#! /bin/sh

# Tweet the contents of next file in DIR using USER and PASSWORD.
# Also, schedule ourselves in PERIOD_MIN+rand(PERIOD_RAND) minutes.

USER=$1
PASSWORD=$2
DIR=$3
PERIOD_MIN="$4"; [ -z $PERIOD_MIN ] && PERIOD_MIN=30
PERIOD_RAND="$5"; [ -z $PERIOD_RAND ] && PERIOD_RAND=25

URL=http://api.twitter.com/1/statuses/update.json
FILE=`ls -rt *.tweet | head -1`
if [ -n "$FILE" ]; then
    curl -s --user $USER:$PASSWORD --data-urlencode status@$FILE $URL > /dev/null
    mv $FILE $FILE.done
fi

r0=`od -A n -N 2 -t d /dev/random`
r=`expr $PERIOD_MIN + $r0 % $PERIOD_RAND + 1`
echo "$0 $@" | at now + $r min
