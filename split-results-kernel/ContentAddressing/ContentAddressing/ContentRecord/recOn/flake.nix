{
  description = "Lean declaration: ContentAddressing.ContentRecord.recOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ContentAddressing-Multihash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/String";
    ContentAddressing-ContentRecord.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord";
    ContentAddressing-CID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/CID";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/List";
    ContentAddressing-ContentRecord-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord/mk";
    ContentAddressing-ContentRecord-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/ContentRecord/rec";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.ContentRecord.recOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/ContentRecord/recOn.lean $out/
        '';
      };
    };
}