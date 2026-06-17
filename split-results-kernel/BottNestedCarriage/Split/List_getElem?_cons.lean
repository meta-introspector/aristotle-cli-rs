import Split.False
import Split.outParam
import Split.congrArg
import Split.False_elim
import Split.HSub_hSub
import Split.List_instGetElem?NatLtLength
import Split.noConfusion_of_Nat
import Split.Option_some
import Split.instSubNat
import Split.instOfNatNat
import Split.ite_cond_eq_true
import Split.List_cons
import Split.Nat_casesAuxOn
import Split.List
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.getElem?_pos
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Nat_ctorIdx
import Split.instAddNat
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.instLTNat
import Split.GetElem?_getElem?
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.ite_cond_eq_false
import Split.eq_false'
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.List_instLawfulGetElemNatLtLength
import Split.Eq_trans
import Split.Option
import Split.ite

-- List.getElem?_cons from environment
-- theorem List.getElem?_cons : forall {α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 : outParam.{succ (succ u_1)} Type.{u_1}} {a : α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72} {l : List.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72} {i : Nat}, Eq.{succ u_1} (Option.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) Nat α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 (fun (as : List.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 as)) (List.instGetElem?NatLtLength.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) (List.cons.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 a l) i) (ite.{succ u_1} (Option.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) (Eq.{1} Nat i (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat i (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 a) (GetElem?.getElem?.{u_1, 0, u_1} (List.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) Nat α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 (fun (as : List.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72 as)) (List.instGetElem?NatLtLength.{u_1} α._@.Init.Data.List.Lemmas.4277965859._hygCtx._hyg.72) l (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `List.getElem?_cons`.
-- In a full split, the body would be extracted from the environment.
