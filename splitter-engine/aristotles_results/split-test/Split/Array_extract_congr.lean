import Split.Array_extract
import Split.Array
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- Array.extract_congr from environment
-- theorem Array.extract_congr : forall {α : Type.{u_1}} {start : Nat} {start' : Nat} {stop : Nat} {stop' : Nat} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, (Eq.{succ u_1} (Array.{u_1} α) xs ys) -> (Eq.{1} Nat start start') -> (Eq.{1} Nat stop stop') -> (Eq.{succ u_1} (Array.{u_1} α) (Array.extract.{u_1} α xs start stop) (Array.extract.{u_1} α ys start' stop'))

-- Stub: this file represents the declaration `Array.extract_congr`.
-- In a full split, the body would be extracted from the environment.
