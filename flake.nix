{
  description = "A tool for polling Aristotle results and managing Lean4 project compilation";

  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=omaster";
    crane.url = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git?ref=omaster";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git?ref=omain";
    rust-overlay.url = "git+file:///mnt/data1/git/github.com/oxalica/rust-overlay.git?ref=omaster";
  };

  outputs = { self, nixpkgs, crane, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
        craneLib = crane.mkLib pkgs;

        rawGitSrc = builtins.fetchGit {
          url = "git+file:///mnt/data1/git/github.com/arist/aristotle-manager.git";
          ref = "main";
        };

        cleanedSrc = craneLib.cleanCargoSource rawGitSrc;

        cargoArtifacts = craneLib.buildDepsOnly {
          src = cleanedSrc;
          buildInputs = [ pkgs.libgit2 pkgs.openssl.dev pkgs.zlib ];
        };

        myCrate = craneLib.buildPackage {
          src = cleanedSrc;
          cargoArtifacts = cargoArtifacts;
          buildInputs = [ pkgs.libgit2 pkgs.openssl.dev pkgs.zlib ]; 
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.cargo
              pkgs.rustc
              pkgs.rustfmt
              pkgs.clippy
              pkgs.libgit2
              pkgs.curl
              pkgs.openssl.dev
              pkgs.zlib
              pkgs.nghttp2
              pkgs.pkg-config
              pkgs.cargo-edit
            ];
            ARISTOTLE_API_KEY = "";
            shellHook = ''
              echo "Aristotle Manager - Local Development"
              echo "======================================"
              echo ""
              echo "Build from source:"
              echo "  cargo build"
              echo "  cargo run"
              echo ""
              echo "Full package:"
              echo "  nix build .#default"
              echo ""
            '';
          };
        };

        packages.default = myCrate;
        apps.default = {
          type = "app";
          program = "${myCrate}/bin/aristotle-manager";
        };
      }
    );
}
