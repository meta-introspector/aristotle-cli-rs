{
  description = "Lean declaration: ByteArray.utf8DecodeChar?.assemble₄";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Option-some.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Option/some";
    ByteArray-utf8DecodeChar?-assemble₄Unchecked.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/assemble₄Unchecked";
    instDecidableEqBool.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/instDecidableEqBool";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/dite";
    Bool-true.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Bool/true";
    Option-none.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Option/none";
    Char-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Char/mk";
    instLTUInt32.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/instLTUInt32";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/LT/lt";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Bool";
    Bool-or.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Bool/or";
    UInt32.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/UInt32";
    ByteArray-utf8DecodeChar?-isInvalidContinuationByte.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/isInvalidContinuationByte";
    Char.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Char";
    UInt32-decLt.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/UInt32/decLt";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/OfNat/ofNat";
    UInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/UInt8";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Eq";
    UInt32-instOfNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/UInt32/instOfNat";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Not";
    Option.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Option";
    ite.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ite";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ByteArray.utf8DecodeChar?.assemble₄";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ByteArray/utf8DecodeChar?/assemble₄.lean $out/
        '';
      };
    };
}