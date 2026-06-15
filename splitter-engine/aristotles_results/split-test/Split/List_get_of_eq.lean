import Split.HEq_refl
import Split.List_get
import Split.Fin_isLt
import Split.Eq_rec
import Split.Fin_mk
import Split.Eq_casesOn
import Split.Fin_val
import Split.List
import Split.Nat
import Split.LT_lt
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.Eq_refl
import Split.HEq
import Split.instLTNat
import Split.Eq_symm
import Split.Fin
import Split.Eq
import Split.List_length

-- List.get_of_eq from environment
-- theorem List.get_of_eq : forall {α : Type.{u_1}} {l : List.{u_1} α} {l' : List.{u_1} α} (h : Eq.{succ u_1} (List.{u_1} α) l l') (i : Fin (List.length.{u_1} α l)), Eq.{succ u_1} α (List.get.{u_1} α l i) (List.get.{u_1} α l' (Fin.mk (List.length.{u_1} α l') (Fin.val (List.length.{u_1} α l) i) (Eq.rec.{0, succ u_1} (List.{u_1} α) l (fun (x._@.Init.Data.List.Lemmas.353677392._hygCtx._hyg.29 : List.{u_1} α) (h._@.Init.Data.List.Lemmas.353677392._hygCtx._hyg.30 : Eq.{succ u_1} (List.{u_1} α) l x._@.Init.Data.List.Lemmas.353677392._hygCtx._hyg.29) => LT.lt.{0} Nat instLTNat (Fin.val (List.length.{u_1} α l) i) (List.length.{u_1} α x._@.Init.Data.List.Lemmas.353677392._hygCtx._hyg.29)) (Fin.isLt (List.length.{u_1} α l) i) l' h)))

-- Stub: this file represents the declaration `List.get_of_eq`.
-- In a full split, the body would be extracted from the environment.
