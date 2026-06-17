import Mathlib

-- spec: theorem MicroLean.calleeDec.eq_1 : forall (t : MicroLean.MicroLeanType), Eq.{1} Int (MicroLean.calleeDec (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned t)) (ite.{1} Int (Eq.{1} Bool (MicroLean.isBoxed t) Bool.true) (instDecidableEqBool (MicroLean.isBoxed t) Bool.true) (Neg.neg.{0} Int Int.instNegInt (OfNat.ofNat.{0} Int 1 (instOfNat 1))) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))
theorem MicroLean.calleeDec.eq_1 : forall (t : MicroLean.MicroLeanType), Eq.{1} Int (MicroLean.calleeDec (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned t)) (ite.{1} Int (Eq.{1} Bool (MicroLean.isBoxed t) Bool.true) (instDecidableEqBool (MicroLean.isBoxed t) Bool.true) (Neg.neg.{0} Int Int.instNegInt (OfNat.ofNat.{0} Int 1 (instOfNat 1))) (OfNat.ofNat.{0} Int 0 (instOfNat 0))) :=
  fun (t : MicroLean.MicroLeanType) => Eq.refl.{1} Int (MicroLean.calleeDec (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned t))
