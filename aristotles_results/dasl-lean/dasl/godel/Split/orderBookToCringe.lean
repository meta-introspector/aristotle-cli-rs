import Mathlib

set_option pp.all true
-- spec: orderBookToCringe : SRewrite
def orderBookToCringe : SRewrite :=
  SRewrite.mk Something.OrderBookState Something.SomeMagic (Option.none.{0} Something) Something.CringeState
