{
  description = "Lean declaration: List.Sublist.brecOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-Sublist-below-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist/below/cons";
    List-Sublist-below-slnil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist/below/slnil";
    List-Sublist-below-cons₂.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist/below/cons₂";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    List-Sublist-below.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist/below";
    List-Sublist.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist";
    List-Sublist-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Sublist/rec";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.Sublist.brecOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/Sublist/brecOn.lean $out/
        '';
      };
    };
}