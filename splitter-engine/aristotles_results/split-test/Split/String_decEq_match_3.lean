import Split.ByteArray_mk
import Split.String
import Split.ByteArray_casesOn
import Split.Array_casesOn
import Split.Array
import Split.List
import Split.String_casesOn
import Split.ByteArray
import Split.Array_mk
import Split.UInt8
import Split.String_ofByteArray
import Split.ByteArray_IsValidUTF8

-- String.decEq.match_3 from environment
-- def String.decEq.match_3 : forall (motive : String -> String -> Sort.{u_1}) (s₁._@.Init.Prelude.18944143._hygCtx._hyg.16 : String) (s₂._@.Init.Prelude.18944143._hygCtx._hyg.18 : String), (forall (s₁ : List.{0} UInt8) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₁))) (s₂ : List.{0} UInt8) (isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47 : ByteArray.IsValidUTF8 (ByteArray.mk (Array.mk.{0} UInt8 s₂))), motive (String.ofByteArray (ByteArray.mk (Array.mk.{0} UInt8 s₁)) isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.48) (String.ofByteArray (ByteArray.mk (Array.mk.{0} UInt8 s₂)) isValidUTF8._@.Init.Prelude.18944143._hygCtx._hyg.47)) -> (motive s₁._@.Init.Prelude.18944143._hygCtx._hyg.16 s₂._@.Init.Prelude.18944143._hygCtx._hyg.18)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.decEq.match_3`.
-- In a full split, the body would be extracted from the environment.
