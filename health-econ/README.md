## Background - the WHO Health and Economic Assessment Tool (HEAT)

HEAT main website is
[heatwalkingcycling.org](https://www.heatwalkingcycling.org). The impact
of physical activity is described
[here](https://www.heatwalkingcycling.org/#how_does_PA_work), the
calculation of mortality
[here](https://www.heatwalkingcycling.org/#impact_calculation), the
effects of exposure to air pollution
[here](https://www.heatwalkingcycling.org/#how_does_AP_work), and
default values used in the tool are
[here](https://www.heatwalkingcycling.org/#generic_data).

### Physical Activity

The assumed relative reduction in risk for walking if 0.886, giving an
effect for walking a certain distance under a given scenario of

0.114 \* d-scenario / d-reference

Risk reduction for walking is capped at 30%.

### Exposure

  - Each increment of +10 ug/m^3 increases all-cause mortality risk by
    1.07
  - But only up to 50ug/m^3, beyond which no further increases occur
  - Increase in exposure for walking is assumed to be a factor of 1.6

## Some Stats from, or useful for, Accra

Background mortality for HEAT is taken from the [WHO mortality
database](http://apps.who.int/healthinfo/statistics/mortality/whodpms).
This is difficult to access, so the table for all available counties is
included here, giving the following global average value:

    #> global mortality = 0.00742570824543746

Population from wikipedia is 2.27 million

### Air pollution

An article on [air pollution in sub-Saharan African
cities](https://link.springer.com/article/10.1007%2Fs11869-013-0199-6)
has an appendix
[here](https://static-content.springer.com/esm/art%3A10.1007%2Fs11869-013-0199-6/MediaObjects/11869_2013_199_MOESM1_ESM.docx)
that includes figures for Accra from [this
paper](https://pubs.acs.org/doi/10.1021/es903276s). That estimates
average PM2.5 concentrations throughout the year *apart from* Dec-Jan,
when dust blows in from the Sahara, of 39-53ug/m^3 at roadside sites,
and 30-70ug/m^3 at residential sites. Across the whole year, average
values at roadside sites were 80-108ug/m^3, and at residential sites
57-106ug/m^3.

The paper helpfully simply states that PM2.5 concentrations at roadside
sites were 8-14ug/m^3 higher at roadside than at residential sites. This
suggests we can assume a background value of 35ug/m^3, with road-borne
emissions adding another 14ug/m^3 at the highest vehicular intensities.

### Walking statistics

Taken from the data previously shared by WHO

Trips to school: 63.7% walk, and 15.3 take trotro Trips to healthcare:
58% walk, 36% take taxis or trotros Trips to work (male+female): 47.4%
walk, 19% trotro

Accra distance to nearest market (km):

| \<1  | 1.1-2 | 2.1-3 | 3.1-6 | 6.1-10 |
| ---- | ----- | ----- | ----- | ------ |
| 27.3 | 21.2  | 6.1   | 42.4  | 3.0    |

Trips per day on foot

| 0-10 | 11-20 | 21-30 | 31-40 | 41-60 | 61-100 | \> 100 |
| ---- | ----- | ----- | ----- | ----- | ------ | ------ |
| 64.0 | 20.4  | 6.2   | 2.9   | 3.4   | 0.7    | 0.0    |

Distance from home to trotro

| 0-0.5 | 0.6-1 | 1.1-2 | 2.1-5 | \> 5 |
| ----- | ----- | ----- | ----- | ---- |
| 83.2  | 11.9  | 2.3   | 0.5   | 2.2  |

Mode of transport to nearest food shop: walk = 93% Mode of transport to
nearest other shop: walk = 78.2%, trotro = 15.8%

These can be used to derive an average weekly distance walked, according
to the following steps. First, presume that trips to work are same as
trips to markets:

    #> Average distance to work = 1.411 km

number of walking trips per day:

    #> Number of walking trips per day = 11.253 or per week = 78.771

Then presume that weekly trips consist of 2-3 visits to a market, 2.5
trips to work per person, and the remainder over distances typical of
walks to trotro stops. This gives a total weekly average distance of:

    #> Average reference weekly distance walked = 47.21 km

… and that is well beyond the HEAT-assumed baseline value of 14.84, but
their value is taken primarily from cities of the global North, not ones
in which almost all trips are made on foot.

## Scenarios

The following calculations give the effective increase in distance
walked per week in response to a relative increase of `mode_incr` - in
other words, a mode shift of that amount towards walking, and presumably
away from other modes. This is also translated, using standard HEAT
values along with the global average mortality rate, into an estimate of
reduction in mortality in Accra.
<img src="figures/mode_shift-1.png" width="100%" />

Increased walking also increases exposure to pollutants, with the
following code quantifying those effects in the same way as HEAT. If
`rel_exp` is anything other than the default value, then the particular
values for Accra are used instead, which translate to a multiple for
increased exposure during walking of 1.31 instead of 1.6 (because
background pollution in Accra is so high to begin with).

<img src="figures/exposure-1.png" width="100%" />
