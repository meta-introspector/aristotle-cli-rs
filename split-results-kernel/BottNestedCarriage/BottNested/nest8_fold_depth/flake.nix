{
  description = "Lean declaration: BottNested.nest8_fold_depth";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq/mpr";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/congrArg";
    BottNested-nest8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/nest8";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/id";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instOfNatNat";
    BottNested-nest8_depth.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/nest8_depth";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat";
    BottNested-NestedCarriage-depth.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/NestedCarriage/depth";
    BottNested-bottFold.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/bottFold";
    BottNested-bottFold_depth.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/BottNested/bottFold_depth";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-BottNested.nest8_fold_depth";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp BottNested/nest8_fold_depth.lean $out/
        '';
      };
    };
}