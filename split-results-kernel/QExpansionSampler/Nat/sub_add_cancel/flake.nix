{
  description = "Lean declaration: Nat.sub_add_cancel";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/mpr";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/congrArg";
    HSub-hSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HSub/hSub";
    Nat-add_sub_of_le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/add_sub_of_le";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/id";
    instSubNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instSubNat";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/LE/le";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instLENat";
    instHAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHAdd";
    instHSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instHSub";
    HAdd-hAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/HAdd/hAdd";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat";
    instAddNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/instAddNat";
    Eq-refl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq/refl";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Eq";
    Nat-add_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/add_comm";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.sub_add_cancel";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/sub_add_cancel.lean $out/
        '';
      };
    };
}