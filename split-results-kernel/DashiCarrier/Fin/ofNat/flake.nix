{
  description = "Lean declaration: Fin.ofNat";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Zero-ofOfNat0.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Zero/ofOfNat0";
    Fin-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin/mk";
    Nat-instMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat/instMod";
    instHMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instHMod";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instOfNatNat";
    HMod-hMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/HMod/hMod";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    NeZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/NeZero";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Fin.ofNat";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Fin/ofNat.lean $out/
        '';
      };
    };
}