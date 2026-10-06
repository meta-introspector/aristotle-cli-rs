import Mathlib

-- spec: theorem AristotleWeaver.Core.layoutClean_const : forall (f : Nat), Eq.{1} Bool (AristotleWeaver.Core.layoutClean f) (AristotleWeaver.Core.layoutClean (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
theorem AristotleWeaver.Core.layoutClean_const : forall (f : Nat), Eq.{1} Bool (AristotleWeaver.Core.layoutClean f) (AristotleWeaver.Core.layoutClean (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) :=
  fun (f : Nat) => rfl.{1} Bool (AristotleWeaver.Core.layoutClean f)
