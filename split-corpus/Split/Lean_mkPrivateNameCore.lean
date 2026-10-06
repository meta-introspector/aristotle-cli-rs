import Mathlib

set_option pp.all true
-- spec: Lean.mkPrivateNameCore : Lean.Name -> Lean.Name -> Lean.Name
def Lean.mkPrivateNameCore : Lean.Name -> Lean.Name -> Lean.Name :=
  fun (mainModule : Lean.Name) (n : Lean.Name) => HAppend.hAppend.{0, 0, 0} Lean.Name Lean.Name Lean.Name (instHAppendOfAppend.{0} Lean.Name Lean.instAppendName) (Lean.Name.mkNum (HAppend.hAppend.{0, 0, 0} Lean.Name Lean.Name Lean.Name (instHAppendOfAppend.{0} Lean.Name Lean.instAppendName) Lean.privateHeader mainModule) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) n
