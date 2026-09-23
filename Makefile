# Makefile — atajos para instalar y mantener la configuración de Neovim
#
#   make install  → instala (symlink + plugins)
#   make sync     → re-sincroniza los plugins
#   make update   → git pull + re-sincroniza plugins
#   make help     → muestra todos los targets

REPO := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: install sync update info help

install: ## Instala la configuración y los plugins (primera vez)
	./install.sh

sync: ## Re-sincroniza los plugins (instala/actualiza/borra según la lista)
	nvim --headless "+Lazy! sync" +qa

update: ## Actualiza este repo (git pull) y re-sincroniza los plugins
	git -C "$(REPO)" pull
	nvim --headless "+Lazy! sync" +qa

info: ## Muestra información del entorno
	@echo "Repo:   $(REPO)"
	@echo "Config: $(HOME)/.config/nvim"
	@nvim --version | head -n 1

help: ## Muestra esta ayuda
	@grep -h -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ".*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'