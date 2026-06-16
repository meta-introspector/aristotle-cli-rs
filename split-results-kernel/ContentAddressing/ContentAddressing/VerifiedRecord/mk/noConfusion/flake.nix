{
  description = "Lean declaration: ContentAddressing.VerifiedRecord.mk.noConfusion";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-VerifiedRecord-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/VerifiedRecord/mk";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/id";
    ContentAddressing-ContentRecord.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Bool/true";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/List";
    ContentAddressing-VerifiedRecord-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/VerifiedRecord/noConfusion";
    ContentAddressing-acceptRecord.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/acceptRecord";
    ContentAddressing-HashFunction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/HashFunction";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Bool";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Prod";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    ContentAddressing-VerifiedRecord.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/VerifiedRecord";
    ContentAddressing-MultihashCodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec";
    ContentAddressing-ContentRecord-hashesConsistent.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord/hashesConsistent";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.VerifiedRecord.mk.noConfusion";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/VerifiedRecord/mk/noConfusion.lean $out/
        '';
      };
    };
}