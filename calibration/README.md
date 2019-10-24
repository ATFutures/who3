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

## Modelling Pedestrian Flows

We modelled pedestrian flows throughout the entirety of New York City,
USA, in order to calibrate our models against the empirical data from
the 114 pedestrian count stations. Models were constructed using the
[`dodgr`](https://github.com/atfutures/dodgr) software package for
large-scale routing through street networks, by assembling an array of
“flow layers” representing pedestrian flows between distinct
categories of origin and destination points.

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

<div id="ref-padgham_dodgr:_2019">

Padgham, Mark. 2019. *Dodgr: An R Package for Network Flow Aggregation*.
Vol. 2. Transport Findings. Network Design Lab.
<https://doi.org/10.32866/6945>.

</div>

</div>
