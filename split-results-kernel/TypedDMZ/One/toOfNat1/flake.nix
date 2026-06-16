{
  description = "Lean declaration: One.toOfNat1";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    One.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/One";
    One-one.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/One/one";
    OfNat-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/mk";
    OfNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-One.toOfNat1";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp One/toOfNat1.lean $out/
        '';
      };
    };
}