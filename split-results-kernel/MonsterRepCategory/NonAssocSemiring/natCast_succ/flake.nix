{
  description = "Lean declaration: NonAssocSemiring.natCast_succ";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    AddMonoid-toAddSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/AddMonoid/toAddSemigroup";
    NonAssocSemiring-toOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NonAssocSemiring/toOne";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instOfNatNat";
    NatCast-natCast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NatCast/natCast";
    NonUnitalNonAssocSemiring-toAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NonUnitalNonAssocSemiring/toAddCommMonoid";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instHAdd";
    AddSemigroup-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/AddSemigroup/toAdd";
    NonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NonAssocSemiring";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/HAdd/hAdd";
    NonAssocSemiring-toNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NonAssocSemiring/toNonUnitalNonAssocSemiring";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat";
    One-toOfNat1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/One/toOfNat1";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instAddNat";
    AddCommMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/AddCommMonoid/toAddMonoid";
    NonAssocSemiring-toNatCast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/NonAssocSemiring/toNatCast";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-NonAssocSemiring.natCast_succ";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp NonAssocSemiring/natCast_succ.lean $out/
        '';
      };
    };
}