import Mathlib

set_option pp.all true
-- spec: isCyclicRewriteChain : Something -> (List.{0} SRewrite) -> Prop
def isCyclicRewriteChain : Something -> (List.{0} SRewrite) -> Prop :=
  fun (start : Something) (rs : List.{0} SRewrite) => Eq.{1} Bool (isCyclicRewriteChainBool start rs) Bool.true
