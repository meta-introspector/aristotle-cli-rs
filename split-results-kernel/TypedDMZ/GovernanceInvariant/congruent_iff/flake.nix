{
  description = "Lean declaration: GovernanceInvariant.congruent_iff";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    GovernanceInvariant-CID.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GovernanceInvariant/CID";
    ZMod-commRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ZMod/commRing";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrArg";
    AddGroupWithOne-toAddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddGroupWithOne/toAddMonoidWithOne";
    GovernanceInvariant-Congruent.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GovernanceInvariant/Congruent";
    GovernanceInvariant-Block.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GovernanceInvariant/Block";
    Prod-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod/mk";
    AddMonoidWithOne-toNatCast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddMonoidWithOne/toNatCast";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instOfNatNat";
    Nat-cast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat/cast";
    ZMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ZMod";
    Prod-fst.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod/fst";
    GovernanceInvariant-CID-digest.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GovernanceInvariant/CID/digest";
    iff_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/iff_self";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/And";
    Iff.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Iff";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    True.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/True";
    of_eq_true.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/of_eq_true";
    congrFun'.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrFun'";
    GovernanceInvariant-Block-contentHash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GovernanceInvariant/Block/contentHash";
    CommRing-toRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/CommRing/toRing";
    Prod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    Prod-snd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Prod/snd";
    Ring-toAddGroupWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ring/toAddGroupWithOne";
    Eq-trans.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/trans";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-GovernanceInvariant.congruent_iff";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp GovernanceInvariant/congruent_iff.lean $out/
        '';
      };
    };
}