#!/usr/bin/env perl
use strict;
use warnings;
# plot seismogram

#my $phase    = "PKIKP-PKiKP";           # phase
my $phase    = "SKP";                  # phase
my $sta      = "ARU";                  # station

my $data_dir = "../data/seismograms";                      # data directory
my @events   = ("19980730233630640", "20130609002132679"); # two events
my @colors   = ("blue", "red");                            # colors

# GMT parameters
my $PS = "../figs/seism-${sta}-${phase}.ps";
my $J  = "X6c/2c";
my ($x1, $x2, $y1, $y2) = split " ", &find_R($phase,$sta);
my $R = "$x1/$x2/$y1/$y2";

# GMT default setting
`gmt gmtset MAP_FRAME_PEN 0.5p`;
`gmt gmtset MAP_TICK_LENGTH_PRIMARY 1.5p`;
`gmt gmtset MAP_LABEL_OFFSET 2p`;
`gmt gmtset FONT_ANNOT_PRIMARY 6p,Helvetica`;
`gmt gmtset FONT_LABEL 8p,Helvetica`;


# begin plotting
`gmt psxy -J$J -R$R -P -T -K > $PS`;

# plot seismograms
for (my $i = 0; $i < @events; $i++) {
    my @files = glob "$data_dir/$events[$i]/*.${sta}.*Z.SAC"; chomp @files;
    print STDERR "@files\n";
    if ($i == 0) {
        `gmt pssac @files -J -R -En -Tt-3 -M-1.2c -W1p,$colors[$i] -C$x1/$x2 -P -K -O >> $PS`;
    }
    else {
        my ($dt) = -1 * &find_dt($phase, $sta);
        print STDERR "$sta: shift $dt s for $phase\n";
        `gmt pssac @files -J -R -En -Tt-3+s$dt -M-1.2c -W1p,$colors[$i] -C$x1/$x2 -P -K -O >> $PS`;
    }
}

# plot text
my ($x, $y) = ($x2-0.3, $y2-0.2);
`echo $x $y $sta | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
if ($phase eq "PKIKP-PKiKP") {
    $x = $x2-1.6;
    `echo $x $y 0 \104 | gmt pstext -J -R -F+f8,12,black+a+jLM -N -K -O >> $PS`;
    $x = $x2-1.4;
    `echo $x $y 0 = 133\260 | gmt pstext -J -R -F+f8,black+a+jLM -N -K -O >> $PS`;
}

if ($phase eq "SKP") {
    ($x, $y) = ($x2-2.7, $y1+0.3);
    `echo $x $y $phase | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
} elsif ($phase eq "PKIKP-PKiKP") {
    ($x, $y) = ($x1+1.0, $y1+0.2);
    `echo $x $y PKIKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
    ($x, $y) = ($x1+2.5, $y1+0.2);
    `echo $x $y PKiKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
}

# plot doublet id
if ($phase eq "PKIKP-PKiKP") {
    my $xx1 = $x1+0.6; my $xx2 = $xx1+0.5;
    my $yy1 = $y2-0.2; my $yy2 = $yy1-0.2;

    open(GMT, "| gmt psxy -J -R -W1p,$colors[0] -K -O >> $PS");
    print GMT "$xx1 $yy1\n$xx2 $yy1\n";
    close(GMT);
    open(GMT, "| gmt psxy -J -R -W1p,$colors[1] -K -O >> $PS");
    print GMT "$xx1 $yy2\n$xx2 $yy2\n";
    close(GMT);
    `echo $xx2 $yy1 1998/07/30 | gmt pstext -J -R -F+f6,$colors[0]+jLM -N -K -O >> $PS`;
    `echo $xx2 $yy2 2013/06/09 | gmt pstext -J -R -F+f6,$colors[1]+jLM -N -K -O >> $PS`;
}

# plot dt
if ($phase eq "PKIKP-PKiKP") {
    my $xx=$x2-1.7; my $yy1=$y1+0.45; my $yy2=$y1+0.2;
    `echo $xx $yy1 "dt\(PKIKP\) = -0.015 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
    `echo $xx $yy2 "dt\(PKiKP\) = -0.015 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
}
elsif ($phase eq "SKP") {
    my $xx=$x2-1.55; my $yy=$y1+0.2;
    `echo $xx $yy "dt\(SKP\) = -0.026 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
}

# plot basemap
`gmt psbasemap -J -R -BwSne -Bxa1f0.5+l"t (sec)" -K -O >> $PS`;

# end plot
`gmt psxy -J -R -T -O >> $PS`;

#`gmt psconvert -Tf -P -A $PS`;
`rm gmt.*`;



##############################
# find traveltime difference due to location difference
# input : phase, station
# output : traveltime difference
sub find_dt {
    my ($phase, $sta) = @_;

    open(STA, "< ../docs/$sta") or die "Error in opening $sta.\n";
    my @lines = <STA>; close(STA); chomp @lines;

    for (my $i = 1; $i < @lines; $i++) {
        my ($dd, @dts) = split " ", $lines[$i];
        if (abs($dd - 0.1) < 0.0001) {
            # correct both horizontal and vertical separations
            #return $dts[2] if ($phase eq "PKIKP-PKiKP");
            #return $dts[$#dts] if ($phase eq "SKP");

            # only correct vertical separations
            return $dts[1] if ($phase eq "PKIKP-PKiKP");
            return $dts[$#dts-1] if ($phase eq "SKP");
        }
    }
}


# find x1,x2,y1,y2 of -R for GMT
# input : phase, station
# output : x1,x2,y1,y2
sub find_R {
    my ($phase, $sta) = @_;

    my ($x1, $x2);
    my ($y1, $y2) = (-1, 1);

    if ($phase eq "SKP") {
        $x1 = 1355; $x2 = 1360;
    }
    elsif ($phase eq "PKIKP-PKiKP") {
        $x1 = 1152; $x2 = 1157;
    }

    return "$x1 $x2 $y1 $y2";
}

