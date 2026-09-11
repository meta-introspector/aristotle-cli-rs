import RequestProject.Gvcs.Bootstrap
import RequestProject.Gvcs.Plan

/-!
# The workshop: running the LifeTrac production system for real

`RequestProject/Fabrication.lean` describes the production system, and
`RequestProject/Plan.lean` gives the general semantics of working through a
production plan against a stock.  This file joins the two: it checks that the
LifeTrac system satisfies the one structural hypothesis of the plan theory
(tools are never eaten as inputs), stocks a yard with exactly the raw-material
demand of one machine plus one of each tool, and shows that the resulting plan
runs to completion with a tractor on the shelf at the end.

This is the sense in which the system is "based on raw materials": nothing has
to be bought in halfway through, and nothing is on the starting shelf except
the seven raw materials and the shop's own equipment.
-/

namespace LifeTrac
namespace Workflow

open Item

/-! ## Tools are never consumed -/

/-- No workflow eats a tool: nothing appearing in the seed toolkit or in the
shop-built tool list is ever an *input* to any recipe. -/
theorem no_tool_is_input (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ p ∈ r.inputs, p.1 ∉ seedToolkit ∧ p.1 ∉ shopTools := by
  revert i r h; decide

/-- Anything used as a tool anywhere in the system is a seed tool or a
shop-built tool. -/
theorem isTool_seed_or_shop {t : Item} (ht : plant.IsTool t) :
    t ∈ seedToolkit ∨ t ∈ shopTools := by
  obtain ⟨j, r, hj, hr⟩ := ht
  exact tools_seed_or_shop j r hj t hr

/-- The LifeTrac system satisfies the standing hypothesis of the plan theory:
a lathe is never melted down to make bar stock. -/
theorem plant_toolsNotConsumed : plant.ToolsNotConsumed := by
  intro t ht j r hj p hp
  rcases isTool_seed_or_shop ht with h | h
  · rintro rfl; exact (no_tool_is_input j r hj p hp).1 h
  · rintro rfl; exact (no_tool_is_input j r hj p hp).2 h

/-! ## The starting yard -/

/-- One of each tool the shop owns, and none of anything else. -/
def toolStock (x : Item) : ℚ := if x ∈ seedToolkit ∨ x ∈ shopTools then 1 else 0

theorem toolStock_nonneg (x : Item) : 0 ≤ toolStock x := by
  unfold toolStock; split <;> norm_num

theorem toolStock_of_mem {x : Item} (h : x ∈ seedToolkit ∨ x ∈ shopTools) :
    toolStock x = 1 := if_pos h

theorem toolStock_lifeTrac : toolStock lifeTrac = 0 := by decide

/-- The stock a shop must have on hand before it starts: the raw-material
demand of one machine, plus one of each tool. -/
noncomputable def startStock (x : Item) : ℚ := plant.rawDemand lifeTrac 1 x + toolStock x

theorem startStock_lifeTrac : startStock lifeTrac = plant.rawDemand lifeTrac 1 lifeTrac := by
  simp [startStock, toolStock_lifeTrac]

/-! ## The capstone -/

/-- **The whole system runs.**  Starting from a yard holding exactly the
raw-material demand of one LifeTrac and one of each tool in the shop, the
production plan for one machine is admissible at every single step — every
input it calls for is already on the shelf, made by an earlier step or dug out
of the ground — and when the last step is done there is a finished tractor. -/
theorem lifeTrac_plan_works :
    plant.PlanOK (plant.plan lifeTrac 1) startStock ∧
      1 ≤ plant.runPlan (plant.plan lifeTrac 1) startStock lifeTrac := by
  have hs : ∀ x, plant.rawDemand lifeTrac 1 x ≤ startStock x := by
    intro x
    have := toolStock_nonneg x
    simp only [startStock]
    linarith
  have htool : ∀ t, plant.IsTool t → 1 ≤ startStock t := by
    intro t ht
    have h1 : toolStock t = 1 := toolStock_of_mem (isTool_seed_or_shop ht)
    have h2 : 0 ≤ plant.rawDemand lifeTrac 1 t :=
      plant.rawDemand_nonneg zero_le_one t
    simp only [startStock, h1]
    linarith
  obtain ⟨h1, h2⟩ :=
    plant.plan_produces plant_toolsNotConsumed lifeTrac zero_le_one startStock hs htool
  refine ⟨h1, ?_⟩
  rw [startStock_lifeTrac] at h2
  linarith

/-- Every quantity called for by the plan is nonnegative. -/
theorem lifeTrac_plan_qty_nonneg : ∀ p ∈ plant.plan lifeTrac 1, 0 ≤ p.2 :=
  plant.plan_qty_nonneg lifeTrac 1 zero_le_one

/-- The plan is not a trivial one: its last step is the final assembly of one
machine. -/
theorem lifeTrac_plan_getLast : (plant.plan lifeTrac 1).getLast? = some (lifeTrac, 1) := by
  obtain ⟨r, hr⟩ := Option.isSome_iff_exists.1 (has_recipe lifeTrac (by decide) (by decide))
  rw [plant.plan_recipe hr]
  simp

end Workflow
end LifeTrac
