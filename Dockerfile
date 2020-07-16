FROM golang:1.13.3-stretch as builder

# Username and password to use basic auth and download the repo.
# Recommend using engbot for this
ARG NIGHTFALL_GITHUB_USER
ARG NIGHTFALL_GITHUB_PASS
# Verify GIT_USER and GIT_PASS were passed in as arguments
RUN test -n "$NIGHTFALL_GITHUB_USER"
RUN test -n "$NIGHTFALL_GITHUB_PASS"