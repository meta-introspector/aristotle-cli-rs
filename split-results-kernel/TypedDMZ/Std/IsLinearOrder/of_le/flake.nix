{
  description = "Lean declaration: Std.IsLinearOrder.of_le";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Antisymm-antisymm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/Antisymm/antisymm";
    Std-Antisymm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/Antisymm";
    Std-IsLinearPreorder-toIsPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder/toIsPreorder";
    inferInstance.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/inferInstance";
    Std-IsLinearPreorder-le_total.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder/le_total";
    Std-IsPartialOrder-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsPartialOrder/mk";
    Std-IsLinearPreorder-of_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder/of_le";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE/le";
    autoParam.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/autoParam";
    Std-IsLinearOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearOrder";
    LE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LE";
    Trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Trans";
    Std-IsLinearOrder-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearOrder/mk";
    Std-IsLinearPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/IsLinearPreorder";
    Std-Total.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Std/Total";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.IsLinearOrder.of_le";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/IsLinearOrder/of_le.lean $out/
        '';
      };
    };
}