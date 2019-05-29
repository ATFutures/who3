<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

This document sets out a plan for the third phase of work for the WHO on
the topic of urban and transport planning from a health perspective.
**The main output will be a prototype web tool that shows scenarios of
change at a city level, down to the street level.**

The work will build on previous projects funded by the WHO (in grants
2017/773067 and 2017/773067-0), which resulted in an online interactive
tool, with the working title “Active Transport Tool” (ATT) (Lovelace et
al. 2018). The ATT can be used for many purposes related to the
interface between transport and human health, including assessment of
exposure to air pollution, changes in the distribution of physical
activity, and the spatial distribution of cycling and pedestrian flow
densities. These flow densities — quantified as relative densities of
bi-directional movement along each segment of the urban street network —
were calculated for a number of “layers” reflecting distinct journey
purposes and modes.

The driving aim of this project across all stages will be to create of a
*flexible framework* for analyzing, visualizing and testing a range of
scenarios based on different input datasets and parameters, and to
ensure the framework is able to be updated and modified at any stage
within or beyond the project timetable as desired.

This work will go beyond the Propensity to Cycle Tool (PCT) project
(Lovelace et al. 2017), which has become a part of legally binding
legislation and is being used by dozens of transport planning
organizations around the UK. The longer term aim is to create a globally
scalable tool for sustainable transport planning.

# Deliverables

The main output will be stable, online web tool that is feature-rich and
available for testing during the project. The tool will initially be
developed for Accra and Kathmandu, but provision will be built-in to
scale the tool to other locations.

<!-- Completion of health impact analysis in the scenarios of change, including based on the VSL methodology. This can build on WHO work Andreas Santos -->

The primary deliverables will be:

1.  A core codebase for the processing and integration of data from
    OpenStreetMap, WorldPop, and local sources in order to estimate
    baseline active transport levels at the route network levels
2.  A default user interface for people to explore the transport system
    at the city level, available via our prototype online app (see
    below).
3.  Plausible scenarios of change, including:
      - A global, citywide scenario of uptake of active transport, as a
        result of citywide policies to promote walking and cycling. This
        would use baseline levels of walking and cycling from the global
        south as a reference, and an uptake scenario such as Go Dutch
        for cycling.
      - A global, citywide scenario of multi-modal tranpsort change,
        showing reduced levels of driving following disincentives to own
        and use cars.
      - A global scenario of public transport uptake, linked to
        [SDG 11](https://sustainabledevelopment.un.org/sdg11).
      - Locally specific scenarios, such as creation of car-free zones
        or reductions in car parking spaces.
4.  Health impacts: estimates of the health impacts of increased
    physical activity associated with changing transport behaviour under
    these scenarios, including integration of the primary outputs with
    HEAT.
    <!--- A customised service for different cities with different scenarios, user interface options (e.g. with specific modes, such as minibus, available in different places). This would include an adaptation guide.-->
5.  A user manual which will provide information on every aspect of the
    user interface
6.  An adaptation manual which will provide additional information on
    how the tool may be adapted to particular local circumstances,
    desires, or future visions.

# Methods

This section briefly describes the methods that will be derived and
implemented to generate the above deliverables.

1.  **Codebase** The codebase will extend directly from code developed
    during the first two phases, resulting in an integrated system built
    on several primary modules for extracting and integrating the
    various sources of data.
2.  **Prototype App** The prototype app will be set-up and served from a
    stable web location, and will be maintained for the duration of the
    project.
3.  **Scenarios** \<TODO\>
4.  **Health Impacts** \<TODO\>
5.  **User Manual** \<TODO\>
6.  **Adaptation Manual** \<TODO\>

<!-- - Reproduce results from phase 2 - Mark and Robin -->

  - Scenario development <!-- Robin -->
  - Health output calculations - heat integration <!-- Mark -->
  - User interface updates
  - User manual
  - Adaptation document <!-- Could be a vignette inside an R package -->
  - Set-up server and deploy to atfutures.github.io (in the first
    instance)

## Automation

# Resources and timeline

## Gantt chart

# References

<div id="refs" class="references">

<div id="ref-lovelace_estimating_2018">

Lovelace, R, N Groot, M Adepeju, and M Padgham. 2018. “Estimating
Cycling Potential on Route Networks in Accra and Kathmandu.” World
Health Organization.

</div>

<div id="ref-lovelace_propensity_2017">

Lovelace, Robin, Anna Goodman, Rachel Aldred, Nikolai Berkoff, Ali
Abbas, and James Woodcock. 2017. “The Propensity to Cycle Tool: An Open
Source Online System for Sustainable Transport Planning.” *Journal of
Transport and Land Use* 10 (1). <https://doi.org/10.5198/jtlu.2016.862>.

</div>

</div>
