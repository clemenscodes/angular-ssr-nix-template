{
  callPackage,
  writeShellScriptBin,
  eslint_d,
  prettierd,
  ungoogled-chromium,
}: let
  mainPkg = callPackage ./default.nix {};
  mkNpxAlias = name: writeShellScriptBin name "npx ${name} \"$@\"";
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        eslint_d
        prettierd
        (mkNpxAlias "tsc")
        (mkNpxAlias "tsserver")
        (mkNpxAlias "ngserver")
        (writeShellScriptBin "ng" "npx --package @angular/cli ng \"$@\"")
      ]
      ++ (oa.nativeBuildInputs or []);

    CHROME_BIN = "${ungoogled-chromium}/bin/chromium";

    shellHook = ''
      echo "Angular devShell loaded..."
    '';
  })
