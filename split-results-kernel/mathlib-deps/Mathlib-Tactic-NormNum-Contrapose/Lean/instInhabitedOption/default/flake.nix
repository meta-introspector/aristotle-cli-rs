{
  description = "Lean declaration: Lean.instInhabitedOption.default";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Inhabited-default.url = "path:/tmp/mathlib-split-test/Inhabited/default";
    Lean-Option.url = "path:/tmp/mathlib-split-test/Lean/Option";
    Lean-Option-mk.url = "path:/tmp/mathlib-split-test/Lean/Option/mk";
    Lean-Name.url = "path:/tmp/mathlib-split-test/Lean/Name";
    Inhabited.url = "path:/tmp/mathlib-split-test/Inhabited";
    Lean-instInhabitedName.url = "path:/tmp/mathlib-split-test/Lean/instInhabitedName";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.instInhabitedOption.default";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/instInhabitedOption/default.lean $out/
        '';
      };
    };
}