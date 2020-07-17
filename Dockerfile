FROM golang:1.13.3-stretch as builder

# Username and password to use basic auth and download the repo.
# ARG NIGHTFALL_GITHUB_USER
# ARG NIGHTFALL_GITHUB_PASS
ARG GIT_USER
ARG GIT_PASS
ARG JOSH_TEST

RUN echo $JOSH_TEST

# no need to set WORKDIR as github actions already do that
# WORKDIR /projects/
# Verify username/pass args were passed in
# RUN test -n "$NIGHTFALL_GITHUB_USER"
# RUN test -n "$NIGHTFALL_GITHUB_PASS"
RUN git clone https://$GIT_USER:$GIT_PASS@github.com/watchtowerai/nightfall_dlp.git
