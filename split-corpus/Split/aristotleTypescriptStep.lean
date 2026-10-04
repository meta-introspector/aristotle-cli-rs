import Mathlib

set_option pp.all true
-- spec: aristotleTypescriptStep : SRewrite
def aristotleTypescriptStep : SRewrite :=
  SRewrite.mk Something.SomeTypescriptClient Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.SomeTypescriptClient
