Project 1 Bios 611
==================
Superhero Powers Dataset
------------------------

This repo will eventually contain an analysis of the Superhero Powers Dataset.

Usage
-----

You'll need Docker and the ability to run Docker as your current user.

You'll need to build the container:

    > docker build . -t project1-env

This Docker container is based on rocker/verse. To run rstudio server:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
      -e PASSWORD=mypassword -t project1-env
      
Then connect to the machine on port 8787.

If you are cool and you want to run this on the command line:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; R"
    
Or to run Bash:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"

Makefile
========

The Makefile is an excellent place to look to get a feel for the project.

To build figures relating to the distribution of super powers over
gender, for example, enter Bash either via the above incantation or
with Rstudio and say:

    > make figures/gender_power_comparison.png 
    
