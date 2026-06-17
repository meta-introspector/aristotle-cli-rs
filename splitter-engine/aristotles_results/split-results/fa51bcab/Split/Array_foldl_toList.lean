import Split.Pure_pure
import Split.List_foldl_eq_foldlM
import Split.List_foldlM
import Split.Monad_toApplicative
import Split.Eq_rec
import Split.instOfNatNat
import Split.List_foldl
import Split.Id_run
import Split.Id
import Split.Applicative_toPure
import Split.Array_toList
import Split.Array_foldl
import Split.Array
import Split.Array_foldlM_toList
import Split.Nat
import Split.Id_instMonad
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Array_size

-- Array.foldl_toList from environment
-- theorem Array.foldl_toList : forall {β : Type.{u_1}} {α : Type.{u_2}} (f : β -> α -> β) {init : β} {xs : Array.{u_2} α}, Eq.{succ u_1} β (List.foldl.{u_1, u_2} β α f init (Array.toList.{u_2} α xs)) (Array.foldl.{u_2, u_1} α β f init xs (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u_2} α xs))

-- Stub: this file represents the declaration `Array.foldl_toList`.
-- In a full split, the body would be extracted from the environment.
