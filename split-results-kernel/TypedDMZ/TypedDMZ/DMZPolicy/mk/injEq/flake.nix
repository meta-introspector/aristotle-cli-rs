{
  description = "Lean declaration: TypedDMZ.DMZPolicy.mk.injEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TypedDMZ-DMZPolicy-mk-inj.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/DMZPolicy/mk/inj";
    Eq-propIntro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/propIntro";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/String";
    TypedDMZ-DMZRule.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/DMZRule";
    Lean-injEq_helper.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Lean/injEq_helper";
    KernelGovernance-Dataset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/KernelGovernance/Dataset";
    HEq-homo_ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HEq/homo_ndrec";
    Prod-fst.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod/fst";
    TypedDMZ-DMZPolicy-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/DMZPolicy/mk";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/And";
    DecidablePred.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/DecidablePred";
    TypedDMZ-Capability.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/Capability";
    Eq-ndrec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/ndrec";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/refl";
    HEq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HEq";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    Prod-snd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod/snd";
    TypedDMZ-DMZPolicy.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/TypedDMZ/DMZPolicy";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-TypedDMZ.DMZPolicy.mk.injEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp TypedDMZ/DMZPolicy/mk/injEq.lean $out/
        '';
      };
    };
}