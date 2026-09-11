import RequestProject.Gvcs.Bounds
import RequestProject.Gvcs.Bootstrap

set_option maxRecDepth 1000000

/-!
# The absolute minimum: fifty-two steps and 7529.35 kg

`RequestProject/Bounds.lean` proves, for an arbitrary production system, two
lower bounds on what a bootstrap can cost.  This file applies them to the
LifeTrac system and answers the question exactly.

**Steps.**  Fifty-two of the system's seventy-two items are made by it rather
than dug up or brought along as seed plant, and every one of them is needed —
directly or indirectly, as an input or as a tool — for the tractor.  So

* no admissible plan that starts on a greenfield yard and finishes with a
  tractor is shorter than **52 production runs** (`greenfield_steps_ge_52`),
  and
* there is one exactly that long (`minimalPlan_length`, `minimalPlan_ok`,
  `minimalPlan_builds`): run each of the fifty-two workflows once, in build
  order, each for the total quantity the rest of the plan will call for.

Fifty-two is therefore the absolute minimum (`minimal_steps_eq_52`).

**Material.**  The starting yard must contain at least the tractor's
raw-material demand — 4760.96 kg (`greenfield_rawTotal_ge`) — and the yard the
fifty-two-step plan actually needs holds 7529.35 kg
(`minStock_rawTotal`), the extra being exactly the ore that goes into the nine
tools the shop builds for itself before it can start
(`minStock_eq_shop_plus_tractor`).

Everything about the minimal plan is checked by computation against the
workflows: `demandTable` is not a table of postulated figures but the demand
propagated backwards through the build order.
-/

namespace LifeTrac
namespace Workflow

open Item

/-! ## The fifty-two workflows -/

/-- The items the system makes for itself: everything except the seven raw
materials and the thirteen seed tools. -/
def nonBase : List Item := buildOrder.filter (fun i => (recipe i).isSome)

/-- Fifty-two of the seventy-two items are made by the system. -/
theorem nonBase_length : nonBase.length = 52 := by decide +kernel

theorem nonBase_nodup : nonBase.Nodup := by decide +kernel

theorem nonBase_made : ∀ j ∈ nonBase, plant.recipe j ≠ none := by decide +kernel

theorem mem_nonBase_iff (i : Item) : i ∈ nonBase ↔ plant.recipe i ≠ none := by
  revert i; decide +kernel

/-- **Everything the system makes is needed for the tractor.**  Each of the
fifty-two is either the tractor itself or something the tractor calls for,
however indirectly, as an input or as a tool. -/
theorem nonBase_needed : ∀ j ∈ nonBase, j = lifeTrac ∨ plant.Needs lifeTrac j := by
  have hclosure : ∀ j ∈ nonBase, j = lifeTrac ∨ j ∈ plant.reachDeps 6 lifeTrac := by
    decide +kernel
  intro j hj
  rcases hclosure j hj with h | h
  · exact Or.inl h
  · exact plant.mem_reachDeps 6 j h

/-- No workflow of the system lists the same input twice. -/
theorem plant_inputsNodup : plant.InputsNodup := by
  intro i r h
  cases i <;> simp only [plant_recipe, recipe] at h <;>
    first
      | (injection h with h'; subst h'; decide)
      | exact absurd h (by simp)

/-! ## The lower bound on steps -/

/-- **Fifty-two runs at the very least.**  Start on a greenfield yard: nothing
on the shelf that the system knows how to make, only raw materials and
whatever seed plant was brought along.  Then *any* admissible plan that ends
with a tractor on the shelf contains at least fifty-two production runs. -/
theorem greenfield_steps_ge_52 (l : List (Item × ℚ)) (s : Item → ℚ)
    (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 < s x → plant.recipe x = none)
    (hprod : 0 < plant.runPlan l s lifeTrac) : 52 ≤ l.length := by
  have h := plant.steps_lower_bound lifeTrac nonBase nonBase_nodup nonBase_needed
    nonBase_made l s hq hOK hs hprod
  rw [nonBase_length] at h
  exact h

/-! ## A plan that attains it

