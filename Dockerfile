FROM rocker/verse
MAINTAINER Vincent Toups <toups@email.unc.edu>
RUN R -e "install.packages('gridExtra')"
