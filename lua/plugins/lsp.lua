-- ============================
-- LSP — Language Server Protocol
-- ----------------------------
-- Tres piezas trabajan juntas:
--   • mason.nvim          — gestor de SERVIDORES de lenguaje (los descarga,
--                           actualiza y borra, como un "gestor de paquetes").
--   • mason-lspconfig.nvim— puente: instala los servidores de la lista y los
--                           habilita automáticamente.
--   • nvim-lspconfig      — aporta las configuraciones de cada servidor.
--
-- Requiere Neovim ≥ 0.11 (usa vim.lsp.enable()).
-- ============================
return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      -- Gestor de servidores LSP. Solo se carga al usar :Mason.
      { "williamboman/mason.nvim", cmd = "Mason", opts = {} },

      -- Puente mason ↔ lspconfig. instalas y habilita los servidores
      -- de "ensure_installed" sin que hagas nada más.
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          -- Servidores que se instalan y activan solos al arrancar.
          -- Añade o quita según los lenguajes que uses.
          ensure_installed = { "lua_ls", "pyright", "bashls" },
        },
      },

      -- Traduce las "capabilities" del servidor para que nvim-cmp
      -- sepa qué puede ofrecer el LSP (ver cmp.lua).
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      -- ============================
      -- 1. Capacidades del cliente
      -- ============================
      -- "capabilities" = qué es capaz de entender el editor. Se lo
      -- comunicamos a TODOS los servidores (la "config *" aplica a todos).
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )
      vim.lsp.config("*", { capabilities = capabilities })

      -- ============================
      -- 2. Atajos de LSP
      -- ============================
      -- Los keymaps se crean cuando un servidor se conecta al buffer
      -- (evento LspAttach), así que solo existen donde hay LSP activo.

      local function map(bufnr, mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ConfigLsp", { clear = true }),
        callback = function(args)
          local buf = args.buf

          -- Navegación y consultas
          map(buf, "n", "gd", vim.lsp.buf.definition, "Ir a la definición")
          map(buf, "n", "gr", vim.lsp.buf.references, "Ver referencias")
          map(buf, "n", "K", vim.lsp.buf.hover, "Documentación (hover)")
          map(buf, "n", "gi", vim.lsp.buf.implementation, "Ver implementaciones")

          -- Refactor y edición
          map(buf, "n", "<leader>rn", vim.lsp.buf.rename, "Renombrar símbolo")
          map(buf, "n", "<leader>ca", vim.lsp.buf.code_action, "Acciones de código")
          map(buf, "n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Formatear con el LSP")

          -- Diagnósticos (errores y avisos)
          map(buf, "n", "[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
          map(buf, "n", "]d", vim.diagnostic.goto_next, "Diagnóstico siguiente")
          map(buf, "n", "<leader>d", vim.diagnostic.open_float, "Ver diagnóstico en ventana flotante")
        end,
      })
    end,
  },
}