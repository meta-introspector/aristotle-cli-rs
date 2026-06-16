{
  description = "Lean declaration: Nat.sub_lt";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    HSub-hSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/HSub/hSub";
    Eq-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/rec";
    Nat-sub_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat/sub_le";
    instSubNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instSubNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instOfNatNat";
    Nat-lt_succ_of_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat/lt_succ_of_le";
    absurd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/absurd";
    instHSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instHSub";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat";
    Nat-lt_irrefl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat/lt_irrefl";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/LT/lt";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/instLTNat";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/OfNat/ofNat";
    Eq-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq/symm";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Eq";
    Nat-succ_sub_succ_eq_sub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Nat/succ_sub_succ_eq_sub";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.sub_lt";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/sub_lt.lean $out/
        '';
      };
    };
}