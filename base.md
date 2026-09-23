# ¿Cómo funciona Neovim?

Esta guía explica cómo funciona Neovim por dentro, pensada para alguien que quiere entenderlo antes de usarlo a fondo. Al terminar sabrás cómo se configura, cómo se extiende con plugins y en qué se parece y en qué se diferencia de trabajar en VSCode.

---

## 1. ¿Qué es Neovim?

Neovim es un **fork (derivación) de Vim** iniciado en 2014 para modernizar el editor sin romper con su herencia. Vim, a su vez, es el heredero directo de *vi*, el editor incluido en los sistemas Unix desde hace décadas.

Características que lo definen:

- **Editor modal**: funciona con "modos" en lugar de combinaciones de Ctrl/Alt como los editores modernos (ver sección 2).
- **Funciona en la terminal**: no es una aplicación gráfica con botones; vive dentro de la terminal.
- **Ligero y rápido**: arranca en milisegundos y maneja archivos enormes sin esfuerzo.
- **Extensible por diseño**: desde el primer día su filosofía es "no intentes adivinar qué quiere el usuario, dale herramientas para construirlo".
- **Configuración y plugins en Lua**: la gran diferencia con Vim, que usaba Vimscript. Neovim integró Lua (con LuaJIT, una implementación muy rápida) como lenguaje de configuración y extensión.

Puntos clave para entender la cultura de Neovim:

- Es **software libre** y la comunidad controla su desarrollo; no hay una empresa detrás.
- Es el editor por defecto de millones de desarrolladores, y herramientas como `git` o `crontab` abren su editor desde terminal (muchas veces Vim) cuando necesitan que edites texto.
- "Neovim" y "Vim" se parecen tanto que los atajos y comandos son intercambiables en el 99% de los casos. Todo lo que aprendas de Vim vale para Neovim y viceversa.

---

## 2. El modelo modal (el corazón de Vim)

Casi todo lo que hace a Neovim diferente nace de su **modelo modal**: el teclado no siempre escribe texto; su significado cambia según el modo activo.

Los modos principales:

| Modo | Qué ocurre | Cómo entrar | Cómo salir |
|------|------------|-------------|------------|
| **Normal** | Las teclas son *comandos* (mover, borrar, copiar, deshacer). No escriben texto. | `Esc` / `Ctrl+[` | — |
| **Insertar** | Las teclas escriben texto, como en cualquier editor. | `i`, `a`, `o`, `A`, `I`, `O` | `Esc` |
| **Visual** | Selección de texto para operar sobre ella (borrar, reemplazar, indentar). | `v` (carácter), `V` (línea), `Ctrl+v` (bloque) | `Esc` |
| **Línea de comandos** | Escribes comandos (`:w` guardar, `:q` salir, `:e archivo`). | `:` | `Esc` o `Enter` |
| **Operador pendiente** | Estado intermedio de un comando ("borrar + ¿hasta dónde?"). | tras `d`, `c`, `y`... | — |

El punto que más cuesta al principio: **en el modo Normal las teclas no escriben texto**. Para escribir pulsas `i`. Suena trivial, pero es justamente lo que hace a Vim tan eficiente: los comandos de edición viven *siempre disponibles*, sin la mano saliendo del teclado.

Los comandos además se **componen** como frases:

- `d w` = "delete word" → borra la palabra.
- `d 2 j` = borra la línea actual y 2 más abajo ("delete 2 down").
- `ci "` = "change inside quotes" → borra el contenido entre comillas y entra en modo insertar.
- `gg d G` = ir al inicio y borrar hasta el final.

Esta "gramática" (verbo + movimiento + cantidad) permite miles de combinaciones sin memorizar una por una.

---

## 3. Archivos de configuración

Neovim persigue su configuración en archivos que él mismo lee (a esto se le llama *dogfooding*: el editor se configura con el editor).

### `init.lua` — el entrypoint

El archivo principal en el que Neovim busca su configuración es:

```
~/.config/nvim/init.lua
```

(y si no existe, busca versiones en `.vimrc` o `init.vim`, por compatibilidad con Vim).

