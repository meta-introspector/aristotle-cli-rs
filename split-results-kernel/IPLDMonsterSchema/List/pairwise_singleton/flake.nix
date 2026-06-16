{
  description = "Lean declaration: List.pairwise_singleton";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/False";
    List-Pairwise.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/List/Pairwise";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/congrArg";
    and_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/and_self";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Membership/mem";
    false_implies.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/false_implies";
    List-cons.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/List/cons";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/List";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/And";
    List-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/List/instMembership";
    implies_congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/implies_congr";
    congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/congr";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/True";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/of_eq_true";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq/refl";
    implies_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/implies_true";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/Eq/trans";
    List-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/List/nil";
    forall_congr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/IPLDMonsterSchema/forall_congr";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.pairwise_singleton";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/pairwise_singleton.lean $out/
        '';
      };
    };
}