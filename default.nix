{
  buildNpmPackage,
  importNpmLock,
  nodejs_20,
  bash,
  lib,
  util-linux,
  jq,
  gitignore,
}:
let
  pname = "angular-template";
  version = "0.1.0";
  inherit (gitignore.lib) gitignoreSource;
in
buildNpmPackage rec {
  inherit pname version;
  inherit (importNpmLock) npmConfigHook;

  src = lib.cleanSourceWith {
    filter =
      path: type:
      let
        baseName = baseNameOf path;
      in
      !(
        (type == "directory" && baseName == ".github")
        || lib.hasSuffix ".md" baseName
        || baseName == ".envrc"
        || lib.hasSuffix ".nix" baseName
        || baseName == "flake.lock"
      );
    src = gitignoreSource ./.;
    name = "${pname}-source";
  };

  npmDeps = importNpmLock { npmRoot = src; };
  nodejs = nodejs_20;

  checkPhase = ''
    runHook preCheck

    echo "Configuring Nx"
    export PATH="$PWD/node_modules/.bin:$PATH"
    export NX_CACHE_DIRECTORY=$NIX_BUILD_TOP/nx-cache
    export NX_PROJECT_GRAPH_CACHE_DIRECTORY=$NIX_BUILD_TOP/nx-cache

    ${util-linux}/bin/script -c "nx run-many -t lint --all --outputStyle=static" /dev/null
    ${util-linux}/bin/script -c "nx run-many -t test --all --outputStyle=static" /dev/null
    ${util-linux}/bin/script -c "nx run-many -t build --all --outputStyle=static" /dev/null

    runHook postCheck
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
