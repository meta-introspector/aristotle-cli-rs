{
  description = "Lean declaration: ContentAddressing.instDecidableEqCID.decEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-instDecidableEqCIDVersion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/instDecidableEqCIDVersion";
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable/isTrue";
    ContentAddressing-instDecidableEqCID-decEq-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/instDecidableEqCID/decEq/match_1";
    ContentAddressing-CID-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/CID/mk";
    ContentAddressing-Multihash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable";
    ContentAddressing-instDecidableEqMulticodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/instDecidableEqMulticodec";
    ContentAddressing-CIDVersion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/CIDVersion";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/dite";
    ContentAddressing-CID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/CID";
    ContentAddressing-Multicodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq/ndrec";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable/isFalse";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Not";
    ContentAddressing-instDecidableEqMultihash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/instDecidableEqMultihash";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.instDecidableEqCID.decEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/instDecidableEqCID/decEq.lean $out/
        '';
      };
    };
}