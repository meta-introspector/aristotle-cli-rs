import Split.Exists
import Split.Exists_intro
import Split.Exists_rec

-- Exists.casesOn from environment
-- def Exists.casesOn : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop} (t : Exists.{u} α p), (forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Exists.casesOn`.
-- In a full split, the body would be extracted from the environment.
