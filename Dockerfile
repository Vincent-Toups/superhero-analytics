FROM rocker/verse
MAINTAINER Vincent Toups <toups@email.unc.edu>
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('gbm')"
RUN apt update && apt-get install emacs
