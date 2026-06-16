{
  description = "Lean declaration: Fin.ne_of_val_ne";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/False";
    Ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Ne";
    Fin-val.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin/val";
    absurd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/absurd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    Fin-val_eq_of_eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin/val_eq_of_eq";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Fin.ne_of_val_ne";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Fin/ne_of_val_ne.lean $out/
        '';
      };
    };
}