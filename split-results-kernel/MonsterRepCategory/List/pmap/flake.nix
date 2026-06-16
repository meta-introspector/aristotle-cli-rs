{
  description = "Lean declaration: List.pmap";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-brecOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/brecOn";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Membership/mem";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/cons";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List";
    List-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/instMembership";
    List-below.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/below";
    List-pmap-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/pmap/match_1";
    List-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/List/nil";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.pmap";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/pmap.lean $out/
        '';
      };
    };
}