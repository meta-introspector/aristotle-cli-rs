{
  description = "Lean declaration: List.sum_replicate";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-sum_nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/sum_nil";
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/mpr";
    List-replicate.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/replicate";
    Nat-recAux.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/recAux";
    List-replicate_zero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/replicate_zero";
    instHSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHSMul";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/congrArg";
    AddMonoid-toAddZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoid/toAddZeroClass";
    List-sum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/sum";
    AddMonoid-toNSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoid/toNSMul";
    AddZeroClass-toAddZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddZeroClass/toAddZero";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/id";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instOfNatNat";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/cons";
    AddZero-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddZero/toZero";
    List-replicate_succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/replicate_succ";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHAdd";
    zero_nsmul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/zero_nsmul";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HAdd/hAdd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat";
    List-sum_cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/sum_cons";
    AddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoid";
    succ_nsmul'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/succ_nsmul'";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instAddNat";
    AddZero-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddZero/toAdd";
    Zero-toOfNat0.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Zero/toOfNat0";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/refl";
    HSMul-hSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HSMul/hSMul";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq";
    List-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/List/nil";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.sum_replicate";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/sum_replicate.lean $out/
        '';
      };
    };
}