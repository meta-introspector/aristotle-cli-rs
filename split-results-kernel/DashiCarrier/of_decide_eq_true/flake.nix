{
  description = "Lean declaration: of_decide_eq_true";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ne_true_of_eq_false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/ne_true_of_eq_false";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Decidable";
    decide_eq_false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/decide_eq_false";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool/true";
    absurd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/absurd";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Bool";
    Decidable-decide.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Decidable/decide";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-of_decide_eq_true";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp of_decide_eq_true.lean $out/
        '';
      };
    };
}