import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.Eq_mp
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array_extract
import Split.Array_eq_empty_of_size_eq_zero
import Split.List_toArray
import Split.Array
import Split.Iff
import Split.List_size_toArray
import Split.instHSub
import Split.Array_size_extract
import Split.Nat
import Split.congr
import Split.Iff_intro
import Split.Decidable_byContradiction
import Split.congrFun'
import Split.instDecidableEqNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Nat_decLe
import Split.Min_min
import Split.instMinNat
import Split.List_nil

-- Array.extract_eq_empty_iff from environment
-- theorem Array.extract_eq_empty_iff : forall {α : Type.{u_1}} {i : Nat} {j : Nat} {as : Array.{u_1} α}, Iff (Eq.{succ u_1} (Array.{u_1} α) (Array.extract.{u_1} α as i j) (List.toArray.{u_1} α (List.nil.{u_1} α))) (LE.le.{0} Nat instLENat (Min.min.{0} Nat instMinNat j (Array.size.{u_1} α as)) i)

-- Stub: this file represents the declaration `Array.extract_eq_empty_iff`.
-- In a full split, the body would be extracted from the environment.
