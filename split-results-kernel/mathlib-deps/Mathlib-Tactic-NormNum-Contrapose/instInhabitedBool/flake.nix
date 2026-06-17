{
  description = "Lean declaration: instInhabitedBool";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instInhabitedBool-default.url = "path:/tmp/mathlib-split-test/instInhabitedBool/default";
    Bool.url = "path:/tmp/mathlib-split-test/Bool";
    Inhabited.url = "path:/tmp/mathlib-split-test/Inhabited";
    Inhabited-mk.url = "path:/tmp/mathlib-split-test/Inhabited/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-instInhabitedBool";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp instInhabitedBool.lean $out/
        '';
      };
    };
}