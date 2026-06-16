{
  description = "Lean declaration: DashiCORE.Ternary.pos.sizeOf_spec";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instOfNatNat";
    DashiCORE-Ternary-pos.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Ternary/pos";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    DashiCORE-Ternary.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Ternary";
    SizeOf-sizeOf.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/SizeOf/sizeOf";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/refl";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-DashiCORE.Ternary.pos.sizeOf_spec";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp DashiCORE/Ternary/pos/sizeOf_spec.lean $out/
        '';
      };
    };
}