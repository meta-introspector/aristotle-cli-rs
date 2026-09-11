import RequestProject.Gvcs.Minimal
import RequestProject.Gvcs.Pit

set_option maxRecDepth 1000000

/-!
# The absolute minimum in the pit: eleven runs and 9261.33 kg of ground

`RequestProject/Minimal.lean` answers the minimality question for the *shop*:
fifty-two production runs and a yard of 7529.35 kg of raw material.  But that
yard has to come out of the ground, and this file asks the same two questions
of the *pit*.

The pit makes eleven things — three stages of iron, three of copper, and one
each of coal, limestone, sand, oil and latex — and every one of them is needed
for one of the seven raw materials the shop consumes.  So

* no admissible plan that starts on bare ground — the deposits and the ten
  devices the bootstrap built, and nothing else — and finishes with all seven
  raw materials on the stockpile is shorter than **eleven runs**
  (`pit_steps_ge_11`), and
* there is one exactly that long (`pitPlan`), which delivers precisely the
  quantities the shop's minimal plan calls for
  (`pitPlan_delivers`, `shopYard_eq_minStock`);
* the ground must give up at least **9261.33 kg**
  (`pit_groundTotal_ge`), and the eleven-run plan takes exactly that
  (`pitYard_groundTotal`), so the bound is attained;
* and it is **10.39 hours** of machine time at the face (`pit_hours`).

Putting the two stages together, the whole bootstrap — dig the materials, then
build the machine — is **sixty-three production runs**
(`whole_bootstrap_minimum`).
-/

namespace LifeTrac
namespace Mining

open Item

/-! ## The eleven workings -/

/-- Every item of the pit, in rank order: the deposits and the devices first,
then the streams of rock, then the finished raw materials. -/
def pitOrder : List Item :=
  [oreBody, coalSeam, limestoneLedge, sandBank, oilSeep, rubberGrove, copperLode,
   tractor, miningBucket, ripperTooth, rockBreaker, augerDrill, jawCrusher, screenDeck,
   oreTrailer, tapSpout, stillRig,
   ironRock, ironCrushed, ironOre, copperRock, copperCrushed, copperOre,
   coal, limestone, silicaSand, crudeOil, latex]

theorem pitOrder_complete : ∀ i : Item, i ∈ pitOrder := by decide

theorem pitOrder_nodup : pitOrder.Nodup := by decide

/-- The things the pit makes: everything except the seven deposits and the ten
devices. -/
def pitNonBase : List Item := pitOrder.filter (fun i => (recipe i).isSome)

/-- Eleven workings in all. -/
theorem pitNonBase_length : pitNonBase.length = 11 := by decide

theorem pitNonBase_nodup : pitNonBase.Nodup := by decide

theorem pitNonBase_made : ∀ j ∈ pitNonBase, plant.recipe j ≠ none := by decide

/-- No workflow of the pit lists the same input twice — indeed each of them has
a single input. -/
theorem plant_inputsNodup : plant.InputsNodup := by
  intro i r h
  cases i <;> simp only [plant_recipe, recipe] at h <;>
    first
      | (injection h with h'; subst h'; decide)
      | exact absurd h (by simp)

/-- **Everything the pit makes is needed for the seven raw materials.** -/
theorem pitNonBase_needed :
    ∀ j ∈ pitNonBase, ∃ t ∈ products, j = t ∨ plant.Needs t j := by
  have hclosure : ∀ j ∈ pitNonBase, ∃ t ∈ products, j = t ∨ j ∈ plant.reachDeps 3 t := by
    decide +kernel
  intro j hj
  obtain ⟨t, ht, h⟩ := hclosure j hj
  refine ⟨t, ht, ?_⟩
  rcases h with rfl | h
  · exact Or.inl rfl
  · exact plant.mem_reachDeps 3 j h

/-! ## The lower bound on steps -/

