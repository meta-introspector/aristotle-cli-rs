{
  description = "dotagents-core — vendormod generated flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        crate-name = "dotagents-core";
        crate-version = "0.1.0";
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = crate-name;
          version = crate-version;
          src = ./.;
          cargoSha256 = pkgs.lib.fakeSha256;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo rustc rust-analyzer rustfmt clippy
          ];
        };
      });
}
