import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.Mul
import Split.AddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.NonUnitalNonAssocSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocSemiring.mk from environment
-- constructor NonUnitalNonAssocSemiring.mk : forall {α : Type.{u}} [toAddCommMonoid : AddCommMonoid.{u} α] [toMul : Mul.{u} α], (forall (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid)))) b c)) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid)))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a c))) -> (forall (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid)))) a b) c) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid)))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a c) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) b c))) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid)))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid))))) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α toMul) a (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid))))) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (AddCommMonoid.toAddMonoid.{u} α toAddCommMonoid))))) -> (NonUnitalNonAssocSemiring.{u} α)

-- Stub: this file represents the declaration `NonUnitalNonAssocSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
