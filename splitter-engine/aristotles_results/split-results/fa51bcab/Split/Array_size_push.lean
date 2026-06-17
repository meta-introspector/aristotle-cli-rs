import Split.Array_push
import Split.instOfNatNat
import Split.Array_toList
import Split.Array
import Split.instHAdd
import Split.List_length_concat
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size

-- Array.size_push from environment
-- theorem Array.size_push : forall {α : Type.{u}} {xs : Array.{u} α} (v : α), Eq.{1} Nat (Array.size.{u} α (Array.push.{u} α xs v)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `Array.size_push`.
-- In a full split, the body would be extracted from the environment.
