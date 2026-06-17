import Mathlib

set_option pp.all true
-- spec: SRewrite.how : SRewrite -> Something
def SRewrite.how : SRewrite -> Something :=
  fun (self : SRewrite) => self.2
