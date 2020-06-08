#!/usr/bin/perl
use strict;
use warnings;
# plot seismogram

#my $phase    = "PKIKP-PKiKP";           # phase
my $phase    = "SKP";                  # phase
#my $sta      = "ARU";                  # station
my $sta      = "AAK";                   # station

my $data_dir = "../data/seismograms";                      # data directory
my @events   = ("19931201005901500", "20030906154700205"); # two events
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
    my @files = glob "$data_dir/$events[$i]/*.${sta}.*"; chomp @files;
    my ($xx1, $xx2) = (1144,1151);
    if ($i == 0) {
        `gmt pssac @files -J -R -En -Tt-3 -M-1.2c -W1p,$colors[$i] -P -K -O >> $PS`;
    }
    else {
        my ($dt) = -1 * &find_dt($phase, $sta);
        print STDERR "$sta: shift $dt s for $phase\n";
        `gmt pssac @files -J -R -En -Tt-3+s$dt -M-1.2c -W1p,$colors[$i] -P -K -O >> $PS`;
    }
}

# plot text
my ($x, $y) = ($x2-0.3, $y2-0.2);
`echo $x $y $sta | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
if ($phase eq "PKIKP-PKiKP") {
    if ($sta eq "AAK") {
        $x = $x2-1.6;
        `echo $x $y 0 \104 | gmt pstext -J -R -F+f8,12,black+a+jLM -N -K -O >> $PS`;
        $x = $x2-1.4;
        `echo $x $y 0 = 130\260 | gmt pstext -J -R -F+f8,black+a+jLM -N -K -O >> $PS`;
    }
    elsif ($sta eq "ARU") {
        $x = $x2-1.6;
        `echo $x $y 0 \104 | gmt pstext -J -R -F+f8,12,black+a+jLM -N -K -O >> $PS`;
        $x = $x2-1.4;
        `echo $x $y 0 = 132\260 | gmt pstext -J -R -F+f8,black+a+jLM -N -K -O >> $PS`;
    }
}

if ($phase eq "SKP") {
    ($x, $y) = ($x2-3.5, $y1+0.3);
    `echo $x $y $phase | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
} elsif ($phase eq "PKIKP-PKiKP") {
    if ($sta eq "AAK") {
        ($x, $y) = ($x1+1, $y1+0.2);
        `echo $x $y PKIKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
        ($x, $y) = ($x1+1, $y1+0.34);
        `echo $x $y 55 0.5 | gmt psxy -J -R -Sv0.2c+e -W0.6p -Gblack -N -O -K >> $PS`;

        ($x, $y) = ($x1+2.2, $y1+0.2);
        `echo $x $y PKiKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
        ($x, $y) = ($x1+2.2, $y1+0.34);
        `echo $x $y 65 0.5 | gmt psxy -J -R -Sv0.2c+e -W0.6p -Gblack -N -O -K >> $PS`;
    }
    elsif ($sta eq "ARU") {
        ($x, $y) = ($x1+1.3, $y1+0.3);
        `echo $x $y PKIKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
        ($x, $y) = ($x1+2.7, $y1+0.3);
        `echo $x $y PKiKP | gmt pstext -J -R -F+f8 -N -K -O >> $PS`;
    }
}

# plot doublet id
if ($sta eq "AAK" && $phase eq "PKIKP-PKiKP") {
    my $xx1 = $x1+0.6; my $xx2 = $xx1+0.5;
    my $yy1 = $y2-0.2; my $yy2 = $yy1-0.2;

    open(GMT, "| gmt psxy -J -R -W1p,$colors[0] -K -O >> $PS");
    print GMT "$xx1 $yy1\n$xx2 $yy1\n";
    close(GMT);
    open(GMT, "| gmt psxy -J -R -W1p,$colors[1] -K -O >> $PS");
    print GMT "$xx1 $yy2\n$xx2 $yy2\n";
    close(GMT);
    `echo $xx2 $yy1 1993/12/01 | gmt pstext -J -R -F+f6,$colors[0]+jLM -N -K -O >> $PS`;
    `echo $xx2 $yy2 2003/09/06 | gmt pstext -J -R -F+f6,$colors[1]+jLM -N -K -O >> $PS`;
}

# plot dt
if ($phase eq "PKIKP-PKiKP") {
    my $xx=$x2-1.7; my $yy1=$y1+0.45; my $yy2=$y1+0.2;
    `echo $xx $yy1 "dt\(PKIKP\) = -0.106 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
    `echo $xx $yy2 "dt\(PKiKP\) = -0.106 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
}
elsif ($phase eq "SKP") {
    if ($sta eq "AAK") {
        my $xx=$x2-1.55; my $yy=$y1+0.2;
        `echo $xx $yy "dt\(SKP\) = -0.184 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
    }
    elsif ($sta eq "ARU") {
        my $xx=$x2-1.55; my $yy=$y1+0.2;
        `echo $xx $yy "dt\(SKP\) = -0.185 s" | gmt pstext -J -R -F+f6+jLM -N -K -O >> $PS`;
    }
}

