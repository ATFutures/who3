

docker run --rm -p 3838:3838 \
    -v /mnt/57982e2a-2874-4246-a6fe-115c199bc6bd/atfutures/shinyapps/:/srv/shiny-server/ \
    -v /mnt/57982e2a-2874-4246-a6fe-115c199bc6bd/atfutures/shinylog/:/var/log/shiny-server/ \
    rocker/shiny

sudo chown $USER ../shinyapps

wget https://github.com/rstudio/shiny-examples/archive/master.zip
unzip master.zip
ls shiny-examples-master/001*  

ls -hal ../shinyapps
mv -v shiny-examples-master/001*  ../shinyapps
mv -v shiny-examples-master/002*  ../shinyapps
mv -v shiny-examples-master/003*  ../shinyapps

# next step: container admin with docker attach
