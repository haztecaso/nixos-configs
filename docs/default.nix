{ pkgs }: let
  modulesDocs = pkgs.nmd.buildModulesDocs {
    moduleRootPaths = [ ./.. ];
    modules = [ ../modules ];
    mkModuleUrl = path: "https://github.com/haztecaso/nixos-configs/blob/master/${path}#blob-path";
    channelName = "nixos-configs";
    docBook.id = "nixos-configs-options";
  };
  docs = nmd.buildDocBookDocs {
    pathName = "nixos-configs";
    modulesDocs = [ modulesDocs ];
    documentsDirectory = ./.;
    documentType = "book";
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-nixos-configs-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-options"><?dbhtml filename="options.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };
in {
  manPages = docs.manPages;
  manual = { inherit (docs) html htmlOpenTool; };
}
