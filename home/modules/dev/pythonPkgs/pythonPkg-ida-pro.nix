{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "idapro";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cy4YSxnk2EBOpIsfF/ObIbBUkxMVlA7pcW74VZFEmI8=";
  };

  doCheck = false;

  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
}