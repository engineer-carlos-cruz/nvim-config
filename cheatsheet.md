# Chuleta de comandos de Vim/Neovim

Referencia rápida para el día a día. Complementa la guía [base.md](base.md), que explica la teoría.

> Convención de esta chuleta: `x` = tecla literal, `gx` = tecla tras `g`, `d` + `w` = borrar palabra, `:cmd` = comando en la línea de comandos, `<C-x>` = Ctrl+x, `<leader>` = barra espaciadora (en esta config).

---

## 1. Modos

| Entrar | Modo | Uso |
|---|---|---|
| `Esc` / `<C-[>` | → Normal | Comandos y movimientos |
| `i` `a` `o` `I` `A` `O` | → Insertar | Escribir texto |
| `v` (carácter) `V` (línea) `<C-v>` (bloque) | → Visual | Seleccionar |
| `:` | → Comandos | Ejecutar comandos |
| `R` | → Reemplazar | Sobrescribir carácter a carácter |

---

## 2. Movimientos

| Teclas | Qué hace |
|---|---|
| `h` `j` `k` `l` | Izquierda, abajo, arriba, derecha |
| `w` `W` | Siguiente palabra (W ignora puntuación) |
| `b` `B` | Palabra anterior |
| `e` `E` | Final de la palabra |
| `0` `^` `$` | Inicio / primer carácter / fin de línea |
| `gg` `G` | Primera / última línea del archivo |
| `{` `}` | Párrafo (bloque) anterior / siguiente |
| `%` | Paréntesis/llave/corchete que empareja |
| `f{ch}` `F{ch}` | Siguiente / anterior carácter en la línea |
| `t{ch}` `T{ch}` | Igual pero justo antes del carácter |
| `<C-f>` `<C-b>` | Pantalla hacia delante / atrás |
| `<C-d>` `<C-u>` | Media pantalla abajo / arriba |
| `<C-o>` `<C-i>` | Saltar atrás / adelante en el historial de saltos |

Números como prefijo repiten: `3j` baja 3, `2w` avanza 2 palabras, `5dd` borra 5 líneas.

---

## 3. Edición (verbos + objetos)

| Verbo | Qué hace |
|---|---|
| `d` | Borrar (cortar) |
| `c` | Cambiar (borrar y entrar en Insertar) |
| `y` | Copiar (yank) |
| `p` `P` | Pegar (después / antes) |
| `>…` `<…` | Indentar a la derecha / izquierda |
| `x` `X` | Borrar carácter bajo / antes del cursor |
| `u` `<C-r>` | Deshacer / rehacer |
| `.` | Repetir el último cambio |
| `~` | Cambiar mayúscula/minúscula |

### Objetos de texto (se usan tras un verbo)

| Objeto | Significado |
|---|---|
| `w` `W` | Palabra |
| `s` `p` | Oración / párrafo |
| `t{` `i{` (o `[`, `(`, `<`, `"`, `'`) | Hasta / dentro de… |
| `a` + delimitador | Todo incluido el delimitador (`da"` borra todo entre comillas) |
| `i` + delimitador | Solo el contenido (`ci(` cambia lo que hay entre paréntesis) |

Ejemplos: `ci"` → cambia el contenido entre comillas; `di(` → borra el contenido de un paréntesis; `yit` → copia el contenido de una etiqueta HTML/XML.

---

## 4. Búsqueda

| Teclas | Qué hace |
|---|---|
| `/patrón` `?patrón` | Buscar hacia delante / atrás (`n` / `N` para siguiente/anterior) |
| `*` `#` | Buscar la palabra bajo el cursor |
| `:s/a/b/` | Sustituir en la línea actual |
| `:%s/a/b/g` | Sustituir en todo el archivo |
| `:%s/a/b/gc` | Igual pero pidiendo confirmación |

En esta config, `<Esc>` en modo normal limpia el resaltado de la búsqueda.

