import Split.Exists
import Split.Exists_intro

-- Exists.rec from environment
-- recursor Exists.rec : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop}, (forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) -> (forall (t : Exists.{u} α p), motive t)

-- Stub: this file represents the declaration `Exists.rec`.
-- In a full split, the body would be extracted from the environment.
