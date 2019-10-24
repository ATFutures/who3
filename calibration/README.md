<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

Calibration of UPTHAT (the Urban Planning and Transport Health
Assessment Toolkit) relies primarily on new high performace software
(Padgham 2019) for analysing dynamic movement through urban areas.

This manuscript details procedures developed for calibrating UPTHAT
estimates of both pedestrian and cyclist densities along individual
street segments against empirical data from New York City, USA.

# Methods

## Data Sources

UPTHAT is based out of principle on entirely open data sets, primarily
on data from Open Street Map and “worldpop” (www.worldpop.org). The
latter data enable estimates of population flows to be made in absolute
terms, given aggregate data on proportions and typical frequencies of
trips.

Additional data on pedestrian densities was obtained from New York City
Government [pedestrian count
data](https://www1.nyc.gov/html/dot/html/about/datafeeds.shtml#Pedestrians),
collected bi-annually at 114 stations throughout the city, and on
cyclist densities from data provided by the city’s “citibike” public
hire bicycle system. Additional data on subway usage was obtained from
the city’s [Metropolitan Transit
Authority](http://web.mta.info/nyct/facts/ridership/ridership_sub_annual.htm),
with data on locations obtained through the city’s [open data
portal](https://data.cityofnewyork.us/Transportation/Subway-Stations/arq3-7z49).

### The Street Network

## Modelling Pedestrian Flows

We modelled pedestrian flows throughout the entirety of New York City,
USA, in order to calibrate our models against the empirical data from
the 114 pedestrian count stations. Models were constructed using the
[`dodgr`](https://github.com/atfutures/dodgr) software package for
large-scale routing through street networks, by assembling an array of
“flow layers” representing pedestrian flows between distinct
categories of origin and destination points.

Flow layers were generated in two primary ways: either by dispersing
from a given set of origin points according to specified densities, or
through routing flows between specific sets of origin and destination
points, with densities calculated by a doubly-constrained spatial
interaction model, with exponential form used throughout (Wilson 2008).
We refer to these two methods of calculating flow layers as “flow
dispersal” and “flow aggregation”, and illustrate both in the following
sub-sections. Our spatial interaction models were modified to reflect a
“weighted rich-club effect” (Opsahl et al. 2008), reflecting the
increased likelihood of people being attracted to social groups
surrounding rich or otherwise desirable individuals. The “richer” a
person becomes, the more powerful becomes the attraction of others to
that person, and Opsahl et al. (2008) demonstrated that increases in
attraction with “richness” are supra-linear. Similarly, we hypothesised
that pedestrians are supra-linearly more attracted to centres of
pedestrian activity, through non-linearly increasing flows towards the
destinations of our spatial interaction models in proportion to the
attractiveness of those destinations. Specifically, for a destination of
“size” or “attractiveness”, \(n\) (generally proportion to local
concentration of centres of pedestrian activity), we constructed spatial
interaction models according to a decay parameter, \(k\), and an
additional parameter, \(0\le\alpha\), as,  where \(w\) is a normalising
coefficient equal to the sum over all discrete destinations from a given
point, \(w = \sum_i SI(d_i)\).

### Flow dispersal

The calculation of flow dispersal is illustrated here through
calculating flow dispersing from the subway stations of New York City.
The data were obtained as described above, specified as total annual
numbers of passengers entering or exiting each of 424 subway stations.
Counts extend back to 2013, and we used for this study the most recent
full year of 2018.

For each station, flow dispersal was calculated using the station
coordinates as an origin point, and routing to every other point within
the street network according to a weighting scheme representing typical
pedestrian preferences. We used

## Flow layers

The previous two phases of this work established and calibrated methods
to generate “flow layers” from a range of origins to trip attracting
destinations, defined by the type of trip (work, education, etc). Each
layer is calculated in two directions (origin \(\rightarrow\)
destination; destination \(\rightarrow\) origin):

| origin | destination | mode             |
| :----- | :---------- | :--------------- |
| home   | work        | bicycle foot     |
| home   | education   | bicycle foot     |
| home   | retail      | bicycle foot     |
| home   | bus         | foot             |
| work   | retail      | bicycle foot     |
| work   | bus         | foot             |
| retail | bus         | foot             |
| retail | retail      | foot bicycle bus |

In the second stage, *relative* density along each street segment was
calculated as follows:

1.  Home densities were estimated directly from population density layer
    (enabling subsequent finer distinctions between demographic groups)

2.  Work densities were based on data on “activity centres” (centres of
    commerce, administration, education), scaled by estimated building
    sizes.

<!-- I don't think we've don this yet... (RL) -->

<!-- (including floor areas times height where available), modified for distinct purposes such that, for example, densities for journeys to educational facilities are high for purposes of education, yet lower for purposes of employment. -->

<!-- 3. Educational trip attractor densities were based on open data on schools, colleges and universities. -->

3.  Retail densities based on local densities and sizes of retail
    buildings.

<!-- All of these densities are also adjusted via a model of the spatial patterns of -->

<!-- bus usage which estimates aggregate rates of ingress -- densities entering buses at each stop -- and egress -- densities exiting buses at each stop. -->

<!-- The model used to estimate these rates of ingress and egress has been calibrated against open data from the. -->

The layers were generated in isolation, with associated levels of
uncertainty, but can be combined converting relative flows into absolute
flows and then combining the trip counts for each layer at a given level
of temporal resolution (daily, on week days, in the first instance).
<!-- A trial weighting scheme for a master walking layer was developed for Accra based on statistics for proportions of walking trips for different purposes, and for frequencies of bus usage. -->
Phase 3 will involve calculating absolute flows and validating these
against a range of data sources, including the [Minnesota Transit
Survey](https://gisdata.mn.gov/dataset/us-mn-state-metc-trans-stop-boardings-alightings),
Transport for London’s cycle [traffic count
data](http://roads.data.tfl.gov.uk/) and the UK Census.

# References

<div id="refs" class="references">

<div id="ref-opsahl_prominence_2008">

Opsahl, Tore, Vittoria Colizza, Pietro Panzarasa, and Jos’e J. Ramasco.
2008. “Prominence and Control: The Weighted Rich-Club Effect.” *Physical
Review Letters* 101 (16): 168702.
<https://doi.org/10.1103/PhysRevLett.101.168702>.

</div>

<div id="ref-padgham_dodgr:_2019">

Padgham, Mark. 2019. *Dodgr: An R Package for Network Flow Aggregation*.
Vol. 2. Transport Findings. Network Design Lab.
<https://doi.org/10.32866/6945>.

</div>

<div id="ref-wilson_boltzmann_2008">

Wilson, Alan. 2008. “Boltzmann, Lotka and Volterra and Spatial
Structural Evolution: An Integrated Methodology for Some Dynamical
Systems.” *Journal of the Royal Society Interface* 5 (25): 865–71.
<https://doi.org/10.1098/rsif.2007.1288>.

</div>

</div>
