import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_size_append
import Split.GetElem
import Split.Decidable_casesOn
import Split.dite_congr
import Split.congrArg
import Split.Array_getElem_extract
import Split.Array_getElem_append
import Split.Classical_byContradiction
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.Decidable
import Split.Eq_rec
import Split.Eq_mp
import Split.dif_pos
import Split.id
import Split.instSubNat
import Split.dif_neg
import Split.Array_extract
import Split.dite
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
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
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.Eq_ndrec
import Split.Eq_mpr_not
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instDecidableEqNat
import Split.instLTNat
import Split.Eq_mpr_prop
import Split.Eq
import Split.Array_size
import Split.Not
import Split.HAppend_hAppend
import Split.Min_min
import Split.instMinNat
import Split.Eq_trans

-- Array.extract_append from environment
-- theorem Array.extract_append : forall {α : Type.{u_1}} {as : Array.{u_1} α} {bs : Array.{u_1} α} {i : Nat} {j : Nat}, Eq.{succ u_1} (Array.{u_1} α) (Array.extract.{u_1} α (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) as bs) i j) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) (Array.extract.{u_1} α as i j) (Array.extract.{u_1} α bs (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (Array.size.{u_1} α as)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) j (Array.size.{u_1} α as))))

-- Stub: this file represents the declaration `Array.extract_append`.
-- In a full split, the body would be extracted from the environment.
