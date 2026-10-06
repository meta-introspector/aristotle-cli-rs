import Mathlib

set_option pp.all true
-- spec: SRewrite.fromThing : SRewrite -> Something
def SRewrite.fromThing : SRewrite -> Something :=
  fun (self : SRewrite) => self.1
