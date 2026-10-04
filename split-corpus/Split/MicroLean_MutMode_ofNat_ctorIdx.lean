import Mathlib

-- spec: theorem MicroLean.MutMode.ofNat_ctorIdx : forall (x : MicroLean.MutMode), Eq.{1} MicroLean.MutMode (MicroLean.MutMode.ofNat (MicroLean.MutMode.ctorIdx x)) x
theorem MicroLean.MutMode.ofNat_ctorIdx : forall (x : MicroLean.MutMode), Eq.{1} MicroLean.MutMode (MicroLean.MutMode.ofNat (MicroLean.MutMode.ctorIdx x)) x :=
  fun (x : MicroLean.MutMode) => MicroLean.MutMode.casesOn.{0} (fun (x : MicroLean.MutMode) => Eq.{1} MicroLean.MutMode (MicroLean.MutMode.ofNat (MicroLean.MutMode.ctorIdx x)) x) x (Eq.refl.{1} MicroLean.MutMode MicroLean.MutMode.borrowed) (Eq.refl.{1} MicroLean.MutMode MicroLean.MutMode.mutBorrow) (Eq.refl.{1} MicroLean.MutMode MicroLean.MutMode.owned)
