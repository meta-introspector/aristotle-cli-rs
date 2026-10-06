import Mathlib

set_option pp.all true
-- spec: Std.Format.getIndent : Lean.Options -> Nat
def Std.Format.getIndent : Lean.Options -> Nat :=
  fun (o : Lean.Options) => Lean.Options.get Nat Lean.KVMap.instValueNat o (Lean.Name.mkStr2 "format" "indent") Std.Format.defIndent
