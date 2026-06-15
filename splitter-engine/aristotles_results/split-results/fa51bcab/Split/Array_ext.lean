import Split.congrArg
import Split.Array_casesOn
import Split.Array
import Split.GetElem_getElem
import Split.List
import Split.Array_instGetElemNatLtSize
import Split.Nat
import Split.LT_lt
import Split.Eq_ndrec
import Split.Eq_refl
import Split.instLTNat
import Split.Array_mk
import Split.Eq_symm
import Split.Eq
import Split.Array_size

-- Array.ext from environment
-- theorem Array.ext : forall {α : Type.{u}} {xs : Array.{u} α} {ys : Array.{u} α}, (Eq.{1} Nat (Array.size.{u} α xs) (Array.size.{u} α ys)) -> (forall (i : Nat) (hi₁ : LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (hi₂ : LT.lt.{0} Nat instLTNat i (Array.size.{u} α ys)), Eq.{succ u} α (GetElem.getElem.{u, 0, u} (Array.{u} α) Nat α (fun (xs : Array.{u} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (Array.instGetElemNatLtSize.{u} α) xs i hi₁) (GetElem.getElem.{u, 0, u} (Array.{u} α) Nat α (fun (xs : Array.{u} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (Array.instGetElemNatLtSize.{u} α) ys i hi₂)) -> (Eq.{succ u} (Array.{u} α) xs ys)

-- Stub: this file represents the declaration `Array.ext`.
-- In a full split, the body would be extracted from the environment.
