import Mathlib

set_option pp.all true
-- spec: UInt8.IsUTF8FirstByte : UInt8 -> Prop
def UInt8.IsUTF8FirstByte : UInt8 -> Prop :=
  fun (c : UInt8) => Or (Eq.{1} UInt8 (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) c (OfNat.ofNat.{0} UInt8 128 (UInt8.instOfNat 128))) (OfNat.ofNat.{0} UInt8 0 (UInt8.instOfNat 0))) (Or (Eq.{1} UInt8 (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) c (OfNat.ofNat.{0} UInt8 224 (UInt8.instOfNat 224))) (OfNat.ofNat.{0} UInt8 192 (UInt8.instOfNat 192))) (Or (Eq.{1} UInt8 (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) c (OfNat.ofNat.{0} UInt8 240 (UInt8.instOfNat 240))) (OfNat.ofNat.{0} UInt8 224 (UInt8.instOfNat 224))) (Eq.{1} UInt8 (HAnd.hAnd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAndOfAndOp.{0} UInt8 instAndOpUInt8) c (OfNat.ofNat.{0} UInt8 248 (UInt8.instOfNat 248))) (OfNat.ofNat.{0} UInt8 240 (UInt8.instOfNat 240)))))
