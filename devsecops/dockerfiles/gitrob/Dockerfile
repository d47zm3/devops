FROM golang:1.10.3

LABEL maintainer="d47zm3@gmail.com"
LABEL image_name="security-tools:gitrob"

RUN apt update &&\
    apt -y install git

RUN go get github.com/michenriksen/gitrob