---

## 5. Ventanas, buffers y pestañas

| Teclas / comando | Qué hace |
|---|---|
| `:split` / `:vsplit` | Dividir horizontal / vertical |
| `<C-w>s` / `<C-w>v` | Dividir horizontal / vertical |
| `<C-w>h/j/k/l` (o `<C-h>` aquí) | Ir a otra ventana |
| `<C-w>+` / `<C-w>-` / `<C-w>>` / `<C-w><` | Ajustar tamaño |
| `<C-w>o` | Cerrar el resto de ventanas |
| `:ls` / `:buffers` | Listar buffers |
| `:bn` / `:bp` | Buffer siguiente / anterior |
| `:bd` | Cerrar buffer |
| `:tabnew` | Nueva pestaña |
| `gt` / `gT` | Siguiente / anterior pestaña |
| `<C-w>n` + `:terminal` | Terminal integrada (`<leader>t` aquí) |

---

## 6. Registros, marcas y macros

| Teclas | Qué hace |
|---|---|
| `"ay` / `"ap` | Copiar / pegar en el registro `a` (letras a–z) |
| `ma` … `'a` | Marcar / ir a la marca `a` |
| `q a` … `q` | Grabar macro en el registro `a` |
| `@a` | Repetir la macro `a` |
| `@@` | Repetir la última macro |
| `:reg` | Ver el contenido de los registros |

---

## 7. Comandos `:` útiles

| Comando | Qué hace |
|---|---|
| `:w` `:q` `:wq` `:q!` | Guardar, salir, guardar+y salir, salir sin guardar |
| `:e archivo` | Abrir archivo |
| `:b` | Cambiar de buffer |
| `:Ex` | Explorador de archivos (netrw) |
| `:Terminal` | Terminal integrada |
| `:Lazy` | Gestor de plugins (lazy.nvim) |
| `:Mason` | Gestor de servidores LSP |
| `:checkhealth` | Diagnóstico del sistema |
| `:set <opción>?` | Ver el valor de una opción |
| `:help <tema>` | Ayuda (p. ej. `:help motion.txt`) |
| `:Tutor` | Tutorial interactivo integrado |

---

## 8. Atajos propios de esta configuración

Viven en [lua/config/keymaps.lua](lua/config/keymaps.lua).

| Tecla | Acción |
|---|---|
| `<leader>w` / `<leader>q` | Guardar / cerrar ventana |
| `<leader>e` / `<leader>ee` | Explorador ortogonal / vertical |
| `<leader>t` | Terminal integrada |
| `<S-h>` / `<S-l>` | Buffer anterior / siguiente |
| `<leader>bd` / `<leader>bl` | Cerrar buffer / listar buffers |
| `<C-h/j/k/l>` | Ir a la ventana contigua |
| `<leader>sh` / `<leader>sv` | Dividir horizontal / vertical |
| `J` / `K` (visual) | Mover líneas seleccionadas |
| `<leader>n` | Alternar números de línea |
| `<leader>ff` / `fg` / `fb` / `fh` | Telescope: archivos / texto / buffers / ayuda |
| `gd` `K` `gr` `gi` | LSP: definición / hover / referencias / implementaciones |
| `<leader>rn` `<leader>ca` `<leader>f` | LSP: renombrar / acciones / formatear |
| `[d` `]d` `<leader>d` | LSP: diagnósticos anterior / siguiente / flotante |
| `]c` `[c` `<leader>gp` `<leader>gr` | Git: hunks anterior / siguiente / preview / reset |
| `gcc` / `gc` (visual) | Comentar / descomentar (Comment.nvim) |

---

## 9. Chuleta de supervivencia

No sabes qué hacer → `:` + `help`; te perdiste → `<C-o>`; rompiste algo → `u`; conflicto de git → busca `<<<<<<<` y decide. Cuando algo te falte, mira [troubleshooting.md](troubleshooting.md).