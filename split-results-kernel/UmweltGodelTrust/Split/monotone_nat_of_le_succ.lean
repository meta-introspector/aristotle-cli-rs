import Split.Nat_rel_of_forall_rel_succ_of_le
import Split.instReflLe
import Split.Monotone
import Split.Preorder_toLE
import Split.instOfNatNat
import Split.LE_le
import Split.instIsTransLe
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instPreorder
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Preorder

-- monotone_nat_of_le_succ from environment
-- theorem monotone_nat_of_le_succ : forall {α : Type.{u}} [inst._@.Mathlib.Order.Monotone.Basic.1296635774._hygCtx._hyg.5 : Preorder.{u} α] {f : Nat -> α}, (forall (n : Nat), LE.le.{u} α (Preorder.toLE.{u} α inst._@.Mathlib.Order.Monotone.Basic.1296635774._hygCtx._hyg.5) (f n) (f (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (Monotone.{0, u} Nat α Nat.instPreorder inst._@.Mathlib.Order.Monotone.Basic.1296635774._hygCtx._hyg.5 f)

-- Stub: this file represents the declaration `monotone_nat_of_le_succ`.
-- In a full split, the body would be extracted from the environment.
