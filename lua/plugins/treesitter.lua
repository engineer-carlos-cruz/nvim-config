-- ============================
-- nvim-treesitter — resaltado sintáctico inteligente
-- ============================
-- ⚠ Nota (2025+): este plugin fue REESCRITO por completo para Neovim ≥ 0.12.
--    - El resaltado ya lo hace el propio Neovim (vim.treesitter.start()).
--    - Este plugin aporta los parsers y las "queries" de cada lenguaje.
--    - Para compilar parsers necesita `tree-sitter-cli` (≥ 0.26.1) + gcc.
--      Si no lo tienes, la config arranca igual: solo no habrá parsers
--      nuevos hasta que lo instales (ver troubleshooting.md).
return {
  {
    "nvim-treesitter/nvim-treesitter",

    -- Este plugin NO soporta lazy-loading (lo dice su documentación),
    -- así que se carga siempre al arrancar.
    lazy = false,

    -- "build" se ejecuta al instalar/actualizar el plugin: compila
    -- o actualiza los parsers ya instalados.
    build = ":TSUpdate",

    config = function()
      -- Lenguajes cuyo parser queremos. Añade los tuyos aquí.
      local parsers = {
        "lua", "vim", "vimdoc",
        "bash", "python",
        "markdown", "markdown_inline",
        "html", "css", "javascript", "typescript",
      }

      -- 1. Instala los parsers que falten. Es ASÍNCRONO: no bloquea el
      --    arranque, aunque tarde en compilar (necesita tree-sitter-cli).
      --    Si el cli no está, no intentamos instalar (evita descargas
      --    repetidas en cada arranque) y la config funciona igual.
      if vim.fn.executable("tree-sitter") == 1 then
        local ts = require("nvim-treesitter")
        ts.install(parsers)
      end

      -- 2. Resaltado Treesitter: Neovim lo activa por tipo de archivo
      --    (:h treesitter-highlight). El pcall evita errores si el
      --    parser del lenguaje aún no está instalado (ej. primer arranque).
      local filetypes = {
        "lua", "vim", "help", "sh", "bash", "python",
        "markdown", "html", "css", "javascript",
        "typescript", "typescriptreact",
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        pattern = filetypes,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- 3. Indentación basada en el árbol (EXPERIMENTAL, opcional).
      --    Descomenta si la prefieres a la indentación clásica.
      -- vim.api.nvim_create_autocmd("FileType", {
      --   group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
      --   pattern = filetypes,
      --   callback = function()
      --     vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      --   end,
      -- })
    end,
  },
}