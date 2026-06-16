{
  description = "Lean declaration: Function.Injective.partialOrder";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Preorder-toLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Preorder/toLT";
    PartialOrder-toPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/PartialOrder/toPreorder";
    Preorder-toLE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Preorder/toLE";
    PartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/PartialOrder";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/LE/le";
    LE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/LE";
    Iff.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Iff";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/LT/lt";
    Function-Injective.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Function/Injective";
    Function-Injective-preorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Function/Injective/preorder";
    PartialOrder-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/PartialOrder/mk";
    Preorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Preorder";
    LT.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/LT";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Function.Injective.partialOrder";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Function/Injective/partialOrder.lean $out/
        '';
      };
    };
}