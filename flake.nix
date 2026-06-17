{
  description = "A tool for polling Aristotle results and managing Lean4 project compilation";

  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=omaster";
    crane.url = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git?ref=omaster";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git?ref=omain";
  };

  outputs = { self, nixpkgs, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.mkLib pkgs;

        src = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter = path: type:
              let
                baseName = baseNameOf (toString path);
              in
                ! (
                  baseName == ".git" ||
                  baseName == "target" ||
                  baseName == "result"
                );
          };

        cargoArtifacts = craneLib.buildDepsOnly {
          inherit src;
          buildInputs = [ pkgs.libgit2 pkgs.openssl.dev pkgs.zlib ];
        };

        myCrate = craneLib.buildPackage {
          inherit src cargoArtifacts;
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
