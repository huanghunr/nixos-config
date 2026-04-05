{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  lxml,
  cssselect,
  orjson,
  tld,
  w3lib,
  typing-extensions,
  click,
  curl-cffi,
  playwright,
  patchright,
  browserforge,
  apify-fingerprint-datapoints,
  msgspec,
  anyio,
  mcp,
  markdownify,
  pythonRelaxDepsHook,
}:
buildPythonPackage rec {
  pname = "scrapling";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xzsp1lLrihszN5WXxZb9+jvwVBQZmbYwsBtES/GyduU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cssselect"
    "orjson"
    "tld"
    "w3lib"
    "patchright"
  ];

  propagatedBuildInputs = [
    lxml
    cssselect
    orjson
    tld
    w3lib
    typing-extensions

    click
    curl-cffi
    playwright
    patchright
    browserforge
    apify-fingerprint-datapoints
    msgspec
    anyio
    mcp
    markdownify
  ];

  pythonImportsCheck = [
    "scrapling"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Adaptive scraping framework with MCP integration";
    homepage = "https://github.com/D4Vinci/Scrapling";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
