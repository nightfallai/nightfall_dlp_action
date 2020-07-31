FROM golang:1.13.3-stretch as builder

ARG NIGHTFALL_DLP_RELEASE="v0.0.2"

# create /projects and install DLP repo there
WORKDIR /projects
RUN git clone --branch $NIGHTFALL_DLP_RELEASE https://github.com/nightfallai/jenkins_test.git

# navigate to the nightfalldlp repo and install it to $GOPATH/bin/nightfalldlp
WORKDIR /projects/jenkins_test
RUN go mod download
RUN go install -v ./cmd/nightfalldlp

# mount the $GOPATH dir onto our docker container so we have access to the nightfalldlp executable
# we installed
VOLUME $GOPATH

# pull in & run our entrypoint shell script
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

