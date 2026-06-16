{
  description = "Lean declaration: TypedDMZ.FieldType.ctorElim";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TypedDMZ-FieldType-list.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/list";
    TypedDMZ-FieldType-bytes.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/bytes";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/String";
    TypedDMZ-FieldType-mapType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/mapType";
    TypedDMZ-FieldType-link.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/link";
    TypedDMZ-FieldType-ctorElimType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/ctorElimType";
    TypedDMZ-FieldType-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/casesOn";
    TypedDMZ-FieldType-int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/int";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    TypedDMZ-FieldType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/ndrec";
    TypedDMZ-FieldType-struct.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/struct";
    TypedDMZ-FieldType-bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/bool";
    PULift-down.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/PULift/down";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    TypedDMZ-FieldType-union.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/union";
    TypedDMZ-FieldType-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/ctorIdx";
    TypedDMZ-FieldType-string.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/string";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.FieldType.ctorElim";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/FieldType/ctorElim.lean $out/
        '';
      };
    };
}