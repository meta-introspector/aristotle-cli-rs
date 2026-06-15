import Split.Eq_mpr
import Split.List_data_toByteArray
import Split.congrArg
import Split.ByteArray_extract
import Split.Array_getElem_extract
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.Eq_mp
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.LE_le
import Split.instLENat
import Split.List_toByteArray
import Split.Array_extract
import Split.List_toArray
import Split.List_cons
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.List_size_toArray
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Array_size_extract
import Split.Array_ext
import Split.Nat
import Split.ByteArray_data
import Split.Array_getElem_extract_aux
import Split.congr
import Split.LT_lt
import Split.ByteArray_data_extract
import Split.Decidable_byContradiction
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.instLTNat
import Split.ByteArray
import Split.Nat_zero_add
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.Not
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_ext
import Split.ByteArray_size
import Split.Eq_trans
import Split.List_nil

-- ByteArray.extract_add_one from environment
-- theorem ByteArray.extract_add_one : forall {a : ByteArray} {i : Nat} (ha : LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (ByteArray.size a)), Eq.{1} ByteArray (ByteArray.extract a i (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (List.toByteArray (List.cons.{0} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a i ha) (List.nil.{0} UInt8)))

-- Stub: this file represents the declaration `ByteArray.extract_add_one`.
-- In a full split, the body would be extracted from the environment.
