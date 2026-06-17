import Split.Nat_succ_lt_succ_iff
import Split.HMul_hMul
import Split.congrArg
import Split.List_range'
import Split.List_length_range'
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.Nat_brecOn
import Split.id
import Split.instMulNat
import Split.instOfNatNat
import Split.List_cons
import Split.Nat_below
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Iff_mp
import Split.Nat_add_assoc
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_instLawfulGetElemNatLtLength
import Split.Eq_trans
import Split.instHMul
import Split.Option
import Split.Nat_add_comm

-- List.getElem?_range' from environment
-- theorem List.getElem?_range' : forall {s : Nat} {step : Nat} {i : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat i n) -> (Eq.{1} (Option.{0} Nat) (GetElem?.getElem?.{0, 0, 0} (List.{0} Nat) Nat Nat (fun (as : List.{0} Nat) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} Nat as)) (List.instGetElem?NatLtLength.{0} Nat) (List.range' s n step) i) (Option.some.{0} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) s (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) step i))))

-- Stub: this file represents the declaration `List.getElem?_range'`.
-- In a full split, the body would be extracted from the environment.
