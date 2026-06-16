{
  description = "Lean declaration: InvolutiveStar.mk";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    InvolutiveStar.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/InvolutiveStar";
    Star.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Star";
    Function-Involutive.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Function/Involutive";
    Star-star.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Star/star";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-InvolutiveStar.mk";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp InvolutiveStar/mk.lean $out/
        '';
      };
    };
}