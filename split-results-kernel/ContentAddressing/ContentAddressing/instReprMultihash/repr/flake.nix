{
  description = "Lean declaration: ContentAddressing.instReprMultihash.repr";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Format-nil.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/nil";
    Std-Format-instAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/instAppend";
    ContentAddressing-Multihash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash";
    Std-Format-line.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/line";
    ContentAddressing-instReprMultihashCodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/instReprMultihashCodec";
    ContentAddressing-Multihash-digest.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash/digest";
    Std-Format-group.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/group";
    Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Int";
    instHAppendOfAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHAppendOfAppend";
    instOfNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instOfNat";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    Std-Format-bracket.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/bracket";
    Std-Format.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format";
    ContentAddressing-Multihash-codec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash/codec";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/OfNat/ofNat";
    HAppend-hAppend.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HAppend/hAppend";
    ContentAddressing-Multihash-digestSize.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/Multihash/digestSize";
    Std-Format-nest.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/nest";
    instReprNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instReprNat";
    repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/repr";
    ContentAddressing-MultihashCodec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/MultihashCodec";
    Std-Format-text.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/text";
    Std-Format-FlattenBehavior-allOrNone.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Std/Format/FlattenBehavior/allOrNone";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.instReprMultihash.repr";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/instReprMultihash/repr.lean $out/
        '';
      };
    };
}