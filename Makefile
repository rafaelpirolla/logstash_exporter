PROMU           ?= $(GOPATH)/bin/promu
GOLINTER        ?= $(GOPATH)/bin/golangci-lint
pkgs            = $(shell go list ./... | grep -v /vendor/)
TARGET          ?= logstash_exporter

PREFIX          ?= $(shell pwd)
BIN_DIR         ?= $(shell pwd)

all: clean format vet golangci-lint build test

test:
	@echo ">> running tests"
	@go test -short $(pkgs)

format:
	@echo ">> formatting code"
	@go fmt $(pkgs)

golangci-lint: $(GOLINTER)
	@echo ">> linting code"
	@$(GOLINTER) run

build: $(PROMU)
	@echo ">> building binaries"
	@$(PROMU) build --prefix $(PREFIX)

clean:
	@echo ">> Cleaning up"
	@find . -type f -name '*~' -exec rm -fv {} \;
	@rm -fv $(TARGET)

$(GOPATH)/bin/promu promu:
	@GOOS=$(shell uname -s | tr A-Z a-z) \
		GOARCH=$(subst x86_64,amd64,$(patsubst i%86,386,$(shell uname -m))) \
		go install -v github.com/prometheus/promu@latest

$(GOPATH)/bin/golangci-lint lint:
	@GOOS=$(shell uname -s | tr A-Z a-z) \
		GOARCH=$(subst x86_64,amd64,$(patsubst i%86,386,$(shell uname -m))) \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2

.PHONY: all format vet build test promu clean $(GOPATH)/bin/promu $(GOPATH)/bin/golangci-lint lint
