<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

Pedestrian modelling is very generally approached as an *aggregate*
phenomenon, attempting either to directly model movement between
variously aggregated areal units, or to explain pedestrian counts in
terms of explanatory variables aggregated over defined–and often notably
coarse–spatial areas (see, for example, the comprehensive references in
Singleton and Clifton 2013; Griswold et al. 2018). Moreover, pedestrian
models are frequently considered to be additional or even “optional”
components of general transport models, and have thus been constructed
to be backwards-compatible with traditional modelling approaches,
notably through focussing on coarse spatial scales of aggregation such
as “transport analysis zones” (Singleton and Clifton 2013). Progress is
modelling pedestrian behaviour has generally lagged notably behind
progress in modelling other forms of transport (Kuzmyak et al. 2014),
even though recent research has suggested and revealed that pedestrian
behaviour is more strong determined by variations at finer spatial
scales than other travel behaviour (Clifton et al. 2016).

Parallel to the development of such arguably more “traditional”
approaches to modelling pedestrian behaviour has been the development of
very fine-scale agent-based simulations such as “Simulation of Urban
Mobility” (SUMO; Krajzewicz et al. 2012) and UrbanSim (Waddell 2002,
2011). These are other such tools yield highly detailed models of
dynamic pedestrian movement, yet are typically constrained to small
spatial extents, typically much less than entire city extents. Current
practices in modelling pedestrian movement are thus often faced with a
compromise between modelling movement with sufficient detail yet only
over restricted spatial extents, or modelling movement over larger
spatial extents yet with insufficient fine-scaled detail.

The present work takes advantage of modern high-performance software for
modelling and analysing dynamic movement through urban areas (Padgham
2019) to derive a general framework for pedestrian modelling at the
finest possible spatial scale of individual street segments. The model
presented here is not an individual-based simulation model, rather it
incorporates the finest possible representation of the spatial structure
of a city, including all possible detail of the “way network” (see below
for terminological note), and of all available buildings. It is not a
multi-modal model, and does not explicitly consider pedestrian movement
in any direct relationship with other modes of travel, although it does
implicitly do so by considering movement to and from both locations of
public transport, and private parking facilities for both bicycles and
automobiles.

Importantly, our model is based entirely on open-source software, much
of which was explicitly developed or modified for the present study, and
on exclusively open sources of data. We consider such openness of both
software and data as critically important to advance the science of
pedestrian modelling. The spaces of cities are one of the primary
“common goods” shared amongst urban humanity, and walking is–or ought
to be considered–the primary mode of engagement with such shared spaces.
Accordingly, we see pedestrian modelling as a common good best advanced
through open source software based on open data.

In order to demonstrate the spatially expansive capabilities of our
software and models, we present a model of pedestrian behaviour
throughout the entirety of New York City. The model is calibrated
against pedestrian counts observed at 114 stations, using openly
available data provided by the City of New York for the year 2018. A
major aim of the present work is to demonstrate a *general and
transferrable* technique for pedestrian modelling. Accordingly, our aim
was not just to model pedestrian flows throughout New York City, but to
demonstrate how the results may be directly transferred to other
locations, through extracting the general principles of the resultant
model.

Finally, note that we refer to the network of traversable ways within a
city as a “way network”, in contrast to arguably more traditional
terminology such as “street network.” We do this in acknowledgement both
of the fact that many ways traversable to pedestrians can not be
categorized as streets (think of staircases, or paths across grass
lawns), and that this is the terminology adopted by our primary provider
of open data, Open Street Map.

# Methods

Our model consisted of a number of “flow layers” between specified
categories of origin and destination locations. Each of these layers
comprised flows aggregated between every single pairwise combination of
origin and destination points, following quickest, or least-time, paths
through the way network of New York City as weighted for pedestrian
routing.

## Data Sources

