{
  description = "Lean declaration: sInf_le";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    lowerBounds.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/lowerBounds";
    PartialOrder-toPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/PartialOrder/toPreorder";
    Preorder-toLE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Preorder/toLE";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Membership/mem";
    upperBounds.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/upperBounds";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/LE/le";
    isGLB_sInf.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/isGLB_sInf";
    CompleteSemilatticeInf-toPartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CompleteSemilatticeInf/toPartialOrder";
    And-left.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/And/left";
    CompleteSemilatticeInf.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CompleteSemilatticeInf";
    CompleteSemilatticeInf-toInfSet.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CompleteSemilatticeInf/toInfSet";
    Set-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Set/instMembership";
    InfSet-sInf.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/InfSet/sInf";
    Set.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Set";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-sInf_le";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp sInf_le.lean $out/
        '';
      };
    };
}