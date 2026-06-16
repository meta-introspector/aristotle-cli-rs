{
  description = "Lean declaration: ContentAddressing.Multicodec.ctorElim";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-Multicodec-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/casesOn";
    ContentAddressing-Multicodec-dagPB.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/dagPB";
    ContentAddressing-Multicodec-ctorElimType.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/ctorElimType";
    ContentAddressing-Multicodec-leanTerm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/leanTerm";
    ContentAddressing-Multicodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq/ndrec";
    PULift-down.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/PULift/down";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    ContentAddressing-Multicodec-raw.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/raw";
    ContentAddressing-Multicodec-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/ctorIdx";
    ContentAddressing-Multicodec-dagCBOR.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multicodec/dagCBOR";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.Multicodec.ctorElim";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/Multicodec/ctorElim.lean $out/
        '';
      };
    };
}