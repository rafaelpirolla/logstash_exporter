ARG GO_VERSION=1.17.7
ARG ALPINE_VERSION=3.15
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

ARG username
ARG USER_UID=1000
ARG USER_GID=1000

RUN adduser $username -s /bin/sh -D -u $USER_UID $USER_GID && \
    mkdir -p /etc/sudoers.d && \
    echo $username ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$username && \
    chmod 0440 /etc/sudoers.d/$username

RUN export https_proxy=$https_proxy && apk add -q --update --progress --no-cache git sudo openssh-client fish build-base

RUN go install -v golang.org/x/tools/gopls@latest
RUN go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
RUN go install github.com/ramya-rao-a/go-outline@latest
RUN go install github.com/cweill/gotests/gotests@latest
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/josharian/impl@latest
RUN go install github.com/haya14busa/goplay/cmd/goplay@latest
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

USER $username

ENV EDITOR=vi 
ENV LANG=en_US.UTF-8

USER root
