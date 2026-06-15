{
  description = "Lean declaration: List.getElem_append_left";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/False";
    HEq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HEq/refl";
    False-elim.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/False/elim";
    noConfusion_of_Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/noConfusion_of_Nat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instOfNatNat";
    List-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/rec";
    Nat-le-step.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/le/step";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/cons";
    Nat-casesAuxOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/casesAuxOn";
    GetElem-getElem.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/GetElem/getElem";
    List-append.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/append";
    instHAppendOfAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instHAppendOfAppend";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instHAdd";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HAdd/hAdd";
    Nat-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/le";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/LT/lt";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Eq/ndrec";
    Nat-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/ctorIdx";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instAddNat";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Eq/refl";
    HEq.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HEq";
    Nat-le-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/le/refl";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instLTNat";
    Nat-le-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/le/casesOn";
    List-instAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/instAppend";
    List-instGetElemNatLtLength.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/instGetElemNatLtLength";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/OfNat/ofNat";
    Eq-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Eq/symm";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/succ";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Eq";
    List-length.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/length";
    HAppend-hAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HAppend/hAppend";
    List-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/List/nil";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.getElem_append_left";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/getElem_append_left.lean $out/
        '';
      };
    };
}