{
  description = "Lean declaration: Std.Format.joinSep";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Format-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Std/Format/nil";
    Std-Format-instAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Std/Format/instAppend";
    List-foldl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/List/foldl";
    Std-ToFormat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Std/ToFormat";
    Std-ToFormat-format.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Std/ToFormat/format";
    instHAppendOfAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instHAppendOfAppend";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/List";
    Std-Format.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Std/Format";
    HAppend-hAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/HAppend/hAppend";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.Format.joinSep";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/Format/joinSep.lean $out/
        '';
      };
    };
}