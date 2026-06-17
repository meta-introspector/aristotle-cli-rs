import Mathlib

set_option pp.all true
-- spec: SRewrite.toThing : SRewrite -> Something
def SRewrite.toThing : SRewrite -> Something :=
  fun (self : SRewrite) => self.4
