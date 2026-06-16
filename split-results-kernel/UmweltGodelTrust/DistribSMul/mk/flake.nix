{
  description = "Lean declaration: DistribSMul.mk";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instHSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instHSMul";
    SMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/SMulZeroClass";
    AddZeroClass-toAddZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZeroClass/toAddZero";
    AddZero-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZero/toZero";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instHAdd";
    AddZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZeroClass";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/HAdd/hAdd";
    DistribSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/DistribSMul";
    AddZero-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZero/toAdd";
    HSMul-hSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/HSMul/hSMul";
    SMulZeroClass-toSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/SMulZeroClass/toSMul";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-DistribSMul.mk";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp DistribSMul/mk.lean $out/
        '';
      };
    };
}