{
  description = "Lean declaration: Nat.instAddCommMonoid";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    inferInstance.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/inferInstance";
    Nat-instAddCancelCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/instAddCancelCommMonoid";
    AddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCommMonoid";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    AddCancelCommMonoid-toAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCancelCommMonoid/toAddCommMonoid";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.instAddCommMonoid";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/instAddCommMonoid.lean $out/
        '';
      };
    };
}