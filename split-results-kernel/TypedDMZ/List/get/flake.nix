{
  description = "Lean declaration: List.get";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-brecOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/brecOn";
    Fin-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/mk";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instOfNatNat";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/cons";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT/lt";
    List-below.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/below";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLTNat";
    List-get-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/get/match_1";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/ofNat";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/succ";
    List-length.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/length";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.get";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/get.lean $out/
        '';
      };
    };
}