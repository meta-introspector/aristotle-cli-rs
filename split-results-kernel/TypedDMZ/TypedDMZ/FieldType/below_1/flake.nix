{
  description = "Lean declaration: TypedDMZ.FieldType.below_1";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/String";
    TypedDMZ-FieldType-rec_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType/rec_1";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    PProd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/PProd";
    PUnit.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/PUnit";
    TypedDMZ-FieldType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FieldType";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.FieldType.below_1";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/FieldType/below_1.lean $out/
        '';
      };
    };
}