{
  description = "Lean declaration: Lean.ParserDescr.node";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Lean-ParserDescr.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr";
    Nat.url = "path:/tmp/mathlib-split-test/Nat";
    Lean-SyntaxNodeKind.url = "path:/tmp/mathlib-split-test/Lean/SyntaxNodeKind";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.ParserDescr.node";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/ParserDescr/node.lean $out/
        '';
      };
    };
}