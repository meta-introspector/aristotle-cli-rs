import Split.Array
import Split.GetElem_getElem
import Split.Array_instGetElemNatLtSize
import Split.USize_toNat
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.Array_size
import Split.USize

-- Array.uget from environment
-- def Array.uget : forall {α : Type.{u}} (xs : [mdata borrowed:1 Array.{u} α]) (i : USize), (LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) -> α
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.uget`.
-- In a full split, the body would be extracted from the environment.
