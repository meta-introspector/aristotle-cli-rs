import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.Prod_mk
import Split.instOfNatNat
import Split.List_rec
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.eq_self
import Split.Nat_add_assoc
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.List_instAppend
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.List_zipIdx
import Split.Eq
import Split.List_length
import Split.List_length_eq_2
import Split.List_cons_append
import Split.HAppend_hAppend
import Split.Nat_add_right_comm
import Split.List_zipIdx_cons

-- List.zipIdx_append from environment
-- theorem List.zipIdx_append : forall {α : Type.{u_1}} {xs : List.{u_1} α} {ys : List.{u_1} α} {k : Nat}, Eq.{succ u_1} (List.{u_1} (Prod.{u_1, 0} α Nat)) (List.zipIdx.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) xs ys) k) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} α Nat)) (List.{u_1} (Prod.{u_1, 0} α Nat)) (List.{u_1} (Prod.{u_1, 0} α Nat)) (instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} α Nat)) (List.instAppend.{u_1} (Prod.{u_1, 0} α Nat))) (List.zipIdx.{u_1} α xs k) (List.zipIdx.{u_1} α ys (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k (List.length.{u_1} α xs))))

-- Stub: this file represents the declaration `List.zipIdx_append`.
-- In a full split, the body would be extracted from the environment.
