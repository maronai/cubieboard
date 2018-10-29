#!/usr/bin/perl

# This is based on David Mills work you can find at https://github.com/g7uvw/rPI-multiDS18x20
# You can get the latest version of this file from https://github.com/maronai/cubieboard

use strict;
use warnings;
use POSIX (); 

my $dt = POSIX::strftime "%F %T", localtime $^T;
my $filename = "/var/www/html/index.html";

my @deviceIDs; 
my %sensor_temperature;
my %sensor_correction;
my %sensor_location;

$sensor_correction{'28-000004bf5892'} = 0;  #koszeg outside temperature
$sensor_correction{'28-000004cd5159'} = 0;  #koszeg living room temperature
$sensor_correction{'28-000004d0b512'} = 0;  #koszeg dining room temperature

$sensor_location{'28-000004bf5892'} = "Outside";  #koszeg outside temperature
$sensor_location{'28-000004cd5159'} = "Living room";  #koszeg living room temperature
$sensor_location{'28-000004d0b512'} = "Dining roon";  #koszeg dining room temperature

# getting device IDs from /sys/bus...
&get_device_IDs;

sub get_device_IDs { 
  # The Hex IDs off all detected 1-wire devices on the bus are stored in the file "w1_master_slaves"  
  # open file
  open(FILE, "/sys/bus/w1/devices/w1_bus_master1/w1_master_slaves") or die("Unable to open file");

  # read file into an array
  @deviceIDs = <FILE>;  
  # close file 
  close(FILE); 
  
  my $deviceID;
  # remove line endings from deviceIDs to get the pure id
  foreach $deviceID (@deviceIDs) {
    $deviceID =~ s/\R//g; 
  }
} 

my $deviceID = -1; 
my $reading = -1; 
foreach $deviceID (@deviceIDs) {
   $reading = &read_device($deviceID);
   if ($reading == 9999) {
     $reading = "U"; 
   } 
  $sensor_temperature{$deviceID}=$reading+$sensor_correction{$deviceID};
}

sub read_device { 
  # takes one parameter - a device ID 
  # returns the temperature if we have something like valid conditions 
  # else we return "9999" for undefined  
  my $deviceID = $_[0]; 

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
  return ($ret); 
}

# update the rrd database -> 1: old rrd db; 2: new rrd db; else: don't touch rrd db
if ($ARGV[0]==1) {
  # running rrdtool if first paramter is 1
  `/usr/bin/rrdtool update koszeg_temp.rrd N:$sensor_temperature{'28-000004cd5159'}:$sensor_temperature{'28-000004bf5892'}`;
  `/usr/bin/rrdtool update koszeg_temp-10years.rrd N:$sensor_temperature{'28-000004cd5159'}:$sensor_temperature{'28-000004bf5892'}`;
}
if ($ARGV[0]==2) {
  # running rrdtool if first paramter is 2
  `/usr/bin/rrdtool update koszeg_temp-10years-3sensors.rrd N:$sensor_temperature{'28-000004bf5892'}:$sensor_temperature{'28-000004cd5159'}:$sensor_temperature{'28-000004d0b512'}`;
}

print "\nRunning RRDtool par=$ARGV[0]\n\n";

# Print info to the console
&print_to_console;

sub print_to_console {
  my $deviceID;
  foreach $deviceID (@deviceIDs) {
    print "DeviceID = $deviceID\t Temperature = $sensor_temperature{$deviceID}\t Location=$sensor_location{$deviceID}\t Correction = $sensor_correction{$deviceID}\n";
  }
}

# Print info to the index.html file
&create_index_html($filename);

sub create_index_html {
  $filename = $_[0];
  my $deviceID;
  open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
  print $fh "<html><body>\n";
  print $fh "Latest measurement at ";
  print $fh $dt;
  print $fh "<br>";

  foreach $deviceID (@deviceIDs) {
    print $fh "<br>$sensor_location{$deviceID}:\t $sensor_temperature{$deviceID} Celsius\t\n";
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
}
