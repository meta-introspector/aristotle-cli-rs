{
  description = "Lean declaration: Std.IsLinearOrder.toIsLinearPreorder";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-IsLinearOrder-toIsPartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearOrder/toIsPartialOrder";
    Std-IsLinearOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearOrder";
    LE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE";
    Std-IsLinearOrder-le_total.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearOrder/le_total";
    Std-IsLinearPreorder-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder/mk";
    Std-IsLinearPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder";
    Std-IsPartialOrder-toIsPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsPartialOrder/toIsPreorder";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.IsLinearOrder.toIsLinearPreorder";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/IsLinearOrder/toIsLinearPreorder.lean $out/
        '';
      };
    };
}