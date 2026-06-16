{
  description = "Lean declaration: TypedDMZ.Schema.mk.noConfusion";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TypedDMZ-Field.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Field";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/id";
    TypedDMZ-Schema-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema/noConfusion";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    TypedDMZ-Schema-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema/mk";
    TypedDMZ-Schema.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.Schema.mk.noConfusion";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/Schema/mk/noConfusion.lean $out/
        '';
      };
    };
}