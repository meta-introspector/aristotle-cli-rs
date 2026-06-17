import Split.HMul_hMul
import Split.congrArg
import Split.List_range'
import Split.List_length_range'
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Exists
import Split.List_getElem?_eq_some_iff
import Split.Eq_mp
import Split.instMulNat
import Split.GetElem_getElem
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Iff_mp
import Split.instAddNat
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.List_instGetElemNatLtLength
import Split.Eq
import Split.List_length
import Split.List_getElem?_range'
import Split.instHMul
import Split.Option

-- List.getElem_range' from environment
-- theorem List.getElem_range' : forall {n : Nat} {m : Nat} {step : Nat} {i : Nat} (H : LT.lt.{0} Nat instLTNat i (List.length.{0} Nat (List.range' n m step))), Eq.{1} Nat (GetElem.getElem.{0, 0, 0} (List.{0} Nat) Nat Nat (fun (as : List.{0} Nat) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} Nat as)) (List.instGetElemNatLtLength.{0} Nat) (List.range' n m step) i H) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) step i))

-- Stub: this file represents the declaration `List.getElem_range'`.
-- In a full split, the body would be extracted from the environment.