Al iniciar, Neovim lee `init.lua` de arriba a abajo: aquí se definen opciones, atajos, autocomandos y se cargan los plugins. Un ejemplo mínimo y comentado:

```lua
-- ~/.config/nvim/init.lua

-- 1. Número de línea (una opción)
vim.opt.number = true
vim.opt.relativenumber = true

-- 2. Tab = 4 espacios
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 3. Atajo: en modo normal, <leader>e abre el archivo en la misma ruta
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Explorador de archivos" })

-- 4. Autocomando: al abrir un .lua, establece tab de 2 espacios
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
  end,
})
```

### Buscando organización: `runtimepath`

Neovim busca configuraciones adicionales en una serie de carpetas llamadas *runtimepath*. Esto permite **partir la configuración en archivos separados** y que los plugins "aporten" sus propias carpetas.

Una estructura típica de un proyecto de configuración:

```
~/.config/nvim/
├── init.lua              ← entrada: sólo `require("config")` y cargar plugins
├── lua/
│   ├── config/
│   │   ├── options.lua   ← opciones (tab, número de línea...)
│   │   ├── keymaps.lua   ← atajos de teclado
│   │   ├── autocmds.lua  ← comportamiento automático por tipo de archivo
│   │   └── lazy.lua      ← gestión de plugins
│   └── plugins/          ← un archivo por plugin (telescope.lua, treesitter.lua...)
├── after/                ← configuraciones que se aplican DESPUÉS de los plugins
├── plugin/               ← scripts que Neovim carga automáticamente al arrancar
└── snippets/             ← plantillas de código
```

La regla práctica: cualquier archivo en una carpeta `lua/` solo se ejecuta si lo llamas con `require(...)`. Cualquier archivo en `plugin/` se ejecuta solo al arrancar. Este matiz es lo que permite cargar cosas solo cuando se necesitan.

### Orden de carga

1. `init.lua`.
2. Plugins (cada uno con su propia configuración en `plugin/` o `after/plugin/`).
3. Archivos en `after/` (que sobreescriben lo anterior).

---

## 4. Lua como motor

Vim usó Vimscript durante 20 años. Neovim apuesta por **Lua** porque es rápido (LuaJIT compila a código máquina), pequeño, fácil de aprender y muy expresivo.

Neovim expone toda su API interna bajo el espacio de nombres `vim.*`:

- `vim.opt.*` → opciones (equivalente a `set`): `vim.opt.number = true`.
- `vim.g.*` → variables globales.
- `vim.keymap.set()` → crear atajos (con la API de Lua).
- `vim.api.*` → funciones de bajo nivel: `vim.api.nvim_buf_set_lines()`, `vim.api.nvim_create_autocmd()`, etc.
- `vim.lsp.*` → integración Language Server Protocol (sección 7).
- `vim.fn.*` → llamar funciones de Vimscript desde Lua (compatibilidad total).
- `vim.cmd(...)` → ejecutar comandos `:` desde Lua.

Gracias a esto puedes escribir un plugin de 30 líneas en Lua que habría requerido 300 en Vimscript. Y la gran ventaja sobre configurar a base de copiar texto: **Lua es programación de verdad** (bucles, funciones, tablas), así que tu configuración puede generar atajos, cargar plugins condicionalmente, etc.

---

## 5. Buffers, ventanas (windows) y pestañas (tabs)

Neovim trabaja con tres niveles superpuestos, y entenderlos aclara el 80% de las confusiones iniciales:

- **Bufffer**: el contenido de un archivo (o un archivo aún sin abrir). Es memoria de Neovim. Un archivo puede estar en un *buffer sin guardar* y no volcado al disco.
- **Ventana (window)**: una vista de un buffer. Aunque el buffer sea uno, puedes tener varias ventanas mostrando partes distintas del mismo archivo.
- **Pestaña (tab)**: no es lo mismo que en VSCode. Una pestaña en Neovim es un *conjunto de ventanas* dispuestas en un "layout" específico.

Comandos básicos para orientarse:

