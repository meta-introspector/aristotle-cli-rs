import Split.HMul_hMul
import Split.congrArg
import Split.List_range'
import Split.GetElem_getElem_congr_simp
import Split.instMulNat
import Split.instOfNatNat
import Split.List_range
import Split.GetElem_getElem
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.List_range_eq_range'
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.Nat_zero_add
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.Nat_one_mul
import Split.List_getElem_range'
import Split.Eq_trans
import Split.instHMul

-- List.getElem_range from environment
-- theorem List.getElem_range : forall {j : Nat} {n : Nat} (h : LT.lt.{0} Nat instLTNat j (List.length.{0} Nat (List.range n))), Eq.{1} Nat (GetElem.getElem.{0, 0, 0} (List.{0} Nat) Nat Nat (fun (as : List.{0} Nat) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} Nat as)) (List.instGetElemNatLtLength.{0} Nat) (List.range n) j h) j

-- Stub: this file represents the declaration `List.getElem_range`.
-- In a full split, the body would be extracted from the environment.
