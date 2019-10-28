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

<span style="background-color:yellow; color:red"> \[Describe weighting
profiles for pedestrian routing, and time-based versus distance-based
routing\] </span>

### Trip categories

<span style="background-color:yellow; color:red"> \[Describe the kinds
of origin and destination categories used to generate flow layers\]
</span>

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
sub-sections.

Each of the flow layers described below was initially independently
calibrated against the observed pedestrian flows, by extracting flow
values along the network segments corresponding to each pedestrian count
location, and minimising the standardised error of a linear regression
model. We applied weighted regression, weighting each observed value of
\(n\) pedestrian counts by some factor, \(0\ge\lambda\le1\), as
\(n^\lambda\), where \(\lambda = 0\) yields an unweighted regression
which minimises the overall *relative* error, while values of
\(\lambda\rightarrow1\) minimise the absolute error, through weighting
the contributions of errors on observations with high pedestrian counts
in proportion to those counts. Values of \(\lambda\) were automatically
selected as those giving the lowest overall model error. Values of
`lambda` were automatically selected for each regression as that value
minimising the resultant model error, with all correlation strengths
reported throughout the following (as \(R^2\) values) corresponding to
the resultant values of \(\lambda\), which are also stated for all
reported correlations.

### Spatial Interaction Models

We generated flows along the shortest paths between all origins, \(i\),
and destinations, \(j\), according to exponential spatial interaction
models (Wilson 2008) of the form,  where \(d_{ij}\) denotes the distance
between the points \(i\) and \(j\). The denominator ensured that our
models were singly-constrained to unit sums for each origin, \(i\), over
densities at destinations, \(j\). The above form gives the expected
flow, in direct units of \(n_i\), along the path between the points
\(i\) and \(j\).

We further modified these standard spatial interaction models to
accommodate a possibility that people may tend to walk different average
or typical differences in different locations dependent on levels of
overall pedestrian activity in those locations. In particular, we
hypothesised that people may be more likely to walk further in more
prominent centres than in more peripheral locations of lower aggregate
pedestrian activity. We thus introduced an additional parameter in the
above model, which also retained the possibility that people may in fact
walk shorter distances in more prominent centres. This parameter,
\(\alpha\), simply served to scale observed exponential decay
coefficients according to the sizes of origins, \(n_i\), giving flows
between origins, \(i\), and destinations, \(j\), according to sizes or
origins, \(n_i\), rescaled to relative values of
\(n_i^\prime = n_i/max_j (n_j)\), as, 

### Flow Layers

Our models comprised a variety of flow layers, each of which was
generated by applying the spatial interaction models described above
between a specified set of origin points. Each flow layer was obtained
through calculating shortest paths between each origin point and
destination point in the network, and aggregating the corresponding
values of \(F_{ij} (d_{ij})\) along each segment of each shortest path.
Layers were also calculated describing undirected dispersal throughout
the entire network from a set of origin points. These dispersal models
are equivalent to a set of destination points comprising the entire
network, with unit destination sizes, \(n_j = 1\forall j\).

We used the 8 categories of points shown in Table 1, below, to generate
8$$7/2 = 28 flow layers between all pairwise combinations of origins and
destinations. An additional 8 layers described dispersal from each of
origin points defined by each of the categories, for a final total of 36
flow layers.

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

### Statitstical Models

Each of the above variables was examined in pairwise combination with
all other variables, plus a disersal model was generated for each
category used to define origin points, giving 64 possible layers. Our
final model incorporated only a small fraction of this total number,
through applying a step-wise variable addition procedure. We first
independently correlated all layers with the observed counts,
independently adjusting the two model parameters of \(k\) and \(#alpha\)
for each layer in order to minimise model error. The minimal-error layer
was then selected. The next layer-selection step incorporated that
layer, again independently adjusting values of \(k\) and \(\alpha\) for
each layer to identify the layer giving the lowest error as part of a
multiple-linear regression model including the previously selected
layer. The third layer was then selected through again adjusting values
of \(k\) and \(\alpha\) for each remaining layer, and identifying the
layer yielding the lowest error in a model including the previous two
layers. This procedure was repeated as long as the contribution of each
new layer to the model was statistically significant.

# References

<div id="refs" class="references">

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
