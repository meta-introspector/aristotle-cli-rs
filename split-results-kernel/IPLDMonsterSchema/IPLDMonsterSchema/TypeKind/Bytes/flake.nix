{
  description = "Lean declaration: IPLDMonsterSchema.TypeKind.Bytes";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    IPLDMonsterSchema-TypeKind.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/IPLDMonsterSchema/TypeKind";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-IPLDMonsterSchema.TypeKind.Bytes";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp IPLDMonsterSchema/TypeKind/Bytes.lean $out/
        '';
      };
    };
}