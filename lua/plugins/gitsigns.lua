-- ============================
-- gitsigns.nvim — señales de git en la columna de signos
-- ============================
-- Muestra en la columna de signos qué líneas añadiste, cambiaste o
-- borraste respecto al último commit, y permite moverse/operar por hunks.
return {
  {
    "lewis6991/gitsigns.nvim",

    -- Se carga al abrir cualquier archivo (no hace falta en la UI).
    event = { "BufReadPre", "BufNewFile" },

    keys = {
      { "]c", function() require("gitsigns").next_hunk() end, desc = "Siguiente hunk de cambios" },
      { "[c", function() require("gitsigns").prev_hunk() end, desc = "Anterior hunk de cambios" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Vista previa del hunk (diff)" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Deshacer los cambios del hunk" },
    },

    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}