{
  description = "Lean declaration: DashiCORE.Carrier.mk.injEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-propIntro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/propIntro";
    Lean-injEq_helper.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Lean/injEq_helper";
    DashiCORE-Carrier-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Carrier/mk";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/And";
    DashiCORE-Carrier.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Carrier";
    DashiCORE-Carrier-mk-inj.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Carrier/mk/inj";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/ndrec";
    DashiCORE-Sign.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/DashiCORE/Sign";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/refl";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-DashiCORE.Carrier.mk.injEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp DashiCORE/Carrier/mk/injEq.lean $out/
        '';
      };
    };
}