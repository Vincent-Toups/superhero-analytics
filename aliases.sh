# handy aliases for working with the docker file
# and doing other stuff

alias bu='docker build . -t project1-dev --build-arg linux_user_pwd=not_important'
alias hc='docker run -p 8711:8000 -v `pwd`:/host -it project1-dev hovercraft /host/slides.rst'
alias hcb='docker run -v `pwd`:/host -it project1-dev hovercraft /host/slides.rst /host/html_presentation'

alias r='docker run -v `pwd`:/home/rstudio -e PASSWORD=not_important -it project1-dev sudo -H -u rstudio /bin/bash -c "cd ~/; R"'
