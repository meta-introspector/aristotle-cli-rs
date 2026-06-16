{
  description = "Lean declaration: AddMonoidWithOne.toAddMonoid";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    AddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/AddMonoid";
    AddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/AddMonoidWithOne";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-AddMonoidWithOne.toAddMonoid";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp AddMonoidWithOne/toAddMonoid.lean $out/
        '';
      };
    };
}