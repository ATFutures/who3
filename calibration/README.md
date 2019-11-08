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

Both the street network used to route pedestrian journeys, and the
structure, nature, and location of buildings serving as origins and/or
destinations of those journeys were obtained from Open Street Map,
accessed via the R package, `osmdata` (Padgham et al. 2017). The network
consisted of 813,402 street segments, representing a total 30,226 km.
These segments are simply those used to represent Open Street Map, such
that a single linear length of way may be represented by several points,
and several corresponding edges in our internal representation. We then
used the `dodgr` software (Padgham 2019) to “contract” this network down
to segments between junctions points only, reducing it to 407,840
segments.

Each of these 407,840 segments had an associated length, along with
further detail as contained in the Open Street Map data, including the
type of way (with such values as “cycleway”, “footway”, “pedestrian”, or
“steps”). These types were used to weight the distances to reflect
typical pedestrian preferences (Luxen and Vetter 2011), to enable
pedestrian routes to be accurately calculated. These weighting schemes
act to extend the effective length of ways unsuitable for pedestrians,
for example, by multiplying actual lengths of major vehicular roads by
some factor representative of the associated pedestrian discomfort in
comparison to quiet, pedestrian-only ways. All weighting factors are
greater than one, so that the most pedestrian-friendly ways retain their
original distances, while ways less suitable for pedestrian travel have
weighted lengths greater than their actual lengths. Routing is then
conducted using these weighted lengths, and so routes reflect those that
would be typically chosen by pedestrians. Rather than distance-based
routing, we used time-based routing, which operates on a similar
principle, but introduces several categories of additional time-based
penalties, notably for waiting at traffic lights, or for waiting to
cross busy, multi-lane roads (where such crossing is permitted). All
routing was implemented using the authors’ own `dodgr` software (Padgham
2019).

### Trip categories

Open Street Map includes not only streets, but also buildings with
optional yet frequently extensive descriptions of categories, purpose,
sizes, and other properties. These building descriptions enable Open
Street Map to be used to identify likely locations of trip origins and
destinations according to trip purpose. In particular, we divided
building categories into the five main groups of transportation,
sustenance, entertainment, education, and healthcare, each by grouping
the Open Street Map tags given in Appendix 1. Transportation notably
included all parking facilities, both for bicycles and automobiles.

For each of these categories, we estimated local intensities of the
respective activities by attributing all buildings to the nearest street
network junction, and aggregating numbers at each junction. These
numbers provided estimates of likely numbers of people originating from
or coming to that point for the respective activities, and are referred
to throughout the present work as “densities.” For transportation, Open
Street Map data commonly include capacities of parking facilities,
whether for bicycles or automobiles. These capacities were taken as the
densities of points which provided them, while all other points were
assigned the average capacity of all functionally similar points (so,
for example, bicycle parking facilities absent specified capacity were
assigned the average capacity of all bicycle parking facilities with
specified capacities).

Beyond these Open Street Map-based estimates, we also used Worldpop data
to ascribe aggregate residential densities to each street junction, and
subway counts to represent journeys to or from entrances and exits of
the New York MTA subway system. A final category was based on the
betweenness centrality of the entire street network. Centrality is known
to be a strong determinant of travel behaviour, with more central
points, or street segments, correlated with higher densities of
movements towards or away from those points or segments. A final
categorical trip purpose considered in our analyses below is thus,
“centrality”.

Extraction and processing of these data enabled analyses of the
following eight trip categories, serving as types of journey origins or
destinations:

| n | category       |
| - | -------------- |
| 1 | subway         |
| 2 | centrality     |
| 3 | residential    |
| 4 | transportation |
| 5 | sustenance     |
| 6 | entertainment  |
| 7 | education      |
| 8 | healthcare     |

Each category of trip represented one pairwise combination of these
eight categories, yielding 8×7 = 56 distinct categories. An additional
eight categories were formed through modelling random dispersal away
from spatial locations identified for each category.

## Modelling Pedestrian Flows

