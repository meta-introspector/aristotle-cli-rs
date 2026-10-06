import Mathlib

set_option pp.all true
-- spec: Bool.and : Bool -> Bool -> Bool
def Bool.and : Bool -> Bool -> Bool :=
  fun (x : Bool) (y : Bool) => Bool.and.match_1.{1} (fun (x._@.Init.Prelude.2579035302._hygCtx._hyg.8 : Bool) => Bool) x (fun (_ : Unit) => Bool.false) (fun (_ : Unit) => y)
