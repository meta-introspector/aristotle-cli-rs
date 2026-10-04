import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.set : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Nat -> α -> (Lean.PersistentArray.{u} α)
def Lean.PersistentArray.set : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Nat -> α -> (Lean.PersistentArray.{u} α) :=
  fun {α : Type.{u}} (t : Lean.PersistentArray.{u} α) (i : Nat) (a : α) => ite.{succ u} (Lean.PersistentArray.{u} α) (GE.ge.{0} Nat instLENat i (Lean.PersistentArray.tailOff.{u} α t)) (Nat.decLe (Lean.PersistentArray.tailOff.{u} α t) i) (Lean.PersistentArray.mk.{u} α (Lean.PersistentArray.root.{u} α t) (Array.set!.{u} α (Lean.PersistentArray.tail.{u} α t) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (Lean.PersistentArray.tailOff.{u} α t)) a) (Lean.PersistentArray.size.{u} α t) (Lean.PersistentArray.shift.{u} α t) (Lean.PersistentArray.tailOff.{u} α t)) (Lean.PersistentArray.mk.{u} α (Lean.PersistentArray.setAux.{u} α (Lean.PersistentArray.root.{u} α t) (USize.ofNat i) (Lean.PersistentArray.shift.{u} α t) a) (Lean.PersistentArray.tail.{u} α t) (Lean.PersistentArray.size.{u} α t) (Lean.PersistentArray.shift.{u} α t) (Lean.PersistentArray.tailOff.{u} α t))
