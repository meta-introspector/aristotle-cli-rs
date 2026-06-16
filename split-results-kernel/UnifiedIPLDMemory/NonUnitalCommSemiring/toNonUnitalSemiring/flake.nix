{
  description = "Lean declaration: NonUnitalCommSemiring.toNonUnitalSemiring";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    NonUnitalSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/NonUnitalSemiring";
    NonUnitalCommSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/NonUnitalCommSemiring";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-NonUnitalCommSemiring.toNonUnitalSemiring";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp NonUnitalCommSemiring/toNonUnitalSemiring.lean $out/
        '';
      };
    };
}