Hello! 
put this in .config in your computer and have neovim installed, idk about windows but probably same

## Language tooling

Neovim 0.12+, `git`, `tree-sitter` (CLI), a C compiler, `curl` and `tar` are needed.
Plugins, Mason packages and treesitter parsers install themselves on first start.

| Language | LSP | Format on save | Debugger (`<leader>dc`) |
|---|---|---|---|
| Python | pyright + ruff | ruff | debugpy |
| C / C++ | clangd | clangd (clang-format) | codelldb |
| Rust | rust-analyzer | rust-analyzer (rustfmt) | codelldb (`cargo build` first) |
| Java | jdtls via nvim-java | off (format manually) | java-debug-adapter via nvim-java |
| OCaml | ocamllsp | ocamlformat, only with a `.ocamlformat` file | earlybird |

Things that are not installed by the config itself:

- **OCaml**: `opam init`, then `opam switch create default ocaml-system` and
  `opam install ocaml-lsp-server dune ocamlformat earlybird`. The `~/.opam/default/bin` directory is
  added to `PATH` by `lua/lsp/init.lua`. For debugging, `dune-project` needs `(lang dune 3.7)` (or
  newer) and `(map_workspace_root false)`, and the program must be built as bytecode
  (`dune build ./bin/main.bc`).
- **Java**: nvim-java downloads its own JDK 25, jdtls and debug adapter into `~/.local/share/nvim/nvim-java`
  (jdtls does not run on newer JDKs). jdtls only starts inside a project (`pom.xml`, Gradle files or `.git`).
- **Go**: `gopls` is installed by Mason, which needs `go` on `PATH`.
- **C / C++**: clangd needs a `compile_commands.json` for real projects (`bear -- make`, or
  `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`).

Debug keys: `<leader>b` / `<leader>db` breakpoint, `dB` conditional breakpoint, `dc` continue/start,
`do` step over, `di` step into, `du` step out, `dr` REPL, `dl` run last, `dt` terminate, `dU` toggle UI.
