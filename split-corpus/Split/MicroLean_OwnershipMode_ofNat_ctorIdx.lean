import Mathlib

-- spec: theorem MicroLean.OwnershipMode.ofNat_ctorIdx : forall (x : MicroLean.OwnershipMode), Eq.{1} MicroLean.OwnershipMode (MicroLean.OwnershipMode.ofNat (MicroLean.OwnershipMode.ctorIdx x)) x
theorem MicroLean.OwnershipMode.ofNat_ctorIdx : forall (x : MicroLean.OwnershipMode), Eq.{1} MicroLean.OwnershipMode (MicroLean.OwnershipMode.ofNat (MicroLean.OwnershipMode.ctorIdx x)) x :=
  fun (x : MicroLean.OwnershipMode) => MicroLean.OwnershipMode.casesOn.{0} (fun (x : MicroLean.OwnershipMode) => Eq.{1} MicroLean.OwnershipMode (MicroLean.OwnershipMode.ofNat (MicroLean.OwnershipMode.ctorIdx x)) x) x (Eq.refl.{1} MicroLean.OwnershipMode MicroLean.OwnershipMode.borrowed) (Eq.refl.{1} MicroLean.OwnershipMode MicroLean.OwnershipMode.owned)
