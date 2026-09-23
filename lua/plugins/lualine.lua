-- ============================
-- lualine.nvim — barra de estado
-- ============================
return {
  {
    "nvim-lualine/lualine.nvim",

    -- Se carga tarde (evento "VeryLazy"), no bloquea el arranque.
    event = "VeryLazy",

    opts = {
      options = {
        -- El tema sigue al colorscheme activo.
        theme = "auto",
        -- Separadores planos (sin flechas ni chevrones).
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        -- Una sola barra para todas las ventanas.
        globalstatus = true,
      },
    },
  },
}