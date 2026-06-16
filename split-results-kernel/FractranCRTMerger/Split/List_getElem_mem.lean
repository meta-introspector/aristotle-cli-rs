import Split.List_brecOn
import Split.List_Mem_tail
import Split.Membership_mem
import Split.instOfNatNat
import Split.List_cons
import Split.GetElem_getElem
import Split.List
import Split.instHAdd
import Split.List_instMembership
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.List_Mem_head
import Split.instAddNat
import Split.List_below
import Split.instLTNat
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.List_length

-- List.getElem_mem from environment
-- theorem List.getElem_mem : forall {α : Type.{u_1}} {l : List.{u_1} α} {n : Nat} (h : LT.lt.{0} Nat instLTNat n (List.length.{u_1} α l)), Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l n h)

-- Stub: this file represents the declaration `List.getElem_mem`.
-- In a full split, the body would be extracted from the environment.
