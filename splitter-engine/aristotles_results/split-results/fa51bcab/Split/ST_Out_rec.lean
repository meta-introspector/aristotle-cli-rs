import Split.ST_Out_mk
import Split.Void
import Split.ST_Out

-- ST.Out.rec from environment
-- recursor ST.Out.rec : forall {σ : Type} {α : Type} {motive : (ST.Out σ α) -> Sort.{u}}, (forall (val : α) (state : Void σ), motive (ST.Out.mk σ α val state)) -> (forall (t : ST.Out σ α), motive t)

-- Stub: this file represents the declaration `ST.Out.rec`.
-- In a full split, the body would be extracted from the environment.
