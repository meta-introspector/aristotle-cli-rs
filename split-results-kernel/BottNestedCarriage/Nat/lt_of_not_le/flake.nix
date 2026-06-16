{
  description = "Lean declaration: Nat.lt_of_not_le";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    GE-ge.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/GE/ge";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instLENat";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/LT/lt";
    Nat-lt_or_ge.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Nat/lt_or_ge";
    Or-resolve_right.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Or/resolve_right";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/instLTNat";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/BottNestedCarriage/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.lt_of_not_le";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/lt_of_not_le.lean $out/
        '';
      };
    };
}