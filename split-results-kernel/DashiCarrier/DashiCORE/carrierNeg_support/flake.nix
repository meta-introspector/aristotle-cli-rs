{
  description = "Lean declaration: DashiCORE.carrierNeg_support";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/congrArg";
    DashiCORE-Ternary-support.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Ternary/support";
    DashiCORE-Ternary-neg'_support.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Ternary/neg'_support";
    DashiCORE-carrierNeg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/carrierNeg";
    DashiCORE-CarrierField.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/CarrierField";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/True";
    eq_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/eq_self";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/of_eq_true";
    congrFun'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/congrFun'";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/trans";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-DashiCORE.carrierNeg_support";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp DashiCORE/carrierNeg_support.lean $out/
        '';
      };
    };
}