{
  description = "Lean declaration: EquivLike.left_inv";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Function-LeftInverse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Function/LeftInverse";
    outParam.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/outParam";
    EquivLike.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/EquivLike";
    EquivLike-inv.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/EquivLike/inv";
    EquivLike-coe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/EquivLike/coe";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-EquivLike.left_inv";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp EquivLike/left_inv.lean $out/
        '';
      };
    };
}