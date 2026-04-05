{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  fetchFromGitHub,
  idapro,
  tomli_w,
  ...
}:

buildPythonPackage rec {
  pname = "ida-pro-mcp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mrexodia";
    repo = "ida-pro-mcp";
    rev = "8102a0bae77e44794f2db3eb2e5bcf46183ee990";
    hash = "sha256-KRhirCNmoce6nn8z0PDiXTBi1Urw47a2rkdCHGeKvrY=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];

    dependencies = [
      idapro
      tomli_w
  ];
}