/-- **Eleven runs at the very least.**  Start on bare ground: the deposits and
the devices, nothing on the stockpile that the pit knows how to win.  Then any
admissible plan that ends with all seven raw materials in hand contains at
least eleven production runs. -/
theorem pit_steps_ge_11 (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2)
    (hOK : plant.PlanOK l s) (hs : ∀ x, 0 < s x → plant.recipe x = none)
    (hprod : ∀ t ∈ products, 0 < plant.runPlan l s t) : 11 ≤ l.length := by
  have h := plant.steps_lower_bound_multi products pitNonBase pitNonBase_nodup
    pitNonBase_needed pitNonBase_made l s hq hOK hs hprod
  rw [pitNonBase_length] at h
  exact h

/-! ## A plan that attains it

The order the pit has to fill is the shop's greenfield yard: exactly the
7529.35 kg of raw material that `RequestProject/Minimal.lean` shows a
fifty-two-step bootstrap starts from. -/

/-- The order on the pit: the shop's minimal yard, raw material by raw
material. -/
def shopYard : Item → ℚ
  | ironOre => 132262859/31250
  | coal => 26838099/12500
  | limestone => 397188577/500000
  | silicaSand => 351/5
  | crudeOil => 1789/25
  | latex => 567/4
  | copperOre => 72
  | _ => 0

/-- **The order is exactly the shop's minimal yard.**  Nothing here is
postulated: each figure is the corresponding entry of `Workflow.minStock`. -/
theorem shopYard_eq_minStock :
    shopYard ironOre = Workflow.minStock Workflow.Item.ironOre ∧
    shopYard coal = Workflow.minStock Workflow.Item.coal ∧
    shopYard limestone = Workflow.minStock Workflow.Item.limestone ∧
    shopYard silicaSand = Workflow.minStock Workflow.Item.silicaSand ∧
    shopYard crudeOil = Workflow.minStock Workflow.Item.crudeOil ∧
    shopYard latex = Workflow.minStock Workflow.Item.latex ∧
    shopYard copperOre = Workflow.minStock Workflow.Item.copperOre := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [Workflow.minStock_ironOre]; rfl
  · rw [Workflow.minStock_coal]; rfl
  · rw [Workflow.minStock_limestone]; rfl
  · rw [Workflow.minStock_silicaSand]; rfl
  · rw [Workflow.minStock_crudeOil]; rfl
  · rw [Workflow.minStock_latex]; rfl
  · rw [Workflow.minStock_copperOre]; rfl

/-- The tonnage of every stream the order calls for, got by walking the pit
backwards from the order. -/
def pitDemand : Item → ℚ := plant.demandOf pitOrder shopYard

/-- **The minimal mining plan**: each of the eleven workings run once, in
order, for the whole tonnage the order needs of it. -/
def pitPlan : List (Item × ℚ) := pitNonBase.map (fun i => (i, pitDemand i))

/-- The working face the plan starts from: each deposit opened to exactly the
tonnage the plan will take out of it, and one of each of the ten devices the
bootstrap built.  Nothing that the pit wins for itself is on the stockpile. -/
def pitYard (x : Item) : ℚ :=
  (if x ∈ deposits then pitDemand x else 0) + (if x ∈ devices then 1 else 0)

theorem pitPlan_items : pitPlan.map Prod.fst = pitNonBase := by decide +kernel

/-- Eleven runs — one for each thing the pit makes. -/
theorem pitPlan_length : pitPlan.length = 11 := by decide +kernel

theorem pitPlan_qty_nonneg : ∀ p ∈ pitPlan, 0 ≤ p.2 := by decide +kernel

theorem pitYard_nonneg : ∀ x, 0 ≤ pitYard x := by decide +kernel

/-- The face is untouched: it holds nothing the pit knows how to win. -/
theorem pitYard_greenfield : ∀ x, plant.recipe x ≠ none → pitYard x = 0 := by
  have h : ∀ x, (recipe x).isSome → pitYard x = 0 := by decide +kernel
  intro x hx
  exact h x (Option.isSome_iff_ne_none.2 hx)

