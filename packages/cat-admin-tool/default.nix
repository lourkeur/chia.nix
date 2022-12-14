{
  lib,
  fetchFromGitHub,
  python3Packages,
  chia,
}:
python3Packages.buildPythonApplication rec {
  pname = "CAT-admin-tool";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "7cab4a3bf9a486892352d0fa69d99f8730bd8630";
    hash = "sha256-R3FNpzwoAi//wBN80SOTBVIZ3rw+KF9oNjsC8rd/R9U=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    (toPythonModule chia)
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Admin tool for issuing CATs";
    license = with licenses; [asl20];
    maintainers = teams.chia.members;
    platforms = platforms.all;
  };
}
