{
  description = "Lean declaration: Lean.Parser.Tactic.valConfigItem";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Lean-ParserDescr-nonReservedSymbol.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/nonReservedSymbol";
    instOfNatNat.url = "path:/tmp/mathlib-split-test/instOfNatNat";
    Lean-ParserDescr-nodeWithAntiquot.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/nodeWithAntiquot";
    Lean-ParserDescr-binary.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/binary";
    Lean-ParserDescr.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr";
    Lean-ParserDescr-unary.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/unary";
    Nat.url = "path:/tmp/mathlib-split-test/Nat";
    Lean-ParserDescr-symbol.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/symbol";
    Lean-Name-mkStr2.url = "path:/tmp/mathlib-split-test/Lean/Name/mkStr2";
    Lean-ParserDescr-const.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/const";
    Lean-ParserDescr-cat.url = "path:/tmp/mathlib-split-test/Lean/ParserDescr/cat";
    OfNat-ofNat.url = "path:/tmp/mathlib-split-test/OfNat/ofNat";
    Bool-false.url = "path:/tmp/mathlib-split-test/Bool/false";
    Lean-Name-mkStr1.url = "path:/tmp/mathlib-split-test/Lean/Name/mkStr1";
    Lean-Name-mkStr4.url = "path:/tmp/mathlib-split-test/Lean/Name/mkStr4";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.Parser.Tactic.valConfigItem";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/Parser/Tactic/valConfigItem.lean $out/
        '';
      };
    };
}