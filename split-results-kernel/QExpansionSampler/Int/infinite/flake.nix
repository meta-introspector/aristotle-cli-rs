{
  description = "Lean declaration: Int.infinite";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Infinite-of_injective.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Infinite/of_injective";
    Int-ofNat-inj.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/ofNat/inj";
    Int-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int/ofNat";
    Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat";
    Infinite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Infinite";
    instInfiniteNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instInfiniteNat";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Int.infinite";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Int/infinite.lean $out/
        '';
      };
    };
}