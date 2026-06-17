import Split.Eq_mpr
import Split.congrArg
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Eq_mp
import Split.Option_get_congr_simp
import Split.id
import Split.Prod_mk
import Split.List_length_zipIdx
import Split.GetElem_getElem
import Split.List_getElem?_zipIdx
import Split.Bool_true
import Split.List
import Split.instHAdd
import Split.Option_map
import Split.List_getElem?_eq_getElem
import Split.Option_get
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.eq_self
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.congrFun'
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.Prod
import Split.Option_isSome
import Split.List_instGetElemNatLtLength
import Split.List_zipIdx
import Split.List_getElem_eq_getElem?_get
import Split.Eq
import Split.List_length
import Split.Eq_trans
import Split.Option

-- List.getElem_zipIdx from environment
-- theorem List.getElem_zipIdx : forall {α : Type.{u_1}} {i : Nat} {j : Nat} {l : List.{u_1} α} (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} (Prod.{u_1, 0} α Nat) (List.zipIdx.{u_1} α l j))), Eq.{succ u_1} (Prod.{u_1, 0} α Nat) (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} (Prod.{u_1, 0} α Nat)) Nat (Prod.{u_1, 0} α Nat) (fun (as : List.{u_1} (Prod.{u_1, 0} α Nat)) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} (Prod.{u_1, 0} α Nat) as)) (List.instGetElemNatLtLength.{u_1} (Prod.{u_1, 0} α Nat)) (List.zipIdx.{u_1} α l j) i h) (Prod.mk.{u_1, 0} α Nat (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l i (List.getElem_zipIdx._proof_1.{u_1} α i j l h)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) j i))

-- Stub: this file represents the declaration `List.getElem_zipIdx`.
-- In a full split, the body would be extracted from the environment.
