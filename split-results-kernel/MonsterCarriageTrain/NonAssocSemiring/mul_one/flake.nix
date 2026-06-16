{
  description = "Lean declaration: NonAssocSemiring.mul_one";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    HMul-hMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/HMul/hMul";
    NonAssocSemiring-toOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/NonAssocSemiring/toOne";
    NonUnitalNonAssocSemiring-toMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/NonUnitalNonAssocSemiring/toMul";
    NonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/NonAssocSemiring";
    NonAssocSemiring-toNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/NonAssocSemiring/toNonUnitalNonAssocSemiring";
    One-toOfNat1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/One/toOfNat1";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Eq";
    instHMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/instHMul";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-NonAssocSemiring.mul_one";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp NonAssocSemiring/mul_one.lean $out/
        '';
      };
    };
}