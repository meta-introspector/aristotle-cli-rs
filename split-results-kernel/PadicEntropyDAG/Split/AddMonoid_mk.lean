import Split.instOfNatNat
import Split.AddSemigroup
import Split.autoParam
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.AddMonoid
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.Zero

-- AddMonoid.mk from environment
-- constructor AddMonoid.mk : forall {M : Type.{u}} [toAddSemigroup : AddSemigroup.{u} M] [toZero : Zero.{u} M], (forall (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M toAddSemigroup)) (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M toZero)) a) a) -> (forall (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M toAddSemigroup)) a (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M toZero))) a) -> (forall (nsmul : Nat -> M -> M), (autoParam.{0} (forall (x : M), Eq.{succ u} M (nsmul (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x) (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M toZero))) AddMonoid.nsmul_zero._autoParam) -> (autoParam.{0} (forall (n : Nat) (x : M), Eq.{succ u} M (nsmul (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M toAddSemigroup)) (nsmul n x) x)) AddMonoid.nsmul_succ._autoParam) -> (AddMonoid.{u} M))

-- Stub: this file represents the declaration `AddMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
