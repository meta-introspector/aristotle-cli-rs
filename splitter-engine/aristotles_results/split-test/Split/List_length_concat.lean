import Split.congrArg
import Split.List_concat
import Split.instOfNatNat
import Split.List_rec
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.Eq_trans
import Split.List_nil

-- List.length_concat from environment
-- theorem List.length_concat : forall {α : Type.{u}} {as : List.{u} α} {a : α}, Eq.{1} Nat (List.length.{u} α (List.concat.{u} α as a)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (List.length.{u} α as) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `List.length_concat`.
-- In a full split, the body would be extracted from the environment.
