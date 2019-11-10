Scenarios for the urban planning and transport health assessment tool
================

# Introduction

This report documents deliverable 2, scenario developement, for the WHO
UPTHAT project, which involves: (1) setting out high level policy
scenarios of active transport uptake; (2) converting these changes into
estimates of rates of shift towards walking and cycling down to route
network levels; and (3) simulating the impacts of these scenarios on
walking and cycling levels citywide. Scenario development will also be
strongly informed by the transport scenarios assessed in Accra and
Kathmandu as part of UHI project activities.

# High level policy scenarios of active transport uptake

High level priorities are to improve population health, air quality and
safety levels. This means increasing the proportion of the population
that gets regular physical activity, reducing motorized vehicle use in
urban centres and providing walking and cycling routes that are away
from or otherwise protected from motor traffic. Urban transport policies
can meet each of these objectives, creating ‘win win win’ options.
Reducing car use, for example, will directly improve air quality and
indirectly improve health and safety levels.

Specific scenarios of change include:

  - ‘Get walking’, referring to a global (meaning without spatial input
    components, but with spatially distributed consequences) walking
    uptake, as a result of citywide policies to promote safe and
    attractive walking.
  - ‘Get cycling’, referring to a global scenario of cycling, as a
    result of citywide policies to provide safe cycleways.
  - ‘Car diet’, a global, citywide scenario of multi-modal transport
    change, showing reduced levels of driving following disincentives to
    own and use cars.
  - ‘Go public transport’, a global scenario of public transport uptake,
    linked to [SDG 11](https://sustainabledevelopment.un.org/sdg11).
  - ‘Car free’, meaning investment in car free city centers and other
    spaces, other locally specific scenarios, such as reductions in car
    parking spaces.

# Citywide scenarios of change

To calculate scenarios of change, the minimum data requirements are the
region’s current modal split and data that can be used as explanatory
variables, including data on transport infrastructure and car parking
spaces, and data on the provision of public transport options.

## Mode split data

Mode split is one of the fundamental pieces of information that is known
for most cities. For context, it’s useful to take a step back and
consider the range of modal splits observed in a sample of cities
worldwide. The figure below shows the diversity in mode splits based on
(primarily wealthy) cities, based on data of the type shown in the table
below from [Wikipedia](https://en.wikipedia.org/wiki/Modal_share).

| City       | walking | cycling | pt | car | other | year |
| :--------- | ------: | ------: | -: | --: | ----: | ---: |
| Detroit    |       1 |       0 |  2 |  92 |     5 | 2016 |
| Amsterdam  |       4 |      40 | 29 |  27 |     0 | 2014 |
| Bratislava |       4 |       0 | 70 |  26 |     0 | 2004 |
| Osaka      |      27 |      21 | 34 |  18 |     0 | 2000 |
| Helsinki   |      37 |      10 | 30 |  22 |     1 | 2016 |

The figure shows that cars dominate the transport systems of most
cities, accounting for a mode shares ranging from 18% (Osaka, Japan) to
85% (Adalaide, Australia). A more useful way to view travel systems from
an active transport perspective is to view walking as the foundation of
transport systems and all other modes to supplement walking. This view
is shown on the right of the figure, which shows walking mode shares in
the sample of cities ranging from only 3% to more than 1/3rd (in Madrid,
Spain and Vilnius, Lithuania). It is interesting to note that while
there is a roughly even distribution of mode shares by car, other modes
have more skewed distributions. This could reflect the diversity of
policies used to promote walking, cycling and public transport and the
fact that cars tend to be the default. This implication is that **if no
policies have been implemented to promote alternatives, cars
dominate**.

<img src="../figures/city-mode-split-wiki-cars.png" width="100%" /><img src="../figures/city-mode-split-wiki.png" width="100%" />

The relationships between the different modes is illustrated in the
figure below, which suggests competition between all modes and cars
(with public transport seeming to be the biggest deterrent to driving in
this dataset), and synergies between public transport and walking.
**This strongly suggests that a reliable way to encourage walking in
cities is through investment in public transport.**

<img src="../figures/city-mode-cor.png" width="50%" />

This city level data allows models of mode split to be developed,
assuming there are sufficient explanatory variables defining the
transport system.

## Transport system data

Transport systems are complex, composed of hundreds of interrelated
elements. For modelling purposes, it makes sense to condense available
datasets down into a few key parameters per city, zone or
origin-destination pair. The process of identifying and quantifying
transport system variables should be be an open-ended and adaptable
process that is able to respond when the input data changes (e.g. due to
changes in the transport system or improved data
availability/collection).

This section therefore provides a framework for including key transport
system variables, based on the assumption that additional/modified
variables will be used in future iterations of the model. Key variables
that are readily available for most cities include:

  - Percentage of the transport network that is dedicated to motor
    traffic (an alternative or suplementary measure could be the
    percentage of the city’s surface area dedicated to motor traffic)
  - Provision for public transport, in terms of the percentage of the
    city’s area within walking distance (e.g. 300m) of public transport
    nodes such as bus stops and rail stations
  - The percentage of the city’s transport network that is dedicated to
    cycling. Other important variables include average gradient, type of
    cycle network, level or car ownership and directness of cycle routes
    compared with driving routes
    (<span class="citeproc-not-found" data-reference-id="parkin_estimation_2008">**???**</span>).
  - Provision of walking infrastructure, for example the percentage of
    the city’s transport network that is footway

Note that all the high level varibles outlined above are ‘scale free’,
meaning that they do not depend on the city’s size. The scale free
nature of such measures also means that they can be used to estimate
mode shares not only at city levels but also at the level of ‘desire
lines’ connecting origins and destinations, as with the use of average
gradient as a predictor of cycling potential in the PCT (Lovelace et al.
2017). Some additional variables, such as distance and relative
time/cost for alternative modes, only make sense when measured at the OD
level.

## Modelling mode shift

Treating mode share as a dependent variable involves multiple
interrelated dependent variables, which is problematic for standard
regression approaches. An alternative used in cycling potential research
has been to ‘expand’ mode split data into individual categorical
variables (Lovelace et al. 2017, supplementary information). This
strategy is computationally intensive however.

# Methods of modelling mode shift at the city level

The datasets presented in the previous section are examples of
proportional outcomes, where we are interested in the mode split of all
travel in a city. These types of data are common in ecological modelling
(Douma and Weedon 2019), which provided a basis for investigating the
question of citywide scenarios of mode shift in which modes are
analogous to species. Dirichlet regression is a recently developed
technique for modelling proportions based on a range of dependent
variables (Maier
2014).

# Estimates of rates of shift towards walking and cycling down to route network levels

# Simulating the impacts citywide

Scenario development accounting for the transport systems in Accra and
Kathmandu, as part of UHI project activities, must be based on current
transport data. An overview for Ghana (a proxy for the travel pattern in
Accra) is shown
below.

<img src="../figures/modes-ghana-work.png" width="50%" /><img src="../figures/modes-ghana-work-simple.png" width="50%" />

# References

<div id="refs" class="references">

<div id="ref-douma_analysing_2019">

Douma, Jacob C., and James T. Weedon. 2019. “Analysing Continuous
Proportions in Ecology and Evolution: A Practical Introduction to Beta
and Dirichlet Regression.” *Methods in Ecology and Evolution* 10 (9):
1412–30. <https://doi.org/10.1111/2041-210X.13234>.

</div>

<div id="ref-lovelace_propensity_2017">

Lovelace, Robin, Anna Goodman, Rachel Aldred, Nikolai Berkoff, Ali
Abbas, and James Woodcock. 2017. “The Propensity to Cycle Tool: An Open
Source Online System for Sustainable Transport Planning.” *Journal of
Transport and Land Use* 10 (1). <https://doi.org/10.5198/jtlu.2016.862>.

</div>

<div id="ref-maier_dirichletreg_2014">

Maier, Marco J. 2014. “DirichletReg: Dirichlet Regression for
Compositional Data in R.” 125. Department of Statistics and Mathematics,
WU Vienna.

</div>

</div>
