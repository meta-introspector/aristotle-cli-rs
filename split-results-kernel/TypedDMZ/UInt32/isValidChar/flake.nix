{
  description = "Lean declaration: UInt32.isValidChar";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UInt32-toNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt32/toNat";
    Nat-isValidChar.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/isValidChar";
    UInt32.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt32";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UInt32.isValidChar";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UInt32/isValidChar.lean $out/
        '';
      };
    };
}