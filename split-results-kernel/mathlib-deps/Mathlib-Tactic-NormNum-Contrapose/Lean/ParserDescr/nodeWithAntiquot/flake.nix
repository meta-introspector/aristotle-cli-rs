{
  description = "Lean declaration: Lean.ParserDescr.nodeWithAntiquot";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/tmp/mathlib-split-test/String";
    Lean-ParserDescr.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr";
    Lean-SyntaxNodeKind.url = "path:/tmp/mathlib-split-test/Lean/SyntaxNodeKind";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.ParserDescr.nodeWithAntiquot";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/ParserDescr/nodeWithAntiquot.lean $out/
        '';
      };
    };
}