{
  description = "Lean declaration: MonsterRepCategory.instInhabitedVirtualRep";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    MonsterRepCategory-VirtualRep.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/MonsterRepCategory/VirtualRep";
    MonsterRepCategory-instInhabitedVirtualRep-default.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/MonsterRepCategory/instInhabitedVirtualRep/default";
    Inhabited.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Inhabited";
    Inhabited-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterRepCategory/Inhabited/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-MonsterRepCategory.instInhabitedVirtualRep";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp MonsterRepCategory/instInhabitedVirtualRep.lean $out/
        '';
      };
    };
}