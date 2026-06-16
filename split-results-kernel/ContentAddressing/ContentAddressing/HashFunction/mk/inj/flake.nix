{
  description = "Lean declaration: ContentAddressing.HashFunction.mk.inj";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/String";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/And";
    ContentAddressing-HashFunction-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/HashFunction/mk";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    ContentAddressing-HashFunction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/HashFunction";
    And-intro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/And/intro";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    ContentAddressing-HashFunction-mk-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/HashFunction/mk/noConfusion";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.HashFunction.mk.inj";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/HashFunction/mk/inj.lean $out/
        '';
      };
    };
}