theorem pitYard_pos_base : ∀ x, 0 < pitYard x → plant.recipe x = none := by
  intro x hx
  by_contra hc
  rw [pitYard_greenfield x hc] at hx
  exact lt_irrefl 0 hx

/-- **The mining plan is admissible.**  Every one of the eleven runs finds its
rock at the face and its machine in the yard. -/
theorem pitPlan_ok : plant.PlanOK pitPlan pitYard :=
  plant.planOKb_sound pitPlan pitYard (by decide +kernel)

/-- **… and it delivers the shop's yard exactly.**  When the eleventh run is
done the stockpile holds precisely the seven raw materials the fifty-two-step
bootstrap needs, with nothing over. -/
theorem pitPlan_delivers : ∀ i ∈ products, plant.runPlan pitPlan pitYard i = shopYard i := by
  decide +kernel

/-- **Eleven is the answer for the pit.** -/
theorem minimal_pit_steps_eq_11 :
    (plant.PlanOK pitPlan pitYard ∧ pitPlan.length = 11 ∧
      ∀ i ∈ products, plant.runPlan pitPlan pitYard i = shopYard i) ∧
    (∀ (l : List (Item × ℚ)) (s : Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) → plant.PlanOK l s →
      (∀ x, 0 < s x → plant.recipe x = none) → (∀ t ∈ products, 0 < plant.runPlan l s t) →
      11 ≤ l.length) :=
  ⟨⟨pitPlan_ok, pitPlan_length, pitPlan_delivers⟩, pit_steps_ge_11⟩

/-! ## The lower bound on ground -/

/-- **No cheaper route to the ground.**  However the digging is organised, a
face that starts untouched must be opened to at least the deposit content of
the order — deposit by deposit, and hence in total at least 9261.33 kg. -/
theorem pit_groundTotal_ge (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2)
    (hOK : plant.PlanOK l s) (hs : ∀ x, 0 ≤ s x)
    (hmade : ∀ x, plant.recipe x ≠ none → s x = 0)
    (hfin : ∀ i ∈ products, shopYard i ≤ plant.runPlan l s i) :
    92613280171/10000000 ≤ groundTotal s := by
  have h1 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := oreBody) (by decide) ironOre (shopYard ironOre) l s hq hOK hs hmade
    (hfin ironOre (by decide))
  have h2 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := coalSeam) (by decide) coal (shopYard coal) l s hq hOK hs hmade
    (hfin coal (by decide))
  have h3 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := limestoneLedge) (by decide) limestone (shopYard limestone) l s hq hOK hs hmade
    (hfin limestone (by decide))
  have h4 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := sandBank) (by decide) silicaSand (shopYard silicaSand) l s hq hOK hs hmade
    (hfin silicaSand (by decide))
  have h5 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := oilSeep) (by decide) crudeOil (shopYard crudeOil) l s hq hOK hs hmade
    (hfin crudeOil (by decide))
  have h6 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := rubberGrove) (by decide) latex (shopYard latex) l s hq hOK hs hmade
    (hfin latex (by decide))
  have h7 := plant.greenfield_material_lower_bound_qty plant_inputsNodup
    (b := copperLode) (by decide) copperOre (shopYard copperOre) l s hq hOK hs hmade
    (hfin copperOre (by decide))
  simp only [rd_ironOre, rd_coal, rd_limestone, rd_silicaSand, rd_crudeOil, rd_latex,
    rd_copperOre, ind_self, mul_one, one_mul, shopYard] at h1 h2 h3 h4 h5 h6 h7
  unfold groundTotal
  norm_num at h1 h2 h3 h4 h5 h6 h7 ⊢
  linarith

/-- **9261.33 kg, and not a kilogram less.**  The eleven-run plan opens the
face to exactly the tonnage of the bound, so the bound is attained. -/
theorem pitYard_groundTotal : groundTotal pitYard = 92613280171/10000000 := by
  decide +kernel

