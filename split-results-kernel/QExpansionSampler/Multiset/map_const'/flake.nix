{
  description = "Lean declaration: Multiset.map_const'";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Multiset-map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Multiset/map";
    Multiset-map_const.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Multiset/map_const";
    Multiset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Multiset";
    Multiset-card.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Multiset/card";
    Multiset-replicate.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Multiset/replicate";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Multiset.map_const'";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Multiset/map_const'.lean $out/
        '';
      };
    };
}