{
  description = "Lean declaration: IPLDMonsterSchema.TypeDefnKind.ctorElim";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    IPLDMonsterSchema-TypeDefnKind-map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/map";
    IPLDMonsterSchema-TypeDefnKind-string.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/string";
    IPLDMonsterSchema-TypeDefnKind-unit.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/unit";
    IPLDMonsterSchema-TypeDefnKind-struct.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/struct";
    IPLDMonsterSchema-TypeDefnKind-ctorElimType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/ctorElimType";
    IPLDMonsterSchema-TypeDefnKind-copy.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/copy";
    IPLDMonsterSchema-TypeDefnKind-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/casesOn";
    IPLDMonsterSchema-TypeDefnKind.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind";
    IPLDMonsterSchema-TypeDefnKind-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/ctorIdx";
    IPLDMonsterSchema-TypeDefnKind-bytes.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/bytes";
    IPLDMonsterSchema-TypeDefnKind-enum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/enum";
    IPLDMonsterSchema-TypeDefnKind-int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/int";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat";
    IPLDMonsterSchema-TypeDefnKind-any.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/any";
    IPLDMonsterSchema-TypeDefnKind-union.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/union";
    IPLDMonsterSchema-TypeDefnKind-list.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/list";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq/ndrec";
    PULift-down.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/PULift/down";
    IPLDMonsterSchema-TypeDefnKind-link.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/link";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq";
    IPLDMonsterSchema-TypeDefnKind-bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/bool";
    IPLDMonsterSchema-TypeDefnKind-float.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeDefnKind/float";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-IPLDMonsterSchema.TypeDefnKind.ctorElim";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp IPLDMonsterSchema/TypeDefnKind/ctorElim.lean $out/
        '';
      };
    };
}