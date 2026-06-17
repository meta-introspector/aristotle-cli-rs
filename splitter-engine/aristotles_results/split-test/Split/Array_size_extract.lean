import Split.Eq_mpr
import Split.Nat_sub_min_sub_right
import Split.congrArg
import Split.Array_size_empty
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.Nat_min_self
import Split.Array_extract
import Split.Nat_min_assoc
import Split.List_toArray
import Split.Array
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.Array_extract_loop
import Split.instAddNat
import Split.Eq_refl
import Split.Array_size_extract_loop
import Split.Nat_zero_add
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size
import Split.Min_min
import Split.instMinNat
import Split.List_nil

-- Array.size_extract from environment
-- theorem Array.size_extract : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {start : Nat} {stop : Nat}, Eq.{1} Nat (Array.size.{u_1} α (Array.extract.{u_1} α xs start stop)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Min.min.{0} Nat instMinNat stop (Array.size.{u_1} α xs)) start)

-- Stub: this file represents the declaration `Array.size_extract`.
-- In a full split, the body would be extracted from the environment.
