{
  description = "Lean declaration: List.mem_finRange";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-ofFn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/ofFn";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Membership/mem";
    Exists.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Exists";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List";
    List-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/instMembership";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/True";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/of_eq_true";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin";
    List-finRange.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/finRange";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/trans";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.mem_finRange";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/mem_finRange.lean $out/
        '';
      };
    };
}