The primary source of data for our models was Open Street Map (OSM),
used to obtain both a highly detailed representation of the way network,
and of building locations, structures, and purposes. We used the R
software `osmdata` (Padgham et al. 2017) to download and process all OSM
data. Data on pedestrian densities was obtained from New York City
Government’s [pedestrian count
data](https://www1.nyc.gov/html/dot/html/about/datafeeds.shtml#Pedestrians),
collected bi-annually at 114 stations throughout the city, encompassing
a total area of 705 km<sup>2</sup>. Additional data on subway usage was
obtained from the city’s [Metropolitan Transit Authority
(MTA)](http://web.mta.info/nyct/facts/ridership/ridership_sub_annual.htm),
with data on locations of subway entrances obtained through the city’s
[open data
portal](https://data.cityofnewyork.us/Transportation/Subway-Stations/arq3-7z49).
The MTA figures are annual “ridership totals” for each station, which
are counts of number of passengers entering the system at each of 424
stations (or, in a few cases, “station complexes”, at which a single
entrance provides access to multiple proximate stations and multiple
lines). There are no data for system exits, and so we assumed that exit
numbers equalled entrance numbers throughout. The station locations
given by the City of New York are single coordinates for each station
(473 in total). The City also provides coordinates of all subway
*entrances* (1,926 in total), along with associated subway lines to
which those entrances lead, with entrances often providing access to
multiple subway lines. We allocated the ridership data to subway
entrances by associating each entrance for a given line with the station
coordinates for that line, and associating each subway entrance with the
nearest station for that line. Entrances were associated with individual
stations by repeating this procedure for all subway lines, resulting in
many entrances being associated with both different subway lines and
different stations, but nevertheless providing an accurate connection
between subway entrances, the stations to which they lead, and the MTA’s
ridership counts. Counts for each station were then distributed equally
among all associated subway entrances, ultimately converting 424 counts
into 1,926 locations of associated pedestrian flows.

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

Extraction and processing of these data enabled analyses of the eight
trip categories specified in the following table, serving as types of
journey origins or destinations. The table also enumerates numbers of
buildings of each category in the OSM database at the time of our
analyses (around October 2019).

| n | category       | number of structures or points |
| - | -------------- | ------------------------------ |
| 1 | subway         | 1,926                          |
| 2 | centrality     | \-                             |
| 3 | residential    | 99,022                         |
| 4 | transportation | 6,691                          |
| 5 | sustenance     | 7,489                          |
| 6 | entertainment  | 459                            |
| 7 | education      | 1,680                          |
| 8 | healthcare     | 1,147                          |

Each category of trip represented one pairwise combination of these
eight categories, yielding 8×7 = 56 distinct categories. An additional
eight categories were formed through modelling random dispersal away
from spatial locations identified for each category.

## Modelling Pedestrian Flows

We calibrated our model of pedestrian flows throughout the entirety of
New York City, USA, against empirical data from the 114 pedestrian count
stations. Flow layers were generated in two primary ways: either by
dispersing from a given set of origin points according to specified
densities, or through routing flows between specific sets of origin and
destination points, with densities calculated by a doubly-constrained
spatial interaction model, with exponential form used throughout (Wilson
2008). We refer to these two methods of calculating flow layers as “flow
dispersal” and “flow aggregation”, and illustrate both in the following
sub-sections.

As described above, for all layers other than dispersal, shortest paths
were calculated between all pairwise combinations of origin and
destination points, and flows aggregated along each street segment
throughout the entire network. The shortest paths were actually
calculated by weighting the network for time-based pedestrian travel,
and so were represented “quickest paths” between each pair of points.
The following sub-section briefly formalises our models.

### Flow Layers

Each flow layer was obtained through calculating shortest paths between
each origin point, \(i\), and destination point, \(j\), in the network,
and aggregating flows according to exponential spatial interaction
models (Wilson 2008) of the form,  where \(d_{ij}\) denotes the distance
between the points \(i\) and \(j\) (and self-flows \(SI_{ii}\) were
excluded), and \(n_i\) denotes the number or densities of individuals at
origin point \(i\). The denominator ensured that our models were
singly-constrained to unit sums for each origin, \(i\), over densities
at destinations, \(j\). The above form gives the expected flow, in
direct units of \(n_i\), along the path between the points \(i\) and
\(j\). Layers were also calculated describing undirected dispersal
throughout the entire network from a set of origin points.

Our [`dodgr`](https://github.com/ATFutures/dodgr) software enables
spatial interaction models to be efficiently calculated for a range of
exponential decay coefficients, `k`, returning a matrix of flows, with
one row for each segment of the network, and one column for each
exponential decay coefficient entered (see the following sub-section on
Computational Strategy). This enabled us to initially calculate all flow
layers for defined values of `k`, and to subsequently combine these
pre-calculated layers in a single model as described in the following
section. Each layer was calculated for 30 values of `k`, from 100 to
3000 metres in 100 metre increments.

The strength of spatial interaction (SI) given above was used to
determine the flow between each pair of origins and destinations in a
given layer. The flow along the path between any given pair was then
equal to the SI value divided by the length of the path. Such division
has the important effect of ensuring that the sum of flows throughout
the entire network is equal to the sum of densities at all origins for
that layer, \(\sum_i n_i\). This procedure is also equivalent to
presuming that the SI specifies a static property such as aggregate
flows per unit time, whereas the flow layer itself provides a dynamic or
probabilistic snapshot such that, for a flow of \(F\) between two
points, \(i\) and \(j\), separated by \(n\) edges, the flow along any
one of those edges at any instant of time will equal \(F/n\) (Figure 1).

<img src="figures/flow-diagram-1.png" title="Figure 1. All panels depict unit flows from A to B (black lines in left panels) and from C to D (gray lines in left panels). Panel A shows the unnormalised unit flows from A to B, and from C to D; Panel B the direct aggregation of those values. Panel C shows the normalised flows such that the sums of flows from both A to B and C to D equal one; Panel D shows the aggregation of normalised flows. Sums of flows in B equal 5, while sums in D equal 2, the same as flows from the two origins. Our models were based on flows normalised and aggregated as depicted in Panel D." alt="Figure 1. All panels depict unit flows from A to B (black lines in left panels) and from C to D (gray lines in left panels). Panel A shows the unnormalised unit flows from A to B, and from C to D; Panel B the direct aggregation of those values. Panel C shows the normalised flows such that the sums of flows from both A to B and C to D equal one; Panel D shows the aggregation of normalised flows. Sums of flows in B equal 5, while sums in D equal 2, the same as flows from the two origins. Our models were based on flows normalised and aggregated as depicted in Panel D." width="100%" />

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

### Computational Strategy

Calculating the flow layers was naturally a very computationally
demanding endeavour. Our models aimed to discern for each layer an
optimal width of exponential spatial interaction yielding the lowest
overall model error, according to the modelling procedure described
immediately below. To do that, we needed to calculate each layer for a
range of exponential widths (\(k\)). Rather than independently
calculating each layer for each value of \(k\) for potential
incorporation within a final aggregate model, we pre-calculated all
layers for 30 distinct values of \(k\in\{100,200,300, \ldots 3000\}\),
using the aforementioned ability of our `dodgr` software to calculate a
single layer for multiple values of \(k\) at effectively no additional
computational cost. As also described above, we obtained flows at each
pedestrian count station by aggregating over some variable number of
nearest edges, hereafter denoted \(n\), for which we used values between
1 and 20. This translated to each flow layer providing 30 values of
\(k\) times 20 values of \(n\), or 600 estimates. Each of these 600
values was pre-calculated prior to assembling the final model as
described in the following section.

All computation was conducted on a standard laptop, with the
pre-computation of flow layers taking a few days total calculation time,
a duration we consider quite reasonable for effectively
\(64\times600\times O(1,000)^2\sim 50,000,000,000\) shortest path
calculations on a network with around half a million edges.

### Statistical Models

The 64 pairwise combinations of origin and destination categories
represents 64 potential independent variables in a statistical model
(times the two additional variables described above of \(k\) and \(n\)).
Our final model incorporated only a small fraction of this total number,
through applying a step-wise variable addition procedure. The first
layer was selected by calculating linear regressions against the 114
observed pedestrian flows for each layer and all 600 combinations of
\(k\) and \(n\), and selecting the layer and corresponding values of
\(k\) and \(n\) which yielded the lowest squared residual error.

The procedure was then repeated by applying an analogous procedure to
all 63 remaining layers, and including the flow values from the
previously-selected layer in a multiple linear regression model. Having
selected the second layer, it was then also included along with each of
the remaining 62 layers, in order to determine the third layer yielding
the model with the lowest overall error. Flow layers were successively
added as long as their contribution to the model was significant; that
is, layer addition within the model was terminated as soon as the next
layer added made no significant contribution. Where the addition of new
layers rendered the contribution of any prior layers no longer
significant, those non-significant layers were removed from the model.
We used two degrees of significance to generate the results given below:
initial model construction used a significance of \(p\le0.05\), while
final models only retained layers with \(p\le0.01\). Removal of layers
modifies resultant models, including significance values, and so removal
of layers with \(0.01<p\le0.05\) was iterated until all remaining layers
in the final model had \(p\le0.01\). The statistical summaries given
below also include estimates of the relative importance of each variable
(Lindeman, Merenda, and Gold 1980), obtained by decomposing components
of model variance over all permutations of variable orders (Grömping
2006).

Finally, it is statistically possible for flow layers to be
significantly *negatively* correlated with observed counts (Figure 2).
Because each layer was formed from effectively arbitrary categories, and
because there was no way of knowing at the outset which categories may
or may not be significantly related to pedestrian behaviour, negative
correlations must be expected. In the context of Fig. 2, a negative
correlation could only be avoided if the layers L1 and L2 were combined
at the outset to generate a single composite layer. In general, there
can be no way of knowing in advance which combinations of layers might
be necessary to avoid negative correlations.

<img src="figures/neg-cor-1.png" title="Figure 2. Illustration of negative correlations, with flow from two layers (L1 and L2) to two points in the network (A and B) having the indicated values. If observed pedestrian counts at the points A and B were both equal to 1, the minimal-error combination of flow layers would be L1 - L2, and the latter would be negatively correlated." alt="Figure 2. Illustration of negative correlations, with flow from two layers (L1 and L2) to two points in the network (A and B) having the indicated values. If observed pedestrian counts at the points A and B were both equal to 1, the minimal-error combination of flow layers would be L1 - L2, and the latter would be negatively correlated." width="40%" />

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
the 24 hours of the day (see Figure 3).

<img src="figures/hourly-walking-1.png" title="Figure 3: Hourly proportions of total daily walking trips as obtained from the UK's National Travel Survey, with shaded areas illustrating the hours of pedestrian counting start between 7-9am and 4-7pm" alt="Figure 3: Hourly proportions of total daily walking trips as obtained from the UK's National Travel Survey, with shaded areas illustrating the hours of pedestrian counting start between 7-9am and 4-7pm" width="100%" />

These data reflected a total proportion of trips between the hours of
7-9am and 4-7pm of 42.7%. We assumed this figure to approximately
reflect global pedestrian behaviour, and so converted observed
pedestrian counts – as the sum of the morning plus afternoon values – to
expected equivalent daily totals for weekdays by multiplying by 1 / 0.43
= 2.34.

One of our motivating aims was to derive a model that could accurately
predict absolute pedestrian counts. Our final models were regression
models, and so the resultant estimates for each layer provided relative
scaling coefficients for those layers. Flow values for the layers
themselves were determined by values at the points of origin for each
layer, such that the sum of flows for each layer was equal to the sum of
values for all origins in that layer (see Figure 1).

The only layers with direct scales in numbers of pedestrians per day
were those representing movement away from subway exits. Presuming
numbers exiting each station to equal the recorded numbers entering each
station, the total daily count of 4,664,488 passengers distributed over
1,936 station exits gives 2,350 pedestrians per station exit per day.
Model estimates for layers originating at station exits thus represent
this number of pedestrians for each unit of estimated coefficient. These
estimates may of course be greater than one, because, for example, the
contribution to observed pedestrian counts of numbers *effectively*
dispersing from subway exits may in fact exceed the actual numbers
exiting, because this layer may in fact capture more pedestrian activity
than just dispersive movement of actual subway passengers.

Other layers result in more abstract scaling, but scales that are
nevertheless straightforward to interpret. Four of the categories are
directly associated with the location and form of built structures:
sustenance, entertainment, education, and healthcare. In each case,
sizes of origins were aggregate numbers of building of these categories
associated with each junction of the street network. The reason these
categories were treated independently was because each is generally
associated with different scales – healthcare includes hospitals, which
can be very large, and serve as origins and destinations for large
numbers of pedestrian journeys. Educational institutions can be
similarly large, but potentially cater for distinctly different social
groups. The category of sustenance includes restaurants and supermarkets
(and any categories in between), and so may vary markedly in effective
size. Entertainment may be similarly diverse, and was included as its
own separate category primarily because pedestrian movement to and from
entertainment centres is likely to occur at markedly different times of
day (or night, as the case may be) than movement in relation to the
other categories and, even if only through this difference alone, may
manifest categorically distinct patterns of movement.

Transportation was considered its own distinct category according to an
hypothesis that movement to or from transportation centres may capture
pedestrian behaviour in relation to both cycling and the driving of
automobiles. As described above, sizes of transportation sources were
quantified in numbers of parking places where given, with local averages
assigned to locations lacking specific capacities. Finally, centrality
has its own absolute scale equal to the square of the total number of
distinct vertices or points within a network. In our case, this was
equal to the total number of street junctions, which was 134,732.
Centrality was simply rescaled to a maximum of one, and was the only
category to which an absolute scale could not be assigned.

For all other categories, the results below give effective numbers of
pedestrians observed in the final model for each unit of the
corresponding type of origin; for example, \(n\) pedestrians per
restaurant or supermarket for the sustenance category, or \(n\)
pedestrians per unit of parking capacity for transportation. These scale
of layers to absolute numbers of pedestrians form a central part of the
results that follow.

# Results

The flow layer which made the most significant initial contribution
reflected movement from subway stations towards network centrality. The
model error as a function of the 30 values of exponential decay
coefficients is illustrated in Figure 4, and was typical for most
layers, manifesting a clear and distinctive minimum at 600m.

<img src="figures/layer-error-with-k-1.png" title="Figure 4: Squared residual error of linear model against single flow layer for a range of values of k, the width of the exponential spatial interaction model." alt="Figure 4: Squared residual error of linear model against single flow layer for a range of values of k, the width of the exponential spatial interaction model." width="100%" />

Following the procedure described above of adding the next minimal error
layer that was significant, while removing any layers rendered
non-significant through the addition of subsequent layers, resulted in
the final model statistically summarised in Table 1, ordered by layer
origins, and within each of these groups in decreasing relative
importance.

| Layer Name | Estimate | t value | Pr(\>t) | Rel. Importance |    k |
| :--------- | -------: | ------: | ------: | --------------: | ---: |
| sub-dis    |       53 |     9.0 |  0.0000 |           0.173 |  400 |
| sub-tra    |       15 |     5.1 |  0.0000 |           0.138 | 1000 |
| sub-hea    |       20 |     6.7 |  0.0000 |           0.093 | 2100 |
| sub-cen    |     \-24 |   \-7.0 |  0.0000 |           0.059 | 1100 |
| hea-dis    |   247240 |     9.9 |  0.0000 |           0.156 | 3000 |
| sus-ent    |     3383 |     4.0 |  0.0001 |           0.056 | 1100 |
| sus-edu    |  \-13862 |   \-6.1 |  0.0000 |           0.030 | 2100 |
| sus-sub    |   \-3128 |   \-4.0 |  0.0001 |           0.024 | 1900 |
| sus-res    |    14644 |     5.1 |  0.0000 |           0.016 | 1200 |
| ent-tra    |    89339 |     3.2 |  0.0020 |           0.051 | 2600 |
| edu-hea    |  \-58316 |   \-5.6 |  0.0000 |           0.022 |  600 |
| edu-tra    |    56107 |     5.3 |  0.0000 |           0.020 |  100 |
| edu-dis    | \-182653 |   \-3.2 |  0.0020 |           0.012 |  900 |
| edu-sus    |    39555 |     3.0 |  0.0031 |           0.008 |  100 |

Table 1. Statistical parameters of final model of pedestrian flows
through New York City.

This table reveals that layer origins were divided between the five
categories of subway, health, sustenance, entertainment, and education.
Each of these origin categories was combined with multiple destination
layers, except for health and entertainment, with in each case the
combinations coming from two to three positively-correlated layers, and
one to two negatively-correlated layers. The model was able to explain
R<sup>2</sup> = 0.859 of the observed variation in pedestrian counts
across New York City. Converting the estimates of the resultant
statistical model into absolute scales of pedestrians per day and
summing the result yielded the model shown in Figure 5.

<img src="figures/final-model-plot-1.png" width="100%" />

The most important layers in the model by far were those describing
movement away from subway exits. Model estimates for these layers were
all several tens, indicating rough equivalent numbers of pedestrians of
these values times 1,936 pedestrians per day, so for example the most
important category of dispersal from subway exists equated to 53
\(\times\) 1,936 = 102,231 pedestrians per day. While this number may
seem high, it is important to note that it represents dispersive
movement along all nearby ways, so that effective pedestrians flows
along any one way will generally be orders of magnitude less than this
value. The second most important group was represented by the single
layer of dispersive movement away from healthcare facilities, with a
similar absolute scale of 247,240 pedestrians per unit building per day.
Layers representing movement to defined categories—that is,
non-dispersive layers—had estimates generally at least an order of
magnitude lower than layers representing dispersive movement.

Widths of exponential spatial interaction or dispersal models (\(k\)
values in Table 1) differed between the different flow layers, from 400
metres for the most significant layer of dispersal from subways, to the
maximal value considered of 3,000 metres for dispersal from health care
facilities. (There were also two values of 100 metres for movement from
educational facilities to locations of both transport and sustenance.)
In terms of these exponential widths, patterns of movement from subway
stations depended on journey origins, with dispersive movement being
relatively short (400 metres), other movement (towards transport and
centrality) being over around 1,000 metres, and movement towards health
centres having an exponential width of 2.1 kilometres. Movement from
other locations resulted in more consistent \(k\) values for the various
categories of destination, with movement from locations of sustenance
described by exponential widths of 1-2 kilometres; and movement from
educational facilities by widths of under one kilometre.

## Generalizing the Model

As described at the outset, a primary aim of our model was to extract
general principles of pedestrian modelling, through abstracting these
results as much as possible from the particularities of pedestrian
behaviour in New York City. To do so, we took the final aggregate model
layer in its entirety, and retrospectively examined correlations with
component layers taken in isolation or in combination. Models were only
constructed from positive (non-zero) values for individual and aggregate
layers. The above table suggested primary layers representing movement
from subway stations, and from locations of health, sustenance, and
education. To generalise the model, we quantified dispersive movement
away from each of these categories, then followed the stepwise selection
procedure used to construct the main model of observed pedestrian
counts, yet here fitting sequences of layers to the overall aggregate
layer of flows along all street edges of New York City (of which there
were \(n=408,920\)).

| Layer.Name | Estimate | t value |    k | Rel. Importance |
| :--------- | -------: | ------: | ---: | --------------: |
| sub\_dis   |       22 |     482 |  300 |           0.556 |
| edu\_dis   |    33524 |     167 |  100 |           0.077 |
| sus\_dis   |     4419 |      38 | 3000 |           0.017 |
| hea\_dis   |  \-19076 |    \-12 | 2300 |           0.012 |

Table 2. Statistical parameters of general model of pedestrian flows
through New York City.

This general model explained \(R^2=\) 0.662 of the variation in non-zero
flow values across the entire city, with the Relative Importance values
of Table 2 giving the contributions of each of the four layers to that
overall coefficient. (All layers were entirely significant, with all
\(p\)-values effectively zero.) Modelling dispersal from subway stations
accounted for 0.56 of the explained variable portion of 0.66, or around
84%. The second most influential component was dispersal from
educational facilities, which explained 0.077/0.662 = 11.6% of the total
explained variance. Dispersal widths were in both cases roughly
commensurate with the preceding values from the original model (Table
1), at 300 rather than 400 metres for dispersal from subway, and 100
metres for dispersal from educational facilities. The remaining two
layers of dispersal from sustenance and health care facilities
represented a combined proportion of less than 3%, and are not
considered further here.

Beyond the specificities of New York City, this generalisation suggests
that simply modelling dispersal from public transport facilities can
account for the large majority of pedestrian flows throughout a city.
The above model estimates translate to \(22\times2,250 = 49,500\)
pedestrians per day from each subway exit. To reiterate the above: This
is not to be interpreted to indicate that 50,000 pedestrians actually
disperse directly from each subwqy exit, rather that the major portion
of the city’s general patterns of movement can be best explained by the
diffiusion of this number of people from the general areas surrounding
each subway exit. Dispersal from educational facilities plays a
significant yet secondary role, with an estimate of 33,000 pedestrians
from each facility.

# Discussion

The model developed here was able to reproduce over 85% of the observed
variation in pedestrian counts at 114 stations encompassing a large
portion of New York City. Both this final model and the generalisation
steps revealed dispersal from subway stations to be by far the most
significant contribution to pedestrian flows. While the ability to
explain such a large proportion of the variance in pedestrian counts
across such a large area (705 km<sup>2</sup>) in one of the world’s
major cities is obviously an achievement in its own right, we hope that
the major result of this study is the ability to generalise this model
beyond locational particularities.

Both the specific and general results confirm prior work on the
important influence of public transport on pedestrian activity
(Zacharias 2001). The dispersal radius of 300 metres accords very well
with many prior studies on transit-oriented development and pedestrian
“walksheds” (see Stojanovski 2019, and references therein). These
generalisations obviously need to be confirmed through repeating such
studies in other locations, yet offer an immediate entry point for
cities lacking the detailed kinds of monitoring data provided by New
York City. Absent any additional data whatsoever, the general model
could be adapted to other cites by devising a means to estimate relative
numbers exiting from public transport stops or stations (using proxies
such as network centrality; Derrible 2012; Jiang, Lu, and Peng 2018).
Modelling pedestrian dispersal from these stops or stations according to
estimates of passenger numbers could then provide an initial relative
indication of pedestrian densities throughout a city. A city with a
single pedestrian count station would then be able to convert that
relative scale to an absolute scale; a city with \(n\) pedestrian count
stations would be able to consider combinations of different layers,
with the general model developed here demonstrating how a explaining the
major portion of all pedestrian movement can be constructed from very
few layers indeed.

## Is our model over-fitted?

We now argue why we believe our model to be entirely statistical valid,
in spite of the fact that we calculated around 50 billion shortest paths
through the way network of New York City in order to correlate results
with 114 observations. Numbers of independent variables were at most the
64 layers considered times the 600 combinations of values of \(k\) and
\(n\). As explained above in reference to negative correlations,
however, the actual layers effectively contributing to observed
pedestrian behaviour remain unknown even after constructing our model,
with negative correlations likely indicative of some kind of mismatch
between our arbitrary layer categories and actual behaviour with regard
to categorical origins and destinations. According to this hypothesis,
although we examined 64 layers, we ought to have expected layers from
common origins to be combined both positively and negatively to reflect
effective single layers, and thus this number of 64 layers can not be
interpreted to reflect 64 independent variables. Moreover, this number
is less than numbers of variables commonly employed in pedestrian models
(see again Singleton and Clifton 2013; Griswold et al. 2018, and
references therein).

The combinations of 600 values of \(k\times n\) similarly does not
represent an equivalent number of independent variables, as each layer
was only ultimately represented by one single value of each. The final
model included 5 categories of origin, with two of these represented by
a single layer, and each of the remaining three by four layers. This
translates to an average of 2.8 destinations per origin. Presuming this
to reflect some underlying general process governing combination of
layers would suggest an effective number of independent layers of 64 /
2.8 = 23. Values of \(k\) and \(n\) would then represent one additional
variable each, amounting to 25 equivalent independent variables or
degrees of freedom used to explain 114 observations, suggesting an
entirely valid statistical procedure.

## Future Steps

There is obviously an immediate need to apply the procedure developed
here to other locations and other data. What we have nevertheless
developed is a procedure that is entirely amenable to universal
adaptation, with very little need to adapt or translate the modelling
procedure for other locational particularities. In that regard, we argue
that our modelling procedure truly is unique and uniquely powerful. Many
or arguably most models of pedestrian behaviour are drawn from highly
specific data collected in, and relevant to, one particular location.
Even in cases where adapting such models to other locations may be
possible, such adaptation almost always requires expensive data
collection in order to replicate the data inputs of initial case
studies. Our model merely presumes that a location is reasonably well
represented in Open Street Map, and that pedestrian counts are
available. Locations in which the former requirement is not sufficiently
well met can translate a desire to develop an accurate pedestrian model
into the more general, and vastly more generally useful, task of
enhancing their representation in the worlds foremost open data base of
urban structure.

# References

<div id="refs" class="references">

<div id="ref-clifton_representing_2016">

Clifton, Kelly J., Patrick A. Singleton, Christopher D. Muhs, and Robert
J. Schneider. 2016. “Representing Pedestrian Activity in Travel Demand
Models: Framework and Application.” *Journal of Transport Geography* 52
(April): 111–22. <https://doi.org/10.1016/j.jtrangeo.2016.03.009>.

</div>

<div id="ref-derrible_network_2012">

Derrible, Sybil. 2012. “Network Centrality of Metro Systems.” *PLOS ONE*
7 (7): e40575. <https://doi.org/10.1371/journal.pone.0040575>.

</div>

<div id="ref-griswold_pedestrian_2018">

Griswold, Julia, Aditya Medury, Louis Huang, David Amos, Jiajian Lu,
Schneider, Robert, and Offer Grembek. 2018. “Pedestrian Safety
Improvement Program: Phase 2.” Technical Report CA18-2452. State of
California: Department of Transport. <https://rip.trb.org/view/1427380>.

</div>

<div id="ref-gromping_relative_2006">

Grömping, Ulrike. 2006. “Relative Importance for Linear Regression in R:
The Package Relaimpo.” *Journal of Statistical Software* 17 (1): 1–27.

</div>

<div id="ref-jiang_station-based_2018">

Jiang, Ruoyun, Qing-Chang Lu, and Zhong-Ren Peng. 2018. “A Station-Based
Rail Transit Network Vulnerability Measure Considering Land Use
Dependency.” *Journal of Transport Geography* 66 (January): 10–18.
<https://doi.org/10.1016/j.jtrangeo.2017.09.009>.

</div>

<div id="ref-krajzewicz_recent_2012">

Krajzewicz, Daniel, Jakob Erdmann, Michael Behrisch, and Laura Bieker.
2012. “Recent Development and Applications of SUMO - Simulation of Urban
MObility.” *International Journal on Advances in Systems and
Measurements*, International Journal On Advances in Systems and
Measurements, 5 (3&4): 128–38. <http://elib.dlr.de/80483/>.

</div>

<div id="ref-kuzmyak_estimating_2014">

Kuzmyak, J. Richard, Jerry Walters, Mark Bradley, Kara M. Kockelman,
National Cooperative Highway Research Program, Transportation Research
Board, Engineering National Academies of Sciences, and edicine. 2014.
*Estimating Bicycling and Walking for Planning and Project Development:
A Guidebook*. Washington, D.C.: Transportation Research Board.
<https://doi.org/10.17226/22330>.

</div>

<div id="ref-lindeman_introduction_1980">

Lindeman, Richard Harold, Peter Francis Merenda, and Ruth Z Gold. 1980.
*Introduction to Bivariate and Multivariate Analysis*. Glenview, Ill.:
Scott, Foresman.
<http://catalog.hathitrust.org/api/volumes/oclc/5310754.html>.

</div>

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

<div id="ref-Padgham2017">

Padgham, Mark, Robin Lovelace, Maëlle Salmon, and Bob Rudis. 2017.
“Osmdata.” *The Journal of Open Source Software* 2 (14).
<https://doi.org/10.21105/joss.00305>.

</div>

<div id="ref-singleton_pedestrians_2013">

Singleton, Patrick A., and Kelly J. Clifton. 2013. “Pedestrians in
Regional Travel Demand Forecasting Models: State of the Practice.” In
*Transportation Research Board 92nd Annual Meeting*.
<https://trid.trb.org/view.aspx?id=1242847>.

</div>

<div id="ref-stojanovski_urban_2019">

Stojanovski, Todor. 2019. “Urban Design and Public Transportation –
Public Spaces, Visual Proximity and Transit-Oriented Development (TOD).”
*Journal of Urban Design* 0 (0): 1–21.
<https://doi.org/10.1080/13574809.2019.1592665>.

</div>

<div id="ref-waddell_urbansim:_2002">

Waddell, Paul. 2002. “UrbanSim: Modeling Urban Development for Land Use,
Transportation, and Environmental Planning.” *Journal of the American
Planning Association* 68 (3): 297–314.
<https://doi.org/10.1080/01944360208976274>.

</div>

<div id="ref-waddell_integrated_2011">

———. 2011. “Integrated Land Use and Transportation Planning and
Modelling: Addressing Challenges in Research and Practice.” *Transport
Reviews* 31 (2): 209–29. <https://doi.org/10.1080/01441647.2010.525671>.

</div>

<div id="ref-Wilson2008">

Wilson, Alan. 2008. “Boltzmann, Lotka and Volterra and Spatial
Structural Evolution: An Integrated Methodology for Some Dynamical
Systems.” *Journal of the Royal Society Interface* 5 (25): 865–71.
<https://doi.org/10.1098/rsif.2007.1288>.

</div>

<div id="ref-zacharias_pedestrian_2001">

Zacharias, John. 2001. “Pedestrian Behavior Pedestrian Behavior and
Perception in Urban Walking Environments.” *Journal of Planning
Literature* 16 (1): 3–18. <https://doi.org/10.1177/08854120122093249>.

</div>

</div>
