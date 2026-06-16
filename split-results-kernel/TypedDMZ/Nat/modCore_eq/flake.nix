{
  description = "Lean declaration: Nat.modCore_eq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/mpr";
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/False";
    Decidable-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable/casesOn";
    eq_false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/eq_false";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrArg";
    and_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/and_self";
    HSub-hSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HSub/hSub";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable";
    false_and.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/false_and";
    Nat-modCore-go-eq_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/modCore/go/eq_1";
    dif_pos.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/dif_pos";
    Nat-lt_succ_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/lt_succ_self";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/id";
    instSubNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instSubNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instOfNatNat";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE/le";
    ite_cond_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite_cond_eq_true";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLENat";
    dif_neg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/dif_neg";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/dite";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/And";
    instHSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instHSub";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congr";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT/lt";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/True";
    eq_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/eq_self";
    Nat-modCore.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/modCore";
    eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/eq_true";
    Nat-div_rec_fuel_lemma.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/div_rec_fuel_lemma";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/of_eq_true";
    Nat-decLt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/decLt";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/refl";
    Nat-modCore-go.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/modCore/go";
    congrFun'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrFun'";
    and_false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/and_false";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLTNat";
    instDecidableAnd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instDecidableAnd";
    ite_congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite_congr";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/ofNat";
    ite_cond_eq_false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite_cond_eq_false";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Not";
    Nat-decLe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/decLe";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/trans";
    ite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.modCore_eq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/modCore_eq.lean $out/
        '';
      };
    };
}