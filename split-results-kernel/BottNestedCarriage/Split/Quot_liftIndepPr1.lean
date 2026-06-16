import Split.Quot_sound
import Split.Quot_ind
import Split.Quot_lift
import Split.Quot_indep
import Split.Quot_indepCoherent
import Split.Eq_ndrec
import Split.Quot
import Split.PSigma_fst
import Split.PSigma
import Split.Eq
import Split.rfl
import Split.Quot_mk

-- Quot.liftIndepPr1 from environment
-- theorem Quot.liftIndepPr1 : forall {α : Sort.{u}} {r : α -> α -> Prop} {motive : (Quot.{u} α r) -> Sort.{v}} (f : forall (a : α), motive (Quot.mk.{u} α r a)) (h : forall (a : α) (b : α) (p : r a b), Eq.{v} (motive (Quot.mk.{u} α r b)) (Eq.ndrec.{v, u} (Quot.{u} α r) (Quot.mk.{u} α r a) motive (f a) (Quot.mk.{u} α r b) (Quot.sound.{u} α r a b p)) (f b)) (q : Quot.{u} α r), Eq.{u} (Quot.{u} α r) (PSigma.fst.{u, v} (Quot.{u} α r) motive (Quot.lift.{u, max (max 1 v) u} α r (PSigma.{u, v} (Quot.{u} α r) motive) (Quot.indep.{u, v} α r motive f) (Quot.indepCoherent.{u, v} α r motive f h) q)) q

-- Stub: this file represents the declaration `Quot.liftIndepPr1`.
-- In a full split, the body would be extracted from the environment.
