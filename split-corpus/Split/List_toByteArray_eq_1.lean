import Mathlib

-- spec: theorem List.toByteArray.eq_1 : forall (bs : List.{0} UInt8), Eq.{1} ByteArray (List.toByteArray bs) (List.toByteArray.loop bs ByteArray.empty)
theorem List.toByteArray.eq_1 : forall (bs : List.{0} UInt8), Eq.{1} ByteArray (List.toByteArray bs) (List.toByteArray.loop bs ByteArray.empty) :=
  fun (bs : List.{0} UInt8) => Eq.refl.{1} ByteArray (List.toByteArray bs)
