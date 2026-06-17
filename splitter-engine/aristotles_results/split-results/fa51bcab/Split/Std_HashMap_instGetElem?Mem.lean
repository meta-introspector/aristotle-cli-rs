import Split.GetElem?
import Split.Membership_mem
import Split.Std_HashMap
import Split.Std_HashMap_get
import Split.Std_HashMap_get!
import Split.GetElem_mk
import Split.Std_HashMap_get?
import Split.Inhabited
import Split.Hashable
import Split.GetElem?_mk
import Split.BEq
import Split.Std_HashMap_instMembership

-- Std.HashMap.instGetElem?Mem from environment
-- def Std.HashMap.instGetElem?Mem : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.10 : BEq.{u} α] [inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.13 : Hashable.{succ u} α], GetElem?.{max v u, u, v} (Std.HashMap.{u, v} α β inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.10 inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.13) α β (fun (m : Std.HashMap.{u, v} α β inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.10 inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.13) (a : α) => Membership.mem.{u, max u v} α (Std.HashMap.{u, v} α β inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.10 inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.13) (Std.HashMap.instMembership.{u, v} α β inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.10 inst._@.Std.Data.HashMap.Basic.167679218._hygCtx._hyg.13) m a)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.HashMap.instGetElem?Mem`.
-- In a full split, the body would be extracted from the environment.
