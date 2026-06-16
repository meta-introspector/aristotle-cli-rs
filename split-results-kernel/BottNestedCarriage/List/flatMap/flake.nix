{
  description = "Lean declaration: List.flatMap";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/map";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List";
    List-flatten.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/List/flatten";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.flatMap";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/flatMap.lean $out/
        '';
      };
    };
}