-- ============================
-- Atajos de teclado (keymaps)
-- ============================

-- La "tecla líder" es el prefijo para los atajos propios (<leader>ff,
-- <leader>w...). Usamos la barra espaciadora, el estándar de la comunidad.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================
-- 1. Básicos
-- ============================

-- <leader>w → guarda el archivo actual.
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Guardar archivo" })

-- <leader>q → cierra la ventana actual (si es la última, Neovim pregunta).
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Cerrar la ventana" })

-- <Esc> en modo normal limpia el resaltado de la última búsqueda
-- (evita teclear :nohlsearch cada vez).
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de búsqueda" })

-- ============================
-- 2. Navegación entre ventanas
-- ============================

-- Ctrl + h/j/k/l para saltar de ventana sin salir del modo normal.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ventana de la izquierda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ventana de abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ventana de arriba" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ventana de la derecha" })

-- Redimensionar ventanas con las flechas.
vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "Ventana más alta" })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "Ventana menos alta" })
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "Ventana más estrecha" })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "Ventana menos estrecha" })

-- Dividir la ventana actual (h = horizontal, v = vertical).
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Dividir horizontalmente" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Dividir verticalmente" })

-- ============================
-- 3. Buffers (archivos abiertos)
-- ============================

-- Shift + h/l → buffer anterior / siguiente.
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer anterior" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Buffer siguiente" })

-- <leader>bd → cierra el buffer actual (no el archivo del disco).
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Cerrar buffer" })

-- <leader>bl → lista los buffers abiertos.
vim.keymap.set("n", "<leader>bl", ":buffers<CR>", { desc = "Listar buffers" })

-- ============================
-- 4. Terminal integrada
-- ============================

-- <leader>t → abre una terminal en una ventana nueva.
vim.keymap.set("n", "<leader>t", ":terminal<CR>", { desc = "Abrir terminal" })

-- <Esc> dentro de la terminal vuelve al modo normal (Ctrl+\ Ctrl+n en bruto).
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Salir de la terminal" })

-- ============================
-- 5. Edición
-- ============================

-- En modo visual, J/K mueven las líneas seleccionadas hacia abajo/arriba
-- y las reindentan.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover líneas hacia abajo" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover líneas hacia arriba" })

-- Indentar en modo visual sin perder la selección.
vim.keymap.set("v", "<", "<gv", { desc = "Indentar hacia la izquierda" })
vim.keymap.set("v", ">", ">gv", { desc = "Indentar hacia la derecha" })

-- Pegar sobre texto seleccionado sin machacar el registro de copia
-- (registro "papelera" _: lo que copies después seguirá intacto).
vim.keymap.set("x", "p", [["_dP]], { desc = "Pegar sin sobrescribir el registro" })

-- <leader>n → alterna los números de línea (relativos).
vim.keymap.set("n", "<leader>n", function()
  local show = vim.o.number
  vim.o.number = not show
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Alternar números de línea" })

-- ============================
-- 6. Explorador de archivos (netrw)
-- ============================

-- <leader>e → abre el navegador de archivos en la misma ruta.
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Explorador de archivos" })

-- <leader>ee → abre el navegador en una ventana vertical.
vim.keymap.set("n", "<leader>ee", ":vertical Explore<CR>", { desc = "Explorador vertical" })