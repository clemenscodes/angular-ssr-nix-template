{
  buildNpmPackage,
  importNpmLock,
  nodejs_20,
  bash,
  lib,
  util-linux,
  jq,
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

    buildPhase = ''
      ${util-linux}/bin/script -c "node_modules/.bin/nx build --skipNxCache --skipRemoteCache --skipSync --outputStyle=static" /dev/null
    '';

    installPhase = ''
      runHook preInstall

      app_name=$(${jq}/bin/jq -r '.defaultProject' nx.json)

      mkdir -p $out/{bin,share/${pname}}
      cp -r dist/apps/$app_name $out/share/${pname}/$app_name

      cat > $out/bin/${pname} <<EOF
      #!${lib.getExe bash}
      exec ${nodejs_20}/bin/node $out/share/${pname}/$app_name/server/server.mjs
      EOF

      chmod +x $out/bin/${pname}

      runHook postInstall
    '';
  }
