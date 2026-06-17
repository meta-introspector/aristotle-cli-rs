import Mathlib

set_option pp.all true
-- spec: gccAstToTypescript : SRewrite
def gccAstToTypescript : SRewrite :=
  SRewrite.mk Something.GccAst Something.SomeLLMQuery (Option.some.{0} Something Something.ThatLLModel) Something.SomeTypescriptClient
