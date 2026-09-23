# Guía de LSP: servidores de lenguaje en Neovim

Guía práctica del LSP en esta configuración: qué es, cómo está montado y cómo añadir servidores nuevos.

---

## 1. ¿Qué es el LSP?

El **Language Server Protocol** es un protocolo (creado por Microsoft) que estandariza la comunicación entre un editor y un "servidor de lenguaje". El servidor conoce el lenguaje a fondo; el editor le pregunta y él responde:

```
tu código ──► Neovim ──► servidor (pyright, lua_ls, tsserver...)
                  ▲               │
                  └──── respuestas ◄──┘
        (definición, completado, errores, renombrar, hover)
```

En Neovim 0.11+ esto se maneja con dos funciones (`:h vim.lsp.*`):

- `vim.lsp.config("nombre", {...})` → define cómo arrancar un servidor (comando, raíz del proyecto, capacidades…). El nombre especial `"*"` aplica a **todos**.
- `vim.lsp.enable("nombre")` → activa el servidor para los archivos que le tocan.

---

## 2. Las tres piezas del setup

| Plugin | Papel |
|---|---|
| `mason.nvim` | **Descarga** los servidores (como un gestor de paquetes). Comando: `:Mason`. |
| `mason-lspconfig.nvim` | **Puente**: instala los servidores de la lista y los activa solos con `vim.lsp.enable()`. |
| `nvim-lspconfig` | **Configuraciones**: le dice a Neovim cómo es cada servidor (qué archivos atiende, dónde está la raíz del proyecto). |

El flujo al arrancar: `mason-lspconfig` se asegura de que `lua_ls`, `pyright` y `bashls` estén instalados, y los activa automáticamente. Tú no tocas nada.

---

## 3. El archivo `lua/plugins/lsp.lua`, explicado

```lua
dependencies = {
  { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "pyright", "bashls" },   -- ← tu lista
    },
  },
  "hrsh7th/cmp-nvim-lsp",
},
```

- `ensure_installed` = servidores que se instalan y activan solos. **Añade aquí los lenguajes que uses.**
- `cmp-nvim-lsp` traduce las "capabilities" para que nvim-cmp ofrezca completado del LSP.

En el `config()`:

```lua
-- 1. Capacidades para TODOS los servidores (necesarias para nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities,
  require("cmp_nvim_lsp").default_capabilities())
vim.lsp.config("*", { capabilities = capabilities })
```

```lua
-- 2. Atajos: se crean cuando un servidor se CONECTA al buffer (LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Ir a la definición")
    map("n", "gr", vim.lsp.buf.references, "Ver referencias")
    map("n", "K", vim.lsp.buf.hover, "Documentación (hover)")
    -- ...
  end,
})
```

---

## 4. Atajos de LSP (resumen)

| Tecla | Acción |
|---|---|
| `gd` | Ir a la definición |
| `gi` | Ver implementaciones |
| `gr` | Ver dónde se usa (referencias) |
| `K` | Documentación flotante (hover) |
| `<leader>rn` | Renombrar símbolo en todo el proyecto |
| `<leader>ca` | Acciones de código (fix, refactor...) |
| `<leader>f` | Formatear con el servidor |
| `[d` `]d` | Diagnóstico anterior / siguiente |
| `<leader>d` | Ver los errores de esa línea en flotante |

---

## 5. Añadir un servidor nuevo (paso a paso)

Ejemplo con **Rust** (`rust_analyzer`):

1. Añádelo a `ensure_installed` en `lua/plugins/lsp.lua`:
   ```lua
   ensure_installed = { "lua_ls", "pyright", "bashls", "rust_analyzer" },
   ```
2. Guarda y ejecuta `:Lazy sync` (o recarga con `:source $MYVIMRC` y luego `:LspInstall rust_analyzer`).
3. Abre un archivo `.rs` y listo.

Servidores comunes y su nombre en Mason/lspconfig:

| Lenguaje | Nombre del servidor |
|---|---|
| Lua | `lua_ls` |
| Python | `pyright` |
| Bash | `bashls` |
| TypeScript / JavaScript | `ts_ls` |
| HTML | `html` |
| CSS | `cssls` |
| Go | `gopls` |
| Rust | `rust_analyzer` |
| C/C++ | `clangd` |
| JSON | `jsonls` |
| Markdown | `marksman` |

Consulta la lista completa con `:Mason` (tecla `u` = update, `x` = install/uninstall, `?` = ayuda).

---

## 6. Diagnósticos y formato

- **Diagnósticos** (subrayado de errores): vienen activados por defecto. Configúralos globalmente con `vim.diagnostic.config()`, p. ej.:
  ```lua
  vim.diagnostic.config({ virtual_text = true, signs = true, update_in_insert = false })
  ```
- **Formatear**: manual con `<leader>f`. Si quieres **automático al guardar**, descomenta el bloque marcado en [lua/config/autocmds.lua](lua/config/autocmds.lua).

Problemas con LSP → sección correspondiente de [troubleshooting.md](troubleshooting.md).