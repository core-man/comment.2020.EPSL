#!/usr/bin/perl
use strict;
use warnings;

# data directory
my $data_raw  = "seismograms-raw"; # raw data downloaded by SOD
my $data_proc = "seismograms";     # data after preprocessing below

# copy raw data
`rm -r $data_proc` if (-d $data_proc);
`cp -r $data_raw $data_proc`;


# data preprocessing based on Section 2 of Yang & Song, 2020, EPSL
open(SAC, "| sac") or die "Error in opening sac\n";
print SAC "r $data_proc/*/* \n ";
print SAC "rmean \nrtrend \n taper \n";     # basic processing
print SAC "transfer from vel to none \n ";  # integrating
print SAC "rmean \nrtrend \n taper \n";     # basic processing
print SAC "transfer from none to wwsp \n "; # convolved with wwsp
print SAC "rmean \nrtrend \n taper \n";     # basic processing
print SAC "bp co 0.6 3 p 2 n 2 \n ";        # bandpass
print SAC "w over \n ";
print SAC "q \n ";
close(SAC);

