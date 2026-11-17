-- ================================================================================================
-- TITLE : nvim-dap
-- ABOUT : debugging for python (debugpy), c/cpp/rust (codelldb), pascal (gdb), ocaml (earlybird) and java.
--         Java is handled by nvim-java (lua/plugins/java.lua), which registers its own adapter
--         and configurations once jdtls has attached.
-- ================================================================================================

local function dap() return require("dap") end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>b", function() dap().toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
    {
      "<leader>dB",
      function() dap().set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      desc = "DAP: conditional breakpoint",
    },
    { "<leader>dc", function() dap().continue() end, desc = "DAP: continue / start" },
    { "<leader>do", function() dap().step_over() end, desc = "DAP: step over" },
    { "<leader>di", function() dap().step_into() end, desc = "DAP: step into" },
    { "<leader>du", function() dap().step_out() end, desc = "DAP: step out" },
    { "<leader>dr", function() dap().repl.open() end, desc = "DAP: open REPL" },
    { "<leader>dl", function() dap().run_last() end, desc = "DAP: run last" },
    { "<leader>dt", function() dap().terminate() end, desc = "DAP: terminate" },
    { "<leader>dU", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
    { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "DAP: evaluate" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- installs the debug adapters below. They are defined by hand (not by mason-nvim-dap's
    -- handlers) so the launch configurations can build the program first.
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "codelldb" },
      handlers = { function() end },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

    local function notify_err(msg)
      vim.notify(msg, vim.log.levels.ERROR, { title = "DAP" })
    end

    -- Runs `cmd` synchronously and returns its result, or nil (after reporting stderr) on failure.
    local function build(cmd, cwd)
      local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
      if res.code ~= 0 then
        notify_err(("%s failed:\n%s"):format(cmd[1], res.stderr ~= "" and res.stderr or res.stdout))
        return nil
      end
      return res
    end

    local function build_output_path()
      local dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "dap")
      vim.fn.mkdir(dir, "p")
      return vim.fs.joinpath(dir, vim.fn.expand("%:t:r"))
    end

    -- ── python (debugpy) ─────────────────────────────────────────────────────────────────────
    -- `debugpy-adapter` is the launcher mason installs; it runs in mason's own venv, and the
    -- debuggee runs with `pythonPath` below.
    dap.adapters.python = { type = "executable", command = "debugpy-adapter" }

    local function python_path()
      local venv = vim.env.VIRTUAL_ENV
      if venv and venv ~= "" then
        return vim.fs.joinpath(venv, "bin", "python")
      end
      local root = vim.fs.root(0, { ".venv", "venv", "pyproject.toml", ".git" }) or vim.fn.getcwd()
      for _, name in ipairs({ ".venv", "venv" }) do
        local candidate = vim.fs.joinpath(root, name, "bin", "python")
        if vim.fn.executable(candidate) == 1 then
          return candidate
        end
      end
      return vim.fn.exepath("python3")
    end

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        pythonPath = python_path,
        cwd = "${workspaceFolder}",
      },
    }

    -- ── c / c++ / rust (codelldb) ────────────────────────────────────────────────────────────
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    }

    local function prompt_for_executable()
      local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      return path ~= "" and path or dap.ABORT
    end

    local function c_family_build()
      local cc = vim.bo.filetype == "c" and "gcc" or "g++"
      local out = build_output_path()
      if not build({ cc, "-g", "-O0", vim.fn.expand("%:p"), "-o", out }) then
        return dap.ABORT
      end
      return out
    end

    local c_family = {
      {
        name = "Build current file (-g) and launch",
        type = "codelldb",
        request = "launch",
        program = c_family_build,
        cwd = "${workspaceFolder}",
        terminal = "integrated",
      },
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = prompt_for_executable,
        cwd = "${workspaceFolder}",
        terminal = "integrated",
      },
    }
    dap.configurations.c = c_family
    dap.configurations.cpp = c_family

    local function cargo_root()
      return vim.fs.root(0, "Cargo.toml")
    end

    local function rust_build()
      local root = cargo_root()
      if not root then -- single file: compile it with debug info
        local out = build_output_path()
        if not build({ "rustc", "-g", vim.fn.expand("%:p"), "-o", out }) then
          return dap.ABORT
        end
        return out
      end
      local res = build({ "cargo", "build", "--message-format=json" }, root)
      if not res then
        return dap.ABORT
      end
      local exe
      for line in res.stdout:gmatch("[^\r\n]+") do
        local ok, msg = pcall(vim.json.decode, line)
        if ok and msg.reason == "compiler-artifact" and msg.executable and vim.tbl_contains(msg.target.kind, "bin") then
          exe = msg.executable
        end
      end
      if not exe then
        notify_err("cargo build produced no binary target")
        return dap.ABORT
      end
      return exe
    end

    dap.configurations.rust = {
      {
        name = "Build (cargo / rustc) and launch",
        type = "codelldb",
        request = "launch",
        program = rust_build,
        cwd = function() return cargo_root() or vim.fn.getcwd() end,
        terminal = "integrated",
      },
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = prompt_for_executable,
        cwd = "${workspaceFolder}",
        terminal = "integrated",
      },
    }

    -- ── pascal (gdb's built-in DAP, gdb >= 14) ──────────────────────────────────────────────
    -- lldb handles FPC's DWARF poorly (no Pascal strings/sets), so pascal goes through gdb.
    dap.adapters.gdb = { type = "executable", command = "gdb", args = { "--interpreter=dap", "--quiet" } }

    local function pascal_build()
      local out = build_output_path()
      local dir = vim.fn.expand("%:p:h")
      local units = vim.fs.joinpath(vim.fn.stdpath("cache"), "dap", "pascal-units")
      vim.fn.mkdir(units, "p")
      local cmd = { "fpc", "-Mobjfpc", "-Sh", "-g", "-gw3", "-gl", "-O-", "-Fu" .. dir, "-Fu" .. dir .. "/../src" }
      vim.list_extend(cmd, { "-FU" .. units, "-o" .. out, vim.fn.expand("%:p") })
      if not build(cmd) then
        return dap.ABORT
      end
      return out
    end

    dap.configurations.pascal = {
      {
        name = "Build current program (-g) and launch",
        type = "gdb",
        request = "launch",
        program = pascal_build,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Launch executable",
        type = "gdb",
        request = "launch",
        program = prompt_for_executable,
        cwd = "${workspaceFolder}",
      },
    }

    -- ── ocaml (earlybird) ────────────────────────────────────────────────────────────────────
    -- `opam install earlybird`; debugs dune-built bytecode executables (`dune build ./bin/main.bc`).
    -- With `(lang dune 3.0)` or newer, breakpoints are only hit if dune-project has
    -- `(lang dune 3.7)` (or later) and `(map_workspace_root false)`. The debugger opens dune's copy
    -- of the source under _build/default/.
    dap.adapters.ocamlearlybird = { type = "executable", command = "ocamlearlybird", args = { "debug" } }

    dap.configurations.ocaml = {
      {
        name = "Launch bytecode executable (dune build first)",
        type = "ocamlearlybird",
        request = "launch",
        stopOnEntry = false,
        program = function()
          local root = vim.fs.root(0, { "dune-project", "dune-workspace" }) or vim.fn.getcwd()
          local path = vim.fn.input("Bytecode executable: ", root .. "/_build/default/bin/main.bc", "file")
          if path == "" then
            return dap.ABORT
          end
          local rel = path:match("_build/default/(.+)$")
          if rel and vim.fn.executable("dune") == 1 and not build({ "dune", "build", "./" .. rel }, root) then
            return dap.ABORT
          end
          return path
        end,
      },
    }
  end,
}
