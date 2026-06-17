import Mathlib

set_option pp.all true
-- spec: godelToQuine : SRewrite
def godelToQuine : SRewrite :=
  SRewrite.mk Something.ThisGodelNumber Something.SomeMagic (Option.none.{0} Something) Something.ThisQuine
