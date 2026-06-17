import Mathlib

set_option pp.all true
-- spec: aristotleGodelToQuine : SRewrite
def aristotleGodelToQuine : SRewrite :=
  SRewrite.mk Something.ThisGodelNumber Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.ThisQuine
