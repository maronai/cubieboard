#!/usr/bin/perl

# This is based on David Mills work you can find at https://github.com/g7uvw/rPI-multiDS18x20
# You can get the latest version of this file from https://github.com/maronai/cubieboard

use strict;
use warnings;
use POSIX (); 

#&check_modules;
&get_device_IDs;

my $dt = POSIX::strftime "%F %T", localtime $^T;
my $count = 0; 
my $reading = -1; 
my $device = -1; 
my $filename = "/var/www/html/index.html";

my @deviceIDs; 
my @temp_readings;  
my @temp_corrections;
my @temp_locations;

my %sensor_temperature;
my %sensor_correction;
my %sensor_location;
my @allData;

$sensor_correction{'28-000004bf5892'} = 0;  #koszeg outside temperature
$sensor_correction{'28-000004cd5159'} = 0;  #koszeg living room temperature
$sensor_correction{'28-000004d0b512'} = 0;  #koszeg dining room temperature

$sensor_location{'28-000004bf5892'} = "Outside";  #koszeg outside temperature
$sensor_location{'28-000004cd5159'} = "Living room";  #koszeg living room temperature
$sensor_location{'28-000004d0b512'} = "Dining roon";  #koszeg dining room temperature

$temp_corrections[0] = 0; #koszeg outside temperature
$temp_corrections[1] = 0; #koszeg living room temperature
$temp_corrections[2] = 0; #koszeg dining room temperature

$temp_locations[0] = "Outside";
$temp_locations[1] = "Living room";
$temp_locations[2] = "Dining room";

foreach $device (@deviceIDs) {
   $reading = &read_device($device);
   if ($reading == 9999) {
     $reading = "U"; 
   } 
   push(@temp_readings,$reading);
}

my $i=0;

foreach $reading (@temp_readings) {
  if ($reading ne 'U') {
    $reading -= $temp_corrections[$i];
  } 
  $i++;
}

#update the database 
if ($ARGV[0]==1) {
  #running rrdtool if first paramter is 1
  `/usr/bin/rrdtool update koszeg_temp.rrd N:$temp_readings[1]:$temp_readings[0]`;
  #`/usr/bin/rrdtool update koszeg_temp-10years-3sensors.rrd N:$sensor_temperature{'28-000004bf5892'}:$sensor_temperature{'28-000004cd5159'}:$sensor_temperature{'28-000004d0b512'}`;
  `/usr/bin/rrdtool update koszeg_temp-10years.rrd N:$temp_readings[1]:$temp_readings[0]`;
}
if ($ARGV[0]==2) {
  #running rrdtool if first paramter is 2
  #`/usr/bin/rrdtool update koszeg_temp.rrd N:$temp_readings[1]:$temp_readings[0]`;
  `/usr/bin/rrdtool update koszeg_temp-10years-3sensors.rrd N:$sensor_temperature{'28-000004bf5892'}:$sensor_temperature{'28-000004cd5159'}:$sensor_temperature{'28-000004d0b512'}`;
  #`/usr/bin/rrdtool update koszeg_temp-10years.rrd N:$temp_readings[1]:$temp_readings[0]`;
}
  print "\nRunning RRDtool par=$ARGV[0] $sensor_temperature{'28-000004bf5892'}  $sensor_temperature{'28-000004cd5159'}  $sensor_temperature{'28-000004d0b512'}\n\n";

#print ($ARGV[0]);

#Print info to the console
$i=0;
foreach $reading (@temp_readings) {
  print "$temp_locations[$i] temperature = $temp_readings[$i]\n";
  $i++;
}

foreach $device (@deviceIDs) {
   $device =~ s/\R//g; 
   print "DeviceID = $device\t Temperature = $sensor_temperature{$device}\t Location=$sensor_location{$device}\t Correction = $sensor_correction{$device}\n";
}

#Print info to the index.html file
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
print $fh "<html><body>\n";
print $fh "Latest measurement at ";
print $fh $dt;
print $fh "<br>";
$i = 0;
foreach $reading (@temp_readings) {
  print $fh "<br>$temp_locations[$i] temperature = $temp_readings[$i]\n";
  $i++;
}
print $fh "<p><img src=\"./mday.png\">\n";
print $fh "<img src=\"./mweek.png\">\n";
print $fh "<br><img src=\"./mmonth.png\">\n";
print $fh "<img src=\"./myear.png\">\n";
print $fh "<p><img src=\"./mday10_3.png\">\n";
print $fh "<img src=\"./mweek10_3.png\">\n";
print $fh "<br><img src=\"./mmonth10_3.png\">\n";
print $fh "<img src=\"./myear10_3.png\">\n";
print $fh "</body></html>\n";
close $fh;
 
sub check_modules {
  my $mods = `cat /proc/modules`; 
  if ($mods =~ /w1_gpio/ && $mods =~ /w1_therm/) { 
    #print "w1 modules already loaded \n";
  } else { 
    print "loading w1 modules \n"; `sudo modprobe w1-gpio`; `sudo modprobe w1-therm`; 
  }  
}

sub get_device_IDs { 
  # The Hex IDs off all detected 1-wire devices on the bus are stored in the file 
  # "w1_master_slaves"  
  # open file
  open(FILE, "/sys/bus/w1/devices/w1_bus_master1/w1_master_slaves") or die("Unable to open file");

  # read file into an array 
  @deviceIDs = <FILE>;  
  # close file 
  close(FILE); 
} 

sub read_device { 
  #takes one parameter - a device ID 
  #returns the temperature if we have something like valid conditions 
  #else we return "9999" for undefined  
  my $deviceID = $_[0]; 
  $deviceID =~ s/\R//g; 

  my $ret = 9999; # default to return 9999 (fail)  
  my $sensordata = `cat /sys/bus/w1/devices/${deviceID}/w1_slave 2>&1`; 
  print "Device ID: $deviceID Read: $sensordata"; 

  if(index($sensordata, 'YES') != -1) { #fix for negative temps from http://habrahabr.ru/post/163575/ 
    $sensordata =~ /t=(\D*\d+)/i; 
	#$sensor_temp =~ /t=(\d+)/i; 
	$sensordata = (($1/1000)); 
	$ret = $sensordata; 
  } else {
    print ("CRC Invalid for device $deviceID.\n"); 
  }  
  $sensor_temperature{$deviceID}=$ret+$sensor_correction{$deviceID};
  return ($ret); 
}
