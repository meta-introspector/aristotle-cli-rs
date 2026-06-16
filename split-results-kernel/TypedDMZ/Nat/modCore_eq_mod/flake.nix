{
  description = "Lean declaration: Nat.modCore_eq_mod";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/mpr";
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/False";
    iteInduction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/iteInduction";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrArg";
    Nat-modCore_eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/modCore_eq";
    HSub-hSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HSub/hSub";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/id";
    Nat-instMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/instMod";
    instHMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instHMod";
    instSubNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instSubNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instOfNatNat";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLENat";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instHAdd";
    HMod-hMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HMod/hMod";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/And";
    instHSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instHSub";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HAdd/hAdd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    Nat-lt_irrefl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/lt_irrefl";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT/lt";
    Nat-modCore.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/modCore";
    Nat-decLt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/decLt";
    Nat-mod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/mod";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instAddNat";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLTNat";
    instDecidableAnd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instDecidableAnd";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/ofNat";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    if_neg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/if_neg";
    Nat-lt_of_lt_of_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/lt_of_lt_of_le";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Not";
    Nat-decLe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/decLe";
    Nat-mod-eq_2.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/mod/eq_2";
    rfl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/rfl";
    ite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.modCore_eq_mod";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/modCore_eq_mod.lean $out/
        '';
      };
    };
}