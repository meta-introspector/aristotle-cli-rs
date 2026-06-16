{
  description = "Lean declaration: Nat.not_le_of_not_ble_eq_true";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/False";
    Nat-ble.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Nat/ble";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instLENat";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Bool/true";
    Nat-ble_eq_true_of_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Nat/ble_eq_true_of_le";
    absurd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/absurd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Nat";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Bool";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.not_le_of_not_ble_eq_true";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/not_le_of_not_ble_eq_true.lean $out/
        '';
      };
    };
}