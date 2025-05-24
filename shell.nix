{callPackage}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (_: {
    shellHook = ''
      export PATH="./node_modules/.bin:$PATH"
      echo "Angular devShell loaded..."
    '';
  })
