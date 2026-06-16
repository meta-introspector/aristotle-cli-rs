{
  description = "Lean declaration: Repr.addAppParen";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Format-paren.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Std/Format/paren";
    GE-ge.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/GE/ge";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instOfNatNat";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instLENat";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    Std-Format.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Std/Format";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/OfNat/ofNat";
    Nat-decLe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat/decLe";
    ite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/ite";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Repr.addAppParen";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Repr/addAppParen.lean $out/
        '';
      };
    };
}