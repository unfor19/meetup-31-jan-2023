#!make
.ONESHELL:
.EXPORT_ALL_VARIABLES:
.PHONY: all $(MAKECMDGOALS)

UNAME := $(shell uname)

# Windows
ifneq (,$(findstring NT, $(UNAME)))
_OS:=windows
BASH_PATH:=/usr/bin/bash

else
# macOS/iOS
ifneq (,$(findstring Darwin, $(UNAME)))
_OS=macos
BASH_PATH=/bin/bash
else
#Linux
ifneq (,$(findstring Linux, $(UNAME)))
_OS=linux
BASH_PATH=/bin/bash
else
# Any other OS
@echo "Could not identify OS - '$(UNAME)'"
exit 1
endif
endif
endif

# Set default shell to `bash` instead of `sh`
SHELL=${BASH_PATH}


ROOT_DIR=${PWD}
APP_DIR_NAME=quasar-project
APP_DIR_PATH=${ROOT_DIR}/${APP_DIR_NAME}
ifneq ("$(wildcard ${ROOT_DIR}/.env)","")
include ${ROOT_DIR}/.env
endif

ifeq (${CI},true)
unexport AWS_PROFILE
endif

ifndef GIT_BRANCH
GIT_BRANCH:=$(shell git branch --show-current)
endif
GIT_BRANCH_SLUG:=$(subst /,-,$(GIT_BRANCH))

# Removes blank rows - fgrep -v fgrep
# Replace ":" with "" (nothing)
# Print a beautiful table with column
help: ## Available make commands
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's~:.* #~~' | column -t -s'#'
	@echo
	
usage: help         


install-global-dependencies:
	yarn global add @quasar/cli


install-dependencies:
	cd ${APP_DIR_PATH} && yarn install


lint:
	cd ${APP_DIR_PATH} && yarn lint


build:
	cd ${APP_DIR_PATH} && quasar build


run:
	cd ${APP_DIR_PATH} && quasar dev
