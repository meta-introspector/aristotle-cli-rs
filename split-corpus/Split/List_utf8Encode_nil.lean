import Mathlib

-- spec: theorem List.utf8Encode_nil : Eq.{1} ByteArray (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty
theorem List.utf8Encode_nil : Eq.{1} ByteArray (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty :=
  of_eq_true (Eq.{1} ByteArray (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty) (Eq.trans.{1} Prop (Eq.{1} ByteArray (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty) (Eq.{1} ByteArray ByteArray.empty ByteArray.empty) True (congrFun'.{1, 1} ByteArray Prop (Eq.{1} ByteArray (List.utf8Encode (List.nil.{0} Char))) (Eq.{1} ByteArray ByteArray.empty) (congrArg.{1, 1} ByteArray (ByteArray -> Prop) (List.utf8Encode (List.nil.{0} Char)) ByteArray.empty (Eq.{1} ByteArray) (congrArg.{1, 1} (List.{0} UInt8) ByteArray (List.flatMap.{0, 0} Char UInt8 String.utf8EncodeChar (List.nil.{0} Char)) (List.nil.{0} UInt8) List.toByteArray (List.flatMap_nil.{0, 0} Char UInt8 String.utf8EncodeChar))) ByteArray.empty) (eq_self.{1} ByteArray ByteArray.empty))
