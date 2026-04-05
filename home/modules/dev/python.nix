{ pkgs, ... }:
let
  python = pkgs.python313.override {
    self = python;
    packageOverrides = pyfinal: pyprev: {
      ida-pro-mcp = pyfinal.callPackage ./pythonPkgs/ida-pro-mcp.nix {
        idapro = pyfinal.callPackage ./pythonPkgs/pythonPkg-ida-pro.nix { };
        tomli_w = pkgs.python313Packages.tomli-w;
      };

      apify-fingerprint-datapoints =
        pyfinal.callPackage ./pythonPkgs/pythonPkg-apify-fingerprint-datapoints.nix
          { };

      patchright = pyfinal.callPackage ./pythonPkgs/pythonPkg-patchright.nix { };

      browserforge = pyprev.browserforge.overrideAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
          pyfinal."apify-fingerprint-datapoints"
        ];
        postInstall = (old.postInstall or "") + ''
          apify_data="${
            pyfinal."apify-fingerprint-datapoints"
          }/${pyfinal.python.sitePackages}/apify_fingerprint_datapoints/data"
          headers_data="$out/${pyfinal.python.sitePackages}/browserforge/headers/data"
          fingerprints_data="$out/${pyfinal.python.sitePackages}/browserforge/fingerprints/data"

          mkdir -p "$headers_data" "$fingerprints_data"

          cp "$apify_data/browser-helper-file.json" "$headers_data/browser-helper-file.json"
          cp "$apify_data/headers-order.json" "$headers_data/headers-order.json"
          cp "$apify_data/input-network-definition.zip" "$headers_data/input-network.zip"
          cp "$apify_data/header-network-definition.zip" "$headers_data/header-network.zip"
          cp "$apify_data/fingerprint-network-definition.zip" "$fingerprints_data/fingerprint-network.zip"
        '';
      });

      scrapling = pyfinal.callPackage ./pythonPkgs/pythonPkg-scrapling.nix {
        typing-extensions = pyfinal.typing-extensions;
        curl-cffi = pyfinal.curl-cffi;
        apify-fingerprint-datapoints = pyfinal."apify-fingerprint-datapoints";
        patchright = pyfinal.patchright;
      };
    };
  };
in
let
  mcpPython = python.withPackages (
    ps:
    with ps;
    [
      # Tooling
      ruff
      black
      mypy
      pytest
      uv
      pipx
      conda
    ]
    ++ [
      # Data / notebook
      jupyter
      jupyterlab
      ipykernel
      ipython
      numpy
      pandas
      scipy
      matplotlib
      tqdm
      z3-solver
    ]
    ++ [
      # Networking / scraping
      requests
      httpx
      pyquery
      beautifulsoup4
      lxml
      pyyaml
      python-dotenv
      boto3
    ]
    ++ [
      # Security / crypto helpers
      scapy
      pwntools
      cryptography
      pynacl
      ida-pro-mcp
      scrapling
      playwright
    ]
    ++ [
      # Misc
      protobuf
      pydantic
      orjson
    ]
  );
in
{
  inherit mcpPython;
  py-exec = "${mcpPython}/bin/python";
  py-site-pkgs = "${mcpPython}/lib/python3.13/site-packages";
  py-bin = "${mcpPython}/bin";
}
