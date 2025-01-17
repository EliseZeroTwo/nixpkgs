{ lib
, buildPythonPackage
, fetchPypi
, ddt
, installShellFiles
, openstackdocstheme
, osc-lib
, pbr
, python-cinderclient
, python-keystoneclient
, python-novaclient
, requests-mock
, sphinx
, sphinxcontrib-apidoc
, stestr
}:

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "6.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EvwZNH9rGb/iw28Rx6GEH0FaLufxi5WUE8ISGZe4SVE=";
  };

  nativeBuildInputs = [
    installShellFiles
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  propagatedBuildInputs = [
    osc-lib
    pbr
    python-cinderclient
    python-keystoneclient
    python-novaclient
  ];

  postInstall = ''
    sphinx-build -a -E -d doc/build/doctrees -b man doc/source doc/build/man
    installManPage doc/build/man/openstack.1
  '';

  nativeCheckInputs = [
    ddt
    stestr
    requests-mock
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "openstackclient" ];

  meta = with lib; {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://github.com/openstack/python-openstackclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
