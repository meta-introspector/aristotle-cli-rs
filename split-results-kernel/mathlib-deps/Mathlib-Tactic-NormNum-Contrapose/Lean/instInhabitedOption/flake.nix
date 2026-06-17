{
  description = "Lean declaration: Lean.instInhabitedOption";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Lean-Option.url = "path:/tmp/mathlib-split-test/Lean/Option";
    Inhabited.url = "path:/tmp/mathlib-split-test/Inhabited";
    Lean-instInhabitedOption-default.url = "path:/tmp/mathlib-split-test/Lean/instInhabitedOption/default";
    Inhabited-mk.url = "path:/tmp/mathlib-split-test/Inhabited/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.instInhabitedOption";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/instInhabitedOption.lean $out/
        '';
      };
    };
}