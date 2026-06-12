{ pkgs ? import <nixpkgs> {} }

let
  myRustc = pkgs.rustc;
  
  myCargo = pkgs.cargo;

in pkgs.mkShell {
  packages = [
    # Rust toolchain
    myRustc
    myCargo
    pkgs.rustfmt
    pkgs.clippy
    
    # Build dependencies
    pkgs.pkg-config
    pkgs.openssl.dev
    pkgs.libgit2
    pkgs.curl
    pkgs.zlib
    pkgs.nghttp2
  ];
  
  shellHook = ''
    echo "Aristotle Manager development shell ready"
    echo "Run 'cargo build' to compile"
    echo "Run 'cargo run -- <command>' to execute"
  '';
}
