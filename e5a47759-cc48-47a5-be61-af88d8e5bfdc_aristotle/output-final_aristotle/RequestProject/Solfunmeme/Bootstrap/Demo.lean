import RequestProject.Solfunmeme.Bootstrap.Plan

/-!
# The bootstrap plan, evaluated

The same objects `Plan.lean` proves things about, printed.  Nothing here is a
theorem: every number below is also pinned by a theorem in
`RequestProject/Bootstrap/Plan.lean`, and this file exists so the tables can be
read without reading the proofs.  Money is in whole cents.
-/

namespace SFM.Bootstrap

/-- One row of the schedule: the month, the stage, what it costs, what it earns
each month afterwards, and the command that checks it. -/
def row (i : Nat) (s : Stage) : Nat × String × Int × Int × String :=
  (i + 1, s.name, s.cost, s.income, s.check)

/-! The thirteen stages, in order. -/
#eval plan.zipIdx.map (fun x => row x.2 x.1)

/-! What the plan spends, and what it is earning by the end. -/
#eval (totalCost plan, totalIncome plan)

/-! The float it needs, from a standing start with no revenue. -/
#eval requiredFloat 0 plan

/-! The balance and the standing revenue at the end of each month, opening with
that float. -/
#eval (trace ⟨openingFloat, 0⟩ plan).map (fun c => (c.cash, c.rate))

/-! The same, with every assumed revenue set to zero. -/
#eval (requiredFloat 0 planNoRevenue,
  (trace ⟨requiredFloat 0 planNoRevenue, 0⟩ planNoRevenue).map (fun c => c.cash))

/-! The capabilities held after each month. -/
#eval (List.range (plan.length + 1)).map (fun i => (i, caps [] (plan.take i)))

/-! The balance for five years of maintenance after the last stage. -/
#eval (List.range 61).map
  (fun n => (run (run ⟨openingFloat, 0⟩ plan) (List.replicate n maintenance)).cash)

/-! The commands, in the order `scripts/bootstrap.sh` runs them. -/
#eval plan.map Stage.check

end SFM.Bootstrap
