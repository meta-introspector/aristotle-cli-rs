import Split.IPLDMonsterSchema_TypeKind_Map
import Split.IPLDMonsterSchema_TypeKind
import Split.IPLDMonsterSchema_TypeKind_Unit
import Split.IPLDMonsterSchema_TypeKind_Bytes
import Split.IPLDMonsterSchema_TypeKind_Bool
import Split.IPLDMonsterSchema_TypeKind_Int
import Split.IPLDMonsterSchema_TypeKind_List
import Split.IPLDMonsterSchema_TypeKind_ctorElimType
import Split.IPLDMonsterSchema_TypeKind_Union
import Split.IPLDMonsterSchema_TypeKind_String
import Split.IPLDMonsterSchema_TypeKind_Any
import Split.IPLDMonsterSchema_TypeKind_Float
import Split.Nat
import Split.IPLDMonsterSchema_TypeKind_ctorIdx
import Split.IPLDMonsterSchema_TypeKind_casesOn
import Split.Eq_ndrec
import Split.IPLDMonsterSchema_TypeKind_Link
import Split.PULift_down
import Split.IPLDMonsterSchema_TypeKind_Struct
import Split.Eq
import Split.IPLDMonsterSchema_TypeKind_Enum

-- IPLDMonsterSchema.TypeKind.ctorElim from environment
-- def IPLDMonsterSchema.TypeKind.ctorElim : forall {motive : IPLDMonsterSchema.TypeKind -> Sort.{u}} (ctorIdx : Nat) (t : IPLDMonsterSchema.TypeKind), (Eq.{1} Nat ctorIdx (IPLDMonsterSchema.TypeKind.ctorIdx t)) -> (IPLDMonsterSchema.TypeKind.ctorElimType.{u} motive ctorIdx) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `IPLDMonsterSchema.TypeKind.ctorElim`.
-- In a full split, the body would be extracted from the environment.
