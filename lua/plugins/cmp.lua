-- ============================
-- nvim-cmp — autocompletado
-- ----------------------------
-- Usa el MECANISMO DE SNIPPETS INTEGRADO de Neovim 0.10+ (vim.snippet),
-- así que no hace falta LuaSnip para lo básico.
-- ============================
return {
  {
    "hrsh7th/nvim-cmp",

    dependencies = {
      -- Fuente: sugerencias del servidor LSP (código, funciones, tipos...)
      "hrsh7th/cmp-nvim-lsp",
      -- Fuente: palabras que ya existen en el buffer actual
      "hrsh7th/cmp-buffer",
      -- Fuente: rutas de archivos (../, ./, /etc...)
      "hrsh7th/cmp-path",
    },

    config = function()
      local cmp = require("cmp")

      cmp.setup({
        -- Cómo expandir los snippets: con el motor integrado de Neovim.
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        -- Ventanas del menú y de la documentación con bordes.
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- Atajos dentro del menú de completado.
        mapping = cmp.mapping.preset.insert({
          -- Aceptar la selección (Enter).
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Abrir el menú manualmente.
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Navegar entre opciones.
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Cancelar.
          ["<C-e>"] = cmp.mapping.abort(),

          -- Tab: si hay opciones, bajar; si hay un snippet activo, saltar
          -- al siguiente campo; si no, el tab normal de siempre.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Fuentes de sugerencias, en orden de prioridad.
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- lo que sabe el servidor de lenguaje
        }, {
          { name = "buffer" }, -- palabras del archivo actual
          { name = "path" },   -- rutas de archivos
        }),

        -- Vista previa "fantasma": texto gris que avanza mientras escribes.
        experimental = { ghost_text = true },
      })
    end,
  },
}