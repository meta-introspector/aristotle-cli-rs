{
  description = "Lean declaration: BottNested.liftCAR_wellLayered";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    MonsterTrain-CARBlock-cid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/MonsterTrain/CARBlock/cid";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/congrArg";
    List-map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/map";
    AddMonoid-toAddZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/AddMonoid/toAddZeroClass";
    MonsterTrain-CARBlock.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/MonsterTrain/CARBlock";
    Nat-instAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat/instAddMonoid";
    BottNested-LayerPayload-layer.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/LayerPayload/layer";
    Eq-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq/rec";
    Fin-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Fin/mk";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/id";
    Nat-instMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat/instMod";
    instHMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instHMod";
    Prod-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Prod/mk";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instOfNatNat";
    zero_add.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/zero_add";
    Prod-fst.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Prod/fst";
    BottNested-LayerPayload-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/LayerPayload/mk";
    GetElem-getElem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/GetElem/getElem";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instHAdd";
    HMod-hMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/HMod/hMod";
    BottNested-NestedCarriage-layers.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/NestedCarriage/layers";
    BottNested-liftCAR.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/liftCAR";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/HAdd/hAdd";
    List-getElem_map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/getElem_map";
    Fin-mk-congr_simp.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Fin/mk/congr_simp";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat";
    BottNested-LayerPayload.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/LayerPayload";
    congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/congr";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/LT/lt";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/True";
    eq_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/eq_self";
    List-length_map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/length_map";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/of_eq_true";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq/ndrec";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instAddNat";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq/refl";
    congrFun'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/congrFun'";
    List-getElem_zipIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/getElem_zipIdx";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instLTNat";
    MonsterTrain-CARBlock-payload.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/MonsterTrain/CARBlock/payload";
    MonsterTrain-CID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/MonsterTrain/CID";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Prod";
    List-instGetElemNatLtLength.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/instGetElemNatLtLength";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/OfNat/ofNat";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Fin";
    List-zipIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/zipIdx";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq";
    Prod-snd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Prod/snd";
    List-length.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/length";
    BottNested-NestedCarriage-wellLayered.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/NestedCarriage/wellLayered";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq/trans";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-BottNested.liftCAR_wellLayered";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp BottNested/liftCAR_wellLayered.lean $out/
        '';
      };
    };
}