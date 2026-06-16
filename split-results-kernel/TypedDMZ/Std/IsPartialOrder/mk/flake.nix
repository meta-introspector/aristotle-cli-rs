{
  description = "Lean declaration: Std.IsPartialOrder.mk";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-IsPartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsPartialOrder";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE/le";
    LE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE";
    Std-IsPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsPreorder";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.IsPartialOrder.mk";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/IsPartialOrder/mk.lean $out/
        '';
      };
    };
}