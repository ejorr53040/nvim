# Keybindings

Leader is `<Space>`; localleader is the default `\`. Sections run roughly from most to least used.
Run `:map <key>` (or `:Telescope keymaps`) to see what a key is bound to right now.

## Everyday navigation & search

| Key | Action |
|---|---|
| `<leader>ff` | Telescope: find files (remote picker while a jupynvim SSH session is active) |
| `<leader>fg` | Telescope: live grep |
| `<leader>fb` | Telescope: buffers |
| `<leader>fh` | Telescope: help tags |
| `<leader>fs` | Neo-tree: reveal file in filesystem (left) |
| `<leader><Space>` | Find files (snacks picker; remote when SSH-connected) |
| `<leader>/` / `<leader>sg` | Grep (snacks picker; remote when SSH-connected) |
| `<leader>e` / `<leader>E` | File explorer at project root / cwd (snacks explorer; remote tree when SSH-connected) |
| `K` | Hover documentation (Lspsaga) |
| `gd` | Go to definition (native) |
| `<leader>gd` | Peek definition (Lspsaga) |
| `<leader>gD` | Go to definition (Lspsaga) |
| `<leader>gS` | Go to definition in vertical split |
| `gx` | Open file path / URL under cursor |

The `<leader><Space>`, `<leader>/`, `<leader>sg`, `<leader>e`, `<leader>E` and `<C-/>` keys are
installed by jupynvim; without an SSH session they fall back to the local snacks.nvim equivalent.

## Terminals

| Key | Action |
|---|---|
| `<C-s>` (normal, insert, terminal) | Toggle bottom terminal (toggleterm) |
| `<C-/>` / `<C-_>` (normal, terminal) | Toggle bottom terminal (snacks; remote PTY when SSH-connected) |
| `<leader>tr` | Toggle right-side remote terminal (only while SSH-connected) |

## Claude chat (agentic.nvim)

Right-side chat bar backed by Claude Code over ACP. Hiding it keeps the session running.

| Key | Action |
|---|---|
| `<C-\>` (normal, visual, insert) | Toggle the chat bar (start / hide) |
| `<C-'>` (normal, visual) | Add current file or selection to Claude's context |
| `<C-,>` (normal, visual, insert) | New Claude session |
| `<leader>as` | Stop the current Claude response |

Inside the chat bar (plugin defaults):

| Key | Action |
|---|---|
| `<CR>` / `<C-s>` | Submit prompt |
| `<S-Tab>` | Switch agent mode |
| `q` | Hide the chat bar |
| `\m` | Switch model |
| `\s` | Switch provider |
| `\t` | Select thinking level |
| `\l` | List sessions |
| `\p` (normal) / `<C-v>` (insert) | Paste image |
| `]c` / `[c` | Next / previous hunk while reviewing a proposed edit |

## Text editing (mini.nvim defaults)

