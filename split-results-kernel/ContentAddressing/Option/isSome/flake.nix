{
  description = "Lean declaration: Option.isSome";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Option-isSome-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Option/isSome/match_1";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Bool/true";
    Unit.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Unit";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Bool";
    Bool-false.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Bool/false";
    Option.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Option";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Option.isSome";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Option/isSome.lean $out/
        '';
      };
    };
}