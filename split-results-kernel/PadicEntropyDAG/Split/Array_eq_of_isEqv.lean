import Split.Array_isEqv
import Split.Exists
import Split.Eq_rec
import Split.Eq_mp
import Split.Array
import Split.GetElem_getElem
import Split.Bool_true
import Split.Array_instGetElemNatLtSize
import Split.Array_ext
import Split.Nat
import Split.LT_lt
import Split.Bool
import Split.decide_eq_true_eq
import Split.instLTNat
import Split.Decidable_decide
import Split.Eq
import Split.Array_size
import Split.DecidableEq

-- Array.eq_of_isEqv from environment
-- theorem Array.eq_of_isEqv : forall {α : Type.{u_1}} [inst._@.Init.Data.Array.DecidableEq.1737215852._hygCtx._hyg.5 : DecidableEq.{succ u_1} α] (xs : Array.{u_1} α) (ys : Array.{u_1} α), (Eq.{1} Bool (Array.isEqv.{u_1} α xs ys (fun (x : α) (y : α) => Decidable.decide (Eq.{succ u_1} α x y) (inst._@.Init.Data.Array.DecidableEq.1737215852._hygCtx._hyg.5 x y))) Bool.true) -> (Eq.{succ u_1} (Array.{u_1} α) xs ys)

-- Stub: this file represents the declaration `Array.eq_of_isEqv`.
-- In a full split, the body would be extracted from the environment.
