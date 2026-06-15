import Split.PSigma_mk
import Split.PSigma

-- PSigma.rec from environment
-- recursor PSigma.rec : forall {α : Sort.{u}} {β : α -> Sort.{v}} {motive : (PSigma.{u, v} α β) -> Sort.{u_1}}, (forall (fst : α) (snd : β fst), motive (PSigma.mk.{u, v} α β fst snd)) -> (forall (t : PSigma.{u, v} α β), motive t)

-- Stub: this file represents the declaration `PSigma.rec`.
-- In a full split, the body would be extracted from the environment.
