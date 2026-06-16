{
  description = "Lean declaration: UnifiedIPLDMemory.MASLAction.liftToProof.inj";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UnifiedIPLDMemory-MASLAction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/MASLAction";
    UnifiedIPLDMemory-IPLDCID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/IPLDCID";
    UnifiedIPLDMemory-MASLAction-liftToProof.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/MASLAction/liftToProof";
    UnifiedIPLDMemory-MASLAction-liftToProof-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/MASLAction/liftToProof/noConfusion";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UnifiedIPLDMemory.MASLAction.liftToProof.inj";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UnifiedIPLDMemory/MASLAction/liftToProof/inj.lean $out/
        '';
      };
    };
}