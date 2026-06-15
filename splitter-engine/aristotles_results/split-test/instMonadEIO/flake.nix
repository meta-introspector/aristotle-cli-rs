{
  description = "Lean declaration: instMonadEIO";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Seq-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Seq/mk";
    SeqLeft-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/SeqLeft/mk";
    SeqRight-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/SeqRight/mk";
    EIO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/EIO";
    Pure-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Pure/mk";
    Functor-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Functor/mk";
    Applicative-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Applicative/mk";
    Monad-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Monad/mk";
    Monad.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Monad";
    Bind-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Bind/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-instMonadEIO";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp instMonadEIO.lean $out/
        '';
      };
    };
}