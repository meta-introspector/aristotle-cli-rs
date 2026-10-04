import Mathlib

-- spec: opaque System.Platform.getNumBits : Unit -> (Subtype.{1} Nat (fun (n : Nat) => Or (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))))
opaque System.Platform.getNumBits : Unit -> (Subtype.{1} Nat (fun (n : Nat) => Or (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))))) :=
  fun (x._@.Init.Prelude.588690023._hygCtx._hyg.21 : Unit) => Subtype.mk.{1} Nat (fun (n : Nat) => Or (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))) (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) _private.Init.Prelude.0.System.Platform.getNumBits._proof_1
