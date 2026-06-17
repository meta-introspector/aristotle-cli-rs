{
  description = "Lean declaration: And.imp";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    And.url = "path:/tmp/mathlib-split-test/And";
    And-right.url = "path:/tmp/mathlib-split-test/And/right";
    And-left.url = "path:/tmp/mathlib-split-test/And/left";
    And-intro.url = "path:/tmp/mathlib-split-test/And/intro";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-And.imp";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp And/imp.lean $out/
        '';
      };
    };
}