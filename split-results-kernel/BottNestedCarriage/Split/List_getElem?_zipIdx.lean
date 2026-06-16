import Split.List_brecOn
import Split.Eq_mpr
import Split.congrArg
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.id
import Split.Prod_mk
import Split.instOfNatNat
import Split.List_cons
import Split.List_length_zipIdx
import Split.List
import Split.instHAdd
import Split.Option_map
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.List_below
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.Prod
import Split.OfNat_ofNat
import Split.List_zipIdx
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_instLawfulGetElemNatLtLength
import Split.rfl
import Split.Eq_trans
import Split.Nat_add_right_comm
import Split.List_nil
import Split.Option

-- List.getElem?_zipIdx from environment
-- theorem List.getElem?_zipIdx : forall {α : Type.{u_1}} {l : List.{u_1} α} {i : Nat} {j : Nat}, Eq.{succ u_1} (Option.{u_1} (Prod.{u_1, 0} α Nat)) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} (Prod.{u_1, 0} α Nat)) Nat (Prod.{u_1, 0} α Nat) (fun (as : List.{u_1} (Prod.{u_1, 0} α Nat)) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} (Prod.{u_1, 0} α Nat) as)) (List.instGetElem?NatLtLength.{u_1} (Prod.{u_1, 0} α Nat)) (List.zipIdx.{u_1} α l i) j) (Option.map.{u_1, u_1} α (Prod.{u_1, 0} α Nat) (fun (a : α) => Prod.mk.{u_1, 0} α Nat a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i j)) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l j))

-- Stub: this file represents the declaration `List.getElem?_zipIdx`.
-- In a full split, the body would be extracted from the environment.
