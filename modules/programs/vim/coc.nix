{ pkgs }:
{
  "coc.preferences.formatOnSaveFiletypes" = [
    "javascript"
    "javascriptreact"
    "typescript"
    "typescriptreact"
    "json"
    "haskell"
    "css"
    "Markdown"
  ];
  "coc.preferences.formatOnTypeFiletypes" = [
    "javascript"
    "css"
    "Markdown"
    "python"
    "json"
  ];
  "diagnostic.checkCurrentLine" = true;
  "texlab.path" = "${pkgs.texlab}/bin/texlab";
  languageserver = {
    # nix = {
    #   command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
    #   filetypes =  [ "nix" ];
    # };
    ccls = {
      command = "${pkgs.ccls}/bin/ccls";
      filetypes =  ["c" "h" "cpp" "hpp" "objc" "objcpp"];
      rootPatterns = [
        ".ccls"
        "compile_commands.json"
        ".vim/"
        ".git/"
        ".hg/"
      ];
      "initializationOptions.cache.directory" = "/tmp/ccls";
    };
  };
}
