import Split.List_mem_of_getElem?
import Split.List_instGetElem?NatLtLength
import Split.Option_some
import Split.List_TFAE
import Split.autoParam
import Split.List
import Split.Iff
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.Eq
import Split.List_length
import Split.Option

-- List.TFAE.out from environment
-- theorem List.TFAE.out : forall {l : List.{0} Prop}, (List.TFAE l) -> (forall (n₁ : Nat) (n₂ : Nat) {a : Prop} {b : Prop}, (autoParam.{0} (Eq.{1} (Option.{0} Prop) (GetElem?.getElem?.{0, 0, 0} (List.{0} Prop) Nat Prop (fun (as : List.{0} Prop) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} Prop as)) (List.instGetElem?NatLtLength.{0} Prop) l n₁) (Option.some.{0} Prop a)) List.TFAE.out._auto_1) -> (autoParam.{0} (Eq.{1} (Option.{0} Prop) (GetElem?.getElem?.{0, 0, 0} (List.{0} Prop) Nat Prop (fun (as : List.{0} Prop) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} Prop as)) (List.instGetElem?NatLtLength.{0} Prop) l n₂) (Option.some.{0} Prop b)) List.TFAE.out._auto_3) -> (Iff a b))

-- Stub: this file represents the declaration `List.TFAE.out`.
-- In a full split, the body would be extracted from the environment.
