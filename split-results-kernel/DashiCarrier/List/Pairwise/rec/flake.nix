{
  description = "Lean declaration: List.Pairwise.rec";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-Pairwise-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/Pairwise/cons";
    List-Pairwise.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/Pairwise";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Membership/mem";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/cons";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List";
    List-Pairwise-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/Pairwise/nil";
    List-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/instMembership";
    List-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/nil";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.Pairwise.rec";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/Pairwise/rec.lean $out/
        '';
      };
    };
}