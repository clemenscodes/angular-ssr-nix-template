{
  callPackage,
  playwright-driver,
  nodejs_20,
  jq,
  gitignore,
}: let
  mainPkg = callPackage ./default.nix {inherit gitignore;};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        playwright-driver.browsers
        jq
      ]
      ++ (oa.nativeBuildInputs or []);

    shellHook = ''
      playwright_chromium_revision=$(${jq}/bin/jq --raw-output '.browsers[] | select(.name == "chromium").revision' ${playwright-driver}/browsers.json)
      export PLAYWRIGHT_NODEJS_PATH=${nodejs_20}/bin/node
      export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
      export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
      export PLAYWRIGHT_LAUNCH_OPTIONS_EXECUTABLE_PATH=${playwright-driver.browsers}/chromium-$playwright_chromium_revision/chrome-linux/chrome
      export PATH="$PWD/node_modules/.bin:$PATH"
      echo "Angular devShell loaded..."
    '';
  })
