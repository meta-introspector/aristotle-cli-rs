{
  description = "Lean declaration: MonsterTrain.frankfurt_absorbing_iter";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Nat-recAux.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat/recAux";
    MonsterTrain-City-frankfurt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/City/frankfurt";
    MonsterTrain-advance.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/advance";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat";
    MonsterTrain-frankfurt_absorbing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/frankfurt_absorbing";
    MonsterTrain-City.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/City";
    MonsterTrain-advanceN.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/advanceN";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Eq";
    MonsterTrain-MonsterCarriageTrain-location.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/MonsterCarriageTrain/location";
    MonsterTrain-MonsterCarriageTrain.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonsterTrain/MonsterCarriageTrain";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-MonsterTrain.frankfurt_absorbing_iter";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp MonsterTrain/frankfurt_absorbing_iter.lean $out/
        '';
      };
    };
}