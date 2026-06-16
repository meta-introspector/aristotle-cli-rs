{
  description = "Lean declaration: NonUnitalCommRing.toNonUnitalNonAssocCommRing";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    NonUnitalRing-toNonUnitalNonAssocRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalRing/toNonUnitalNonAssocRing";
    NonUnitalCommRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalCommRing";
    NonUnitalNonAssocCommRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalNonAssocCommRing";
    NonUnitalCommRing-toNonUnitalRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalCommRing/toNonUnitalRing";
    NonUnitalCommRing-mul_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalCommRing/mul_comm";
    NonUnitalNonAssocCommRing-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/NonUnitalNonAssocCommRing/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-NonUnitalCommRing.toNonUnitalNonAssocCommRing";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp NonUnitalCommRing/toNonUnitalNonAssocCommRing.lean $out/
        '';
      };
    };
}