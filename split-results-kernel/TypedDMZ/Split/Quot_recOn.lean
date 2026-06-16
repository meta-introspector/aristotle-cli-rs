import Split.Quot_sound
import Split.Quot_rec
import Split.Eq_ndrec
import Split.Quot
import Split.Eq
import Split.Quot_mk

-- Quot.recOn from environment
-- def Quot.recOn : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (Quot.{u} α r) -> Sort.{v}} (q : Quot.{u} α r) (f : forall (a : α), motive (Quot.mk.{u} α r a)), (forall (a : α) (b : α) (p : r a b), Eq.{v} (motive (Quot.mk.{u} α r b)) (Eq.ndrec.{v, u} (Quot.{u} α r) (Quot.mk.{u} α r a) motive (f a) (Quot.mk.{u} α r b) (Quot.sound.{u} α r a b p)) (f b)) -> (motive q)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quot.recOn`.
-- In a full split, the body would be extracted from the environment.
