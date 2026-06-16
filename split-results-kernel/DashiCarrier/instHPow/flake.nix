{
  description = "Lean declaration: instHPow";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Pow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Pow";
    Pow-pow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Pow/pow";
    HPow-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/HPow/mk";
    HPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/HPow";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-instHPow";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp instHPow.lean $out/
        '';
      };
    };
}