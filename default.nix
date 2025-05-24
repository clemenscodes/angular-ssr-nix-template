{
  buildNpmPackage,
  importNpmLock,
  nodejs_20,
  bash,
  lib,
}: let
  pname = "angular-template";
  version = "0.1.0";
in
  buildNpmPackage rec {
    inherit pname version;
    inherit (importNpmLock) npmConfigHook;

    src = ./.;
    npmDeps = importNpmLock {npmRoot = src;};
    nodejs = nodejs_20;

    installPhase = ''
      runHook preInstall

      app_name=$(ls dist)

      mkdir -p $out/{bin,share/${pname}}
      cp -r dist/$app_name $out/share/${pname}/$app_name

      cat > $out/bin/${pname} <<EOF
      #!${lib.getExe bash}
      exec ${nodejs_20}/bin/node $out/share/${pname}/$app_name/server/server.mjs
      EOF

      chmod +x $out/bin/${pname}

      runHook postInstall
    '';
  }
