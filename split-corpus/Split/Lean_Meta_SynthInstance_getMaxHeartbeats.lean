import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.getMaxHeartbeats : Lean.Options -> Nat
def Lean.Meta.SynthInstance.getMaxHeartbeats : Lean.Options -> Nat :=
  fun (opts : Lean.Options) => HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Lean.Option.get Nat Lean.KVMap.instValueNat opts Lean.Meta.synthInstance.maxHeartbeats) (OfNat.ofNat.{0} Nat 1000 (instOfNatNat 1000))
