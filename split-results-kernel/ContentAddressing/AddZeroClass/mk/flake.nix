{
  description = "Lean declaration: AddZeroClass.mk";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    AddZero-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddZero/toZero";
    AddZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddZero";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHAdd";
    AddZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddZeroClass";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HAdd/hAdd";
    AddZero-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddZero/toAdd";
    Zero-toOfNat0.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Zero/toOfNat0";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-AddZeroClass.mk";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp AddZeroClass/mk.lean $out/
        '';
      };
    };
}