{
  description = "Lean declaration: instReprFloat";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Float-repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Float/repr";
    Float.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Float";
    Repr-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Repr/mk";
    Repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Repr";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-instReprFloat";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp instReprFloat.lean $out/
        '';
      };
    };
}