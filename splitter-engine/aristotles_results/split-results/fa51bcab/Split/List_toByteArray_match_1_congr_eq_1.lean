import Split.List_toByteArray_match_1
import Split.id
import Split.List_cons
import Split.List
import Split.heq_of_eq
import Split.List_casesOn
import Split.Eq_ndrec
import Split.Eq_refl
import Split.HEq
import Split.ByteArray
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.List_nil

-- List.toByteArray.match_1.congr_eq_1 from environment
-- theorem List.toByteArray.match_1.congr_eq_1 : forall (motive : (List.{0} UInt8) -> ByteArray -> Sort.{u_1}) (x._@.Init.Prelude.4011339995._hygCtx.7.Init.Prelude.4011339995._hygCtx._hyg.30 : List.{0} UInt8) (x._@.Init.Prelude.4011339995._hygCtx.8.Init.Prelude.4011339995._hygCtx._hyg.33 : ByteArray) (h_1 : forall (r : ByteArray), motive (List.nil.{0} UInt8) r) (h_2 : forall (b : UInt8) (bs : List.{0} UInt8) (r : ByteArray), motive (List.cons.{0} UInt8 b bs) r) (r : ByteArray), (Eq.{1} (List.{0} UInt8) x._@.Init.Prelude.4011339995._hygCtx.7.Init.Prelude.4011339995._hygCtx._hyg.30 (List.nil.{0} UInt8)) -> (Eq.{1} ByteArray x._@.Init.Prelude.4011339995._hygCtx.8.Init.Prelude.4011339995._hygCtx._hyg.33 r) -> (HEq.{u_1} (motive x._@.Init.Prelude.4011339995._hygCtx.7.Init.Prelude.4011339995._hygCtx._hyg.30 x._@.Init.Prelude.4011339995._hygCtx.8.Init.Prelude.4011339995._hygCtx._hyg.33) (List.toByteArray.match_1.{u_1} motive x._@.Init.Prelude.4011339995._hygCtx.7.Init.Prelude.4011339995._hygCtx._hyg.30 x._@.Init.Prelude.4011339995._hygCtx.8.Init.Prelude.4011339995._hygCtx._hyg.33 h_1 h_2) (motive (List.nil.{0} UInt8) r) (h_1 r))

-- Stub: this file represents the declaration `List.toByteArray.match_1.congr_eq_1`.
-- In a full split, the body would be extracted from the environment.
