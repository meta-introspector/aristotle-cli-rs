import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.insertIfNew : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> (forall (a : α), (β a) -> (Std.DTreeMap.{u, v} α β cmp))
def Std.DTreeMap.insertIfNew : forall {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering}, (Std.DTreeMap.{u, v} α β cmp) -> (forall (a : α), (β a) -> (Std.DTreeMap.{u, v} α β cmp)) :=
  fun {α : Type.{u}} {β : α -> Type.{v}} {cmp : α -> α -> Ordering} (t : Std.DTreeMap.{u, v} α β cmp) (a : α) (b : β a) => Std.DTreeMap.mk.{u, v} α β cmp (Std.DTreeMap.Internal.Impl.SizedBalancedTree.impl.{u, v} α β (Std.DTreeMap.Internal.Impl.size.{u, v} α β (Std.DTreeMap.inner.{u, v} α β cmp t)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.DTreeMap.Internal.Impl.size.{u, v} α β (Std.DTreeMap.inner.{u, v} α β cmp t)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Std.DTreeMap.Internal.Impl.insertIfNew.{u, v} α β (Ord.mk.{u} α cmp) a b (Std.DTreeMap.inner.{u, v} α β cmp t) (Std.DTreeMap.insert._proof_1.{u, v} α β cmp t))) (Std.DTreeMap.insertIfNew._proof_1.{u, v} α β cmp t a b)
