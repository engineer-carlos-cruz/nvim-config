-- ============================
-- Autocomandos — comportamiento automático
-- ============================

-- Agrupar los autocomandos permite borrarlos todos de golpe (clear = true)
-- al recargar la configuración, evitando duplicados.

local group = vim.api.nvim_create_augroup("ConfigAutocmds", { clear = true })

-- Elimina los espacios en blanco sobrantes al final de cada línea al guardar.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Resalta brevemente el texto recién copiado (yank) para ver qué copiaste.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Al reabrir un archivo, vuelve a la última posición del cursor.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function()
    local last_line = vim.fn.line("'\"")
    local total = vim.fn.line("$")
    if last_line > 1 and last_line <= total then
      vim.cmd('normal! g`"')
    end
  end,
})

-- ============================
-- FORMATEAR CON LSP AL GUARDAR (opcional)
-- ----------------------------
-- Descomenta el bloque de abajo si quieres que el servidor de lenguaje
-- formatee el archivo automáticamente cada vez que guardes.
--
-- Está desactivado por defecto a propósito: modifica tus archivos sin
-- avisar. La alternativa manual es pulsar <leader>f (ver lsp.md).
-- ============================

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = group,
--   callback = function()
--     if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
--       vim.lsp.buf.format({ bufnr = 0, timeout_ms = 2000 })
--     end
--   end,
-- })