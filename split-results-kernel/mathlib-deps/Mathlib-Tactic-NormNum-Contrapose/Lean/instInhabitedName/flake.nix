{
  description = "Lean declaration: Lean.instInhabitedName";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Lean-Name-anonymous.url = "path:/tmp/mathlib-split-test/Lean/Name/anonymous";
    Lean-Name.url = "path:/tmp/mathlib-split-test/Lean/Name";
    Inhabited.url = "path:/tmp/mathlib-split-test/Inhabited";
    Inhabited-mk.url = "path:/tmp/mathlib-split-test/Inhabited/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.instInhabitedName";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/instInhabitedName.lean $out/
        '';
      };
    };
}