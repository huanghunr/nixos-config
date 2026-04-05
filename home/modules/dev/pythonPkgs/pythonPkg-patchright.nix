{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyee,
  greenlet,
}:
buildPythonPackage rec {
  pname = "patchright";
  version = "1.56.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";
    abi = "none";
    platform = "manylinux1_x86_64";
    hash = "sha256-zvDzEzTezhGPqNviDgwKyX6lOaKj590AemfQW0w+BRI=";
  };

  propagatedBuildInputs = [
    pyee
    greenlet
  ];

  pythonImportsCheck = [ "patchright" ];
  doCheck = false;

  meta = with lib; {
    description = "Undetected Python version of Playwright";
    homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python";
    license = licenses.asl20;
  };
}
