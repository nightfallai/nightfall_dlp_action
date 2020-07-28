FROM golang:1.13.3-stretch as builder

ARG nightfall_dlp_release=v0.0.1

# create /projects and install DLP repo there
WORKDIR /projects
RUN git clone --branch $nightfall_dlp_release https://github.com/nightfallai/jenkins_test.git

# navigate to DLP repo and install it to $GOPATH/bin/nightfalldlp
WORKDIR /projects/jenkins_test
RUN go mod download
RUN go install -v ./cmd/nightfalldlp

# mount GOPATH dir so we have access to nightfalldlp executable
VOLUME $GOPATH

# pull in & run our entrypoint shell script
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

