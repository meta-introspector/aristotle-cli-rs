{
  description = "Lean declaration: trueSetoid";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Setoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Setoid";
    true_equivalence.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/true_equivalence";
    Setoid-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Setoid/mk";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/True";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-trueSetoid";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp trueSetoid.lean $out/
        '';
      };
    };
}