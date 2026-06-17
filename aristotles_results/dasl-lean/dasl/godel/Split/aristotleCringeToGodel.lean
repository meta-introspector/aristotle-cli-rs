import Mathlib

set_option pp.all true
-- spec: aristotleCringeToGodel : SRewrite
def aristotleCringeToGodel : SRewrite :=
  SRewrite.mk Something.CringeState Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.ThisGodelNumber
