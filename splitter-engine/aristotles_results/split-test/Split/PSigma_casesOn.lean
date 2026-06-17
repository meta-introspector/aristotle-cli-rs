import Split.PSigma_rec
import Split.PSigma_mk
import Split.PSigma

-- PSigma.casesOn from environment
-- def PSigma.casesOn : forall {α : Sort.{u}} {β : α -> Sort.{v}} {motive : (PSigma.{u, v} α β) -> Sort.{u_1}} (t : PSigma.{u, v} α β), (forall (fst : α) (snd : β fst), motive (PSigma.mk.{u, v} α β fst snd)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `PSigma.casesOn`.
-- In a full split, the body would be extracted from the environment.
