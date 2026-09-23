# Solución de problemas (troubleshooting)

Errores frecuentes de esta configuración y cómo resolverlos. Cuando algo falle, empieza siempre por aquí; el diagnóstico más potente de Neovim es `:checkhealth`.

---

## 1. Diagnóstico general

```
:checkhealth        ← estado de Neovim, plugins y dependencias
:Lazy health        ← estado de los plugins gestionados
:Mason              ← estado de los servidores LSP
```

`checkhealth` marca en verde lo que está bien y en rojo lo que falta, con la instrucción exacta para arreglarlo.

---

## 2. Problemas y soluciones

### El buscador de archivos no encuentra nada (Telescope `find_files`)

- **Síntoma**: `<leader>ff` abre el buscador pero no lista archivos.
- **Causa**: sin `fd` o `rg`, Telescope usa el buscador lento propio.
- **Solución**: instala `ripgrep` (necesario también para `<leader>fg`):
  ```
  sudo apt install ripgrep        # Debian/Ubuntu
  brew install ripgrep            # macOS
  ```

### `live_grep` (<leader>fg) da error

- **Causa**: ripgrep no está instalado (ver arriba).

### Ningún autocompletado aparece (nvim-cmp)

- **Causa 1**: el LSP no está activo en ese archivo (sin servidor no hay sugerencias de código).
  Comprueba con `:LspInfo` qué servidores están conectados al buffer.
- **Causa 2**: el servidor no está instalado. Abre `:Mason` y busca el correspondiente al lenguaje.

### El LSP no arranca (`pyright`, `lua_ls`...)

```
:LspInfo         ← qué servidor debería atender este archivo y por qué no
:Mason           ← ¿está el servidor instalado? (x = instalar)
```

Causas típicas:
- El nombre del servidor está mal en `ensure_installed` (consulta `:h mason-lspconfig`).
- El servidor necesita un binario del sistema (p. ej. `clangd` necesita `clang`; los servidores de JS necesitan `node`). El mensaje de error de `:LspInfo` lo dice.

### Los colores se ven mal o sin resaltado

- **Causa**: tu terminal no soporta truecolor o la variable `TERM` no lo indica.
- **Solución**: dentro de Neovim pulsa `:set termguicolors` y mira. Si no mejora, configura tu terminal (kitty, alacritty, gnome-terminal) y revisa que `$TERM` no sea `xterm` a secas:
  ```
  export TERM=xterm-256color
  ```

### No funciona copiar/pegar con el portapapeles del sistema

- **Causa**: falta un proveedor de portapapeles (xclip / wl-clipboard / pbcopy).
- **Solución**:
  ```
  sudo apt install xclip xsel     # X11
  sudo apt install wl-clipboard   # Wayland
  ```
  Después reinicia Neovim y prueba `yy` y pegar fuera.

### Los iconos/flechas salen cuadrados (□□)

- **Causa**: esta config usa separadores planos (sin iconos), pero si algún plugin muestra un glifo que tu fuente no tiene, se ve un cuadro.
- **Solución**: instala una **Nerd Font** (p. ej. `JetBrainsMono Nerd Font`) y ajústala en tu terminal. No es imprescindible para nada de este setup.

### Los parsers de Treesitter no se instalan

- **Causa**: Neovim 0.12 compila los parsers con `tree-sitter-cli` (≥ 0.26.1), y no está en tu sistema (el apt de Ubuntu trae una versión más vieja).
- **Solución**: instala la CLI reciente desde [releases de tree-sitter](https://github.com/tree-sitter/tree-sitter/releases) (binario comprimido a `~/bin` o `/usr/local/bin`), o con `cargo install tree-sitter-cli`. Luego reinicia Neovim (o `:TSInstall <lenguaje>`).
- Si no lo instalas, la config funciona igual: solo faltará el resaltado por árbol (el de Neovim clásico sigue activo).

### `necesitas tree-sitter-cli` en el log de arranque

Es el aviso de lo anterior: no es un error fatal. Ver solución arriba.

### `:Lazy` da error de "E5560" o no encuentra plugins

- **Causa**: lazy.nvim no está instalado (o el runtimepath quedó roto).
- **Solución** (manualmente, si el bootstrap no funcionó):
  ```
  git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git \
    ~/.local/share/nvim/lazy/lazy.nvim
  ```

### Al guardar, el archivo se "limpia solo" y no quiero

- **Causa**: el autocomando que elimina espacios finales (`lua/config/autocmds.lua`).
- **Solución**: coméntalo si prefieres respetar el texto tal cual.

### Neovim se abre pero la configuración no se aplica

- **Causa**: Neovim no está leyendo este repo. Comprueba el symlink:
  ```
  ls -la ~/.config/nvim
  readlink ~/.config/nvim
  ```
  Debe apuntar a este repositorio. Si no, vuelve a ejecutar `./install.sh`.

### Los cambios del repo no se reflejan tras editar

- Pulsa `:source $MYVIMRC` para recargar (o reinicia Neovim).
- En plugins: `:Lazy reload <plugin>`.

---

## 3. Si nada de esto funciona

1. Recarga limpio: `:Lazy sync` y luego `:checkhealth`.
2. Mira los mensajes de error al arrancar: Neovim los muestra con `:messages`.
3. Ejecuta `nvim --headless +"checkhealth" +qa` desde la terminal para ver el diagnóstico completo sin abrir la UI.
4. Conservador: si roto mucho y quieres volver al estado seguro:
   ```
   ./install.sh    # re-sincroniza plugins según la lista
   ```
   Para un reset total: borra `~/.local/share/nvim` (caché y plugins) y vuelve a `./install.sh`.