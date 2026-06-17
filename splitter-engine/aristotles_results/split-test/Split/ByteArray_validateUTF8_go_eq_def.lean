import Split.ByteArray_validateUTF8_go_match_1
import Split.UInt8_utf8ByteSize
import Split.id
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.LE_le
import Split.instLENat
import Split.dite
import Split.GetElem_getElem
import Split.Bool_true
import Split.instHAdd
import Split.ByteArray_validateUTF8_go
import Split.HAdd_hAdd
import Split.ByteArray_isUTF8FirstByte_of_validateUTF8At
import Split.Nat
import Split.LT_lt
import Split.PSigma_mk
import Split.Bool
import Split.Nat_decLt
import Split.instAddNat
import Split.instLTNat
import Split.ByteArray
import Split.ByteArray_validateUTF8At
import Split.Bool_false
import Split.UInt8
import Split.Eq
import Split.Not
import Split.ByteArray_size

-- ByteArray.validateUTF8.go.eq_def from environment
-- theorem ByteArray.validateUTF8.go.eq_def : forall (b : ByteArray) (i : Nat) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), Eq.{1} Bool (ByteArray.validateUTF8.go b i hi) (dite.{1} Bool (LT.lt.{0} Nat instLTNat i (ByteArray.size b)) (Nat.decLt i (ByteArray.size b)) (fun (hi : LT.lt.{0} Nat instLTNat i (ByteArray.size b)) => ByteArray.validateUTF8.go.match_1.{1} (fun (x._@.Init.Data.String.Basic.2757301087._hygCtx._hyg.38 : Bool) => Bool) (ByteArray.validateUTF8At b i) (fun (h : Eq.{1} Bool (ByteArray.validateUTF8At b i) Bool.false) => Bool.false) (fun (h : Eq.{1} Bool (ByteArray.validateUTF8At b i) Bool.true) => ByteArray.validateUTF8.go b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (UInt8.utf8ByteSize (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b i hi) (ByteArray.isUTF8FirstByte_of_validateUTF8At b i h))) (ByteArray.validateUTF8._proof_1 b i hi h))) (fun (hi : Not (LT.lt.{0} Nat instLTNat i (ByteArray.size b))) => Bool.true))

-- Stub: this file represents the declaration `ByteArray.validateUTF8.go.eq_def`.
-- In a full split, the body would be extracted from the environment.
