{
  description = "Lean declaration: Nat.shiftRight_succ";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instHDiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instHDiv";
    HDiv-hDiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HDiv/hDiv";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instOfNatNat";
    instHShiftRightOfShiftRight.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instHShiftRightOfShiftRight";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instHAdd";
    Nat-instShiftRight.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/instShiftRight";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HAdd/hAdd";
    HShiftRight-hShiftRight.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/HShiftRight/hShiftRight";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat";
    Nat-instDiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/instDiv";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instAddNat";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Eq";
    rfl.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/rfl";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.shiftRight_succ";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/shiftRight_succ.lean $out/
        '';
      };
    };
}