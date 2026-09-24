# ¿Cómo actualizar Neovim?

Esta guía explica cómo mantener Neovim al día: el **binario** (el programa en sí), la **configuración** (este repo) y, de paso, los **plugins** cuando los tengas.

---

## 1. Actualizar el binario de Neovim

Neovim publica versiones estables en su página de releases de GitHub (y una rama `nightly` con las novedades en desarrollo). En este equipo Neovim está instalado **a mano desde el tarball oficial**:

```
/usr/local/bin/nvim  →  /opt/nvim/bin/nvim
```

Por eso se actualiza descargando la última versión y reemplazando la instalación, sin tocar la configuración.

### Paso 0 — Comprobar la versión actual

```
nvim --version
```

### Paso 1 — Descargar la última versión estable

```
curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
```

### Paso 2 — Reemplazar la instalación

Como el symlink apunta a `/opt/nvim`, se extrae el contenido **dentro** de esa carpeta para no romperlo:

```
sudo tar -C /opt/nvim --strip-components=1 -xzf /tmp/nvim.tar.gz
```

(El tarball trae una carpeta `nvim-linux-x86_64/`; `--strip-components=1` la "aplana" para que los binarios caigan en `/opt/nvim/bin/`. Alternativa: borrar `/opt/nvim` y recrear el symlink.)

### Paso 3 — Verificar

```
nvim --version
```

Debería mostrar la nueva versión (p. ej. `NVIM v0.13.0`).

### Otras formas de actualizar (según cada caso)

| Método | Cuándo usarlo | Comentario |
|--------|---------------|------------|
| **Tarball oficial** (el de arriba) | Instalación manual como la de este equipo | Siempre la última estable, sin permisos extra aparte del `sudo` al extraer |
| **AppImage** | Quieres lo último sin tocar `/opt` | `nvim.appimage` se descarga y ejecuta directamente, sin root |
| Gestor de paquetes (`apt`, `snap`, `flatpak`, `brew`) | Prefieres que el sistema gestione actualizaciones | Cómodo, pero suelen llevar versiones más viejas que la última estable |
| Gestor de versiones (`mise`, `asdf`) | Quieres cambiar entre versiones o probar `nightly` | Instala varias versiones y alterna con un comando |

> **Nota**: tu `apt` de Ubuntu no es quien instaló este Neovim (`/usr/local/bin` no lo gestiona). Si algún día lo instalas con `apt`, recuerda que la versión puede quedar desactualizada respecto a la oficial.

---

## 2. Actualizar la configuración (este repo)

La configuración vive en este repositorio de dotfiles y se sincroniza a `~/.config/nvim` (Neovim lee `init.lua` de ahí al arrancar).

1. **Traer los últimos cambios** del repo:

   ```
   cd ~/Projects/nvim-config
   git pull
   ```

2. **Sincronizar a `~/.config/nvim`** (copiar o, mejor, crear un symlink para que sea siempre la misma versión):

   ```
   ln -s ~/Projects/nvim-config ~/.config/nvim
   ```

3. **Aplicar los cambios**: reinicia Neovim o recarga la configuración sin salir:

   ```
   :source $MYVIMRC
   ```

---

## 3. Actualizar plugins (cuando los tengas)

El `init.lua` actual de este repo **no usa gestor de plugins**, así que de momento no hay nada que actualizar aquí. Si más adelante añades `lazy.nvim` (el estándar de la comunidad), la actualización se hace desde dentro de Neovim:

```
:Lazy sync       ← actualizar y sincronizar plugins
:Lazy update     ← solo actualizar lo instalado
```

---

## 4. Comprobación final

Tras cualquier actualización conviene verificar que todo está en orden:

```
nvim --version    ← versión del binario
```

y dentro de Neovim:

```
:checkhealth      ← estado de Neovim, plugins y dependencias del sistema
```

---

## Resumen en una frase

El binario se actualiza **descargando el tarball oficial de GitHub y reemplazando `/opt/nvim`** (sin tocar la configuración); la configuración se actualiza con `git pull` + sincronización a `~/.config/nvim`; y los plugins, cuando existan, con `:Lazy`.