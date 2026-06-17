import Mathlib

set_option pp.all true
-- spec: aristotleTypescriptToOrderBook : SRewrite
def aristotleTypescriptToOrderBook : SRewrite :=
  SRewrite.mk Something.SomeTypescriptClient Something.SomeLLMQuery (Option.some.{0} Something Something.AristotleByHarmonic) Something.OrderBookState
