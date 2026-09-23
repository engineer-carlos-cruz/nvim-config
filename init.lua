-- ============================
-- init.lua — Configuración de Neovim
-- Este archivo va en: ~/.config/nvim/init.lua
-- (o se enlaza desde este repo con ./install.sh)
--
-- Neovim lo lee al arrancar de arriba a abajo. Este archivo solo
-- "conecta" los módulos que viven en lua/config/ y lua/plugins/.
-- ============================

-- Opciones de edición e interfaz (tab, números de línea, búsqueda...)
require("config.options")

-- Atajos de teclado propios
require("config.keymaps")

-- Comportamiento automático (autocomandos)
require("config.autocmds")

-- Gestor de plugins (lazy.nvim) y la lista de plugins en lua/plugins/
require("config.lazy")