import Split.TypedDMZ_FieldType_list
import Split.TypedDMZ_FieldType_bytes
import Split.String
import Split.TypedDMZ_FieldType_mapType
import Split.TypedDMZ_FieldType_link
import Split.Prod_mk
import Split.List_cons
import Split.TypedDMZ_FieldType_int
import Split.List
import Split.TypedDMZ_FieldType
import Split.TypedDMZ_FieldType_struct
import Split.TypedDMZ_FieldType_bool
import Split.Prod
import Split.TypedDMZ_FieldType_union
import Split.TypedDMZ_FieldType_string
import Split.List_nil

-- TypedDMZ.FieldType.rec_3 from environment
-- recursor TypedDMZ.FieldType.rec_3 : forall {motive_1 : TypedDMZ.FieldType -> Sort.{u}} {motive_2 : (List.{0} TypedDMZ.FieldType) -> Sort.{u}} {motive_3 : (List.{0} (Prod.{0, 0} String TypedDMZ.FieldType)) -> Sort.{u}} {motive_4 : (Prod.{0, 0} String TypedDMZ.FieldType) -> Sort.{u}}, (motive_1 TypedDMZ.FieldType.string) -> (motive_1 TypedDMZ.FieldType.int) -> (motive_1 TypedDMZ.FieldType.bool) -> (motive_1 TypedDMZ.FieldType.bytes) -> (motive_1 TypedDMZ.FieldType.link) -> (forall (a._@._internal._hyg.0 : TypedDMZ.FieldType), (motive_1 a._@._internal._hyg.0) -> (motive_1 (TypedDMZ.FieldType.list a._@._internal._hyg.0))) -> (forall (a._@._internal._hyg.0 : TypedDMZ.FieldType) (a_1._@._internal._hyg.0 : TypedDMZ.FieldType), (motive_1 a._@._internal._hyg.0) -> (motive_1 a_1._@._internal._hyg.0) -> (motive_1 (TypedDMZ.FieldType.mapType a._@._internal._hyg.0 a_1._@._internal._hyg.0))) -> (forall (a._@._internal._hyg.0 : List.{0} TypedDMZ.FieldType), (motive_2 a._@._internal._hyg.0) -> (motive_1 (TypedDMZ.FieldType.union a._@._internal._hyg.0))) -> (forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String TypedDMZ.FieldType)), (motive_3 a._@._internal._hyg.0) -> (motive_1 (TypedDMZ.FieldType.struct a._@._internal._hyg.0))) -> (motive_2 (List.nil.{0} TypedDMZ.FieldType)) -> (forall (head : TypedDMZ.FieldType) (tail : List.{0} TypedDMZ.FieldType), (motive_1 head) -> (motive_2 tail) -> (motive_2 (List.cons.{0} TypedDMZ.FieldType head tail))) -> (motive_3 (List.nil.{0} (Prod.{0, 0} String TypedDMZ.FieldType))) -> (forall (head : Prod.{0, 0} String TypedDMZ.FieldType) (tail : List.{0} (Prod.{0, 0} String TypedDMZ.FieldType)), (motive_4 head) -> (motive_3 tail) -> (motive_3 (List.cons.{0} (Prod.{0, 0} String TypedDMZ.FieldType) head tail))) -> (forall (fst : String) (snd : TypedDMZ.FieldType), (motive_1 snd) -> (motive_4 (Prod.mk.{0, 0} String TypedDMZ.FieldType fst snd))) -> (forall (t : Prod.{0, 0} String TypedDMZ.FieldType), motive_4 t)

-- Stub: this file represents the declaration `TypedDMZ.FieldType.rec_3`.
-- In a full split, the body would be extracted from the environment.
