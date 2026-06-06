.DEFAULT_GOAL := help

COMPOSE  = docker compose
EXEC     = $(COMPOSE) exec app
BUNDLE   = $(EXEC) bundle exec

##@ Setup
.PHONY: setup
setup: ## Sobe containers, instala gems e prepara banco
	$(COMPOSE) build
	$(COMPOSE) up -d
	sleep 5
	$(BUNDLE) rails db:prepare

.PHONY: build
build: ## Reconstrói a imagem Docker
	$(COMPOSE) build --no-cache

##@ Execução
.PHONY: up
up: ## Sobe todos os containers em background
	$(COMPOSE) up -d

.PHONY: down
down: ## Derruba todos os containers
	$(COMPOSE) down

.PHONY: restart
restart: down up ## Reinicia todos os containers

.PHONY: logs
logs: ## Exibe logs da app em tempo real
	$(COMPOSE) logs -f app

##@ Rails
.PHONY: console
console: ## Abre o Rails console
	$(BUNDLE) rails console

.PHONY: routes
routes: ## Lista todas as rotas
	$(BUNDLE) rails routes

.PHONY: migrate
migrate: ## Roda migrations pendentes
	$(BUNDLE) rails db:migrate

.PHONY: rollback
rollback: ## Reverte última migration
	$(BUNDLE) rails db:rollback

.PHONY: seed
seed: ## Roda seeds
	$(BUNDLE) rails db:seed

.PHONY: reset-db
reset-db: ## Drop + Create + Migrate + Seed
	$(BUNDLE) rails db:reset

##@ Qualidade
.PHONY: test
test: ## Roda todos os specs
	$(COMPOSE) run --rm test

.PHONY: test-file
test-file: ## Roda spec específico. Ex: make test-file FILE=spec/models/item_spec.rb
	$(EXEC) bundle exec rspec $(FILE)

.PHONY: lint
lint: ## Roda RuboCop
	$(BUNDLE) rubocop

.PHONY: lint-fix
lint-fix: ## Roda RuboCop com autocorrect
	$(BUNDLE) rubocop -A

##@ Utilitários
.PHONY: bash
bash: ## Abre shell no container da app
	$(EXEC) bash

.PHONY: ps
ps: ## Lista containers rodando
	$(COMPOSE) ps

.PHONY: help
help: ## Exibe esta ajuda
	@awk 'BEGIN {FS = ":.*##"; printf "\nUso: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
