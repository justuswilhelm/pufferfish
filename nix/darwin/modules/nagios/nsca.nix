{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "nsca";
  version = "2.10.3";

  src = pkgs.fetchFromGitHub {
    owner = "NagiosEnterprises";
    repo = "nsca";
    rev = "nsca-${version}";
    sha256 = "sha256-F56GqGOPNdb2AHFoIl8LHpvP9FY2qzdqdWrlqiKNVoM=";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp src/nsca src/send_nsca $out/bin
  '';
}

