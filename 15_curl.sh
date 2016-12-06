#!/bin/sh
if [ -z "$INTERVAL" ]; then
    INTERVAL=5
fi  
if [ -z "$TRY" ]; then
    TRY=30
fi 

number=0
while [ "$number" -lt "$TRY" ]
do
  before=`date +%s`
  number=`expr $number + 1 `
  STATUS=$(curl -L --connect-timeout $INTERVAL  -s -o /dev/null -w '%{http_code}' "$HOST")
  if [ $STATUS -eq 200 ] || [ $STATUS -eq 303 ]; then
     if [ -z "$WORD" ]; then
       exit 0; 
     else
       BODY=`curl -L $HOST` 
       if echo "$BODY" | grep -q "$WORD" 
       then
         exit 0
       else
         echo "WORD not exist"
         exit 2
       fi
     fi
  elif [ $STATUS -ne 0 ]; then 
    echo "Response $STATUS"
    exit 2
  fi
  after=`date +%s`
  diff=$((INTERVAL + after - before))
  [ "$diff" -gt 0 ] && sleep $diff 
done
echo "SERVER not start"
exit 1
