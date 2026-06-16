{
  description = "Lean declaration: IPLDMonsterSchema.instReprStructReprStrategy";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Repr-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Repr/mk";
    IPLDMonsterSchema-instReprStructReprStrategy-repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/instReprStructReprStrategy/repr";
    IPLDMonsterSchema-StructReprStrategy.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/StructReprStrategy";
    Repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Repr";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-IPLDMonsterSchema.instReprStructReprStrategy";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp IPLDMonsterSchema/instReprStructReprStrategy.lean $out/
        '';
      };
    };
}