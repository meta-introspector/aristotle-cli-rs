import Split.congrArg
import Split.Set_iInter
import Split.Membership_mem
import Split.iff_self
import Split.Iff
import Split.True
import Split.of_eq_true
import Split.congrFun'
import Split.Set_instMembership
import Split.Eq_trans
import Split.forall_congr
import Split.Set

-- Set.mem_iInter₂ from environment
-- theorem Set.mem_iInter₂ : forall {γ : Type.{u_3}} {ι : Sort.{u_5}} {κ : ι -> Sort.{u_8}} {x : γ} {s : forall (i : ι), (κ i) -> (Set.{u_3} γ)}, Iff (Membership.mem.{u_3, u_3} γ (Set.{u_3} γ) (Set.instMembership.{u_3} γ) (Set.iInter.{u_3, u_5} γ ι (fun (i : ι) => Set.iInter.{u_3, u_8} γ (κ i) (fun (j : κ i) => s i j))) x) (forall (i : ι) (j : κ i), Membership.mem.{u_3, u_3} γ (Set.{u_3} γ) (Set.instMembership.{u_3} γ) (s i j) x)

-- Stub: this file represents the declaration `Set.mem_iInter₂`.
-- In a full split, the body would be extracted from the environment.
