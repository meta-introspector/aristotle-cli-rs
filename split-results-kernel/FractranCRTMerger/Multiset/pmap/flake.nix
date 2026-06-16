{
  description = "Lean declaration: Multiset.pmap";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Quot-recOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Quot/recOn";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Membership/mem";
    Multiset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Multiset";
    Multiset-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Multiset/instMembership";
    List-pmap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/List/pmap";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/List";
    Multiset-ofList.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Multiset/ofList";
    List-isSetoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/List/isSetoid";
    Setoid-r.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Setoid/r";
    Quot-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Quot/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Multiset.pmap";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Multiset/pmap.lean $out/
        '';
      };
    };
}