{
  description = "Lean declaration: ContentAddressing.MultihashCodec.casesOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-MultihashCodec-asciiSum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/asciiSum";
    ContentAddressing-MultihashCodec-blake2b_256.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/blake2b_256";
    ContentAddressing-MultihashCodec-sha3_256.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/sha3_256";
    ContentAddressing-MultihashCodec-identity.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/identity";
    ContentAddressing-MultihashCodec-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/rec";
    ContentAddressing-MultihashCodec-sha2_256.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec/sha2_256";
    ContentAddressing-MultihashCodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.MultihashCodec.casesOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/MultihashCodec/casesOn.lean $out/
        '';
      };
    };
}