FROM golang:1.13.3-stretch as builder

# Username and password to use basic auth and download the repo.
# ARG NIGHTFALL_GITHUB_USER
# ARG NIGHTFALL_GITHUB_PASS
# ARG git_user
ARG GIT_USER
ARG GIT_PASS
ARG JOSH_TEST
ARG just_a_test
ARG DOCKER_TEST
# ARG GITHUB_WORKFLOW
#RUN printenv
# RUN echo "this is a giant test"
# RUN echo ${GITHUB_WORKFLOW}
# RUN echo $GITHUB_WORKFLOW
# RUN echo "$GITHUB_WORKFLOW"
RUN echo $JOSH_TEST
RUN echo $DOCKER_TEST
RUN echo "$DOCKER_TEST"

# RUN test -n "$JOSH_TEST"
RUN echo "HELLO THERE ------------"
RUN echo "$just_a_test"

# no need to set WORKDIR as github actions already do that
WORKDIR /projects/
# Verify username/pass args were passed in
#RUN test -n "$GIT_USER"
#RUN test -n "$GIT_PASS"
#RUN git clone https://$GIT_USER:$GIT_PASS@github.com/watchtowerai/nightfall_dlp.git
