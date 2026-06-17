import Split.Iff_mpr
import Split.LE_le
import Split.instLENat
import Split.Array_extract
import Split.List_toArray
import Split.Array
import Split.Nat
import Split.Array_extract_eq_empty_iff
import Split.Eq
import Split.Array_size
import Split.Min_min
import Split.instMinNat
import Split.List_nil

-- Array.extract_eq_empty_of_le from environment
-- theorem Array.extract_eq_empty_of_le : forall {α : Type.{u_1}} {j : Nat} {i : Nat} {as : Array.{u_1} α}, (LE.le.{0} Nat instLENat (Min.min.{0} Nat instMinNat j (Array.size.{u_1} α as)) i) -> (Eq.{succ u_1} (Array.{u_1} α) (Array.extract.{u_1} α as i j) (List.toArray.{u_1} α (List.nil.{u_1} α)))

-- Stub: this file represents the declaration `Array.extract_eq_empty_of_le`.
-- In a full split, the body would be extracted from the environment.