`demandTable` walks the build order backwards, starting from one tractor and
one of each tool the shop must build for itself, and accumulates for every
item the total quantity of it that the rest of the plan will consume.  The
minimal plan then runs each workflow exactly once, for exactly that
quantity. -/

/-- What the plan must deliver before anything is propagated backwards: one
tractor, and one of each shop-built tool. -/
def initDemand (x : Item) : ℚ := (if x = lifeTrac then 1 else 0) + (if x ∈ shopTools then 1 else 0)

/-- The total quantity of each item the bootstrap calls for: the demand of
`initDemand`, propagated backwards through the build order by
`Plant.demandOf`. -/
def demandTable : Item → ℚ := plant.demandOf buildOrder initDemand

/-- **The minimal plan**: each of the fifty-two workflows run once, in build
order, for the whole quantity the bootstrap needs of it. -/
def minimalPlan : List (Item × ℚ) := nonBase.map (fun i => (i, demandTable i))

/-- The yard the minimal plan starts from: the seven raw materials in the
quantities the plan will consume, and one of each seed tool.  Nothing that the
system makes itself is on the shelf. -/
def minStock (x : Item) : ℚ :=
  (if x ∈ rawMaterials then demandTable x else 0) + (if x ∈ seedToolkit then 1 else 0)

theorem minimalPlan_items : minimalPlan.map Prod.fst = nonBase := by decide +kernel

/-- The plan is fifty-two runs long — one for each thing the system makes. -/
theorem minimalPlan_length : minimalPlan.length = 52 := by decide +kernel

theorem minimalPlan_qty_nonneg : ∀ p ∈ minimalPlan, 0 ≤ p.2 := by decide +kernel

theorem minStock_nonneg : ∀ x, 0 ≤ minStock x := by decide +kernel

/-- The starting yard is a greenfield one: it holds nothing the system knows
how to make. -/
theorem minStock_greenfield : ∀ x, plant.recipe x ≠ none → minStock x = 0 := by
  have h : ∀ x, (recipe x).isSome → minStock x = 0 := by decide +kernel
  intro x hx
  exact h x (Option.isSome_iff_ne_none.2 hx)

theorem minStock_pos_base : ∀ x, 0 < minStock x → plant.recipe x = none := by
  intro x hx
  by_contra hc
  rw [minStock_greenfield x hc] at hx
  exact lt_irrefl 0 hx

set_option maxHeartbeats 4000000 in
/-- **The minimal plan is admissible.**  Every one of the fifty-two runs finds
its inputs on the shelf and its tools in the shop. -/
theorem minimalPlan_ok : plant.PlanOK minimalPlan minStock :=
  plant.planOKb_sound minimalPlan minStock (by decide +kernel)

set_option maxHeartbeats 4000000 in
/-- **… and it ends with a tractor.**  Exactly one, with nothing left over to
spare. -/
theorem minimalPlan_builds : plant.runPlan minimalPlan minStock lifeTrac = 1 := by
  decide +kernel

/-- **Fifty-two is the answer.**  A greenfield bootstrap of the LifeTrac needs
at least fifty-two production runs, and fifty-two suffice. -/
theorem minimal_steps_eq_52 :
    (plant.PlanOK minimalPlan minStock ∧ minimalPlan.length = 52 ∧
      1 ≤ plant.runPlan minimalPlan minStock lifeTrac) ∧
    (∀ (l : List (Item × ℚ)) (s : Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) → plant.PlanOK l s →
      (∀ x, 0 < s x → plant.recipe x = none) → 0 < plant.runPlan l s lifeTrac →
      52 ≤ l.length) := by
  refine ⟨⟨minimalPlan_ok, minimalPlan_length, ?_⟩, greenfield_steps_ge_52⟩
  rw [minimalPlan_builds]

/-! ## The lower bound on material -/

/-- **No cheaper route to the ore.**  Whatever plan is followed, a greenfield
yard must hold at least the tractor's raw-material demand of every raw
material before work starts. -/
theorem greenfield_material_ge {b : Item} (hb : b ∈ rawMaterials)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 ≤ s x) (hmade : ∀ x, plant.recipe x ≠ none → s x = 0)
    (hfin : 1 ≤ plant.runPlan l s lifeTrac) :
    plant.rawDemand lifeTrac 1 b ≤ s b :=
  plant.greenfield_material_lower_bound plant_inputsNodup (rawMaterials_base b hb) lifeTrac
    l s hq hOK hs hmade hfin

