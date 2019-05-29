

# docker run --rm -d 3838:3838 \ 
docker run --rm -p 3838:3838 \
    -e PASSWORD=<YORPASS> \
    -v /mnt/57982e2a-2874-4246-a6fe-115c199bc6bd/atfutures/shinyapps/:/srv/shiny-server/ \
    -v /mnt/57982e2a-2874-4246-a6fe-115c199bc6bd/atfutures/shinylog/:/var/log/shiny-server/ \
    atfutures/pct:v0.0.1

sudo chown $USER ../shinyapps
sudo chown $USER ../shinylogs

wget https://github.com/rstudio/shiny-examples/archive/master.zip
unzip master.zip
ls shiny-examples-master/001*  
ls shiny-examples-master/ | grep map

ls -hal ../shinyapps
mv -v shiny-examples-master/001*  ../shinyapps
mv -v shiny-examples-master/002*  ../shinyapps
mv -v shiny-examples-master/003*  ../shinyapps

mkdir ../shinyapps/att
cp exampleLeafletApp.R ../shinyapps/att/app.R

# next step: container admin with docker attach
docker exec -it competent_yonath /bin/bash

R
install.packages("leaflet")
q()

# sudo -i
# sudo systemctl restart shiny-server
# # sudo systemctl restart shiny-server
# stop shiny-server
exit

# see https://github.com/rocker-org/rocker/issues/235
docker build pct -t atfutures/pct:v0.0.1

cp -Rv ~/hd/npct/pct-shiny/ ../shinyapps/

# mkdir -p ../shinyapps/pct-outputs-regional-R/commute/msoa/
# cp -Rv ~/hd/npct/pct-outputs-regional-R/ ../shinyapps/
