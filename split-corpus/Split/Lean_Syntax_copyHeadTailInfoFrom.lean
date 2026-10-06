import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.copyHeadTailInfoFrom : Lean.Syntax -> Lean.Syntax -> Lean.Syntax
def Lean.Syntax.copyHeadTailInfoFrom : Lean.Syntax -> Lean.Syntax -> Lean.Syntax :=
  fun (target : Lean.Syntax) (source : Lean.Syntax) => Lean.Syntax.setTailInfo (Lean.Syntax.setHeadInfo target (Lean.Syntax.getHeadInfo source)) (Lean.Syntax.getTailInfo source)
