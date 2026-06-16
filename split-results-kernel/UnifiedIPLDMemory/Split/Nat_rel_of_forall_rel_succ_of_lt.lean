import Split.le_rfl
import Split.instOfNatNat
import Split.LE_le
import Split.IsTrans
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instPreorder
import Split.Nat
import Split.LT_lt
import Split.Nat_rel_of_forall_rel_succ_of_le_of_lt
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat

-- Nat.rel_of_forall_rel_succ_of_lt from environment
-- theorem Nat.rel_of_forall_rel_succ_of_lt : forall {β : Type.{v}} (r : β -> β -> Prop) [inst._@.Mathlib.Order.Monotone.Basic.1816240938._hygCtx._hyg.13 : IsTrans.{succ v} β r] {f : Nat -> β}, (forall (n : Nat), r (f n) (f (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (forall {{a : Nat}} {{b : Nat}}, (LT.lt.{0} Nat instLTNat a b) -> (r (f a) (f b)))

-- Stub: this file represents the declaration `Nat.rel_of_forall_rel_succ_of_lt`.
-- In a full split, the body would be extracted from the environment.
