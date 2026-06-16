{
  description = "Lean declaration: LawfulGetElem.getElem?_def";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    GetElem?.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GetElem?";
    GetElem?-toGetElem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GetElem?/toGetElem";
    outParam.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/outParam";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable";
    Option-some.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Option/some";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/dite";
    GetElem-getElem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GetElem/getElem";
    Option-none.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Option/none";
    GetElem?-getElem?.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/GetElem?/getElem?";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Not";
    Option.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Option";
    LawfulGetElem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LawfulGetElem";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-LawfulGetElem.getElem?_def";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp LawfulGetElem/getElem?_def.lean $out/
        '';
      };
    };
}