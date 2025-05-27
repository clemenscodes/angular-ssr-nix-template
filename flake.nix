{
  description = "Angular SSR Template";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs = {
    nixpkgs,
    gitignore,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in rec {
    checks = packages;

    hydraJobs = packages;

    packages = forEachSystem (system: {
      default = pkgsForEach.${system}.callPackage ./default.nix {inherit gitignore;};
    });

    devShells = forEachSystem (system: {
      default = pkgsForEach.${system}.callPackage ./shell.nix {inherit gitignore;};
    });

    formatter = forEachSystem (system: pkgsForEach.${system}.nixfmt-rfc-style);
  };
}
