import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length

-- List.length.eq_2 from environment
-- theorem List.length.eq_2 : forall {α : Type.{u_1}} (head : α) (tail : List.{u_1} α), Eq.{1} Nat (List.length.{u_1} α (List.cons.{u_1} α head tail)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (List.length.{u_1} α tail) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `List.length.eq_2`.
-- In a full split, the body would be extracted from the environment.
