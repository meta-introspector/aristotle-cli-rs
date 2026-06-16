{
  description = "Lean declaration: UmweltGodelTrust.instDecidableEqTrustArchitecture.decEq.match_1";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UmweltGodelTrust-TrustArchitecture-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/TrustArchitecture/mk";
    UmweltGodelTrust-TrustArchitecture-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/TrustArchitecture/casesOn";
    Bool.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Bool";
    UmweltGodelTrust-TrustArchitecture.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/UmweltGodelTrust/TrustArchitecture";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UmweltGodelTrust.instDecidableEqTrustArchitecture.decEq.match_1";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UmweltGodelTrust/instDecidableEqTrustArchitecture/decEq/match_1.lean $out/
        '';
      };
    };
}