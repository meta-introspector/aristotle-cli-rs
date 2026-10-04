import Mathlib

set_option pp.all true
-- spec: ByteArray.casesOn : forall {motive : ByteArray -> Sort.{u}} (t : ByteArray), (forall (data : Array.{0} UInt8), motive (ByteArray.mk data)) -> (motive t)
def ByteArray.casesOn : forall {motive : ByteArray -> Sort.{u}} (t : ByteArray), (forall (data : Array.{0} UInt8), motive (ByteArray.mk data)) -> (motive t) :=
  fun {motive : ByteArray -> Sort.{u}} (t : ByteArray) (mk : forall (data : Array.{0} UInt8), motive (ByteArray.mk data)) => ByteArray.rec.{u} motive (fun (data : Array.{0} UInt8) => mk data) t
