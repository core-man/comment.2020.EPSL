#!/usr/bin/env perl
use strict;
use warnings;
# plot travel time difference due to doublet location difference

my $sta  = "AAK";
#my $sta  = "ARU";
my $data = "../docs/$sta";

my $PS = "../figs/dt-${sta}.ps";
#my $J  = "X4c/4c";
my $J  = "X5c/5c";
my $R  = "-1/1/-0.3/0.3";

#my ($col1, $col2, $col3) = ("162/181/205", "24/116/205", "255/128/128");
#my ($col1, $col2, $col3) = ("red", "black", "blue");
#my ($col1, $col2, $col3) = ("deepskyblue", "black", "purple");
my ($col1, $col2, $col3) = ("dodgerblue1", "black", "purple");

`gmt gmtset MAP_FRAME_PEN 0.5p`;
`gmt gmtset MAP_TICK_LENGTH_PRIMARY 1.5p`;
`gmt gmtset MAP_LABEL_OFFSET 2p`;
`gmt gmtset FONT_ANNOT_PRIMARY 6p,Helvetica`;
`gmt gmtset FONT_LABEL 8p,Helvetica`;


# begin plotting
`gmt psxy -J$J -R$R -P -T -K > $PS`;


# dt(PKIKP)
#`awk '{print \$1,\$4}'  $data | gmt psxy -J -R -W2p,$col1 -K -O >> $PS`; # correct h & v
`awk '{print \$1,\$3}'  $data | gmt psxy -J -R -W2p,$col1 -K -O >> $PS`;  # only correct v

# dt(PKiKP), same as dt(PKIKP)
#`awk '{print \$1,\$7}'  $data | gmt psxy -J -R -W2p,red   -K -O >> $PS`; # correct h & v
#`awk '{print \$1,\$6}'  $data | gmt psxy -J -R -W2p,red   -K -O >> $PS`; # only correct v

# dt(SKP)
#`awk '{print \$1,\$10}' $data | gmt psxy -J -R -W2p,$col2 -K -O >> $PS`; # correct h & v
`awk '{print \$1,\$9}' $data | gmt psxy -J -R -W2p,$col2 -K -O >> $PS`;   # only correct v

# dt(SKP-PKIKP)
#`awk '{print \$1,\$10-\$4}' $data | gmt psxy -J -R -W2p,$col3 -K -O >> $PS`; # correct h & v
`awk '{print \$1,\$9-\$3}' $data | gmt psxy -J -R -W2p,$col3 -K -O >> $PS`;   # only correct v

# dt(SKP-PKiKP), same as dt(SKP-PKIKP)
#`awk '{print \$1,\$10-\$7}' $data | gmt psxy -J -R -W2p,$col3 -K -O >> $PS`; # correct h & v
#`awk '{print \$1,\$9-\$6}' $data | gmt psxy -J -R -W2p,$col3 -K -O >> $PS`;  # only correct v


# plot horizontal dash line
open(GMT, "| gmt psxy -J -R -W1p,140,8_4_8_4:0p -K -O >> $PS");
print GMT "-1 0\n1 0.\n";
close(GMT);
open(GMT, "| gmt psxy -J -R -W1p,140,4_2_4_2:0p -K -O >> $PS");
print GMT "0.7 -0.079\n1 -0.079\n" if ($sta eq "ARU");
print GMT "0.7 -0.078\n1 -0.078\n" if ($sta eq "AAK");
close(GMT);

# plot vertical dash line
open(GMT, "| gmt psxy -J -R -W1p,140,8_4_8_4:0p -K -O >> $PS");
print GMT "0.7 0.3\n0.7 -0.3\n";
close(GMT);


# plot dt for doublet 9303
open(GMT, "| gmt psxy -J -R -Sa0.3 -Gred -K -O >> $PS");
#print GMT "0.7 -0.079\n" if ($sta eq "AAK"); # correct h & v
#print GMT "0.7 -0.074\n" if ($sta eq "ARU"); # correct h & v
print GMT "0.7 -0.078\n" if ($sta eq "AAK");  # only correct v
print GMT "0.7 -0.079\n" if ($sta eq "ARU");  # only correct v
close(GMT);

