import Split.Eq_mpr
import Split.ByteArray_extract_add_one
import Split.congrArg
import Split.ByteArray_extract
import Split.id
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.LE_le
import Split.instLENat
import Split.List_toByteArray
import Split.List_cons
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.instLTNat
import Split.ByteArray
import Split.ByteArray_extract_eq_extract_append_extract
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.Not
import Split.ByteArray_extract_add_three
import Split.HAppend_hAppend
import Split.Nat_decLe
import Split.ByteArray_size
import Split.List_nil

-- ByteArray.extract_add_four from environment
-- theorem ByteArray.extract_add_four : forall {a : ByteArray} {i : Nat} (ha : LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4))) (ByteArray.size a)), Eq.{1} ByteArray (ByteArray.extract a i (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)))) (List.toByteArray (List.cons.{0} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a i (ByteArray.extract_add_four._proof_2 a i ha)) (List.cons.{0} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (ByteArray.extract_add_four._proof_4 a i ha)) (List.cons.{0} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (ByteArray.extract_add_four._proof_6 a i ha)) (List.cons.{0} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3))) ha) (List.nil.{0} UInt8))))))

-- Stub: this file represents the declaration `ByteArray.extract_add_four`.
-- In a full split, the body would be extracted from the environment.
