#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use Math::Trig;
# calculate traveltime difference due to location difference

my $model    = "iasp91";                         # model
my @phases   = ("PKIKP", "PKiKP", "SKP");        # phases
my $out_dir  = "../docs";                        # output directory
my @events   = ("19980730233630640", "20130609002132679"); # two events
my $dir_1998 = "../data/seismograms/$events[0]"; # 1998 data
my $dir_2013 = "../data/seismograms/$events[1]"; # 2013 data


# sac data at station ARU of event 1998
my @sacs_98 = glob "$dir_1998/*Z.SAC"; chomp @sacs_98;

for (my $i = 0; $i < @sacs_98; $i++) {
    # 1998 and 2013 sac files
    my $fname       = fileparse($sacs_98[$i], "");
    my ($net, $sta) = split /\./, $fname;
    my @sacs_13     = glob "$dir_2013/*.${sta}.*"; chomp @sacs_13;


    # find station and event coordinates
    my (undef, $stla1, $stlo1, $evla1, $evlo1, $evdp1) =
            split " ", `saclst stla stlo evla evlo evdp f $sacs_98[$i]`;
    my (undef, $stla2, $stlo2, $evla2, $evlo2, $evdp2) =
            split " ", `saclst stla stlo evla evlo evdp f $sacs_13[0]`;
        #print STDERR "$stla1 $stlo1 $evla1 $evlo1 $evdp1\n";
        #print STDERR "$stla2 $stlo2 $evla2 $evlo2 $evdp2\n";


    # horizontal and vertical differences between 1998 and 2013
    my ($dist1) = split " ", `distaz $stla1 $stlo1 $evla1 $evlo1`;
    my ($dist2) = split " ", `distaz $stla2 $stlo2 $evla2 $evlo2`;
    my $dh0 = sprintf("%.4f", $dist2 - $dist1);
    my $dd0  = sprintf("%.4f", $evdp2 - $evdp1);
    print STDERR "$sta ($dist1): $dh0 deg (dh)  $dd0 km (dd)\n";


    # calculte slowness
    my (@rayps, @v_slowness);
    for (my $j = 0; $j < @phases; $j++) {
        ($rayps[$j], $v_slowness[$j]) = split " ", &cal_slowness($model, $evdp1, $dist1, $phases[$j]);
        print STDERR "$phases[$j]: $rayps[$j] s/deg (ray parameter) $v_slowness[$j] s/km (verticl slownes)\n";
        my $dt_dh = $rayps[$j] * $dh0;
        my $dt_dd = $v_slowness[$j] * $dd0;
        my $dt    = $dt_dh + $dt_dd;
        printf STDERR "dt: %6.3f s (h) %6.3f s (d) %6.3f s (all)\n", $dt_dh,$dt_dd,$dt;
    }


    # calculte travel difference
    my $out = "$out_dir/${sta}";
    open(OUT, "> $out") or die "Error in opening $out.\n";
    print OUT "dd dt-dh(PKIKP) dt-dd(PKIKP) dt-all(PKIKP) dt-dh(PKiKP) dt-dd(PKiKP) dt-all(PKiKP) dt-dh(SKP) dt-dd(SKP) dt-all(SKP)\n";

    for (my $dd = -1.0; $dd <= 1.0; $dd+=0.1) {
        printf OUT "%4.1f", $dd;
        for (my $j = 0; $j < @phases; $j++) {
            if ($rayps[$j] eq "undef") {
                print STDERR "Error in calculating slowness.\n";
                print OUT " undef";
            }
            else {
                my $dt_dh = $rayps[$j] * $dh0;
                my $dt_dd = $v_slowness[$j] * $dd;
                my $dt    = $dt_dh + $dt_dd;;
                printf OUT " %6.3f %6.3f %6.3f", $dt_dh,$dt_dd,$dt;
            }
        }
        print OUT "\n";
    }

    close(OUT);
    print STDERR "\n";
}



######################
# calculate slowness
# input  : model, event depth, station-event distance, phase name
# output : ray parameter, vertical slowness
sub cal_slowness {
    my ($model, $evdp, $dist, $phase) = @_;

    # call taup_time
    my $temp = "taup_temp";
    `taup_time -mod $model -h $evdp -deg $dist -ph $phase > $temp`;

    open(TP, "< $temp") or die "Error in opening $temp.\n";
    my @times = <TP>; close(TP); chomp @times;
    unlink $temp;

    # no result
    if ($times[5] eq "") {
        return "undef undef\n";
    }

    # calculte slowness
    # units of ray parameter & vertical slowess are s/deg & s/km, respectively.
    for (my $i = 5; $i < @times-1; $i++) {
        my (undef, undef, $ph, undef, $rayp, $takeoff) = split " ", $times[$i];
        if ($ph eq $phase) {
            my $v_slowness = sprintf("%.3f", 0.0-$rayp/111.195/tan(deg2rad($takeoff)));
            return "$rayp $v_slowness\n";
        }
    }
}