| Key | Action |
|---|---|
| `gcc` / `gc{motion}` / `gc` (visual) | Toggle comment on line / motion / selection |
| `gc` (operator-pending) | Comment textobject (e.g. `dgc` deletes a comment block) |
| `sa{motion}{char}` / `sa{char}` (visual) | Surround: add (e.g. `saiw"`) |
| `sd{char}` | Surround: delete |
| `sr{old}{new}` | Surround: replace |
| `sf` / `sF` | Surround: find right / left part |
| `sh` | Surround: highlight |
| `sdn` `sdl`, `srn` `srl`, `sfn` `sfl`, `sFn` `sFl`, `shn` `shl` | Same actions on the next (`n`) / previous (`l`) surrounding |
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | Move line (normal) or selection (visual) left / down / up / right |
| `a` / `i` + `f` `a` `b` `q` `t` | Extra textobjects: function call, argument, bracket, quote, tag (e.g. `daa`, `cif`) |
| `an` / `in` / `al` / `il` + object | Next / last textobject (e.g. `cinq` = change inside next quote) |
| `g[` / `g]` + object | Jump to start / end of textobject |
| `ii` / `ai` | Indent scope textobject (without / with border lines) |
| `[i` / `]i` | Jump to top / bottom of the current indent scope |
| `(` `[` `{` `"` `'` `` ` `` (insert) | Auto-pairs; typing the closer skips over it, `<BS>` / `<CR>` inside a pair handle both sides |

## LSP: editing & fixing code

Set on `LspAttach` (buffer-local), except the native `gr*` / `gO` / `[d` defaults, which are global.

| Key | Action |
|---|---|
| `<leader>ca` | Code actions (Lspsaga) |
| `<leader>rn` | Rename symbol (Lspsaga) |
| `<leader>dd` | Cursor diagnostics |
| `<leader>D` | Line diagnostics (float) |
| `<leader>nd` / `<leader>pd` | Next / previous diagnostic (Lspsaga) |
| `<leader>oi` | Organize imports (+ format) |
| `<leader>fd` | LSP finder (definitions + references, fzf-lua) |
| `<leader>fr` | LSP references |
| `<leader>fo` | Document symbols |
| `<leader>fw` | Workspace symbols |
| `<leader>fi` | Go to implementation |
| `<leader>ft` | Go to type definition |
| `<leader>cf` | Pascal only: format with Jedi Code Formatter (saves first) |
| `grn` / `gra` / `grr` / `gri` / `grt` / `grx` | Native: rename / code action / references / implementation / type definition / run codelens |
| `gO` | Native: document symbols (location list) |
| `[d` / `]d`, `[D` / `]D` | Previous / next diagnostic, first / last diagnostic |
| `<C-w>d` | Diagnostics under cursor (float) |
| `<Tab>` / `<S-Tab>` (insert, select) | Jump to next / previous snippet placeholder |

Native insert-mode `<C-s>` (signature help) is shadowed by toggleterm's `<C-s>`.

Formatting also runs on save (ruff, clangd, rust-analyzer, ocamllsp, efm); Java is skipped.

## Code running

| Key | Action |
|---|---|
| `<leader>rr` | Run code |
| `<leader>rf` | Run file |
| `<leader>rp` | Run project |
| `<leader>rc` | Close runner |
| `<leader>rft` | Run file in new tab |
| `<leader>crf` | Set filetype runner command |
| `<leader>crp` | Set project runner command |
| `<leader>sr` (visual) | Run selected snippet in place (sniprun) |
| `<leader>sr` | Run current line (sniprun) |
| `<leader>sc` | Clear snippet output |
| `<leader>sl` (visual) | Look up selection on the web |

## Debugging (DAP)

| Key | Action |
|---|---|
| `<leader>b` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>du` | Step out |
| `<leader>dU` | Toggle DAP UI |
| `<leader>de` | Evaluate (normal + visual) |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last |
| `<leader>dt` | Terminate |

## Jupyter notebooks (jupynvim, `.ipynb` buffers only)

Buffer-local; inside a notebook these win over the global `<leader>n…` minimap / diagnostic keys.

| Key | Action |
|---|---|
| `<S-CR>` (normal, insert) / `<leader>nr` | Run cell and advance |
| `<C-CR>` (normal, insert) | Run cell |
| `<leader>nR` | Run all cells |
| `<leader>nA` / `<leader>nB` | Run all cells above / below |
| `<leader>na` / `<leader>nb` | Add cell above / below |
| `<leader>nd` | Delete cell |
| `<leader>nk` / `<leader>nj` | Move cell up / down |
| `<leader>nm` / `<leader>ny` | Convert to markdown / code cell |
| `]c` / `[c` | Next / previous cell |
| `]i` / `[i` | Next / previous image cell |
| `<C-j>` / `<C-k>` | Enter output below / above |
| `<leader>nK` | Pick kernel |
| `<leader>ns` / `<leader>nS` | Start / stop kernel |
| `<leader>ni` | Interrupt kernel |
| `<leader>nx` | Restart kernel |
| `<leader>no` | Expand / collapse truncated output |
| `<leader>nO` | Hide / show cell output |
| `<leader>nl` | Show N lines of cell output |
| `<leader>nc` / `<leader>nC` | Clear cell output / all outputs |
| `<leader>nI` / `<leader>nD` | Save / delete cell image |
| `<leader>nL` | Refresh notebook display |
| `gx` | Open link under cursor |

## Git

| Key | Action |
|---|---|
| `<leader>gg` | Open Neogit (`?` inside for its key help) |

## Markdown preview

| Key | Action |
|---|---|
| `<leader>mp` | Start live preview |
| `<leader>ms` | Stop live preview |

## PDF viewer (pdfview.nvim)

| Key | Action |
|---|---|
| `<leader>pv` | Open PDF viewer (Telescope file picker) |
| `<leader>pn` | Next page |
| `<leader>pp` | Previous page |

## Database viewer (vim-dadbod-ui)

| Key | Action |
|---|---|
| `<leader>db` | Toggle database UI drawer |
| `nvim file.db` / `:e file.sqlite` | Open a SQLite file straight in the drawer |
| `<CR>` on a table → `List` | Show table rows |
| `<leader>S` (in query buffer) | Run query |

## LaTeX (vimtex defaults, `.tex` buffers only)

A successful compile opens the PDF in PDFview automatically.

| Key | Action |
|---|---|
| `\ll` | Toggle continuous compilation |
| `\lk` | Stop compilation |
| `\lv` | View output |
| `\le` | Show errors / warnings |
| `\lc` / `\lC` | Clean auxiliary files / clean everything |
| `\lt` | Table of contents |
| `\li` | vimtex info |
| `ie` / `ae`, `ic` / `ac`, `i$` / `a$`, `id` / `ad` | Textobjects: environment, command, math, delimiter |
| `cse` / `dse` | Change / delete surrounding environment |
| `tse` / `tsd` | Toggle starred environment / `\left…\right` delimiters |
| `]]` (insert) | Close the current environment |

## OCaml (ocaml.nvim defaults, active after opening an OCaml file)

| Key | Action |
|---|---|
| `\t` | Show type under cursor and start a type-enclosing session |
| `<Up>` / `<Down>` (in session) | Grow / shrink the enclosing expression |
| `<Right>` / `<Left>` (in session) | Increase / decrease type verbosity |
| `<Esc>` (in session) | Exit the type-enclosing session |
| `\n` / `\p` | Jump to next / previous typed hole |
| `\c` | Construct: list valid substitutions for the hole |
| `\j` | List jump targets from here |
| `\pn` / `\pp` | Jump to next / previous phrase |
| `\i` | Infer the interface from the implementation |
| `\s` | Switch between `.ml` and `.mli` |

## Treesitter selection

| Key | Action |
|---|---|
| `<C-space>` (normal) | Select node |
| `<C-space>` (visual) | Select parent node |
| `<BS>` (visual) | Select child node |
| `]n` / `[n` (visual) | Select next / previous node |
| `]N` / `[N` (visual) | Select next / previous sibling node |

## Minimap (neominimap)

| Key | Action |
|---|---|
| `<leader>nm` | Toggle global minimap |
| `<leader>no` / `<leader>nc` | Enable / disable global minimap |
| `<leader>nr` | Refresh global minimap |
| `<leader>nf` / `<leader>nu` | Focus / unfocus minimap |
| `<leader>ns` | Switch focus on minimap |
| `<leader>nwt` / `<leader>nwr` / `<leader>nwo` / `<leader>nwc` | Toggle / refresh / enable / disable minimap for window |
| `<leader>ntt` | Toggle minimap (global toggle; the tab flag alone can't show it) |
| `<leader>ntr` / `<leader>nto` / `<leader>ntc` | Refresh / enable / disable minimap for tab |
| `<leader>nbt` / `<leader>nbr` / `<leader>nbo` / `<leader>nbc` | Toggle / refresh / enable / disable minimap for buffer |

## Neo-tree window (plugin defaults)

| Key | Action |
|---|---|
| `<CR>` / `<Space>` | Open / toggle node |
| `s` / `S` / `t` / `w` | Open in vsplit / split / new tab / picked window |
| `P` / `l` | Toggle preview / focus preview |
| `C` / `z` | Close node / close all nodes |
| `a` / `A` | Add file / directory |
| `d` / `r` / `b` | Delete / rename / rename basename |
| `T` / `u` / `U` | Trash / undo trash / restore from trash |
| `y` / `x` / `p` / `<C-r>` | Copy / cut / paste / clear clipboard |
| `c` / `m` | Copy / move to path |
| `H` | Toggle hidden files |
| `/` / `D` / `#` / `f` / `<C-x>` | Fuzzy find / fuzzy find directory / fuzzy sort / filter / clear filter |
| `<BS>` / `.` | Navigate up / set root |
| `[g` / `]g` | Previous / next git-modified file |
| `i` | File details |
| `o` + `c` `d` `g` `m` `n` `s` `t` | Order by created / diagnostics / git / modified / name / size / type |
| `R` | Refresh |
| `<` / `>` | Previous / next source |
| `q` / `?` | Close / help |

## Built-in bracket motions (Neovim defaults)

| Key | Action |
|---|---|
| `[b` / `]b`, `[B` / `]B` | Previous / next buffer, first / last buffer |
| `[q` / `]q`, `[Q` / `]Q`, `[<C-q>` / `]<C-q>` | Quickfix: previous / next, first / last, previous / next file |
| `[l` / `]l`, `[L` / `]L`, `[<C-l>` / `]<C-l>` | Location list: previous / next, first / last, previous / next file |
| `[t` / `]t`, `[T` / `]T`, `[<C-t>` / `]<C-t>` | Tag: previous / next, first / last, preview previous / next |
| `[a` / `]a`, `[A` / `]A` | Argument list: previous / next, first / last |
| `[<Space>` / `]<Space>` | Add empty line above / below |
