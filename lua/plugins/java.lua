-- nvim-java: sets up jdtls together with java-debug-adapter and java-test (registers the java DAP adapter).
-- It downloads and manages its own jdtls, debug adapter and JDK 25 (jdtls needs Java 21-25, so a
-- system JDK 26 is rejected), independent of mason. Your projects still build with the system JDK.
-- It has to be configured before jdtls is enabled, so jdtls is deliberately not in lua/lsp/init.lua.
return {
  "nvim-java/nvim-java",
  ft = { "java" },
  config = function()
    require("java").setup()
    vim.lsp.enable("jdtls")
  end,
}
