FROM golang:1.13.3-stretch as builder

# Username and password to use basic auth and download the repo.
ARG NIGHTFALL_GITHUB_USER
ARG NIGHTFALL_GITHUB_PASS
# Verify username/pass args were passed in
RUN test -n "$NIGHTFALL_GITHUB_USER"
RUN test -n "$NIGHTFALL_GITHUB_PASS"
