-- ============================
-- lazy.nvim — gestor de plugins
-- ============================
-- lazy.nvim es el gestor de plugins estándar de la comunidad: descarga,
-- actualiza, activa y configura plugins, cargándolos SOLO cuando se usan
-- (esto es lo que hace que Neovim arranque en milisegundos).

-- 1. Ubicación donde viven los plugins (dentro de los datos de Neovim).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 2. Si lazy.nvim no está instalado, se clona la primera vez.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- 3. Añadir lazy.nvim al runtimepath para poder cargarlo.
vim.opt.rtp:prepend(lazypath)

-- 4. Cargar todos los plugins definidos en lua/plugins/.
--    Cada archivo de esa carpeta devuelve una o varias especificaciones.
require("lazy").setup("plugins")