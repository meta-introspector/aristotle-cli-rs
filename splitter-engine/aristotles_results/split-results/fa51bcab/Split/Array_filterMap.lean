import Split.Pure_pure
import Split.Monad_toApplicative
import Split.Array_filterMapM
import Split.instOfNatNat
import Split.Id_run
import Split.Id
import Split.Applicative_toPure
import Split.Array
import Split.Nat
import Split.Id_instMonad
import Split.optParam
import Split.OfNat_ofNat
import Split.Array_size
import Split.Option

-- Array.filterMap from environment
-- def Array.filterMap : forall {α : Type.{u}} {β : Type.{u_1}}, (α -> (Option.{u_1} β)) -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> (Array.{u_1} β))
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.filterMap`.
-- In a full split, the body would be extracted from the environment.
