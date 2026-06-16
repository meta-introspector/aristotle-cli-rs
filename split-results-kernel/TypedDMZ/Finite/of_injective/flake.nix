{
  description = "Lean declaration: Finite.of_injective";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Finite-of_equiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Finite/of_equiv";
    Equiv-instEquivLike.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Equiv/instEquivLike";
    Finite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Finite";
    Classical-propDecidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Classical/propDecidable";
    Function-comp.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Function/comp";
    Membership-mem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Membership/mem";
    Exists.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Exists";
    Subtype-fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Subtype/fintype";
    Set-Elem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Set/Elem";
    Equiv.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Equiv";
    Finite-of_fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Finite/of_fintype";
    Fin-fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/fintype";
    Equiv-ofInjective.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Equiv/ofInjective";
    Exists-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Exists/casesOn";
    Function-Injective-comp.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Function/Injective/comp";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    Nonempty-casesOn.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nonempty/casesOn";
    Finite-exists_equiv_fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Finite/exists_equiv_fin";
    Nonempty.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nonempty";
    Equiv-injective.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Equiv/injective";
    Set-range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Set/range";
    Function-Injective.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Function/Injective";
    Equiv-symm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Equiv/symm";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin";
    Set-instMembership.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Set/instMembership";
    DFunLike-coe.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/DFunLike/coe";
    EquivLike-toFunLike.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/EquivLike/toFunLike";
    Set.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Set";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Finite.of_injective";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Finite/of_injective.lean $out/
        '';
      };
    };
}