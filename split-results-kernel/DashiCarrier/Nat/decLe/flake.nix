{
  description = "Lean declaration: Nat.decLe";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Decidable/isTrue";
    Nat-le_of_ble_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat/le_of_ble_eq_true";
    Nat-ble.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat/ble";
    Nat-not_le_of_not_ble_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat/not_le_of_not_ble_eq_true";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Decidable";
    instDecidableEqBool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instDecidableEqBool";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instLENat";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/dite";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool/true";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Decidable/isFalse";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.decLe";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/decLe.lean $out/
        '';
      };
    };
}