```
:ls        ← listar buffers abiertos
:bn / :bp  ← siguiente / anterior buffer
:bd        ← cerrar buffer (no el archivo)
:split     ← dividir ventana horizontalmente
:vsplit    ← dividir verticalmente
:tabnew    ← nueva pestaña
Ctrl+w ←   ← moverse entre ventanas
```

La consecuencia práctica que más sorprende: puedes cerrar la "pestaña" y el buffer sigue abierto; o cerrar el buffer sin cerrar la ventana. Separa estos conceptos y el sistema deja de parecer caótico.

---

## 6. Plugins: cómo se extiende

Neovim es, en la práctica, **un núcleo pequeño y un ecosistema infinito de plugins**. Se puede extender para que haga casi cualquier cosa que haga un IDE, porque todo lo que ve un plugin es el mismo API Lua que usas en tu configuración.

### Cómo se instala un plugin

Neovim no trae gestor de paquetes. La comunidad usa **`lazy.nvim`** hoy como estándar *de facto*. Un plugin es, en el fondo, una carpeta con archivos de Lua que se añade al *runtimepath* y cuyos archivos `plugin/` se cargan al arrancar. `lazy.nvim` gestiona ese proceso: descarga, actualiza, activa, configura, y solo carga el plugin cuando de verdad se usa.

```lua
-- Ejemplo con lazy.nvim
return {
  {
    "folke/tokyonight.nvim",            -- tema de colores
    priority = 1000,                    -- se carga primero (colores)
    lazy = false,                       -- sin lazy loading: cargar siempre
  },
  {
    "nvim-telescope/telescope.nvim",    -- buscador de archivos/texto
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>ff" },            -- SE CARGA solo al pulsar <leader>ff
    opts = {},                          -- configuración del plugin
  },
}
```

### El `lazy loading` (y por qué arranca tan rápido)

Un truco central de Neovim moderno: **cargar plugins solo cuando hacen falta**. En vez de arrancar cargando 80 plugins, se cargan por eventos (al abrir un `.lua`), por atajos (`keys`), por comandos (`cmd = "Telescope"`) o por tipo de archivo (`ft = "python"`). Resultado: Neovim abre en milisegundos aunque tenga cientos de plugins, y es esa mismo idea la que te permite acumular funcionalidad sin degradar el inicio.

### Qué hace la comunidad con esto

El ecosistema cubre hoy casi todo lo de un IDE moderno:

- **Búsqueda** de archivos, texto o símbolos: Telescope, fzf-lua.
- **Resaltado sintáctico** inteligente: Treesitter.
- **Autocompletado** de código: nvim-cmp.
- **Barra de estado**: lualine.nvim.
- **Explorador de archivos**: nvim-tree vía netrw.
- **Integración con Git**: fugitive.vim, octo.nvim (GitHub).
- **Almacén de notas / maduración de ideas**: markdown + Telescope + neorg.
- **Temas, iconos, snippets, testing, dépuration, múltiples cursores...**

Es tan flexible que a menudo "configurar Neovim" se convierte en un hobby: gente incluso publica sus *dotfiles* (configuraciones completas) como la gente comparte temas.

---

## 7. LSP, Treesitter y autocompletado

Estos tres son los encargados de que Neovim "sienta" como un IDE.

### LSP (Language Server Protocol)

Es un protocolo creado por Microsoft para que *cualquier* editor hable con *cualquier* "servidor de lenguaje". El servidor es un programa que conoce el lenguaje a fondo (p. ej. `clangd` para C/C++, `pyright` para Python, `tsserver` para TypeScript). El editor le pregunta y él responde.

```
tu código ──► Neovim ──► LSP server (pyright, ts_server...)
                ▲               │
                └────── respuestas ◄────┘
                  (definition, completion, diagnostics, rename, hover)
```

El cliente LSP de Neovim cubre: ir a la definición, ver dónde se usa un símbolo (references), renombrar en todo el proyecto, autocompletado, diagnóstico en línea (errores subrayados), hover con documentación, etc. Se configura con `nvim-lspconfig` (que instala los servidores declarativos) + `mason.nvim` (que los descarga automáticamente, como un "gestor de paquetes de servidores").

### Treesitter

