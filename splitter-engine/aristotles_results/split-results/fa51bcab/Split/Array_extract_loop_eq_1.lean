import Split.Array_push
import Split.instOfNatNat
import Split.dite
import Split.Array
import Split.instHAdd
import Split.Unit
import Split.Array_extract_loop_eq_def
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Array_getInternal
import Split.Array_extract_loop
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Eq_trans
import Split.Array_appendCore_loop_match_1

-- Array.extract.loop.eq_1 from environment
-- theorem Array.extract.loop.eq_1 : forall {α : Type.{u_1}} (as : Array.{u_1} α) (i : Nat) (j : Nat) (bs : Array.{u_1} α), Eq.{succ u_1} (Array.{u_1} α) (Array.extract.loop.{u_1} α as i j bs) (dite.{succ u_1} (Array.{u_1} α) (LT.lt.{0} Nat instLTNat j (Array.size.{u_1} α as)) (Nat.decLt j (Array.size.{u_1} α as)) (fun (hlt : LT.lt.{0} Nat instLTNat j (Array.size.{u_1} α as)) => Array.appendCore.loop.match_1.{succ u_1} (fun (i._@.Init.Prelude.1895423239._hygCtx._hyg.35 : Nat) => Array.{u_1} α) i (fun (_ : Unit) => bs) (fun (i' : Nat) => Array.extract.loop.{u_1} α as i' (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) j (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Array.push.{u_1} α bs (Array.getInternal.{u_1} α as j hlt)))) (fun (x._@.Init.Prelude.1895423239._hygCtx._hyg.65 : Not (LT.lt.{0} Nat instLTNat j (Array.size.{u_1} α as))) => bs))

-- Stub: this file represents the declaration `Array.extract.loop.eq_1`.
-- In a full split, the body would be extracted from the environment.
