import Split.Semigroup
import Split.Monoid
import Split.Semigroup_toMul
import Split.One
import Split.HMul_hMul
import Split.instOfNatNat
import Split.autoParam
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.One_toOfNat1
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Monoid.mk from environment
-- constructor Monoid.mk : forall {M : Type.{u}} [toSemigroup : Semigroup.{u} M] [toOne : One.{u} M], (forall (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M toSemigroup)) (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M toOne)) a) a) -> (forall (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M toSemigroup)) a (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M toOne))) a) -> (forall (npow : Nat -> M -> M), (autoParam.{0} (forall (x : M), Eq.{succ u} M (npow (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x) (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M toOne))) Monoid.npow_zero._autoParam) -> (autoParam.{0} (forall (n : Nat) (x : M), Eq.{succ u} M (npow (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x) (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (Semigroup.toMul.{u} M toSemigroup)) (npow n x) x)) Monoid.npow_succ._autoParam) -> (Monoid.{u} M))

-- Stub: this file represents the declaration `Monoid.mk`.
-- In a full split, the body would be extracted from the environment.
