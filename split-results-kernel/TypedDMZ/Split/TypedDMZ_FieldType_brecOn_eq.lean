import Split.TypedDMZ_FieldType_list
import Split.TypedDMZ_FieldType_bytes
import Split.String
import Split.TypedDMZ_FieldType_mapType
import Split.TypedDMZ_FieldType_link
import Split.TypedDMZ_FieldType_below
import Split.TypedDMZ_FieldType_brecOn
import Split.TypedDMZ_FieldType_casesOn
import Split.TypedDMZ_FieldType_int
import Split.List
import Split.TypedDMZ_FieldType_below_3
import Split.TypedDMZ_FieldType_brecOn_go
import Split.TypedDMZ_FieldType
import Split.TypedDMZ_FieldType_struct
import Split.TypedDMZ_FieldType_bool
import Split.TypedDMZ_FieldType_below_1
import Split.Eq_refl
import Split.TypedDMZ_FieldType_below_2
import Split.Prod
import Split.Eq
import Split.TypedDMZ_FieldType_union
import Split.TypedDMZ_FieldType_string

-- TypedDMZ.FieldType.brecOn.eq from environment
-- theorem TypedDMZ.FieldType.brecOn.eq : forall {motive_1 : TypedDMZ.FieldType -> Sort.{u}} {motive_2 : (List.{0} TypedDMZ.FieldType) -> Sort.{u}} {motive_3 : (List.{0} (Prod.{0, 0} String TypedDMZ.FieldType)) -> Sort.{u}} {motive_4 : (Prod.{0, 0} String TypedDMZ.FieldType) -> Sort.{u}} (t : TypedDMZ.FieldType) (F_1 : forall (t : TypedDMZ.FieldType), (TypedDMZ.FieldType.below.{u} motive_1 motive_2 motive_3 motive_4 t) -> (motive_1 t)) (F_2 : forall (t : List.{0} TypedDMZ.FieldType), (TypedDMZ.FieldType.below_1.{u} motive_1 motive_2 motive_3 motive_4 t) -> (motive_2 t)) (F_3 : forall (t : List.{0} (Prod.{0, 0} String TypedDMZ.FieldType)), (TypedDMZ.FieldType.below_2.{u} motive_1 motive_2 motive_3 motive_4 t) -> (motive_3 t)) (F_4 : forall (t : Prod.{0, 0} String TypedDMZ.FieldType), (TypedDMZ.FieldType.below_3.{u} motive_1 motive_2 motive_3 motive_4 t) -> (motive_4 t)), Eq.{u} (motive_1 t) (TypedDMZ.FieldType.brecOn.{u} motive_1 motive_2 motive_3 motive_4 t F_1 F_2 F_3 F_4) (F_1 t ((TypedDMZ.FieldType.brecOn.go.{u} motive_1 motive_2 motive_3 motive_4 t F_1 F_2 F_3 F_4).2))

-- Stub: this file represents the declaration `TypedDMZ.FieldType.brecOn.eq`.
-- In a full split, the body would be extracted from the environment.
