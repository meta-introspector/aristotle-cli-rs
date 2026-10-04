import Mathlib

set_option pp.all true
-- spec: Bool.dcond : forall {α : Sort.{u}} (c : Bool), ((Eq.{1} Bool c Bool.true) -> α) -> ((Eq.{1} Bool c Bool.false) -> α) -> α
def Bool.dcond : forall {α : Sort.{u}} (c : Bool), ((Eq.{1} Bool c Bool.true) -> α) -> ((Eq.{1} Bool c Bool.false) -> α) -> α :=
  fun {α : Sort.{u}} (c : Bool) (x : (Eq.{1} Bool c Bool.true) -> α) (y : (Eq.{1} Bool c Bool.false) -> α) => Bool.dcond.match_1.{u, u} α (fun (c._@.Init.Prelude.2255054822._hygCtx._hyg.18 : Bool) (x : (Eq.{1} Bool c._@.Init.Prelude.2255054822._hygCtx._hyg.18 Bool.true) -> α) (y : (Eq.{1} Bool c._@.Init.Prelude.2255054822._hygCtx._hyg.18 Bool.false) -> α) => α) c x y (fun (x : (Eq.{1} Bool Bool.true Bool.true) -> α) (y : (Eq.{1} Bool Bool.true Bool.false) -> α) => x (rfl.{1} Bool Bool.true)) (fun (x : (Eq.{1} Bool Bool.false Bool.true) -> α) (y : (Eq.{1} Bool Bool.false Bool.false) -> α) => y (rfl.{1} Bool Bool.false))
