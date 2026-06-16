import Split.LE_le_eq_or_lt
import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Eq_rec
import Split.instOfNatNat
import Split.Std_Refl
import Split.LE_le
import Split.IsTrans
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instPartialOrder
import Split.Nat_rel_of_forall_rel_succ_of_le_of_lt
import Split.instAddNat
import Split.Or_elim
import Split.OfNat_ofNat
import Split.refl
import Split.Eq

-- Nat.rel_of_forall_rel_succ_of_le_of_le from environment
-- theorem Nat.rel_of_forall_rel_succ_of_le_of_le : forall {β : Type.{v}} (r : β -> β -> Prop) [inst._@.Mathlib.Order.Monotone.Basic.2152230632._hygCtx._hyg.13 : Std.Refl.{succ v} β r] [inst._@.Mathlib.Order.Monotone.Basic.2152230632._hygCtx._hyg.16 : IsTrans.{succ v} β r] {f : Nat -> β} {a : Nat}, (forall (n : Nat), (LE.le.{0} Nat instLENat a n) -> (r (f n) (f (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))) -> (forall {{b : Nat}} {{c : Nat}}, (LE.le.{0} Nat instLENat a b) -> (LE.le.{0} Nat instLENat b c) -> (r (f b) (f c)))

-- Stub: this file represents the declaration `Nat.rel_of_forall_rel_succ_of_le_of_le`.
-- In a full split, the body would be extracted from the environment.
