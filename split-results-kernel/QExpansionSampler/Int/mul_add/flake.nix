{
  description = "Lean declaration: Int.mul_add";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/mpr";
    Int-negOfNat_add.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/negOfNat_add";
    HMul-hMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HMul/hMul";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/congrArg";
    Nat-right_distrib.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/right_distrib";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/id";
    Int-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/ofNat";
    instMulNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instMulNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instOfNatNat";
    Nat-mul_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/mul_comm";
    Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int";
    Nat-add_left_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/add_left_comm";
    Int-negSucc_mul_subNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/negSucc_mul_subNatNat";
    Int-add_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/add_comm";
    Nat-cast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/cast";
    Int-instMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/instMul";
    Int-negOfNat_eq_subNatNat_zero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/negOfNat_eq_subNatNat_zero";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHAdd";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HAdd/hAdd";
    Int-subNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/subNatNat";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat";
    congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/congr";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/True";
    eq_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/eq_self";
    Nat-add_assoc.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/add_assoc";
    Int-subNatNat_add.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/subNatNat_add";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/of_eq_true";
    Int-instAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/instAdd";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instAddNat";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/refl";
    congrFun'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/congrFun'";
    instNatCastInt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instNatCastInt";
    Int-negSucc.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/negSucc";
    Int-ofNat_mul_subNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/ofNat_mul_subNatNat";
    Nat-left_distrib.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/left_distrib";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/OfNat/ofNat";
    Eq-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/symm";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/trans";
    Int-negOfNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/negOfNat";
    instHMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHMul";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Int.mul_add";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Int/mul_add.lean $out/
        '';
      };
    };
}