{
  description = "Lean declaration: AddGroupWithOne.toAddGroup";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    AddGroupWithOne-zsmul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/zsmul";
    SubNegMonoid-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/SubNegMonoid/mk";
    AddGroupWithOne-toAddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/toAddMonoidWithOne";
    AddGroupWithOne-sub_eq_add_neg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/sub_eq_add_neg";
    AddGroupWithOne-toNeg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/toNeg";
    AddGroupWithOne-zsmul_succ'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/zsmul_succ'";
    AddGroupWithOne-zsmul_neg'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/zsmul_neg'";
    AddGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroup";
    AddGroupWithOne-neg_add_cancel.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/neg_add_cancel";
    AddGroupWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne";
    AddGroupWithOne-toSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/toSub";
    AddMonoidWithOne-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddMonoidWithOne/toAddMonoid";
    AddGroupWithOne-zsmul_zero'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroupWithOne/zsmul_zero'";
    AddGroup-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/AddGroup/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-AddGroupWithOne.toAddGroup";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp AddGroupWithOne/toAddGroup.lean $out/
        '';
      };
    };
}