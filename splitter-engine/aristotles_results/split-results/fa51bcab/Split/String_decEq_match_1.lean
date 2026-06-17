import Split.ByteArray_mk
import Split.HEq_refl
import Split.Eq_casesOn
import Split.List
import Split.eq_of_heq
import Split.Eq_ndrec
import Split.Eq_refl
import Split.HEq
import Split.Array_mk
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.ByteArray_IsValidUTF8

-- String.decEq.match_1 from environment
-- def String.decEq.match_1 : forall (motive : forall (s₁._@.Init.Prelude.18944143._hygCtx._hyg.65 : List.{0} UInt8) (s₂._@.Init.Prelude.18944143._hygCtx._hyg.67 : List.{0} UInt8), (Eq.{1} (List.{0} UInt8) s₁._@.Init.Prelude.18944143._hygCtx._hyg.65 s₂._@.Init.Prelude.18944143._hygCtx._hyg.67) -> (ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₁._@.Init.Prelude.18944143._hygCtx._hyg.65))) -> (ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₂._@.Init.Prelude.18944143._hygCtx._hyg.67))) -> Sort.{u_1}) (s₁._@.Init.Prelude.18944143._hygCtx._hyg.65 : List.{0} UInt8) (s₂._@.Init.Prelude.18944143._hygCtx._hyg.67 : List.{0} UInt8) (h._@.Init.Prelude.18944143._hygCtx._hyg.69 : Eq.{1} (List.{0} UInt8) s₁._@.Init.Prelude.18944143._hygCtx._hyg.65 s₂._@.Init.Prelude.18944143._hygCtx._hyg.67) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₁._@.Init.Prelude.18944143._hygCtx._hyg.65))) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₂._@.Init.Prelude.18944143._hygCtx._hyg.67))), (forall (a._@.Init.Prelude.18944143._hygCtx._hyg.87 : List.{0} UInt8) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 a._@.Init.Prelude.18944143._hygCtx._hyg.87))) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 a._@.Init.Prelude.18944143._hygCtx._hyg.87))), motive a._@.Init.Prelude.18944143._hygCtx._hyg.87 ([mdata _inaccessible:1 a._@.Init.Prelude.18944143._hygCtx._hyg.87]) (Eq.refl.{1} (List.{0} UInt8) a._@.Init.Prelude.18944143._hygCtx._hyg.87) isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48 isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47) -> (motive s₁._@.Init.Prelude.18944143._hygCtx._hyg.65 s₂._@.Init.Prelude.18944143._hygCtx._hyg.67 h._@.Init.Prelude.18944143._hygCtx._hyg.69 isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48 isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.decEq.match_1`.
-- In a full split, the body would be extracted from the environment.
