{
  description = "Lean declaration: not_lt_of_ge";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Preorder-toLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Preorder/toLT";
    Preorder-toLE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Preorder/toLE";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/LE/le";
    imp_not_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/imp_not_comm";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/LT/lt";
    Iff-mp.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Iff/mp";
    not_le_of_gt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/not_le_of_gt";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Not";
    Preorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Preorder";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-not_lt_of_ge";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp not_lt_of_ge.lean $out/
        '';
      };
    };
}