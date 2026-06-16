{
  description = "Lean declaration: Nat.instTrivialStar";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    TrivialStar-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/TrivialStar/mk";
    Nat-instStarRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/instStarRing";
    StarAddMonoid-toInvolutiveStar.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarAddMonoid/toInvolutiveStar";
    NonUnitalNonAssocSemiring-toAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalNonAssocSemiring/toAddCommMonoid";
    StarRing-toStarAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarRing/toStarAddMonoid";
    Nat-instNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/instNonUnitalNonAssocSemiring";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat";
    TrivialStar.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/TrivialStar";
    InvolutiveStar-toStar.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/InvolutiveStar/toStar";
    AddCommMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddCommMonoid/toAddMonoid";
    rfl.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/rfl";
    Star-star.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Star/star";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.instTrivialStar";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/instTrivialStar.lean $out/
        '';
      };
    };
}