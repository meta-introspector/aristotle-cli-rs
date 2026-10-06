import Mathlib

set_option pp.all true
-- spec: aristotleQuineToGccAst : SRewrite
def aristotleQuineToGccAst : SRewrite :=
  SRewrite.mk Something.ThisQuine Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.GccAst
