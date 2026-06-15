import Split.List_brecOn
import Split.Eq_mpr
import Split.List_toByteArray_match_1_congr_eq_2
import Split.congrArg
import Split.ByteArray_push
import Split.List_toByteArray_match_1
import Split.List_toByteArray_loop
import Split.id
import Split.List_toByteArray_loop_eq_def
import Split.List_cons
import Split.List
import Split.List_toByteArray_match_1_congr_eq_1
import Split.eq_of_heq
import Split.List_below
import Split.Eq_refl
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.List_nil

-- List.toByteArray.loop.induct_unfolding from environment
-- theorem List.toByteArray.loop.induct_unfolding : forall (motive : (List.{0} UInt8) -> ByteArray -> ByteArray -> Prop), (forall (r : ByteArray), motive (List.nil.{0} UInt8) r r) -> (forall (b : UInt8) (bs : List.{0} UInt8) (r : ByteArray), (motive bs (ByteArray.push r b) (List.toByteArray.loop bs (ByteArray.push r b))) -> (motive (List.cons.{0} UInt8 b bs) r (List.toByteArray.loop bs (ByteArray.push r b)))) -> (forall (x._@.Init.Prelude.4011339995._hygCtx._hyg.7 : List.{0} UInt8) (x._@.Init.Prelude.4011339995._hygCtx._hyg.8 : ByteArray), motive x._@.Init.Prelude.4011339995._hygCtx._hyg.7 x._@.Init.Prelude.4011339995._hygCtx._hyg.8 (List.toByteArray.loop x._@.Init.Prelude.4011339995._hygCtx._hyg.7 x._@.Init.Prelude.4011339995._hygCtx._hyg.8))

-- Stub: this file represents the declaration `List.toByteArray.loop.induct_unfolding`.
-- In a full split, the body would be extracted from the environment.
