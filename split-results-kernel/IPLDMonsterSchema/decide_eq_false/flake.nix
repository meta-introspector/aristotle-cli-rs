{
  description = "Lean declaration: decide_eq_false";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Decidable/isTrue";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Decidable";
    absurd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/absurd";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Bool";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Decidable/isFalse";
    Bool-false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Bool/false";
    Decidable-decide.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Decidable/decide";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Not";
    rfl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/rfl";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-decide_eq_false";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp decide_eq_false.lean $out/
        '';
      };
    };
}