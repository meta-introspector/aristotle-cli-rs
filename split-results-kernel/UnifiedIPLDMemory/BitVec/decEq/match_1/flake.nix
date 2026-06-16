{
  description = "Lean declaration: BitVec.decEq.match_1";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instPowNat";
    BitVec-ofFin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/BitVec/ofFin";
    BitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/BitVec";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instOfNatNat";
    instNatPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instNatPowNat";
    BitVec-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/BitVec/casesOn";
    HPow-hPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/HPow/hPow";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Nat";
    instHPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instHPow";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/OfNat/ofNat";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Fin";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-BitVec.decEq.match_1";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp BitVec/decEq/match_1.lean $out/
        '';
      };
    };
}