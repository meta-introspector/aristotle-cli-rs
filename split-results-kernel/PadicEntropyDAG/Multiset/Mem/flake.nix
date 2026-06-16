{
  description = "Lean declaration: Multiset.Mem";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Quot-liftOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Quot/liftOn";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Membership/mem";
    Multiset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Multiset";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/List";
    List-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/List/instMembership";
    List-isSetoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/List/isSetoid";
    Setoid-r.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Setoid/r";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Multiset.Mem";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Multiset/Mem.lean $out/
        '';
      };
    };
}