{ fetchFromGitHub, fetchurl, runCommand, buildPythonPackage, stdenv, cmake
, pkgconfig, coverage, dateutil_2_1, mock, numpy, ordereddict, prettytable
, psutil_1, pycapnp, pymysql, pytest, pytestcov, pytest_xdist, pyyaml, unittest2
, validictory}:

let
  asteval = buildPythonPackage rec {
    name = "asteval-${version}";
    version = "0.9.1";

    src = fetchurl {
      url = "mirror://pypi/a/asteval/${name}.tar.gz";
      sha256 = "0a8l95ph048xlam5cnnmfggy94f87asq3ljra7vi0vfnqjr9mify";
    };

    meta = {
      description = "Safe, minimalistic evaluator of python expression using ast module";
    };
  };
  dbutils = buildPythonPackage rec {
    name = "DBUtils-${version}";
    version = "1.1";

    src = fetchurl {
      url = "mirror://pypi/D/DBUtils/${name}.tar.gz";
      sha256 = "1xxzl378jims7liqk97qiqjx09912vs03jg9add29nfvmyx1lbfn";
    };

    meta = {
      description = "Database connections for multi-threaded environments.";
    };
  };
  pyproj = buildPythonPackage rec {
    name = "pyproj-${version}";
    version = "1.9.3";

    src = fetchurl {
      url = "mirror://pypi/p/pyproj/${name}.tar.gz";
      sha256 = "035a599ds7k5f5yrn6b8gki6kdagmya6a1rx1wfhjzs0brndhbli";
    };

    meta = {
      description = "Python interface to PROJ.4 library";
    };
  };
  pycapnp_0_5_7 = pycapnp.overrideDerivation (o: rec {
    name = "pycapnp-${version}";
    version = "0.5.7";

    src = fetchurl {
      url = "mirror://pypi/p/pycapnp/${name}.tar.gz";
      sha256 = "0ihlb99zk14fvj17bwr2d0svyb6g7jrki00h7s2pzw2hidgk7qi8";
    };
  });
  nupic-bindings = buildPythonPackage rec {
    name = "nupic.bindings-${version}";
    version = "0.4.13";

    src = fetchFromGitHub {
      owner = "numenta";
      repo = "nupic.core";
      rev = version;
      sha256 = "0vamy3h0lh46k0lz6fcmx28bvn6g20jknkljjz86p95gqzkk2qx4";
    };

    buildInputs = [ cmake ];
    propagatedBuildInputs = [
      coverage numpy pycapnp_0_5_7 pytest pytestcov pytest_xdist
    ];

    patches = [ ./build-bindings.patch ];
    preInstall = "ln -s bindings/py/dist ./dist";

    meta = {
      description = "Numenta Platform for Intelligent Computing - bindings";
    };
  };
in buildPythonPackage rec {
  name = "nupic-${version}";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "numenta";
    repo = "nupic";
    rev = version;
    sha256 = "05f2xkpr13kpc9l47125b47wzyp78n55y1jq9wa93hlirnk00r9q";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [
    asteval coverage dateutil_2_1 dbutils mock nupic-bindings ordereddict
    prettytable psutil_1 pymysql pycapnp_0_5_7 pyproj pytestcov pyyaml unittest2
    validictory
  ];

  patches = [ ./build.patch ];
  USER = "testuser";
  doCheck = !stdenv.isArm;

  meta = {
    description = "Numenta Platform for Intelligent Computing";
  };
}
