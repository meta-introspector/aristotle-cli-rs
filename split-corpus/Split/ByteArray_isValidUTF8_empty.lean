import Mathlib

-- spec: theorem ByteArray.isValidUTF8_empty : ByteArray.IsValidUTF8 ByteArray.empty
theorem ByteArray.isValidUTF8_empty : ByteArray.IsValidUTF8 ByteArray.empty :=
  ByteArray.IsValidUTF8.intro ByteArray.empty (List.nil.{0} Char) (of_eq_true (Eq.{1} ByteArray ByteArray.empty (List.utf8Encode (List.nil.{0} Char))) (Eq.trans.{1} Prop (Eq.{1} ByteArray ByteArray.empty (List.utf8Encode (List.nil.{0} Char))) (Eq.{1} ByteArray ByteArray.empty ByteArray.empty) True (congrArg.{1, 1} ByteArray Prop (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty (Eq.{1} ByteArray ByteArray.empty) List.utf8Encode_nil) (eq_self.{1} ByteArray ByteArray.empty)))
