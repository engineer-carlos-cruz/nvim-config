-- ============================
-- telescope.nvim — buscador de archivos, texto y símbolos
-- ============================
return {
  {
    "nvim-telescope/telescope.nvim",

    -- plenary es la biblioteca utilitaria que Telescope usa internamente.
    dependencies = { "nvim-lua/plenary.nvim" },

    -- "Lazy loading" por atajos: Telescope solo se carga al pulsar uno de
    -- estos. Fíjate en que antes de pulsarlos no ocupa ni un milisegundo.
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto en el proyecto (usa ripgrep)" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buscar entre buffers abiertos" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Buscar en la ayuda de Vim/Neovim" },
    },

    opts = {
      defaults = {
        -- El prompt en la parte de arriba (como en el IDE medio).
        sorting_strategy = "ascending",
        layout_config = { horizontal = { prompt_position = "top" } },
      },
    },
  },
}