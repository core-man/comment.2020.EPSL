#!/usr/bin/env perl
use strict;
use warnings;

# data directory
my $data_raw  = "seismograms-raw"; # raw data downloaded by SOD
my $data_proc = "seismograms";     # data after preprocessing below

# copy raw data
`rm -r $data_proc` if (-d $data_proc);
`cp -r $data_raw $data_proc`;


# some data preprocessing based on Yao et al., 2015, JGR
open(SAC, "| sac") or die "Error in opening sac\n";
print SAC "r $data_proc/*/* \n";
print SAC "rmean \nrtrend \n taper \n";     # basic processing
#print SAC "transfer from vel to none \n "; # integrating
print SAC "transfer from none to wwsp \n";  # convolved with wwsp
#print SAC "bp co 0.6 3 p 2 n 2 \n ";       # bandpass
print SAC "bp co 0.5 1 p 1 n 2 \n";         # bandpass

print SAC "interp delta 0.0025 \n";         # interpolation
print SAC "w over \n ";
print SAC "q \n ";
close(SAC);

