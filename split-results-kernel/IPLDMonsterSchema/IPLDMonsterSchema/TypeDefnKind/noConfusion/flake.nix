{
  description = "Lean declaration: IPLDMonsterSchema.TypeDefnKind.noConfusion";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    noConfusionEnum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/noConfusionEnum";
    IPLDMonsterSchema-TypeDefnKind-noConfusionType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/noConfusionType";
    IPLDMonsterSchema-TypeDefnKind.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind";
    IPLDMonsterSchema-TypeDefnKind-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/ctorIdx";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat";
    instDecidableEqNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instDecidableEqNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-IPLDMonsterSchema.TypeDefnKind.noConfusion";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp IPLDMonsterSchema/TypeDefnKind/noConfusion.lean $out/
        '';
      };
    };
}