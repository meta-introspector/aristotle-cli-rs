import Split.PSigma_snd
import Split.Quot_liftIndepPr1
import Split.Quot_sound
import Split.Quot_lift
import Split.Quot_indep
import Split.Quot_indepCoherent
import Split.Eq_ndrec
import Split.Quot
import Split.PSigma_fst
import Split.Eq_ndrecOn
import Split.PSigma
import Split.Eq
import Split.Quot_mk

-- Quot.rec from environment
-- def Quot.rec : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (Quot.{u} α r) -> Sort.{v}} (f : forall (a : α), motive (Quot.mk.{u} α r a)), (forall (a : α) (b : α) (p : r a b), Eq.{v} (motive (Quot.mk.{u} α r b)) (Eq.ndrec.{v, u} (Quot.{u} α r) (Quot.mk.{u} α r a) motive (f a) (Quot.mk.{u} α r b) (Quot.sound.{u} α r a b p)) (f b)) -> (forall (q : Quot.{u} α r), motive q)
-- (definition body omitted)

-- Stub: this file represents the declaration `Quot.rec`.
-- In a full split, the body would be extracted from the environment.
