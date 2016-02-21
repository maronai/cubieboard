#!/bin/bash

# This is based on David Mills work you can find at https://github.com/g7uvw/rPI-multiDS18x20
# You can get the latest version of this file from https://github.com/maronai/cubieboard


RRDPATH="/home/hawai/cubieboard/temperature"
DESTPATH="/var/www/html"
RAWCOLOUR1="#FF0000"
TRENDCOLOUR1="#800000"
RAWCOLOUR2="#00FF00"
TRENDCOLOUR2="#008000"
RRDFILE="koszeg_temp.rrd"
RRDFILE10="koszeg_temp-10years.rrd"

#hour
rrdtool graph $DESTPATH/mhour.png --start -6h \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE10:out_temp:AVERAGE \
CDEF:intrend=intemp,7200,TREND \
CDEF:outtrend=outtemp,7200,TREND \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE1:intrend$TRENDCOLOUR1:"7200 sec trend" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
LINE1:outtrend$TRENDCOLOUR2:"7200 sec trend" \
-y 1:2 -X 1 --lower-limit -10 --title Hour

#day
rrdtool graph $DESTPATH/mday.png --start -1d \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE10:out_temp:AVERAGE \
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
DEF:outtemp=$RRDPATH/$RRDFILE10:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Week

#month
rrdtool graph $DESTPATH/mmonth.png --start -1m \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE10:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Month

#year
rrdtool graph $DESTPATH/myear.png --start -1y \
DEF:intemp=$RRDPATH/$RRDFILE:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/$RRDFILE10:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Year
