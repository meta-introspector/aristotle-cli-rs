{
  description = "Lean declaration: Lean.ParserDescr.nonReservedSymbol";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/tmp/mathlib-split-test/String";
    Lean-ParserDescr.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr";
    Bool.url = "path:/tmp/mathlib-split-test/Bool";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.ParserDescr.nonReservedSymbol";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/ParserDescr/nonReservedSymbol.lean $out/
        '';
      };
    };
}