# plot basemap
`gmt psbasemap -J -R -BwSne -Bxa1f0.5+l"t (sec)" -K -O >> $PS`;

# plot SKP noise at AAK
`gmt psxy -J -R -X1c -Y1.45c -T -K -O >> $PS`;
if ($sta eq "AAK" && $phase eq "SKP") {
    my $J2 = "X4c/0.5c";
    my $x11=$x1-17;  my $x22=$x2+8;
    my $R2 = "$x11/$x22/$y1/$y2";

    for (my $i = 0; $i < @events; $i++) {
        my @files = glob "$data_dir/$events[$i]/*.${sta}.*"; chomp @files;
        if ($i == 0) {
            `gmt pssac @files -J$J2 -R$R2 -En -Tt-3 -M-1.4c -W0.5p,$colors[$i] -P -K -O >> $PS`;
        }
        else {
            my ($dt) = -1 * &find_dt($phase, $sta);
            print STDERR "$sta: shift $dt s for $phase\n";
            `gmt pssac @files -J -R -En -Tt-3+s$dt -M-1.4c -W0.5p,$colors[$i] -P -K -O >> $PS`;
        }
    }

    # plot box
    open(GMT, "| gmt psxy -J -R -W0.5p,black,4_2_4_2:0p -K -O >> $PS");
    print GMT "$x1 $y1\n$x1 $y2\n";
    close(GMT);
    open(GMT, "| gmt psxy -J -R -W0.5p,black,4_2_4_2:0p -K -O >> $PS");
    print GMT "$x2 $y1\n$x2 $y2\n";
    close(GMT);
    `echo $x1 $y1 -168 3.3 | gmt psxy -J -R -Sv0.15c+e -W0.5p -Gblack -N -O -K >> $PS`;
    `echo $x2 $y1 -18 2.1 | gmt psxy -J -R -Sv0.15c+e -W0.5p -Gblack -N -O -K >> $PS`;

    `gmt gmtset MAP_ANNOT_OFFSET_PRIMARY 2.2p`;
    `gmt psbasemap -J$J2 -R$R2 -BWSe -Bxa5 -K -O >> $PS`;
}
`gmt psxy -J$J -R$R -X-1c -Y-1.45c -T -K -O >> $PS`;


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
        if (abs($dd - 0.7) < 0.0001) {
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
    ($y1, $y2) = (-0.5, 1) if ($sta eq "AAK" && $phase eq "SKP");

    if ($phase eq "SKP") {
        if ($sta eq "AAK") {
            $x1 = 1352; $x2 = 1357;
        }
        elsif ($sta eq "ARU") {
            $x1 = 1349; $x2 = 1354;
        }
    }
    elsif ($phase eq "PKIKP-PKiKP") {
        if ($sta eq "AAK") {
            $x1 = 1145; $x2 = 1150;
        }
        elsif ($sta eq "ARU") {
            $x1 = 1149; $x2 = 1154;
        }
    }

    return "$x1 $x2 $y1 $y2";
}
