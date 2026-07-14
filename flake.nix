{
  description = "Aristotle Manager — Rust binary for polling Aristotle results and managing Lean4 project compilation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
  };

  outputs = { self, nixpkgs, nora-system-managers, flake-utils, nora }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        noraPkgs = nora.packages.${system};
      in {
        packages = rec {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "aristotle-manager";
            version = "0.1.0";
            src = ./.;
            cargoSha256 = "0000000000000000000000000000000000000000000000000000";
            buildInputs = [ pkgs.openssl pkgs.zlib pkgs.libgit2 pkgs.curl pkgs.nghttp2 ];
            nativeBuildInputs = [ pkgs.pkg-config ];
            doCheck = false;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rustc cargo rustfmt clippy
            pkg-config openssl.dev libgit2 curl zlib nghttp2
            jq cargo-edit
          ];
          ARISTOTLE_API_KEY = "";
          shellHook = ''
            echo "Aristotle Manager — Dev Shell"
            echo "  cargo build --release  # build"
            echo "  nix build               # nix build"
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/aristotle-manager";
        };
      }));
}
