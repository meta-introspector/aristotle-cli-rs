import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.Mul
import Split.AddCommGroup_toAddGroup
import Split.AddCommGroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocRing.mk from environment
-- constructor NonUnitalNonAssocRing.mk : forall {α : Type.{u}} [toAddCommGroup : AddCommGroup.{u} α] [toMul : Mul.{u} α], (forall (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup)))))) b c)) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup)))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a c))) -> (forall (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup)))))) a b) c) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup)))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a c) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) b c))) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup)))))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup))))))) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup))))))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α toAddCommGroup))))))) -> (NonUnitalNonAssocRing.{u} α)

-- Stub: this file represents the declaration `NonUnitalNonAssocRing.mk`.
-- In a full split, the body would be extracted from the environment.
