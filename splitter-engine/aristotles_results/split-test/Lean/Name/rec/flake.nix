{
  description = "Lean declaration: Lean.Name.rec";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String";
    Lean-Name-num.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Lean/Name/num";
    Lean-Name-str.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Lean/Name/str";
    Lean-Name-anonymous.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Lean/Name/anonymous";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Nat";
    Lean-Name.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Lean/Name";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.Name.rec";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/Name/rec.lean $out/
        '';
      };
    };
}