{
  description = "Lean declaration: Lean.Parser.Tactic.optConfig";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Lean-ParserDescr-nodeWithAntiquot.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/nodeWithAntiquot";
    Lean-ParserDescr-binary.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/binary";
    Lean-ParserDescr.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr";
    Lean-ParserDescr-unary.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/unary";
    Lean-Parser-Tactic-configItem.url = "path:/tmp/mathlib-split-test/Lean/Parser/Tactic/configItem";
    Lean-ParserDescr-const.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/const";
    Lean-Name-mkStr1.url = "path:/tmp/mathlib-split-test/Lean/Name/mkStr1";
    Lean-Name-mkStr4.url = "path:/tmp/mathlib-split-test/Lean/Name/mkStr4";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.Parser.Tactic.optConfig";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/Parser/Tactic/optConfig.lean $out/
        '';
      };
    };
}