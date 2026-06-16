{
  description = "Lean declaration: nonempty_fintype";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Finite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Finite";
    Exists.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Exists";
    Equiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Equiv";
    Fintype-ofEquiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Fintype/ofEquiv";
    Nonempty-intro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Nonempty/intro";
    Fin-fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Fin/fintype";
    Exists-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Exists/casesOn";
    Fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Fintype";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Nat";
    Nonempty-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Nonempty/casesOn";
    Finite-exists_equiv_fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Finite/exists_equiv_fin";
    Nonempty.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Nonempty";
    Equiv-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Equiv/symm";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Fin";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-nonempty_fintype";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp nonempty_fintype.lean $out/
        '';
      };
    };
}