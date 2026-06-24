{
  description = "Aristotle consolidated-dasl project";

  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git";
    lean4-nix.url = "git+file:///home/mdupont/git/github.com/lenianiva/lean4-nix.git";
  };

  outputs = { self, nixpkgs, lean4-nix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (lean4-nix.readToolchainFile ./lean-toolchain) ];
      };
    in {
      packages.${system}.default =
        (pkgs.lean.buildLeanPackage {
          name = "consolidated-dasl";
          src = ./.;
          roots = [ "ConsolidatedDasl" "RequestProject" ];
        })
        .executable;

      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.lean ];
      };
    };
}
