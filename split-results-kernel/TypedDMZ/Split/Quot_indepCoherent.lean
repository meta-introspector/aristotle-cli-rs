import Split.Quot_sound
import Split.PSigma_eta
import Split.Quot_indep
import Split.Eq_ndrec
import Split.Quot
import Split.PSigma
import Split.Eq
import Split.Quot_mk

-- Quot.indepCoherent from environment
-- theorem Quot.indepCoherent : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (Quot.{u} α r) -> Sort.{v}} (f : forall (a : α), motive (Quot.mk.{u} α r a)), (forall (a : α) (b : α) (p : r a b), Eq.{v} (motive (Quot.mk.{u} α r b)) (Eq.ndrec.{v, u} (Quot.{u} α r) (Quot.mk.{u} α r a) motive (f a) (Quot.mk.{u} α r b) (Quot.sound.{u} α r a b p)) (f b)) -> (forall (a : α) (b : α), (r a b) -> (Eq.{max (max 1 u) v} (PSigma.{u, v} (Quot.{u} α r) motive) (Quot.indep.{u, v} α r motive f a) (Quot.indep.{u, v} α r motive f b)))

-- Stub: this file represents the declaration `Quot.indepCoherent`.
-- In a full split, the body would be extracted from the environment.
