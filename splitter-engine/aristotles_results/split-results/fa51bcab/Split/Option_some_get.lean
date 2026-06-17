import Split.Option_some
import Split.Bool_true
import Split.Option_get
import Split.Bool
import Split.Option_isSome
import Split.Eq
import Split.rfl
import Split.Option

-- Option.some_get from environment
-- theorem Option.some_get : forall {α : Type.{u_1}} {x : Option.{u_1} α} (h : Eq.{1} Bool (Option.isSome.{u_1} α x) Bool.true), Eq.{succ u_1} (Option.{u_1} α) (Option.some.{u_1} α (Option.get.{u_1} α x h)) x

-- Stub: this file represents the declaration `Option.some_get`.
-- In a full split, the body would be extracted from the environment.