We modelled pedestrian flows throughout the entirety of New York City,
USA, in order to calibrate our models against the empirical data from
the 114 pedestrian count stations. Models were constructed using the
[`dodgr`](https://github.com/atfutures/dodgr) software package for
large-scale routing through street networks, by assembling an array of
“flow layers” representing pedestrian flows between the distinct
categories of origin and destination points described above.

Flow layers were generated in two primary ways: either by dispersing
from a given set of origin points according to specified densities, or
through routing flows between specific sets of origin and destination
points, with densities calculated by a doubly-constrained spatial
interaction model, with exponential form used throughout (Wilson 2008).
We refer to these two methods of calculating flow layers as “flow
dispersal” and “flow aggregation”, and illustrate both in the following
sub-sections.

### Flow Layers

Our models comprised a variety of flow layers, each of which was
generated by applying the spatial interaction models described above
between a specified set of origin points, taken from the eight
categories given above. Each flow layer was obtained through calculating
shortest paths between each origin point, \(i\), and destination point,
\(j\), in the network, and aggregating flows according to exponential
spatial interaction models (Wilson 2008) of the form,  where \(d_{ij}\)
denotes the distance between the points \(i\) and \(j\). The denominator
ensured that our models were singly-constrained to unit sums for each
origin, \(i\), over densities at destinations, \(j\). The above form
gives the expected flow, in direct units of \(n_i\), along the path
between the points \(i\) and \(j\). Layers were also calculated
describing undirected dispersal throughout the entire network from a set
of origin points.

Our [`dodgr`](https://github.com/ATFutures/dodgr) software enables
spatial interaction models to be efficiently calculated for a range of
exponential decay coefficients, `k`, returning a matrix of flows, with
one row for each segment of the network, and one column for each
exponential decay coefficient entered. This enabled us to initially
calculate all flow layers for defined values of `k`, and to subsequently
combine these pre-calculated layers in a single model as described in
the following section. Each layer was calculated for 30 values of `k`,
from 100 to 3000 metres in 100 metre increments.

Finally, the city-wide flows from these flow layers, amounting in each
layer to values along over 800,000 street segments, were mapped on to
the locations of the pedestrian count stations. Flow layers contained
non-zero values for the actual street segments on which count stations
were located only where the data describing the start and end points
translated into at least one route passing along that segment. This was
not always the case, and so values for each pedestrian counter were
aggregated from a selected number of nearest non-zero flow values. This
number itself was varied between 1 and 20, and the value chosen which
gave the minimal error model following the procedures in the subsequent
section. This approach yielded flow values at pedestrian count stations
which were aggregated over potentially differing numbers of nearest
street segments for the different layers, but we argue that this
procedure is appropriate because actual placements of flow values for
each layer depend on the spatial location and variability of data as
recorded in Open Street Map.

### Statitstical Models

The 64 pairwise combinations of origin and destination categories
represents 64 potential independent variables in a statistical model.
Our final model incorporated only a small fraction of this total number,
through applying a step-wise variable addition procedure. The first
layer was selected by applying the same procedure to each layer of
aggregated flows generated by each of the 30 value of `k`, across
numbers of nearest segments, `n`, from 1 to 20 as described above, to
determine the values of `k` and `n` that minimised the error of a
standard linear regression against observed pedestrian counts. The layer
which yielded the overall minimal error was selected as the first model
layer.

The procedure was then repeated by applying an analogous procedure to
all 63 remaining layers, and including the flow values from the
previously-selected layer in a multiple linear regression model. Having
selected the second layer, it was then also included along with each of
the remaining 62 layers, in order to determine the third layer yielding
the model with the lowest overall error. Flow layers were successively
added to the model as long as their contribution to the model was
significant; that is, layer addition within the model was terminated as
soon as the next layer added made no significant contribution.

Where the addition of new layers rendered the contribution any any prior
layers no longer significant, those non-significant layers were removed
from the model. Finally, it is statistically possible that a flow layer
is significantly *negatively* correlated with observed counts. Such
layers were not included with our models, which were constructed
exclusively from layers which were positively correlated with observed
counts.

## Calibration to Observed Values

The observed pedestrian counts are given as total numbers observed
within either two- or three-hour windows (twice on weekdays, between
7-9am and 4-7pm; and once on Saturdays, between 12-2pm). We used the
weekday counts to yield an overall aggregate estimate of numbers per
day. To scale the observed values, we compared them with values derived
from the United Kingdom’s National Travel Survey
([NTS](https://beta.ukdataservice.ac.uk/datacatalogue/series/series?id=2000037),
waves 2002-2017 representing 5.8m single stage journeys), from which we
obtained a nation-wide estimate of numbers of walking trips for each of
the 24 hours of the day (see Figure 1).

<img src="figures/hourly-walking-1.png" title="Figure 1: Hourly proportions of total daily walking trips as obtained from the UK's National Travel Survey, with shaded areas illustrating the hours of pedestrian counting start between 7-9am and 4-7pm" alt="Figure 1: Hourly proportions of total daily walking trips as obtained from the UK's National Travel Survey, with shaded areas illustrating the hours of pedestrian counting start between 7-9am and 4-7pm" width="100%" />

These data reflected a total proportion of trips between the hours of
7-9am and 4-7pm of 42.7%. We assumed this figure to approximately
reflect global pedestrian behaviour, and so converted observed
pedestrian counts to expected equivalent daily totals for weekdays by
multiplying by 1 / 0.43 = 2.34.

# Results

The flow layer which made the most significant initial contribution
reflected dispersal from subway stations. The model error along the 30
values of exponential decay coefficients is illustrated in Figure 1, and
was typical for most layers, manifesting a clear and distinctive
minimum.

<img src="figures/layer-error-with-k-1.png" width="100%" />

# References

<div id="refs" class="references">

<div id="ref-luxen_real-time_2011">

Luxen, Dennis, and Christian Vetter. 2011. “Real-Time Routing with
OpenStreetMap Data.” In *Proceedings of the 19th ACM SIGSPATIAL
International Conference on Advances in Geographic Information Systems*,
513–16. GIS ’11. New York, NY, USA: ACM.
<https://doi.org/10.1145/2093973.2094062>.

</div>

<div id="ref-padgham_dodgr:_2019">

Padgham, Mark. 2019. *Dodgr: An R Package for Network Flow Aggregation*.
Vol. 2. Transport Findings. Network Design Lab.
<https://doi.org/10.32866/6945>.

</div>

<div id="ref-padgham_osmdata_2017">

Padgham, Mark, Robin Lovelace, Maëlle Salmon, and Bob Rudis. 2017.
“Osmdata.” *The Journal of Open Source Software* 2 (14).
<https://doi.org/10.21105/joss.00305>.

</div>

<div id="ref-wilson_boltzmann_2008">

Wilson, Alan. 2008. “Boltzmann, Lotka and Volterra and Spatial
Structural Evolution: An Integrated Methodology for Some Dynamical
Systems.” *Journal of the Royal Society Interface* 5 (25): 865–71.
<https://doi.org/10.1098/rsif.2007.1288>.

</div>

</div>
