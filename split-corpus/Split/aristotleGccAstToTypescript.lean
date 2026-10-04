import Mathlib

set_option pp.all true
-- spec: aristotleGccAstToTypescript : SRewrite
def aristotleGccAstToTypescript : SRewrite :=
  SRewrite.mk Something.GccAst Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.SomeTypescriptClient
