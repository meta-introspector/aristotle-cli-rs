{
  description = "Lean declaration: MonsterTrain.King.mk.inj";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    MonsterTrain-King-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/King/mk";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/And";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat";
    And-intro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/And/intro";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Eq";
    MonsterTrain-King.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/King";
    MonsterTrain-King-mk-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/King/mk/noConfusion";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-MonsterTrain.King.mk.inj";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp MonsterTrain/King/mk/inj.lean $out/
        '';
      };
    };
}