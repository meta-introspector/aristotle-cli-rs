import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Membership_mem
import Split.Exists
import Split.List_getElem?_eq_some_iff
import Split.Eq_rec
import Split.GetElem_getElem
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.List_getElem_mem
import Split.LT_lt
import Split.Iff_mp
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Eq
import Split.List_length
import Split.Option

-- List.mem_of_getElem? from environment
-- theorem List.mem_of_getElem? : forall {α : Type.{u_1}} {l : List.{u_1} α} {i : Nat} {a : α}, (Eq.{succ u_1} (Option.{u_1} α) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElem?NatLtLength.{u_1} α) l i) (Option.some.{u_1} α a)) -> (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) l a)

-- Stub: this file represents the declaration `List.mem_of_getElem?`.
-- In a full split, the body would be extracted from the environment.
