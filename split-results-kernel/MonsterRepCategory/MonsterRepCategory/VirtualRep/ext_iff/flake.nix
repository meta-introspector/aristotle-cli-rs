{
  description = "Lean declaration: MonsterRepCategory.VirtualRep.ext_iff";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    MonsterRepCategory-VirtualRep-coeffs.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/MonsterRepCategory/VirtualRep/coeffs";
    HEq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/HEq/refl";
    MonsterRepCategory-VirtualRep.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/MonsterRepCategory/VirtualRep";
    Eq-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/casesOn";
    MonsterRepCategory-VirtualRep-ext.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/MonsterRepCategory/VirtualRep/ext";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instOfNatNat";
    Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Int";
    Iff.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Iff";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat";
    Iff-intro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Iff/intro";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/ndrec";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/refl";
    HEq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/HEq";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/OfNat/ofNat";
    Eq-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/symm";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Fin";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-MonsterRepCategory.VirtualRep.ext_iff";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp MonsterRepCategory/VirtualRep/ext_iff.lean $out/
        '';
      };
    };
}