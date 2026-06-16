{
  description = "Lean declaration: IPLDMonsterSchema.RepresentationKind.recOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    IPLDMonsterSchema-RepresentationKind-Float.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Float";
    IPLDMonsterSchema-RepresentationKind-Link.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Link";
    IPLDMonsterSchema-RepresentationKind-String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/String";
    IPLDMonsterSchema-RepresentationKind-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/rec";
    IPLDMonsterSchema-RepresentationKind-Bytes.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Bytes";
    IPLDMonsterSchema-RepresentationKind-Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Int";
    IPLDMonsterSchema-RepresentationKind.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind";
    IPLDMonsterSchema-RepresentationKind-Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Bool";
    IPLDMonsterSchema-RepresentationKind-Map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/Map";
    IPLDMonsterSchema-RepresentationKind-List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/RepresentationKind/List";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-IPLDMonsterSchema.RepresentationKind.recOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp IPLDMonsterSchema/RepresentationKind/recOn.lean $out/
        '';
      };
    };
}