/-- **The bill in kilograms.**  A greenfield yard must weigh at least 4760.96
kg of raw material — the tractor's own demand — however the work is
organised. -/
theorem greenfield_rawTotal_ge (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2)
    (hOK : plant.PlanOK l s) (hs : ∀ x, 0 ≤ s x)
    (hmade : ∀ x, plant.recipe x ≠ none → s x = 0)
    (hfin : 1 ≤ plant.runPlan l s lifeTrac) :
    (1190240053 : ℚ)/250000 ≤ rawTotal s := by
  have hb : ∀ b ∈ rawMaterials, plant.rawDemand lifeTrac 1 b ≤ s b :=
    fun b hb => greenfield_material_ge hb l s hq hOK hs hmade hfin
  have h1 := hb ironOre (by decide)
  have h2 := hb coal (by decide)
  have h3 := hb limestone (by decide)
  have h4 := hb silicaSand (by decide)
  have h5 := hb crudeOil (by decide)
  have h6 := hb latex (by decide)
  have h7 := hb copperOre (by decide)
  obtain ⟨e1, e2, e3, e4, e5, e6, e7⟩ := lifeTrac_rawDemand
  rw [e1] at h1; rw [e2] at h2; rw [e3] at h3; rw [e4] at h4
  rw [e5] at h5; rw [e6] at h6; rw [e7] at h7
  unfold rawTotal
  linarith

/-! ## What the minimal plan actually digs -/

theorem minStock_ironOre : minStock ironOre = 132262859/31250 := by decide +kernel
theorem minStock_coal : minStock coal = 26838099/12500 := by decide +kernel
theorem minStock_limestone : minStock limestone = 397188577/500000 := by decide +kernel
theorem minStock_silicaSand : minStock silicaSand = 351/5 := by decide +kernel
theorem minStock_crudeOil : minStock crudeOil = 1789/25 := by decide +kernel
theorem minStock_latex : minStock latex = 567/4 := by decide +kernel
theorem minStock_copperOre : minStock copperOre = 72 := by decide +kernel

/-- **The yard, item by item, is the tractor plus the tools that build it.**
The material the fifty-two-step plan starts with is exactly the tractor's own
raw-material demand plus the demand of one of each shop-built tool — the
figures of `RequestProject/Bootstrap.lean`, arrived at here by a completely
different route. -/
theorem minStock_eq_shop_plus_tractor :
    ∀ b ∈ rawMaterials, minStock b = shopDemand b + plant.rawDemand lifeTrac 1 b := by
  intro b hb
  fin_cases hb
  · rw [minStock_ironOre]; simp [shopDemand, ind]; norm_num
  · rw [minStock_coal]; simp [shopDemand, ind]; norm_num
  · rw [minStock_limestone]; simp [shopDemand, ind]; norm_num
  · rw [minStock_silicaSand]; simp [shopDemand, ind]; norm_num
  · rw [minStock_crudeOil]; simp [shopDemand, ind]; norm_num
  · rw [minStock_latex]; simp [shopDemand, ind]
  · rw [minStock_copperOre]; simp [shopDemand, ind]; norm_num

/-- **7529.35 kg out of the ground.**  That is what a greenfield bootstrap of
one LifeTrac — shop tools and all — weighs. -/
theorem minStock_rawTotal : rawTotal minStock = 3764673281/500000 := by
  unfold rawTotal
  rw [minStock_ironOre, minStock_coal, minStock_limestone, minStock_silicaSand,
    minStock_crudeOil, minStock_latex, minStock_copperOre]
  norm_num

/-- The minimal plan's yard is heavier than the bound of `greenfield_rawTotal_ge`,
and it has to be: the bound counts the tractor only, while a greenfield shop
must also make its own nine tools. -/
theorem minStock_rawTotal_gt_bound : (1190240053 : ℚ)/250000 < rawTotal minStock := by
  rw [minStock_rawTotal]; norm_num

end Workflow
end LifeTrac
