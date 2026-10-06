import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.ofFormat : Std.Format -> Lean.MessageData
def Lean.MessageData.ofFormat : Std.Format -> Lean.MessageData :=
  fun (fmt : Std.Format) => Lean.MessageData.ofFormatWithInfos (Lean.FormatWithInfos.mk fmt (Std.TreeMap.empty.{0, 0} Nat Lean.Elab.Info (Ord.compare.{0} Nat instOrdNat)))