# plot doublet 9303
`echo -0.3 -0.175 doublet 9303 | gmt pstext -J -R -F+f8,0,black+jLM -N -K -O >> $PS`;
`echo 0.1 -0.16 25 1.5 | gmt psxy -J -R -Sv0.23c+e -W0.5p,60 -G60 -N -O -K >> $PS`;


# plot text
#`echo -0.98 -0.28 PKIKP/PKiKP: PKIKP or PKiKP | gmt pstext -J -R -F+f7,0,black+jLM -N -K -O >> $PS`;
#`echo -0.95 -0.27 $sta | gmt pstext -J -R -F+f10,0,black+jLM -N -K -O >> $PS`;
`echo 0.15 0.26 "\($sta\)" | gmt pstext -J -R -F+f10,0,black+jLM -N -K -O >> $PS`;
`echo -0.4 0.26 0 \104 | gmt pstext -J -R -F+f10,12,black+a+jLM -N -K -O >> $PS`;
`echo -0.3 0.26 0 = 132\260 | gmt pstext -J -R -F+f10,black+a+jLM -N -K -O >> $PS` if ($sta eq "ARU");
`echo -0.3 0.26 0 = 130\260 | gmt pstext -J -R -F+f10,black+a+jLM -N -K -O >> $PS` if ($sta eq "AAK");

open(GMT, "| gmt pstext -J -R -F+f7,0,black+a-20+jLM -K -O >> $PS");
#print GMT "0.4 0.0 (0.7, -0.079)\n" if ($sta eq "AAK"); # correct h & v
#print GMT "0.4 0.0 (0.7, -0.074)\n" if ($sta eq "ARU"); # correct h & v
print GMT "0.46 -0.02 (0.7, -0.078)\n" if ($sta eq "AAK"); # only correct v
print GMT "0.46 -0.02 (0.7, -0.079)\n" if ($sta eq "ARU"); # only correct v
close(GMT);

if ($sta eq "ARU") {
=pod correct h & v
    `echo -1.0 0.19 PKIKP/PKiKP | gmt pstext -J -R -F+f6,0,$col1+a-28+jLM -N -K -O >> $PS`;
    `echo -0.9 0.28 SKP | gmt pstext -J -R -F+f6,0,$col2+a-40+jLM -K -O >> $PS`;
    `echo -1.0 0.09 SKP-PKIKP/PKiKP | gmt pstext -J -R -F+f6,0,$col3+a-20+jLM -N -K -O >> $PS`;
=cut
    # only correct v
    `echo -0.98 0.175 PKIKP/PKiKP | gmt pstext -J -R -F+f7,0,$col1+a-27+jLM -N -K -O >> $PS`;
    `echo -0.9 0.27 SKP | gmt pstext -J -R -F+f7,0,$col2+a-43+jLM -K -O >> $PS`;
    `echo -0.98 0.08 SKP-PKIKP/PKiKP | gmt pstext -J -R -F+f7,0,$col3+a-20+jLM -N -K -O >> $PS`;
}
elsif ($sta eq "AAK") {
=pod correct h & v
    `echo -1.0 0.18 PKIKP/PKiKP | gmt pstext -J -R -F+f6,0,$col1+a-28+jLM -N -K -O >> $PS`;
    `echo -0.9 0.27 SKP | gmt pstext -J -R -F+f6,0,$col2+a-43+jLM -K -O >> $PS`;
    `echo -1.0 0.08 SKP-PKIKP/PKiKP | gmt pstext -J -R -F+f6,0,$col3+a-20+jLM -N -K -O >> $PS`;
=cut
    # only correct v
    `echo -0.98 0.18 PKIKP/PKiKP | gmt pstext -J -R -F+f7,0,$col1+a-28+jLM -N -K -O >> $PS`;
    `echo -0.9 0.27 SKP | gmt pstext -J -R -F+f7,0,$col2+a-43+jLM -K -O >> $PS`;
    `echo -0.98 0.08 SKP-PKIKP/PKiKP | gmt pstext -J -R -F+f7,0,$col3+a-20+jLM -N -K -O >> $PS`;
}


# plot basemap
`gmt psbasemap -J -R -BWSne -Bxa0.4f0.2+l"doublet depth difference (km)" -Bya0.1f0.05+l"doublet travel time difference (sec)" -K -O >> $PS`;

# end plot
`gmt psxy -J -R -T -O >> $PS`;


#`gmt psconvert -Tf -P -A $PS`;
`rm gmt.*`;

