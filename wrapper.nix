{
  description = "A wrapper flake to build aristotle-manager from git";

  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=omaster";
    crane.url = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git?ref=omaster";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git?ref=omain";
    rust-overlay.url = "git+file:///mnt/data1/git/github.com/oxalica/rust-overlay.git?ref=omaster";
    aristotle-manager-src.url = "git+file:///mnt/data1/git/github.com/arist/aristotle-manager.git";
    aristotle-manager-src.flake = false;
  };

  outputs = { self, nixpkgs, crane, flake-utils, rust-overlay, aristotle-manager-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };
        craneLib = crane.mkLib pkgs;

        cleanedSrc = craneLib.cleanCargoSource aristotle-manager-src;

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
        packages.default = myCrate;
        apps.default = {
          type = "app";
          program = "${myCrate}/bin/aristotle-manager";
        };
      }
    );
}
