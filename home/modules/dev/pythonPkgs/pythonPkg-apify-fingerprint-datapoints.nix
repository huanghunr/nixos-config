{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:
buildPythonPackage rec {
  pname = "apify-fingerprint-datapoints";
  version = "0.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "apify_fingerprint_datapoints";
    inherit version;
    hash = "sha256-P5BcOSsRon+1nM/kCJHBZqvXN6ucYglzPxAruzswJRU=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "apify_fingerprint_datapoints" ];
  doCheck = false;

  meta = with lib; {
    description = "Browser fingerprint datapoints collected by Apify";
    homepage = "https://github.com/apify/fingerprint-suite";
    license = licenses.asl20;
  };
}
