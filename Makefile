NODE=$(shell which node 2> /dev/null)
NPM=$(shell which npm 2> /dev/null)
YARN=$(shell which yarn 2> /dev/null)
JQ=$(shell which jq 2> /dev/null)

PKM?=$(if $(YARN),$(YARN),$(shell which npm))

BABEL=./node_modules/.bin/babel
COVERALLS=./node_modules/coveralls/bin/coveralls.js
REMOTE="git@github.com:reactjs/react-modal"
CURRENT_VERSION:=$(shell jq ".version" package.json)
COVERAGE?=true


BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
CURRENT_VERSION:=$(shell jq ".version" package.json)

VERSION:=$(if $(RELEASE),$(shell read -p "Release $(CURRENT_VERSION) -> " V && echo $$V), "HEAD")

help: info
	@echo
	@echo "Current version: $(CURRENT_VERSION)"
	@echo
	@echo "List of commands:"
	@echo
	@echo "  make info             - display node, npm and yarn versions..."
	@echo "  make deps             - install all dependencies."
	@echo "  make serve            - start the server."
	@echo "  make tests            - run tests."
	@echo "  make tests-single-run - run tests (used by continuous integration)."
	@echo "  make coveralls        - show coveralls."
	@echo "  make lint             - run lint."
	@echo "  make docs             - build and serve the docs."
	@echo "  make build            - build project artifacts."
	@echo "  make publish          - build and publish version on npm."
	@echo "  make publish-docs     - build the docs and publish to gh-pages."
	@echo "  make publish-all      - publish version and docs."

info:
	@[[ ! -z "$(NODE)" ]] && echo node version: `$(NODE) --version` "$(NODE)"
	@[[ ! -z "$(PKM)" ]] && echo $(shell basename $(PKM)) version: `$(PKM) --version` "$(PKM)"
	@[[ ! -z "$(JQ)" ]] && echo jq version: `$(JQ) --version` "$(JQ)"

deps: deps-project deps-docs

deps-project: 
	@$(PKM install)

deps-docs:
	@pip install --user mkdocs mkdocs-material jsx-lexer

# Rules for development
serve:
	@npm start

tests:
	@npm run test

tests-single-run:
	@npm run test -- --single-run

coveralls:
	-cat ./coverage/lcov.info | $(COVERALLS) 2>/dev/null

lint:
	@npm run lint

docs: build-docs
	mkdocs serve