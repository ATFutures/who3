FROM rocker/geospatial
RUN install2.r shiny pct shinyjs dodgr stplanr osmdata
RUN R -e "devtools::install_github('atfutures-labs/upthat')"
RUN export ADD=shiny && bash /etc/cont-init.d/add