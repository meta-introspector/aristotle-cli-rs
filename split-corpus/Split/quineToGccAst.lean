import Mathlib

set_option pp.all true
-- spec: quineToGccAst : SRewrite
def quineToGccAst : SRewrite :=
  SRewrite.mk Something.ThisQuine Something.SomeLLMQuery (Option.some.{0} Something Something.ThatLLModel) Something.GccAst
