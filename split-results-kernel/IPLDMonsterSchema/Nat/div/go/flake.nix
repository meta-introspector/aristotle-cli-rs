{
  description = "Lean declaration: Nat.div.go";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    HSub-hSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/HSub/hSub";
    Nat-brecOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/brecOn";
    instSubNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instSubNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instOfNatNat";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instLENat";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/dite";
    Nat-below.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/below";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instHAdd";
    instHSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instHSub";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/HAdd/hAdd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/LT/lt";
    Nat-div_rec_fuel_lemma.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/div_rec_fuel_lemma";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instAddNat";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/instLTNat";
    Nat-div-go-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/div/go/match_1";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/OfNat/ofNat";
    Nat-succ.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/succ";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Not";
    Nat-decLe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Nat/decLe";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.div.go";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/div/go.lean $out/
        '';
      };
    };
}