#!/bin/bash

# This is based on David Mills work you can find at https://github.com/g7uvw/rPI-multiDS18x20
# You can get the latest version of this file from https://github.com/maronai/cubieboard


RRDPATH="/home/hawai/cubieboard/temperature"
DESTPATH="/var/www/html"
#red
RAWCOLOUR1="#FF0000"
TRENDCOLOUR1="#800000"
#green
RAWCOLOUR2="#00FF00"
TRENDCOLOUR2="#008000"
#yellow
RAWCOLOUR4="#FFFF00"
#blue
RAWCOLOUR3="#0000FF"
RRDFILE="koszeg_temp.rrd"
RRDFILE10_3="koszeg_temp-10years-3sensors.rrd"

#hour
rrdtool graph $DESTPATH/mhour.png --start -6h \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE:out_temp:AVERAGE \
CDEF:intrend=intemp,7200,TREND \
CDEF:outtrend=outtemp,7200,TREND \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE1:intrend$TRENDCOLOUR1:"7200 sec trend" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
LINE1:outtrend$TRENDCOLOUR2:"7200 sec trend" \
-y 1:2 -X 1 --lower-limit -10 --title "6 Hours"

#day
rrdtool graph $DESTPATH/mday.png --start -1d \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE:out_temp:AVERAGE \
CDEF:intrend=intemp,7200,TREND \
CDEF:outtrend=outtemp,7200,TREND \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE1:intrend$TRENDCOLOUR1:"7200 sec trend" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
LINE1:outtrend$TRENDCOLOUR2:"7200 sec trend" \
--title Day

#week
rrdtool graph $DESTPATH/mweek.png --start -1w \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Week

#month
rrdtool graph $DESTPATH/mmonth.png --start -1m \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Month

#year
rrdtool graph $DESTPATH/myear.png --start -1y \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Year

###for 10 years 3 sensors
#hour
rrdtool graph $DESTPATH/mhour10_3.png --start -6h \
DEF:living_room_temp=$RRDPATH/$RRDFILE10_3:living_room_temp:AVERAGE \
DEF:outside_temp=$RRDPATH/$RRDFILE10_3:outside_temp:AVERAGE \
DEF:dining_room_temp=$RRDPATH/$RRDFILE10_3:dining_room_temp:AVERAGE \
LINE2:living_room_temp$RAWCOLOUR1:"Living room temperature" \
LINE2:dining_room_temp$RAWCOLOUR3:"Dining room temperature" \
LINE2:outside_temp$RAWCOLOUR2:"Outside temperature" \
-y 1:2 -X 1 --lower-limit -10 --title "6 Hours"

#day
rrdtool graph $DESTPATH/mday10_3.png --start -1d \
DEF:living_room_temp=$RRDPATH/$RRDFILE10_3:living_room_temp:AVERAGE \
DEF:outside_temp=$RRDPATH/$RRDFILE10_3:outside_temp:AVERAGE \
DEF:dining_room_temp=$RRDPATH/$RRDFILE10_3:dining_room_temp:AVERAGE \
LINE2:living_room_temp$RAWCOLOUR1:"Living room temperature" \
LINE2:dining_room_temp$RAWCOLOUR3:"Dining room temperature" \
LINE2:outside_temp$RAWCOLOUR2:"Outside temperature" \
--title Day

#week
rrdtool graph $DESTPATH/mweek10_3.png --start -1w \
DEF:living_room_temp=$RRDPATH/$RRDFILE10_3:living_room_temp:AVERAGE \
DEF:outside_temp=$RRDPATH/$RRDFILE10_3:outside_temp:AVERAGE \
DEF:dining_room_temp=$RRDPATH/$RRDFILE10_3:dining_room_temp:AVERAGE \
LINE2:living_room_temp$RAWCOLOUR1:"Living room temperature" \
LINE2:dining_room_temp$RAWCOLOUR3:"Dining room temperature" \
LINE2:outside_temp$RAWCOLOUR2:"Outside temperature" \
--title Week

#month
rrdtool graph $DESTPATH/mmonth10_3.png --start -1m \
DEF:living_room_temp=$RRDPATH/$RRDFILE10_3:living_room_temp:AVERAGE \
DEF:outside_temp=$RRDPATH/$RRDFILE10_3:outside_temp:AVERAGE \
DEF:dining_room_temp=$RRDPATH/$RRDFILE10_3:dining_room_temp:AVERAGE \
LINE2:living_room_temp$RAWCOLOUR1:"Living room temperature" \
LINE2:dining_room_temp$RAWCOLOUR3:"Dining room temperature" \
LINE2:outside_temp$RAWCOLOUR2:"Outside temperature" \
--title Month

#year
rrdtool graph $DESTPATH/myear10_3.png --start -1y \
DEF:living_room_temp=$RRDPATH/$RRDFILE10_3:living_room_temp:AVERAGE \
DEF:outside_temp=$RRDPATH/$RRDFILE10_3:outside_temp:AVERAGE \
DEF:dining_room_temp=$RRDPATH/$RRDFILE10_3:dining_room_temp:AVERAGE \
LINE2:living_room_temp$RAWCOLOUR1:"Living room temperature" \
LINE2:dining_room_temp$RAWCOLOUR3:"Dining room temperature" \
LINE2:outside_temp$RAWCOLOUR2:"Outside temperature" \
--title Year
