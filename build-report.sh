#!/bin/bash

Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"
mkdir -p tagged_reports/

CLEAN_P=`git status | grep no\ changes\ added | grep working\ tree\ clean`

if ["$CLEAN_P" == "nothing to commit, working tree clean"]; then
    echo Creating a commit tagged report.
    cp report.pdf tagged_reports/`git log -1 | head -n 1| cut -d' ' -f2`-report.pdf
else
    echo Working copy not pristine, not creating a tagged report.
fi


