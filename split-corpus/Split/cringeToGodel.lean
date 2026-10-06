import Mathlib

set_option pp.all true
-- spec: cringeToGodel : SRewrite
def cringeToGodel : SRewrite :=
  SRewrite.mk Something.CringeState Something.SomeMagic (Option.none.{0} Something) Something.ThisGodelNumber
