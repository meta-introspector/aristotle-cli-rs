import Split.Subtype
import Split.Subtype_mk
import Split.Subtype_val
import Split.Eq
import Split.rfl

-- Subtype.ext from environment
-- theorem Subtype.ext : forall {α : Sort.{u}} {p : α -> Prop} {a1 : Subtype.{u} α (fun (x : α) => p x)} {a2 : Subtype.{u} α (fun (x : α) => p x)}, (Eq.{u} α (Subtype.val.{u} α (fun (x : α) => p x) a1) (Subtype.val.{u} α (fun (x : α) => p x) a2)) -> (Eq.{max 1 u} (Subtype.{u} α (fun (x : α) => p x)) a1 a2)

-- Stub: this file represents the declaration `Subtype.ext`.
-- In a full split, the body would be extracted from the environment.
