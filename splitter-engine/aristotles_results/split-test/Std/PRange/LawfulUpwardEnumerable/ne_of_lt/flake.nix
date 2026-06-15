{
  description = "Lean declaration: Std.PRange.LawfulUpwardEnumerable.ne_of_lt";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-PRange-UpwardEnumerable.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/PRange/UpwardEnumerable";
    Std-PRange-UpwardEnumerable-LT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/PRange/UpwardEnumerable/LT";
    Ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Ne";
    Std-PRange-LawfulUpwardEnumerable.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/PRange/LawfulUpwardEnumerable";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.PRange.LawfulUpwardEnumerable.ne_of_lt";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/PRange/LawfulUpwardEnumerable/ne_of_lt.lean $out/
        '';
      };
    };
}