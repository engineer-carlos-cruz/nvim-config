-- ============================
-- Pequeños plugins de calidad de vida
-- ============================
return {
  -- Cierra automáticamente paréntesis, corchetes, llaves y comillas.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Comenta y descomenta código con la misma tecla:
  --   gcc  → comenta la línea    (modo normal)
  --   gc   → comenta la selección (modo visual)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}