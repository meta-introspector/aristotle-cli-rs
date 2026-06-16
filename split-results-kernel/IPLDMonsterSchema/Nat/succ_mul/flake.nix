{
  description = "Lean declaration: Nat.succ_mul";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq/mpr";
    Nat-recAux.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/recAux";
    Nat-mul_succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/mul_succ";
    HMul-hMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/HMul/hMul";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/congrArg";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/id";
    instMulNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instMulNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instOfNatNat";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instHAdd";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/HAdd/hAdd";
    Nat-add_succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/add_succ";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instAddNat";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq/refl";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/OfNat/ofNat";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq";
    Nat-add_right_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/add_right_comm";
    instHMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instHMul";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.succ_mul";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/succ_mul.lean $out/
        '';
      };
    };
}