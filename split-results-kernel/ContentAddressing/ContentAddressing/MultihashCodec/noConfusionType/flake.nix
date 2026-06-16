{
  description = "Lean declaration: ContentAddressing.MultihashCodec.noConfusionType";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-MultihashCodec-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/ctorIdx";
    noConfusionTypeEnum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/noConfusionTypeEnum";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    instDecidableEqNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instDecidableEqNat";
    ContentAddressing-MultihashCodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.MultihashCodec.noConfusionType";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/MultihashCodec/noConfusionType.lean $out/
        '';
      };
    };
}