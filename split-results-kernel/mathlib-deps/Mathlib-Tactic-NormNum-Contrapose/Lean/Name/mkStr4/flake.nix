{
  description = "Lean declaration: Lean.Name.mkStr4";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/tmp/mathlib-split-test/String";
    Lean-Name-str.url = "path:/tmp/mathlib-split-test/Lean/Name/str";
    Lean-Name-anonymous.url = "path:/tmp/mathlib-split-test/Lean/Name/anonymous";
    Lean-Name.url = "path:/tmp/mathlib-split-test/Lean/Name";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.Name.mkStr4";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/Name/mkStr4.lean $out/
        '';
      };
    };
}