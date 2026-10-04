import Mathlib

-- spec: theorem String.toByteArray_append : forall {s : String} {t : String}, Eq.{1} ByteArray (String.toByteArray (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t)) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (String.toByteArray s) (String.toByteArray t))
theorem String.toByteArray_append : forall {s : String} {t : String}, Eq.{1} ByteArray (String.toByteArray (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t)) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (String.toByteArray s) (String.toByteArray t)) :=
  fun {s : String} {t : String} => rfl.{1} ByteArray (String.toByteArray (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t))
