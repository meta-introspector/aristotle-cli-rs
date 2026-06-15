import Split.Eq_mpr
import Split.congrArg
import Split.Array_getElem_extract
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.Array_extract
import Split.Nat_min_assoc
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Array_size_extract
import Split.Array_ext
import Split.Nat
import Split.Array_getElem_extract_aux
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Decidable_byContradiction
import Split.Nat_add_assoc
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instDecidableEqNat
import Split.instLTNat
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Min_min
import Split.instMinNat
import Split.Eq_trans

-- Array.extract_extract from environment
-- theorem Array.extract_extract : forall {α : Type.{u_1}} {as : Array.{u_1} α} {i : Nat} {j : Nat} {k : Nat} {l : Nat}, Eq.{succ u_1} (Array.{u_1} α) (Array.extract.{u_1} α (Array.extract.{u_1} α as i j) k l) (Array.extract.{u_1} α as (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i k) (Min.min.{0} Nat instMinNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i l) j))

-- Stub: this file represents the declaration `Array.extract_extract`.
-- In a full split, the body would be extracted from the environment.
