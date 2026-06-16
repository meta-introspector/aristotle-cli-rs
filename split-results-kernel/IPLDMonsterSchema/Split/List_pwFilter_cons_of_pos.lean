import Split.DecidableRel
import Split.Membership_mem
import Split.if_pos
import Split.List_decidableBAll
import Split.List_cons
import Split.List
import Split.List_instMembership
import Split.List_pwFilter
import Split.List_foldr
import Split.Eq
import Split.List_nil
import Split.ite

-- List.pwFilter_cons_of_pos from environment
-- theorem List.pwFilter_cons_of_pos : forall {α : Type.{u_1}} {R : α -> α -> Prop} [inst._@.Batteries.Data.List.Pairwise.3159145048._hygCtx._hyg.9 : DecidableRel.{succ u_1, succ u_1} α α R] {a : α} {l : List.{u_1} α}, (forall (b : α), (Membership.mem.{u_1, u_1} α (List.{u_1} α) (List.instMembership.{u_1} α) (List.pwFilter.{u_1} α R inst._@.Batteries.Data.List.Pairwise.3159145048._hygCtx._hyg.9 l) b) -> (R a b)) -> (Eq.{succ u_1} (List.{u_1} α) (List.pwFilter.{u_1} α R inst._@.Batteries.Data.List.Pairwise.3159145048._hygCtx._hyg.9 (List.cons.{u_1} α a l)) (List.cons.{u_1} α a (List.pwFilter.{u_1} α R inst._@.Batteries.Data.List.Pairwise.3159145048._hygCtx._hyg.9 l)))

-- Stub: this file represents the declaration `List.pwFilter_cons_of_pos`.
-- In a full split, the body would be extracted from the environment.
