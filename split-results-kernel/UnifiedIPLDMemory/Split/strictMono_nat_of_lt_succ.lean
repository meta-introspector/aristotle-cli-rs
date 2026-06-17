import Split.Preorder_toLT
import Split.StrictMono
import Split.instOfNatNat
import Split.instHAdd
import Split.instIsTransLt
import Split.HAdd_hAdd
import Split.Nat_instPreorder
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.Nat_rel_of_forall_rel_succ_of_lt
import Split.OfNat_ofNat
import Split.Preorder

-- strictMono_nat_of_lt_succ from environment
-- theorem strictMono_nat_of_lt_succ : forall {α : Type.{u}} [inst._@.Mathlib.Order.Monotone.Basic.3312072607._hygCtx._hyg.5 : Preorder.{u} α] {f : Nat -> α}, (forall (n : Nat), LT.lt.{u} α (Preorder.toLT.{u} α inst._@.Mathlib.Order.Monotone.Basic.3312072607._hygCtx._hyg.5) (f n) (f (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (StrictMono.{0, u} Nat α Nat.instPreorder inst._@.Mathlib.Order.Monotone.Basic.3312072607._hygCtx._hyg.5 f)

-- Stub: this file represents the declaration `strictMono_nat_of_lt_succ`.
-- In a full split, the body would be extracted from the environment.
