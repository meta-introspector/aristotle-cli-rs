import Split.Pure_pure
import Split.Monad_toApplicative
import Split.instOfNatNat
import Split.Id_run
import Split.Id
import Split.Applicative_toPure
import Split.Array
import Split.Array_foldlM
import Split.Nat
import Split.Id_instMonad
import Split.optParam
import Split.OfNat_ofNat
import Split.Array_size

-- Array.foldl from environment
-- def Array.foldl : forall {α : Type.{u}} {β : Type.{v}}, (β -> α -> β) -> β -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> β)
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.foldl`.
-- In a full split, the body would be extracted from the environment.
