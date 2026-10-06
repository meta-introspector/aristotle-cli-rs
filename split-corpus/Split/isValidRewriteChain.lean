import Mathlib

set_option pp.all true
-- spec: isValidRewriteChain : (List.{0} SRewrite) -> Prop
def isValidRewriteChain : (List.{0} SRewrite) -> Prop :=
  fun (rs : List.{0} SRewrite) => Eq.{1} Bool (isValidRewriteChainBool rs) Bool.true
