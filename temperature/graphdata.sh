#!/bin/bash
RRDPATH="/home/hawai/cubieboard/temperature"
DESTPATH="/var/www/html"
RAWCOLOUR1="#FF0000"
TRENDCOLOUR1="#800000"
RAWCOLOUR2="#00FF00"
TRENDCOLOUR2="#008000"

#hour
rrdtool graph $DESTPATH/mhour.png --start -6h \
DEF:intemp=$RRDPATH/koszeg_temp.rrd:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/koszeg_temp.rrd:out_temp:AVERAGE \
CDEF:intrend=intemp,1800,TREND \
CDEF:outtrend=outtemp,1800,TREND \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE1:intrend$TRENDCOLOUR1:"30 min trend" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
LINE1:outtrend$TRENDCOLOUR2:"30 min trend" \
-y 1:2 -X 1 --lower-limit -10 --title Hour

#day
rrdtool graph $DESTPATH/mday.png --start -1d \
DEF:intemp=$RRDPATH/koszeg_temp.rrd:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/koszeg_temp.rrd:out_temp:AVERAGE \
CDEF:intrend=intemp,3600,TREND \
CDEF:outtrend=outtemp,3600,TREND \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE1:intrend$TRENDCOLOUR1:"1h trend" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
LINE1:outtrend$TRENDCOLOUR2:"1h trend" \
--title Day

#week
rrdtool graph $DESTPATH/mweek.png --start -1w \
DEF:intemp=$RRDPATH/koszeg_temp.rrd:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/koszeg_temp.rrd:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Week

#month
rrdtool graph $DESTPATH/mmonth.png --start -1m \
DEF:intemp=$RRDPATH/koszeg_temp.rrd:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/koszeg_temp.rrd:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Month

#year
rrdtool graph $DESTPATH/myear.png --start -1y \
DEF:intemp=$RRDPATH/koszeg_temp.rrd:in_temp:AVERAGE \
DEF:outtemp=$RRDPATH/koszeg_temp.rrd:out_temp:AVERAGE \
LINE2:intemp$RAWCOLOUR1:"Inside temperature" \
LINE2:outtemp$RAWCOLOUR2:"Outside temperature" \
--title Year
