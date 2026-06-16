import Split.Eq_mpr
import Split.GetElem?_toGetElem
import Split.congrArg
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Eq_mp
import Split.id
import Split.LE_le
import Split.instLENat
import Split.List_getElem?_eq_none
import Split.dite
import Split.GetElem_getElem
import Split.forall_prop_domain_congr
import Split.Option_none
import Split.List
import Split.List_ext_getElem?
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Eq_substr
import Split.eq_true
import Split.of_eq_true
import Split.Nat_decLt
import Split.Eq_refl
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Eq_symm
import Split.Eq
import Split.List_length
import Split.Not
import Split.Nat_le_of_not_lt
import Split.List_instLawfulGetElemNatLtLength
import Split.Eq_trans
import Split.Option
import Split.forall_congr

-- List.ext_getElem from environment
-- theorem List.ext_getElem : forall {α : Type.{u_1}} {l₁ : List.{u_1} α} {l₂ : List.{u_1} α}, (Eq.{1} Nat (List.length.{u_1} α l₁) (List.length.{u_1} α l₂)) -> (forall (i : Nat) (h₁ : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l₁)) (h₂ : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α l₂)), Eq.{succ u_1} α (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l₁ i h₁) (GetElem.getElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (List.instGetElemNatLtLength.{u_1} α) l₂ i h₂)) -> (Eq.{succ u_1} (List.{u_1} α) l₁ l₂)

-- Stub: this file represents the declaration `List.ext_getElem`.
-- In a full split, the body would be extracted from the environment.
