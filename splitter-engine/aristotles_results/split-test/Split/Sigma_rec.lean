import Split.Sigma_mk
import Split.Sigma

-- Sigma.rec from environment
-- recursor Sigma.rec : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Sigma.{u, v} α β) -> Sort.{u_1}}, (forall (fst : α) (snd : β fst), motive (Sigma.mk.{u, v} α β fst snd)) -> (forall (t : Sigma.{u, v} α β), motive t)

-- Stub: this file represents the declaration `Sigma.rec`.
-- In a full split, the body would be extracted from the environment.
