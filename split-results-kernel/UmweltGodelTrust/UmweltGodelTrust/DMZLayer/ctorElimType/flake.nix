{
  description = "Lean declaration: UmweltGodelTrust.DMZLayer.ctorElimType";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    cond.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/cond";
    Nat-ble.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/ble";
    UmweltGodelTrust-DMZLayer-bedrock_trust.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/bedrock_trust";
    UmweltGodelTrust-DMZLayer-offJ_shadows.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/offJ_shadows";
    PULift.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/PULift";
    UmweltGodelTrust-DMZLayer-onJ_bindings.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/onJ_bindings";
    UmweltGodelTrust-DMZLayer-grade0_void.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/grade0_void";
    UmweltGodelTrust-DMZLayer-degeneracy_grades.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/degeneracy_grades";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat";
    UmweltGodelTrust-DMZLayer-maximal_umwelt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer/maximal_umwelt";
    UmweltGodelTrust-DMZLayer.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/DMZLayer";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UmweltGodelTrust.DMZLayer.ctorElimType";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UmweltGodelTrust/DMZLayer/ctorElimType.lean $out/
        '';
      };
    };
}