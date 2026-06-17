import Mathlib

set_option pp.all true
-- spec: typescriptStep : SRewrite
def typescriptStep : SRewrite :=
  SRewrite.mk Something.SomeTypescriptClient Something.SomeLLMQuery (Option.some.{0} Something Something.ThatLLModel) Something.SomeTypescriptClient
