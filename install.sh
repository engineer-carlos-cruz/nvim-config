#!/usr/bin/env bash
#
# install.sh — Instala esta configuración de Neovim
#
# Qué hace:
#   1. Comprueba que Neovim esté instalado y su versión sea ≥ 0.11.
#   2. Crea el symlink ~/.config/nvim → este repositorio.
#   3. Abre Neovim en modo "headless" para que lazy.nvim instale los plugins.
#
# Uso:
#   ./install.sh
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config/nvim"

say()  { printf '\033[1;32m✔\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m⚠\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m✖\033[0m %s\n' "$*"; }

# ---------- 1. ¿Existe Neovim? ¿Versión suficiente? ----------
if ! command -v nvim >/dev/null 2>&1; then
  err "Neovim no está instalado."
  echo "   Instálalo primero (ver base.md). La guía de instalación manual"
  echo "   del binario está en update.md."
  exit 1
fi

NVIM_VERSION="$(nvim --version | head -n 1)"
NVIM_MINOR="$(nvim --version | sed -n 's/^NVIM v0\.\([0-9]*\).*/\1/p' | head -n 1)"
say "Neovim encontrado: ${NVIM_VERSION}"
if [ -z "${NVIM_MINOR}" ] || [ "${NVIM_MINOR}" -lt 11 ]; then
  err "Esta configuración necesita Neovim ≥ 0.11 (usa vim.lsp.enable())."
  echo "   Actualiza el binario siguiendo update.md y vuelve a intentarlo."
  exit 1
fi

# ---------- 2. Symlink a ~/.config/nvim ----------
if [ ! -d "${HOME}/.config" ]; then
  mkdir -p "${HOME}/.config"
fi

if [ -L "${CONFIG_DIR}" ]; then
  say "Symlink ya existente: ${CONFIG_DIR} → $(readlink "${CONFIG_DIR}")"
elif [ -d "${CONFIG_DIR}" ]; then
  warn "${CONFIG_DIR} ya existe y NO es un symlink."
  read -r -p "   ¿Borrarlo y enlazarlo a este repo? (se perderá esa config) [y/N] " resp
  if [[ "${resp}" =~ ^[Yy]$ ]]; then
    rm -rf "${CONFIG_DIR}"
  else
    err "Abortado. Instala manualmente: ln -s \"${REPO_DIR}\" \"${CONFIG_DIR}\""
    exit 1
  fi
fi

if [ ! -L "${CONFIG_DIR}" ]; then
  ln -s "${REPO_DIR}" "${CONFIG_DIR}"
fi
say "Config enlazada: ${CONFIG_DIR} → ${REPO_DIR}"

# ---------- 3. Instalar/actualizar los plugins (lazy.nvim) ----------
warn "El primer arranque descarga lazy.nvim y los plugins; tardará un poco."
nvim --headless "+Lazy! sync" +qa

# ---------- 4. Avisos de dependencias externas ----------
if ! command -v rg >/dev/null 2>&1; then
  warn "ripgrep no está instalado: Telescope 'buscar texto' (<leader>fg) fallará."
  echo "   Instálalo con: sudo apt install ripgrep   (o tu gestor de paquetes)"
fi

if ! command -v tree-sitter >/dev/null 2>&1; then
  warn "tree-sitter-cli no está instalado: los parsers de Treesitter no se compilarán."
  echo "   Los parsers de Neovim 0.12 se compilan con la CLI de tree-sitter (≥ 0.26.1):"
  echo "     - Descarga el binario: https://github.com/tree-sitter/tree-sitter/releases"
  echo "     - o con cargo:  cargo install tree-sitter-cli"
  echo "   Sin ello, el resto de la configuración funciona igual."
fi

echo ""
say "Instalación completada. Abre:  nvim"