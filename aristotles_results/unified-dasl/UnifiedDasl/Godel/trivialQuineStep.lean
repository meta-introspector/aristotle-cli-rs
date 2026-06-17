import Mathlib

set_option pp.all true
-- spec: trivialQuineStep : SRewrite
def trivialQuineStep : SRewrite :=
  SRewrite.mk Something.ThisQuine Something.SomeMagic (Option.none.{0} Something) Something.ThisQuine
