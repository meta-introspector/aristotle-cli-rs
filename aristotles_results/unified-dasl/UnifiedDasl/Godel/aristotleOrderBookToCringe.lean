import Mathlib

set_option pp.all true
-- spec: aristotleOrderBookToCringe : SRewrite
def aristotleOrderBookToCringe : SRewrite :=
  SRewrite.mk Something.OrderBookState Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.CringeState
