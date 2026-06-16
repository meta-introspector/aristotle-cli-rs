{
  description = "A tool for polling Aristotle results and managing Lean4 project compilation";
  
  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git?ref=main";
    nora.url = "git+file:///mnt/data1/git/github.com/getnora-io/nora.git?ref=main";
  };
  
  outputs = { self, nixpkgs, nora, flake-utils }:
    let
      system-manager = nora.inputs.system-manager;
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        noraPkgs = nora.packages.${system};
        rust-toolchain = nora.inputs.rust-overlay.packages.${system}.default;
        myPackages = rec {
          aristotle-manager = pkgs.stdenv.mkDerivation {
            pname = "aristotle-manager";
            version = "0.1.0";
            
            src = ./.;
            
            buildInputs = [
              rust-toolchain
              pkgs.cargo
              pkgs.rustfmt
              pkgs.clippy
              pkgs.pkg-config
              pkgs.openssl.dev
              pkgs.zlib
            ];
            
            cargoBuildFlags = [ "--release" ];
            doStrip = true;
            
            installPhase = ''
              mkdir -p "$out/bin"
              cp target/release/aristotle-manager "$out/bin/"
            '';
          };
          default = aristotle-manager;
        };
      in
      {
        devShells = rec {
          default = pkgs.mkShell {
            packages = [
              rust-toolchain
              pkgs.cargo
              pkgs.rustfmt
              pkgs.clippy
              pkgs.libgit2
              pkgs.curl
              pkgs.openssl.dev
              pkgs.zlib
              pkgs.nghttp2
              pkgs.pkg-config
              pkgs.jq
              pkgs.cargo-edit
            ];
            ARISTOTLE_API_KEY = "";
            shellHook = ''
              echo "Aristotle Manager - Local Development"
              echo "======================================"
              echo ""
              echo "Build from source:"
              echo "  cargo build        # Build the release binary"
              echo "  cargo run          # Run the CLI"
              echo ""
              echo "Full package:"
              echo "  nix build .#aristotle-manager"
              echo ""
            '';
          };
        };
        
        packages = myPackages;
        
        apps = {
          default = {
            type = "app";
            program = "${myPackages.default}/bin/aristotle-manager";
          };
        };
      }
    );
}
