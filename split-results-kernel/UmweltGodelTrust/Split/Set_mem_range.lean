import Split.Iff_rfl
import Split.Membership_mem
import Split.Exists
import Split.Iff
import Split.Set_range
import Split.Eq
import Split.Set_instMembership
import Split.Set

-- Set.mem_range from environment
-- theorem Set.mem_range : forall {α : Type.{u}} {ι : Sort.{u_1}} {f : ι -> α} {x : α}, Iff (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) (Set.range.{u, u_1} α ι f) x) (Exists.{u_1} ι (fun (y : ι) => Eq.{succ u} α (f y) x))

-- Stub: this file represents the declaration `Set.mem_range`.
-- In a full split, the body would be extracted from the environment.
