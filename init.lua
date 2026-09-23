-- ============================
-- init.lua — Configuración de Neovim
-- Este archivo va en: ~/.config/nvim/init.lua
-- Neovim lo lee al arrancar de arriba a abajo.
-- ============================

-- ============================
-- 1. Edición de texto
-- ============================

-- El tab se inserta como espacios en vez de un carácter de tabulador.
vim.opt.expandtab = true

-- Tamaño de tabulación en espacios.
vim.opt.tabstop = 4

-- Cuántos espacios se usan al indentar (>>, <<, autoindentado).
vim.opt.shiftwidth = 4

-- Número de columnas que retrocede al pulsar Backspace dentro de un tab.
vim.opt.softtabstop = 4

-- Indenta automáticamente al pulsar Enter o al abrir llaves { }.
vim.opt.smartindent = true

-- Anchura máxima de línea (guía mental para envolver código donde aplique).
-- 0 = desactivada.
vim.opt.textwidth = 0

-- ============================
-- 2. Interfaz
-- ============================

-- Muestra el número de línea en la columna izquierda.
vim.opt.number = true

-- Numeración relativa: muestra la distancia a la línea actual
-- (p. ej. 3 si estás 3 líneas arriba). Muy útil con movimientos como 3j o 3dd.
vim.opt.relativenumber = true

-- Resalta la línea donde está el cursor.
vim.opt.cursorline = true

-- No envuelve las líneas largas automáticamente (sin salto visual de palabra).
vim.opt.wrap = false

-- Activa colores de 24 bits (truecolor) en terminales que lo soportan.
vim.opt.termguicolors = true

-- Reserva una columna siempre para los signos (iconos de git, diagnóstico,
-- marcadores). Evita que el texto salte al abrir/cerrar errores.
vim.opt.signcolumn = "yes"

-- Muestra la línea y columna del cursor en la barra de estado.
vim.opt.ruler = true

-- ============================
-- 3. Búsqueda
-- ============================

-- La búsqueda ignora mayúsculas/minúsculas...
vim.opt.ignorecase = true

-- ...pero si escribes alguna mayúscula, pasa a diferenciarlas.
vim.opt.smartcase = true

-- Resalta todas las coincidencias de la última búsqueda.
vim.opt.hlsearch = true

-- Incremental: va saltando al resultado mientras escribes la búsqueda.
vim.opt.incsearch = true

-- ============================
-- 4. Comportamiento
-- ============================

-- Usa el portapapeles del sistema (Ctrl+C/Ctrl+V fuera de Neovim
-- comparten portapapeles con "y"/"p").
vim.opt.clipboard = "unnamedplus"

-- Desactiva el archivo de intercambio temporal (.swp) — migajas que se
-- generan al editar. Neovim gestiona la recuperación por otros medios.
vim.opt.swapfile = false

-- Guarda el historial de deshacer entre sesiones (undofile).
-- Puedes deshacer incluso después de cerrar y volver a abrir Neovim.
vim.opt.undofile = true

-- Guarda hasta 1000 comandos en el historial de líneas de comandos (:).
vim.opt.history = 1000

-- Mantiene al menos 8 líneas visibles por encima/por debajo del cursor
-- al hacer scroll. Sin parpadeos ni pérdida de contexto.
vim.opt.scrolloff = 8

-- Las divisiones (:split / :vsplit) se abren debajo y a la derecha
-- de la ventana actual.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================
-- 5. Tecla líder y atajos básicos
-- ============================

-- La "tecla líder" es el prefijo para atajos propios (p. ej. <leader>e).
-- La establecemos en espacio, el estándar de la comunidad.
vim.g.mapleader = " "

-- Atajo: en modo normal, <leader>e abre el archivo que estás editando
-- dentro del navegador de archivos de Neovim (netrw).
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Explorador de archivos" })

-- Atajo: en modo normal, <leader>w guarda el archivo actual.
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Guardar archivo" })

-- Atajo: <Esc> en modo normal limpia el resaltado de la última búsqueda
-- (evita tener que teclear :nohlsearch cada vez).
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de búsqueda" })