/-- The pit's own minimality statement, both halves together. -/
theorem minimal_pit_ground :
    groundTotal pitYard = 92613280171/10000000 ∧
    (∀ (l : List (Item × ℚ)) (s : Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) → plant.PlanOK l s →
      (∀ x, 0 ≤ s x) → (∀ x, plant.recipe x ≠ none → s x = 0) →
      (∀ i ∈ products, shopYard i ≤ plant.runPlan l s i) →
      groundTotal pitYard ≤ groundTotal s) := by
  refine ⟨pitYard_groundTotal, fun l s hq hOK hs hmade hfin => ?_⟩
  rw [pitYard_groundTotal]
  exact pit_groundTotal_ge l s hq hOK hs hmade hfin

/-! ## The machine time -/

/-- **10.39 hours at the face.**  That is what the tractor spends ripping,
crushing, screening, drilling and tapping to win the whole greenfield yard —
its own materials and those of the nine tools the shop builds for itself. -/
theorem pit_hours : hours Workflow.minStock = 10392905541/1000000000 := by
  rw [hours]
  rw [Workflow.minStock_ironOre, Workflow.minStock_coal, Workflow.minStock_limestone,
    Workflow.minStock_silicaSand, Workflow.minStock_crudeOil, Workflow.minStock_latex,
    Workflow.minStock_copperOre]
  simp only [lf_ironOre, lf_coal, lf_limestone, lf_silicaSand, lf_crudeOil, lf_latex,
    lf_copperOre]
  norm_num

/-- Two days at the face — comfortably under two working days — win everything
the shop needs. -/
theorem pit_hours_lt_16 : hours Workflow.minStock < 16 := by
  rw [pit_hours]; norm_num

/-! ## The whole bootstrap, both stages -/

/-- **Sixty-three runs from bare ground to a finished tractor.**  Eleven in the
pit, which take 9261.33 kg out of the ground and put the shop's 7529.35 kg
greenfield yard on the stockpile; then fifty-two in the shop, which turn that
yard into one LifeTrac.  Neither half can be done in fewer. -/
theorem whole_bootstrap_minimum :
    -- the pit: eleven admissible runs delivering the shop's yard
    (plant.PlanOK pitPlan pitYard ∧
      (∀ i ∈ products, plant.runPlan pitPlan pitYard i = shopYard i)) ∧
    -- the shop: fifty-two admissible runs delivering the tractor
    (Workflow.plant.PlanOK Workflow.minimalPlan Workflow.minStock ∧
      Workflow.plant.runPlan Workflow.minimalPlan Workflow.minStock Workflow.Item.lifeTrac = 1) ∧
    -- sixty-three runs in all
    pitPlan.length + Workflow.minimalPlan.length = 63 ∧
    -- and neither half admits a shorter plan
    (∀ (l : List (Item × ℚ)) (s : Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) → plant.PlanOK l s →
      (∀ x, 0 < s x → plant.recipe x = none) → (∀ t ∈ products, 0 < plant.runPlan l s t) →
      11 ≤ l.length) ∧
    (∀ (l : List (Workflow.Item × ℚ)) (s : Workflow.Item → ℚ), (∀ p ∈ l, 0 ≤ p.2) →
      Workflow.plant.PlanOK l s → (∀ x, 0 < s x → Workflow.plant.recipe x = none) →
      0 < Workflow.plant.runPlan l s Workflow.Item.lifeTrac → 52 ≤ l.length) :=
  ⟨⟨pitPlan_ok, pitPlan_delivers⟩,
   ⟨Workflow.minimalPlan_ok, Workflow.minimalPlan_builds⟩,
   by rw [pitPlan_length, Workflow.minimalPlan_length],
   pit_steps_ge_11,
   Workflow.greenfield_steps_ge_52⟩

end Mining
end LifeTrac
