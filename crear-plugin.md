# Crea tu primer plugin en Lua

Guía práctica para escribir un plugin de Neovim desde cero. Al terminar tendrás un plugin propio funcionando, y entenderás mejor cómo se construye el ecosistema.

---

## 1. ¿Qué es, en el fondo, un plugin?

Un plugin es **una carpeta con archivos de Lua (y/o Vimscript)** que se añade al **runtimepath** de Neovim. Dos tipos de archivos conviven:

| Carpeta | Cuándo se carga | Uso |
|---|---|---|
| `plugin/*.vim` (o `.lua`) | **Siempre**, al arrancar | Atajos, comandos, configuración inicial |
| `lua/…` | Solo cuando haces `require("…")` | La lógica, cargada bajo demanda |

Los plugins modernos ponen casi toda la lógica en `lua/` y dejan en `plugin/` solo lo mínimo ("pon esto en marcha").

---

## 2. Tu primer plugin: `hola.nvim`

Va a ofrecer:

- El comando `:Hola <nombre>` → saluda en la línea de comandos.
- El atajo `<leader>H` → saluda con el nombre del archivo actual.
- Al abrir un `.md`, un mensaje de recordatorio.

### Paso 1 — crea la carpeta del plugin

```
~/.local/share/nvim/site/pack/developer/start/hola.nvim/
```

Neovim carga automáticamente los plugins que viven en `pack/*/start/` (así se llaman los plugins "de sistema", sin gestor). También puedes ver el siguiente bloque para cargarlo con lazy.nvim.

### Paso 2 — la lógica en `lua/hola/init.lua`

```lua
-- lua/hola/init.lua
local M = {}

-- Saludo básico
function M.saluda(nombre)
  nombre = nombre or "mundo"
  print("Hola, " .. nombre .. "! 👋")
end

-- Saluda con el nombre del archivo actual
function M.saluda_archivo()
  local archivo = vim.fn.expand("%:t")   -- nombre del archivo actual
  if archivo == "" then
    archivo = "mundo"
  end
  M.saluda(archivo)
end

return M
```

### Paso 3 — el arranque en `plugin/hola.lua`

```lua
-- plugin/hola.lua  (carga automática al arranque)
local hola = require("hola")

-- El comando :Hola [nombre]
vim.api.nvim_create_user_command("Hola", function(args)
  hola.saluda(args.args ~= "" and args.args or nil)
end, { nargs = "*", desc = "Saluda" })

-- El atajo <leader>H
vim.keymap.set("n", "<leader>H", hola.saluda_archivo, { desc = "Saludar al archivo" })

-- Un autocomando de ejemplo
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  callback = function()
    vim.schedule(function()
      vim.notify("Recuerda: esto es Markdown 😉")
    end)
  end,
})
```

### Paso 4 — prueba

1. Abre un archivo y ejecuta `:Hola Carlos`.
2. Pulsa `<leader>H` estando en cualquier buffer con archivo.
3. Abre un `.md` y mira la notificación.

> ¿Notificaciones cuadradas? Es normal en terminales sin Nerd Font; el mensaje se ve igualmente en la línea de comandos con `print`.

---

## 3. Cargar el plugin con lazy.nvim (recomendado)

Para plugins locales, lazy.nvim acepta rutas con `dir`:

```lua
-- lua/plugins/hola.lua
return {
  dir = "~/.local/share/nvim/site/pack/developer/start/hola.nvim",
  keys = { "<leader>H" },
  cmd = "Hola",
}
```

Y si el plugin es un proyecto en desarrollo, tienes utilidades como `dev = true` + `:Lazy dev` en lazy.nvim.

---

## 4. Estructura "de verdad" para un plugin

Cuando quieras publicarlo (o mantenerlo bien), usa la estructura estándar:

```
hola.nvim/
├── README.md            ← qué hace, cómo se instala, screenshot
├── LICENSE
├── lua/
│   └── hola/
│       ├── init.lua     ← entrada del módulo (require("hola"))
│       ├── config.lua   ← opciones del plugin (setup(opts))
│       └── util.lua     ← helpers internos
├── plugin/
│   └── hola.lua         ← carga inicial (atajos, comandos)
├── doc/
│   └── hola.txt         ← documentación :help (con tags)
└── tests/               ← opcional
```

### El patrón `setup(opts)`

La mayoría de plugins expone `require("plugin").setup(opts)` para personalizarse. El patrón típico:

```lua
-- lua/hola/init.lua
local M = {
  defaults = { nombre = "mundo", emoji = true },
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.saluda()
  local nombre = M.options.nombre
  print("Hola, " .. nombre .. (M.options.emoji and "! 🎉" or "!"))
end

return M
```

Y en `plugin/hola.lua`:

```lua
require("hola").setup()          -- arranque con valores por defecto
vim.keymap.set("n", "<leader>H", function() require("hola").saluda() end,
  { desc = "Saludar" })
```

Con lazy.nvim no hace falta llamar a `setup()` a mano: usa `main = "hola"` y `opts = { ... }` y lazy llamará a `require("hola").setup(opts)` por ti.

---

## 5. Recursos para seguir

- `:help runtimepath` — cómo y dónde busca Neovim los plugins.
- `:help write-plugin` / `:help plugin` — la guía oficial (empezó como Vimscript, sigue siendo válida).
- `:help lua-guide` — cómo usar la API `vim.*` desde Lua.
- El [wikia de Neovim](https://github.com/neovim/neovim/wiki) y la comunidad de r/neovim para ideas.

El mejor aprendizaje: busca un plugin que uses a diario, lee su `lua/` y copia sus patrones.