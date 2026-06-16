{
  description = "Lean declaration: TypedDMZ.FiberSchemaMap.mk.noConfusion";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TypedDMZ-FiberSchemaMap-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FiberSchemaMap/noConfusion";
    KernelGovernance-Dataset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/KernelGovernance/Dataset";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/id";
    TypedDMZ-Schema.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Schema";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    TypedDMZ-FiberSchemaMap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FiberSchemaMap";
    TypedDMZ-FiberSchemaMap-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/FiberSchemaMap/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.FiberSchemaMap.mk.noConfusion";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/FiberSchemaMap/mk/noConfusion.lean $out/
        '';
      };
    };
}