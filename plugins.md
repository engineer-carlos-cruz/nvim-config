# Guía de plugins: lazy.nvim y el setup de este repo

Esta guía explica cómo se gestionan los plugins en esta configuración y qué hace (y cómo está configurado) cada uno. Complementa la sección 6 de [base.md](base.md).

---

## 1. lazy.nvim — el gestor de plugins

En el repo, lazy.nvim se carga en [lua/config/lazy.lua](lua/config/lazy.lua). Su idea central es el **lazy loading**: los plugins no se cargan al arrancar, sino *solo cuando hace falta*.

| Disparador (trigger) | Ejemplo | Se carga cuando… |
|---|---|---|
| `keys` | `keys = { "<leader>ff" }` | pulsas el atajo |
| `cmd` | `cmd = "Mason"` | ejecutas el comando `:Mason` |
| `event` | `event = "VeryLazy"` | Neovim lleva un rato arrancado |
| `ft` | `ft = "python"` | abres un archivo de ese tipo |
| `build` | `build = ":TSUpdate"` | al instalar/actualizar (compila parsers, etc.) |
| *(sin nada)* | — | se carga siempre al arrancar |

El resultado: aunque este repo declara ~12 plugins, Neovim arranca casi igual de rápido que sin ellos.

### Comandos `:Lazy`

```
:Lazy            ← panel de gestión
:Lazy sync       ← instala/actualiza/borra según la lista (equivale a "install all")
:Lazy update     ← actualiza lo instalado
:Lazy clean      ← borra plugins que ya no están en la lista
:Lazy health     ← estado de los plugins
```

---

## 2. Los plugins de este setup

### telescope.nvim — búsqueda
Busca archivos, texto, símbolos, buffers, de forma difusa. Es el "Cmd+P" de este Neovim. Depende de `plenary.nvim` (biblioteca utilitaria).

```lua
-- lua/plugins/telescope.lua
keys = {
  { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Buscar archivos" },
  { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto (usa ripgrep)" },
  { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buscar entre buffers" },
  { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Buscar en la ayuda" },
}
```

Prueba también dentro de Telescope: `<C-p>` / `<C-n>` para navegar, `<CR>` para abrir en esta ventana, `<C-v>` en vertical, `<C-x>` en horizontal.

### nvim-treesitter — sintaxis inteligente
Construye un árbol sintáctico del código en tiempo real. Ojo: desde 2025 este plugin fue **reescrito** para Neovim ≥ 0.12 — el resaltado ahora lo hace el propio Neovim (`vim.treesitter.start()`), y este plugin aporta los parsers y las *queries*.

```lua
-- lua/plugins/treesitter.lua (resumen)
lazy = false,                    -- no soporta lazy-loading
build = ":TSUpdate",             -- compila parsers al instalar/actualizar
config = function()
  local parsers = { "lua", "python", "bash", ... }
  require("nvim-treesitter").install(parsers)   -- parsers automáticos (asíncrono)
  -- activa el resaltado nativo para esos lenguajes:
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "python", ... },
    callback = function() pcall(vim.treesitter.start) end,
  })
end
```

Para instalar un parser sin tocar el archivo: `:TSInstall go`. Para compilar parsers hace falta **`tree-sitter-cli` ≥ 0.26.1** y un compilador C (ver la nota al pie y [troubleshooting.md](troubleshooting.md)).

### Mason + lspconfig — LSP
Trío LSP: `mason.nvim` (descarga servidores), `mason-lspconfig.nvim` (los instala y activa), `nvim-lspconfig` (las configuraciones de cada servidor). Lo explica en profundidad [lsp.md](lsp.md).

### nvim-cmp — autocompletado
El menú de sugerencias que ves al escribir. Se alimenta de fuentes:
`nvim_lsp` (el servidor), `buffer` (palabras del archivo) y `path` (rutas). Los snippets usan el motor integrado de Neovim (`vim.snippet`), por eso no hace falta LuaSnip para lo básico.

### lualine.nvim — barra de estado
Una barra limpia con modo, archivo, rama git, LSP activo y posición del cursor. Con `globalstatus = true` hay una sola barra para todas las ventanas.

### gitsigns.nvim — señales de git
Marca con `+`/`~`/`_` las líneas añadidas, modificadas o borradas, y da movimientos por *hunks*:

```
]c  [c          → siguiente / anterior hunk
<leader>gp      → vista previa del hunk (diff)
<leader>gr      → deshacer cambios del hunk
```

### which-key.nvim — ayuda de atajos
Cuando pulsas `<leader>` (o cualquier prefijo) y dudas, espera medio segundo: aparece una ventana con todos los atajos y su descripción. Así, ninguna tecla es un misterio.

### nvim-autopairs — parejas automáticas
Cierra `(`, `[`, `{`, `"`, `'` y ` backtick` al escribirlas. Poca configuración: `opts = {}`.

### Comment.nvim — comentar código
Con la misma tecla comentas y descomentas: `gcc` en normal, `gc` en visual. Detecta el tipo de archivo automáticamente.

---

## 3. Cómo se organiza esto en el repo

La regla de lazy.nvim: **un archivo por plugin** dentro de `lua/plugins/`. Cada archivo devuelve una especificación (o lista):

```lua
-- lua/plugins/mi-plugin.lua
return {
  {
    "author/mi-plugin",        -- "usuario/repo" en GitHub
    event = "VeryLazy",        -- cuándo cargar
    keys = { ... },            -- o por atajo
    opts = { ... },            -- configuración (lazy llama a .setup(opts))
    dependencies = { ... },    -- plugins que necesita
  },
}
```

Si el plugin expone `setup()` y el resto de opciones van en `opts`, lazy.nvim se encarga de llamarlo. Para casos especiales usas `config = function() ... end`.

---

## 4. Próximos pasos (más plugins populares)

| Plugin | Qué aporta |
|---|---|
| `folke/tokyonight.nvim` | Tema de colores (muy usado) |
| `nvim-tree/nvim-tree.lua` | Explorador de archivos gráfico (netrw "mejorado") |
| `echasnovski/mini.nvim` | Colección de mini-plugins de calidad de vida |
| `stevearc/oil.nvim` | Editar el sistema de archivos como si fuera un buffer |
| `akinsho/toggleterm.nvim` | Terminales flotantes/persistentes |
| `NeogitOrg/neogit` | Interfaz de git en Neovim (commit, branches, stage) |
| `folke/todo-comments.nvim` | Resalta `TODO`, `FIXME`, `HACK` en el código |
| `nvimdev/dashboard-nvim` | Pantalla de inicio con accesos rápidos |
| `nvim-neotest/neotest` | Framework de tests |
| `mfussenegger/nvim-dap` | Depurador (breakpoints, variables) |
| `nvimdev/lspsaga.nvim` | UI mejorada para LSP |

Para añadir cualquiera: crea `lua/plugins/lo-que-sea.lua` siguiendo el patrón de la sección 3, guarda, y ejecuta `:Lazy sync`.