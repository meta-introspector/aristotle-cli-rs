{
  description = "Lean declaration: Ring.toSub";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Ring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Ring";
    Sub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Sub";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Ring.toSub";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Ring/toSub.lean $out/
        '';
      };
    };
}