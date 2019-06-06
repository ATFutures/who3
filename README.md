
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

This document sets out a plan for the third phase of work for the WHO’s
Urban Health Initiative, and the ongoing development of an “Active
Transport Tool” (ATT; Lovelace et al. 2018). **The main output will be a
prototype web tool – the ATT – to enable interactive viewing of current
patterns of active transport and associated health impacts, as well as
the effects of scenarios of change.** The work will build on previous
projects funded by the WHO (in grants 2017/773067 and 2017/773067-0).
The ATT can be used for many purposes related to the interface between
transport and human health, including assessment of exposure to air
pollution, changes in the distribution of physical activity, and the
spatial distribution of cycling and pedestrian flow densities. These
flow densities — quantified as relative densities of bi-directional
movement along each segment of the urban street network — are calculated
for a number of “layers” reflecting distinct journey purposes and modes.

The driving aim of this project across all stages will be to create of a
*flexible framework* for analyzing, visualizing and testing a range of
scenarios based on different input datasets and parameters, and to
ensure the framework is able to be updated and modified at any stage
within or beyond the project timetable as desired. This work will go
beyond the Propensity to Cycle Tool (PCT) project (Lovelace et al.
2017), which has become a part of legally binding legislation and is
being used by dozens of transport planning organizations around the UK.
The longer term aim is to create a globally scalable tool for
sustainable transport planning.

# Methods

The third stage of this project will proceed through seven
methodological phases:

1.  **Analytic Methods and Software** Phase II resulted in a prototype
    ATT representing patterns of active travel in Accra only. This third
    Phase will apply all previous analyses to Kathmandu, thereby
    consolidating code and ensuring transferability between locations.

2.  **Health Impacts** The primary outputs of the ATT in current form
    are metrics of mobility (densities of movement along street segments
    for a range of journey purposes, modes of transport, and demographic
    factors). This second phase will translate these outputs into
    health-economic terms, primarily relying on the calibrated values
    used in the WHO’s HEAT. The primary aim of this translation in to
    health impacts will be to enable comparison of scenarios under the
    fourth point below in health-economic terms, although we will also
    investigate the feasibility of using locally-provided data to
    calibrate a static HEAT model.

3.  **Prototype App** Concurrent with the preceding two phases, the
    prototype app will be set-up and served from a stable web location,
    and will be maintained for the duration of the project.

4.  **Scenarios** \<TODO: RL\>

5.  **Health Impacts of Scenarios** The output of the previous phase
    will be combined with those of the second phase to enable comparison
    of scenarios in terms of their impact on health-economic measures.

6.  **User Manual** Final phases of this project stage will yield a user
    manual able to be taken to the study cities of Accra and Kathmandu,
    to enable local stakeholders to understand, utilise, and provide
    feedback on the tool. As stated above, the tool itself will be
    web-based, and this usual manual will presume as little computer
    expertise as possible, and should be intelligible to an entirely
    general audience.

7.  **Adaptation Manual** Finally, we will also develop an “Adaptation
    Manual” serving the dual purpose of describing
    
    1)  How an ATT may be adapted and applied to other, additional
        locations; and in doing so,
    2)  How the ATT as presented to each location may be adapted and
        modified following feedback from local stakeholders.
    
    This manual will detail in general, non-technical terms, the nature
    of inputs, analytic processes, and resultant outputs, to enable
    stakeholders to readily identify modifications that might ultimately
    provide outputs better suited to local needs, desires, and future
    visions.

# Deliverables

The primary deliverables extending from each of the above phases will
be:

1.  **Analytic Methods and Software** This phase will not produce any
    concrete deliverables, but will provide for both cities the
    necessary input data to allow the development of individually
    adapted ATT.
2.  **Health Impacts** This phase will enable ATT output to be expressed
    in health-economic terms. As the third phase will be conducted
    concurrently with these first two, the output of this phase will be
    directly viewable in the ATT.
3.  **Prototype App** The single deliverable of this phase will be the
    ATT, for which both cities will be able to be selected, and a
    variety of ATT outputs viewed.
4.  **Scenarios** \<TODO: RL\> Plausible scenarios of change, including:
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
5.  **Health Impacts of Scenarios** This phase will extend the App to
    include the ability to select and compare scenarios, in terms both
    of changes in mobility patterns as well as associated health and
    economic terms.
6.  **User and Adaptation Manuals** The final two phases will deliver
    both the User and Adaptation manuals for the ATT.

# Resources and timeline

## Gantt chart

    #> 8 issues returned for the repo who3
    #> TypeError: Attempting to change the setter of an unconfigurable property.
    #> TypeError: Attempting to change the setter of an unconfigurable property.

![](README_files/figure-gfm/gantt-1.png)<!-- -->

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
