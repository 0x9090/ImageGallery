#!make
.DEFAULT_GOAL := clean build run
EXECUTABLE=ImageGallery
ifeq ($(OS), Windows_NT)
PS=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
GO=C:\Program Files\Go\bin\go.exe
NODE=C:\Program Files\nodejs
export PATH:=$(NODE);$(PATH)
else
GO=$(which go)
NPX=$(which npx)
NPM=$(which npm)
NODE=$(which node)
endif

install:
	npm install package.json

build:
	npx webpack --config src/typescript/webpack.config.js
ifeq ($(OS), Windows_NT)
	IF EXIST target\ del /F /Q target\*
	$(GO) build -o target\$(EXECUTABLE).exe main.go
else
	rm -f target/*
	go build -o target/$(EXECUTABLE) main.go
endif

clean:
ifeq ($(OS), Windows_NT)
	$(PS) Remove-Item *.out -Force -Recurse -ErrorAction SilentlyContinue
	$(PS) Remove-Item $(EXECUTABLE)*.exe -Force -Recurse -ErrorAction SilentlyContinue
	$(PS) Remove-Item yarn*.lock -Force -Recurse -ErrorAction SilentlyContinue
	IF EXIST target\ del /F /Q target\*
	$(GO) clean
else
	rm -f target/*
	rm -rf *.out ||:
	go clean
endif

test:
	$(which golangci-lint) run --enable-all
	$(GO) test

run:
ifeq ($(OS), Windows_NT)
	target/$(EXECUTABLE).exe
else
	./target/$(EXECUTABLE)
endif