{
  description = "Lean declaration: PadicEntropyDAG.IrrepNode.toJson";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    PadicEntropyDAG-Metrics-toJson.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/Metrics/toJson";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/String";
    List-map.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/List/map";
    Float.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Float";
    ToString-toString.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/ToString/toString";
    Array-toList.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Array/toList";
    instAppendString.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instAppendString";
    PadicEntropyDAG-IrrepNode.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode";
    instHAppendOfAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instHAppendOfAppend";
    instToStringNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instToStringNat";
    Unit.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Unit";
    PadicEntropyDAG-IrrepNode-exponents.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/exponents";
    PadicEntropyDAG-IrrepNode-irrepIds.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/irrepIds";
    PadicEntropyDAG-IrrepNode-toJson-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/toJson/match_1";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Nat";
    instToStringFloat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instToStringFloat";
    PadicEntropyDAG-IrrepNode-metrics.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/metrics";
    String-intercalate.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/String/intercalate";
    PadicEntropyDAG-IrrepNode-componentLog10Scales.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/componentLog10Scales";
    HAppend-hAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/HAppend/hAppend";
    PadicEntropyDAG-IrrepNode-notes.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/notes";
    instToStringString.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instToStringString";
    Option.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Option";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-PadicEntropyDAG.IrrepNode.toJson";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp PadicEntropyDAG/IrrepNode/toJson.lean $out/
        '';
      };
    };
}