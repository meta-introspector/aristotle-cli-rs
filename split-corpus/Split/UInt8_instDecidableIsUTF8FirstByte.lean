import Mathlib

set_option pp.all true
-- spec: UInt8.instDecidableIsUTF8FirstByte : forall {c : UInt8}, Decidable (UInt8.IsUTF8FirstByte c)
def UInt8.instDecidableIsUTF8FirstByte : forall {c : UInt8}, Decidable (UInt8.IsUTF8FirstByte c) :=
  fun {c : UInt8} => UInt8.instDecidableIsUTF8FirstByte._aux_1 c
