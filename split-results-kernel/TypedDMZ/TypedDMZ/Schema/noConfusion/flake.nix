{
  description = "Lean declaration: TypedDMZ.Schema.noConfusion";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TypedDMZ-Schema-noConfusionType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema/noConfusionType";
    TypedDMZ-Field.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Field";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    TypedDMZ-Schema.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/ndrec";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/refl";
    TypedDMZ-Schema-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema/casesOn";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.Schema.noConfusion";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/Schema/noConfusion.lean $out/
        '';
      };
    };
}