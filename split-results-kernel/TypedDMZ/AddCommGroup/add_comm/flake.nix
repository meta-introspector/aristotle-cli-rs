{
  description = "Lean declaration: AddCommGroup.add_comm";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    AddMonoid-toAddSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddMonoid/toAddSemigroup";
    AddCommGroup-toAddGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCommGroup/toAddGroup";
    AddCommGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCommGroup";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instHAdd";
    AddSemigroup-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddSemigroup/toAdd";
    AddGroup-toSubNegMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddGroup/toSubNegMonoid";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/HAdd/hAdd";
    SubNegMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/SubNegMonoid/toAddMonoid";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-AddCommGroup.add_comm";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp AddCommGroup/add_comm.lean $out/
        '';
      };
    };
}