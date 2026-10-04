import Mathlib

-- spec: theorem Eigenspace.ofNat_ctorIdx : forall (x : Eigenspace), Eq.{1} Eigenspace (Eigenspace.ofNat (Eigenspace.ctorIdx x)) x
theorem Eigenspace.ofNat_ctorIdx : forall (x : Eigenspace), Eq.{1} Eigenspace (Eigenspace.ofNat (Eigenspace.ctorIdx x)) x :=
  fun (x : Eigenspace) => Eigenspace.casesOn.{0} (fun (x : Eigenspace) => Eq.{1} Eigenspace (Eigenspace.ofNat (Eigenspace.ctorIdx x)) x) x (Eq.refl.{1} Eigenspace Eigenspace.earth) (Eq.refl.{1} Eigenspace Eigenspace.spoke) (Eq.refl.{1} Eigenspace Eigenspace.hub) (Eq.refl.{1} Eigenspace Eigenspace.clock)
