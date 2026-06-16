{
  description = "Lean declaration: Nat.instAddMonoid";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    inferInstance.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/inferInstance";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    AddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddMonoid";
    Nat-instAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat/instAddCommMonoid";
    AddCommMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/AddCommMonoid/toAddMonoid";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.instAddMonoid";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/instAddMonoid.lean $out/
        '';
      };
    };
}