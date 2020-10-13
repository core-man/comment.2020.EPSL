
Doublet 9303 in SSI.

## [data](data/)

Seismic data downloading and preprocessing

### downloading

We use [SOD](http://www.seis.sc.edu/sod/) to download seismic data recorded at stations `ARU` and `AAK` of eathquakes in `events.csv` from [IRIS](https://www.iris.edu/hq/) based on the recipe `recipe.xml`.

``` bash
# run the SOD recipe to download raw data inside seismograms-raw
$ sod -f recipe.xml
```
### preprocessing

We then perform some data preprocessing using [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) based on the script `preprocess.pl`.

``` bash
# the processed data is inside seismograms
$ perl preprocess.pl
```

## [scripts](scripts/)

Scripts used to do calculation

### Forward calculation

- [cal-dt.pl](scripts/cal-dt.pl): calculate traveltime difference due to location difference


### Plotting

- [plot-raypath.pl](scripts/plot-raypath.pl): plot raypaths of PKIKP, PKiKP and SKP (Fig. 1a)
- [plot-dt.pl](scripts/plot-dt.pl): plot travel time difference due to doublet depth difference (Fig. 1b)
- [plot-seism.pl](scripts/plot-seism.pl): plot seismograms (Figs. 1c-1f)


### Dependent tools

- [SAC](http://ds.iris.edu/ds/nodes/dmc/forms/sac/) : we use `saclst` command to find SAC header value
- [distaz](http://www.seis.sc.edu/software/distaz/) : calculate distance between station and event
- [TauP](http://www.seis.sc.edu/taup/index.html) : calculate predicted traveltime and slowness of PKIKP, PKiKP, and SKP
- [GMT](https://www.generic-mapping-tools.org/) : plot figures


## [docs](docs/)

### travel time difference

Travel time difference of PKIKP, PKiKP, and SKP due to location difference of doublet 9303 at stations [AAK](AAK) and [ARU](ARU).

- `dd` : doublet depth offset
- `dt-dh` : travel time difference due to horizontal separation of doublet 9303
- `dt-dd` : travel time difference due to depth offset of doublet 9303
- `dt-all` : travel time difference due to horizontal and depth separation of doublet 9303


### Raypath

Raypaths of PKIKP, PKiKP, SKP at a distance of 132 degree for a source at 33 km depth

- `PKiKP.raypath.gmt`
- `PKIKP.raypath.gmt`
- `SKP.raypath.gmt`



## [figs](figs/)

- `raypath.ps` : raypath of PKIKP, PKiKP, and SKP (Fig. 1a)
- `dt-AAK.ps` : travel time difference due to doublet depth offset at station AAK
- `dt-ARU.ps` : travel time difference due to doublet depth offset at station ARU (Fig. 1b)
- `seism-AAK-PKIKP-PKiKP.ps` : PKIKP-PKiKP waveforms at station AAK (Fig. 1c)
- `seism-AAK-SKP.ps` : SKP waveforms at station AAK (Fig. 1d)
- `seism-ARU-PKIKP-PKiKP.ps` : PKIKP-PKiKP waveforms at station ARU (Fig. 1e)
- `seism-ARU-SKP.ps` : SKP waveforms at station ARU (Fig. 1f)

