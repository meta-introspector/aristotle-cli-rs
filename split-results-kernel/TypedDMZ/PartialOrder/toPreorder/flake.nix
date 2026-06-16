{
  description = "Lean declaration: PartialOrder.toPreorder";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    PartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/PartialOrder";
    Preorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Preorder";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-PartialOrder.toPreorder";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp PartialOrder/toPreorder.lean $out/
        '';
      };
    };
}