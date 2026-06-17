import Split.Iff_mpr
import Split.List_instGetElem?NatLtLength
import Split.LE_le
import Split.instLENat
import Split.Option_none
import Split.List
import Split.Nat
import Split.LT_lt
import Split.List_getElem?_eq_none_iff
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.Eq
import Split.List_length
import Split.Option

-- List.getElem?_eq_none from environment
-- theorem List.getElem?_eq_none : forall {α._@.Init.GetElem.4238100475._hygCtx._hyg.27 : Type.{u_1}} {l : List.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27} {i : Nat}, (LE.le.{0} Nat instLENat (List.length.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27 l) i) -> (Eq.{succ u_1} (Option.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27) Nat α._@.Init.GetElem.4238100475._hygCtx._hyg.27 (fun (as : List.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27 as)) (List.instGetElem?NatLtLength.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27) l i) (Option.none.{u_1} α._@.Init.GetElem.4238100475._hygCtx._hyg.27))

-- Stub: this file represents the declaration `List.getElem?_eq_none`.
-- In a full split, the body would be extracted from the environment.
