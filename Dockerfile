FROM golang:1.13.3-stretch as builder

# Username and password to use basic auth and download the repo.
#ARG NIGHTFALL_GITHUB_USER
#ARG NIGHTFALL_GITHUB_PASS
#ARG NIGHTFALL_API_KEY
#
#RUN echo $NIGHTFALL_GITHUB_USER
RUN echo "---------- BREAK ----------"
RUN echo $NIGHTFALL_API_KEY
# Verify username/pass args were passed in
#RUN test -n "$NIGHTFALL_GITHUB_USER"
#RUN test -n "$NIGHTFALL_GITHUB_PASS"
RUN pwd && ls
WORKDIR /projects
RUN pwd && ls
RUN git clone https://github.com/nightfallai/jenkins_test.git

WORKDIR /projects/jenkins_test
RUN go mod download
RUN go build -o nightfalldlp -v ./cmd/nightfalldlp
RUN ./nightfalldlp
#RUN go -o nightfall_dlp -v ./cmd/nightfalldlp
#RUN go run ./nightfall_dlp/cmd/nightfalldlp/main.go
