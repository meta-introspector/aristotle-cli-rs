import Split.Nat_brecOn
import Split.Bool_and
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.GetElem_getElem
import Split.Nat_below
import Split.Bool_true
import Split.instHAdd
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Bool
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Array_size

-- Array.isEqvAux from environment
-- def Array.isEqvAux : forall {α : Type.{u}} (xs : Array.{u} α) (ys : Array.{u} α), (Eq.{1} Nat (Array.size.{u} α xs) (Array.size.{u} α ys)) -> (α -> α -> Bool) -> (forall (i : Nat), (LE.le.{0} Nat instLENat i (Array.size.{u} α xs)) -> Bool)
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.isEqvAux`.
-- In a full split, the body would be extracted from the environment.
