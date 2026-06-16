{
  description = "Lean declaration: UmweltGodelTrust.instFintypeDMZLayer";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Finset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Finset";
    UmweltGodelTrust-DMZLayer-bedrock_trust.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/bedrock_trust";
    UmweltGodelTrust-DMZLayer-offJ_shadows.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/offJ_shadows";
    Insert-insert.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Insert/insert";
    Finset-instInsert.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Finset/instInsert";
    UmweltGodelTrust-DMZLayer-onJ_bindings.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/onJ_bindings";
    UmweltGodelTrust-DMZLayer-grade0_void.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/grade0_void";
    Fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Fintype";
    UmweltGodelTrust-DMZLayer-degeneracy_grades.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/degeneracy_grades";
    Fintype-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Fintype/mk";
    UmweltGodelTrust-instDecidableEqDMZLayer.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/instDecidableEqDMZLayer";
    UmweltGodelTrust-DMZLayer-maximal_umwelt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/maximal_umwelt";
    Finset-instSingleton.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Finset/instSingleton";
    Singleton-singleton.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Singleton/singleton";
    UmweltGodelTrust-DMZLayer.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UmweltGodelTrust.instFintypeDMZLayer";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UmweltGodelTrust/instFintypeDMZLayer.lean $out/
        '';
      };
    };
}