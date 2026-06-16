{
  description = "Lean declaration: ContentAddressing.ContentRecord.mk.injEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-propIntro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq/propIntro";
    ContentAddressing-Multihash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/String";
    Lean-injEq_helper.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Lean/injEq_helper";
    ContentAddressing-ContentRecord.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord";
    ContentAddressing-ContentRecord-mk-inj.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord/mk/inj";
    ContentAddressing-CID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/CID";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/List";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/And";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq/ndrec";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq/refl";
    ContentAddressing-ContentRecord-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord/mk";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.ContentRecord.mk.injEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/ContentRecord/mk/injEq.lean $out/
        '';
      };
    };
}