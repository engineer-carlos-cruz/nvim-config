# Configuración de Neovim (dotfiles)

Configuración personal de [Neovim](https://neovim.io) construida desde cero y acompañada de **guías didácticas en español**. No es un setup gigantesco: es un setup **entendible**, donde cada opción y cada plugin están explicados.

## ¿Qué incluye la configuración?

Un Neovim moderno basado en **lazy.nvim**:

| Área | Plugin |
|---|---|
| Búsqueda de archivos y texto | Telescope |
| Resaltado sintáctico inteligente | Treesitter |
| LSP (definición, renombrar, hover...) | Mason + lspconfig |
| Autocompletado | nvim-cmp |
| Barra de estado | lualine |
| Señales de git | gitsigns |
| Ayuda para atajos | which-key |
| Calidad de vida | nvim-autopairs, Comment |

## Estructura del repositorio

```
nvim-config/
├── init.lua                ← punto de entrada (solo conecta los módulos)
├── lua/
│   ├── config/             ← options, keymaps, autocmds y lazy
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocmds.lua
│   │   └── lazy.lua
│   └── plugins/            ← un archivo por plugin (o grupo de plugins)
├── base.md                 ← ¿cómo funciona Neovim? (guía introductoria)
├── cheatsheet.md           ← chuleta de comandos esenciales
├── plugins.md              ← guía de lazy.nvim y de cada plugin del setup
├── lsp.md                  ← guía de LSP y servidores de lenguaje
├── crear-plugin.md         ← guía para escribir tu primer plugin en Lua
├── troubleshooting.md      ← problemas frecuentes y sus soluciones
├── update.md               ← cómo actualizar Neovim, la config y los plugins
├── install.sh              ← instalador (symlink + plugins)
├── Makefile                ← atajos: make install / sync / update
└── .gitignore
```

## Instalación

Requisitos:

- **Neovim ≥ 0.11** (se usa `vim.lsp.enable()`). Cómo actualizarlo: [update.md](update.md#1-actualizar-el-binario-de-neovim).
- Opcional pero recomendado: **ripgrep** (para `Telescope live_grep`).
- Opcional: **tree-sitter-cli ≥ 0.26.1** + `gcc` (para compilar los parsers de Treesitter). Sin ellos, todo lo demás funciona; solo no se instalarán parsers nuevos. Detalles: [troubleshooting.md](troubleshooting.md).

Pasos:

```bash
cd ~/Projects/nvim-config   # o donde hayas clonado este repo
./install.sh                # crea el symlink ~/.config/nvim → repo e instala plugins

# equivalente con make:
make install
```

Eso es todo. Abre `nvim` 🚀

## Uso diario (resumen)

`<leader>` es la **barra espaciadora**.

| Tecla | Acción |
|---|---|
| `<leader>ff` | Buscar archivos |
| `<leader>fg` | Buscar texto en el proyecto (necesita ripgrep) |
| `<leader>fb` | Buscar entre buffers abiertos |
| `<leader>e` | Explorador de archivos (netrw) |
| `<leader>w` | Guardar |
| `<leader>t` | Terminal integrada |
| `<S-h>` / `<S-l>` | Buffer anterior / siguiente |
| `gd` | Ir a la definición (LSP) |
| `K` | Documentación (LSP) |
| `<leader>rn` | Renombrar símbolo (LSP) |
| `<leader>f` | Formatear (LSP) |
| `]c` / `[c` | Siguiente / anterior hunk de git |

La chuleta completa está en **[cheatsheet.md](cheatsheet.md)**.

## Guías

1. [**base.md**](base.md) — ¿Cómo funciona Neovim por dentro? Modos, buffers, Lua, plugins y arquitectura.
2. [**cheatsheet.md**](cheatsheet.md) — Comandos esenciales para usar a diario.
3. [**plugins.md**](plugins.md) — lazy.nvim y cada plugin del setup, con ejemplos.
4. [**lsp.md**](lsp.md) — LSP, Mason, servidores de lenguaje y atajos.
5. [**crear-plugin.md**](crear-plugin.md) — Crea tu primer plugin en Lua, paso a paso.
6. [**troubleshooting.md**](troubleshooting.md) — Problemas típicos y soluciones.
7. [**update.md**](update.md) — Actualizar el binario, la config y los plugins.

## Mantenimiento

```bash
make update    # git pull + re-sincroniza los plugins
make sync      # solo re-sincronizar plugins
```

## Licencia

Usa lo que quieras. Sin garantías. 😄