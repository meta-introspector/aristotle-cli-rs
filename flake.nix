{
  description = "A tool for polling Aristotle results and managing Lean4 project compilation";
  
  inputs = {
    # Use local nixpkgs for development
    nixpkgs.url = "path:/mnt/data1/nixpkgs/nixpkgs-unstable";
    
    # flake-utils from nora
    nora-system-managers.url = "path:/mnt/data1/nix/nora/pkgs/nora-system-managers";
    flake-utils.follows = "nora-system-managers/flake-utils";
    
    # Nora utilities
    nora.url = "path:/mnt/data1/nix/nora";
    nora.follows = "nora-system-managers/nora";
  };
  
  outputs = { self, nixpkgs, nora-system-managers, nora }:
    let
      # Get system-specific packages
      pkgs = nixpkgs.legacyPackages;
      
      # Nora package
      noraPkgs = nora.packages;
      
      # Legacy packages from our local nixpkgs
      flakeUtils = nora-system-managers.legacyPackages;
    in flakeUtils.default:
      # Development shell
      {
        devShells = rec {
          default = pkgs.mkShell {
            packages = [
              # Rust toolchain from nora
              noraPkgs.rust-bin.stable.latest.default
              noraPkgs.cargo
              noraPkgs.rustfmt
              noraPkgs.clippy
              
              # System libraries
              pkgs.libgit2
              pkgs.curl
              pkgs.openssl.dev
              pkgs.zlib
              pkgs.nghttp2
              pkgs.pkg-config
              
              # Utilities
              pkgs.jq
              pkgs.cargo-edit
            ];
            
            # Environment
            ARISTOTLE_API_KEY = "";
            
            # Shell hook for building from source
            shellHook = ''
              echo "Aristotle Manager - Local Development"
              echo "======================================"
              echo ""
              echo "Build from source:"
              echo "  cargo build        # Build the release binary"
              echo "  cargo run          # Run the CLI"
              echo ""
              echo "Full package:"
              echo "  nix build .#package"
              echo ""
            '';
          };
        };
        
        # Package definition
        packages = rec {
          default = pkgs.stdenv.mkDerivation {
            pname = "aristotle-manager";
            version = "0.1.0";
            
            src = ./.;
            
            # Build dependencies from nora
            buildInputs = [
              noraPkgs.rust-bin.stable.latest.default
              noraPkgs.cargo
              noraPkgs.pkg-config
              pkgs.openssl.dev
              pkgs.zlib
            ];
            
            # Build instructions
            cargoBuildFlags = [ "--release" ];
            doStrip = true;
            
            # Install
            installPhase = ''
              mkdir -p "$out/bin"
              cp target/release/aristotle-manager "$out/bin/"
            '';
          };
        };
        
        # Provide app for Nix/Nora integration
        apps = {
          default = {
            type = "app";
            program = "${packages.default}/bin/aristotle-manager";
          };
        };
        
      };
  
  # Simple build using nix-shell directly
  outputsFromSelf = pkgs:
    {
      apps = pkgs.legacyPackages;
      defaultApp = {
        command = "${pkgs.legacyPackages.${pkgs.system}/bin/bash }";
        sandboxBin = [ "${pkgs.legacyPackages.${pkgs.system}.stdenv}/bin/true" ];
      };
    };
}
