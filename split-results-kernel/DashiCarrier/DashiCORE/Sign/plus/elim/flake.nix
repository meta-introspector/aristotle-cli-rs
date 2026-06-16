{
  description = "Lean declaration: DashiCORE.Sign.plus.elim";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    PULift-up.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/PULift/up";
    DashiCORE-Sign-ctorIdx.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Sign/ctorIdx";
    DashiCORE-Sign-plus.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Sign/plus";
    DashiCORE-Sign-ctorElim.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Sign/ctorElim";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    DashiCORE-Sign.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Sign";
    Eq-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/symm";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-DashiCORE.Sign.plus.elim";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp DashiCORE/Sign/plus/elim.lean $out/
        '';
      };
    };
}