Un *parser* de cada lenguaje que construye un **árbol sintáctico** del código en tiempo real. Neovim usa ese árbol no solo para resaltar sintaxis (mucho mejor que el regex de colores de antaño) sino para reconocer bloques de código: `ci(` (cambiar contenido entre paréntesis), indentado automático inteligente, plegado de código por función... El editor "entiende" la estructura del lenguaje en lugar de limitarse a colorear texto.

### Autocompletado

Telescope buscador + nvim-cmp completador + LSP como fuente de sugerencias + snippets = la experiencia de autocompletado del IDE, todo en terminal.

---

## 8. ¿Puede reemplazar tu trabajo en VSCode?

Respuesta corta: **sí, para la inmensa mayoría de tareas de edición y código — con una curva de aprendizaje real a cambio**. Respuesta matizada: todo lo dél está cubierto, pero hay cosas más fáciles de hacer en un IDE gráfico.

| Lo que Neovim cubre estupendo | Lo que requiere esfuerzo o plugins |
|-------------------------------|-----------------------------------|
| Edición de texto (lo mejor del mercado) | Depuración visual (con `nvim-dap.nvim` + UI Sudo se puede, pero es más config) |
| Búsqueda, reemplazo, navegación | Git diff gráfico / paneles de merges visuales |
| Autocompletado y LSP en todos los lenguajes | Refactoring multi-archivo avanzado (el LSP ya lo da, pero hay Movimientos visuales de VSCode) |
| Terminal integrada (`:terminal`) | Plugins "todo-en-uno" robustos |
| Git (fugitive/octo, conflict markers) | Visualización gráfica de ramas |
| Múltiples cursores, macros, snippets | Algunas herramientas específicas (Emmet, plugins propietarios) |
| 0 segundos de arranque, funciona por SSH | — |

Lo más honesto: lo que en VSCode "viene por defecto con un clic" (tablas, autocompletado, explorador) aquí se instala como plugin y se configura. Si estás dispuesto a invertir **1–3 semanas** aprendiendo la lógica modal y copiando una buena configuración base, el nivel de productividad en tareas de código es comparable o superior — especialmente si programás de forma intensiva, porque la velocidad de edición con la gramática de comandos es incomparable.

Si el objetivo es *empezar ya* sin pelearte con 80 plugins al día 1, la vía pragmática es instalar una **distribución** lista:

- **LazyVim** (la más popular hoy): configuración remaster necesaria con todas las baterías incluidas. Tienes un Neovim "recargado" al instante y puedes ir quitando/añadiendo.
- **NvChad**, **AstroNvim**: alternativas maduras.
- **Comenzar desde cero** con `init.lua` propio: el camino más instructivo, pero más lento.

Mi recomendación para decidir: si quieres *trabajo hecho hoy*, empieza con LazyVim; si quieres *entender el editor*, construye el tuyo poco a poco.

---

## 9. Cómo empezar (plan de acción)

1. **Instalar Neovim** (≥ 0.9): en Linux con tu gestor de paquetes o descargando el binario. Comprueba con `nvim --version`.
2. **Aprender los modos sobre archivos reales**: `vimtutor` (o `:Tutor` dentro de Neovim) es un tutorial interactivo de ~30 min que enseña los fundamentos.
3. **Vivir en modo Normal**: resiste la tentación de usar flechas; practica `w`, `b`, `d`, `c`, `y`, `/buscar`.
4. **Configurar un objetivo**: empieza con una config minimalista propia (`init.lua` con opciones, keymaps y 3–5 plugins) y amplíala.
5. **Decidir el riesgo**: distribución (LazyVim) vs config propia.
6. **Estudiar en cada uso**: cada vez que quieras hacer algo que "no sabes hacer", busca el comando o plugin para ello; esa es la manera natural de crecer con Neovim.

---

## Resumen en una frase

Neovim es un editor modal, ligero, configurado con **Lua**, extensible con **plugins (lazy.nvim)**, que entiende la sintaxis del código con **Treesitter** y habla con los lenguajes vía **LSP** — y que, con una pequeña inversión de aprendizaje, puede reemplazar el día a día que hace un editor como VSCode.