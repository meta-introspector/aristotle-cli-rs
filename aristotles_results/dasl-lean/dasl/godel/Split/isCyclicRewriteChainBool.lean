import Mathlib

set_option pp.all true
-- spec: isCyclicRewriteChainBool : Something -> (List.{0} SRewrite) -> Bool
def isCyclicRewriteChainBool : Something -> (List.{0} SRewrite) -> Bool :=
  fun (start : Something) (rs : List.{0} SRewrite) => isCyclicRewriteChainBool.match_1.{1} (fun (rs._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.10 : List.{0} SRewrite) (x._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.12 : Option.{0} SRewrite) => Bool) rs (List.getLast?.{0} SRewrite rs) (fun (head._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.28 : SRewrite) (tail._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.29 : List.{0} SRewrite) (last : SRewrite) => Bool.and (Bool.and (BEq.beq.{0} Something instBEqSomething (SRewrite.fromThing (List.head!.{0} SRewrite instInhabitedSRewrite rs)) start) (BEq.beq.{0} Something instBEqSomething (SRewrite.toThing last) start)) (isValidRewriteChainBool rs)) (fun (x._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.59 : List.{0} SRewrite) (x._@.RequestProject.MetaReflective.533495541._hygCtx._hyg.58 : Option.{0} SRewrite) => Bool.false)
