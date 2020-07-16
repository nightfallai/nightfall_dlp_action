FROM golang:1.13.3-stretch as builder

RUN apt-get install make

# Username and password to use basic auth and download the repo.
# Recommend using engbot for this
ARG GIT_USER
ARG GIT_PASS
# Verify GIT_USER and GIT_PASS were passed in as arguments
RUN test -n "$GIT_USER"
RUN test -n "$GIT_PASS"
# Rewrite url to use basic auth from arguments passed in
RUN git config --global url."https://$GIT_USER:$GIT_PASS@github.com/".insteadOf "https://github.com/"

WORKDIR /projects/nightfall_dlp

COPY Makefile go.mod go.sum ./
RUN make deps

# Install GolangCI-Lint
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.23.6
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v0.9.15

COPY . .
