import Mathlib

set_option pp.all true
-- spec: instReprTupleOfRepr : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.1932855813._hygCtx._hyg.5 : Repr.{u_1} α], ReprTuple.{u_1} α
def instReprTupleOfRepr : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.1932855813._hygCtx._hyg.5 : Repr.{u_1} α], ReprTuple.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Repr.1932855813._hygCtx._hyg.5 : Repr.{u_1} α] => ReprTuple.mk.{u_1} α (fun (a : α) (xs : List.{0} Std.Format) => List.cons.{0} Std.Format (repr.{u_1} α inst._@.Init.Data.Repr.1932855813._hygCtx._hyg.5 a) xs)
