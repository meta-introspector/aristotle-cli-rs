import RequestProject.Gvcs.Mining

/-!
# The pit and the shop: what it costs the machine to feed itself

`RequestProject/Mining.lean` describes the pit; `RequestProject/Bootstrap.lean`
says how much raw material the shop needs.  This file puts the two together.

`order` turns a raw-material demand of the *shop* into an order on the *pit*,
and `hours` into the machine time it takes to fill it.  Applied to the
raw-material demand of one LifeTrac, of the mining kit and of the nine
shop-built tools, that answers the question the whole exercise was for:

* one machine needs **5850.79 kg** moved out of the ground, and **7.66 hours**
  of machine time at the face to move it — under a single working day
  (`tractor_mined_in_a_day`);
* the mining kit itself costs another 4818.81 kg and 5.04 hours, and the
  shop-built tools 3410.53 kg and 2.74 hours, so the whole undertaking —
  equip the shop, build the mining kit, build the tractor — is
  **14 080.13 kg** of ground and **15.44 hours** at the face
  (`whole_bootstrap`);
* against 841.03 hours in the shop, mining is under two per cent of the work
  (`mining_is_two_percent_of_the_work`).

Finally, `pit_plan_works` runs the pit for real: starting with nothing but the
deposits and one of each device, the production plan for an order of ore is
admissible at every step and ends with the ore on the stockpile.
-/

namespace LifeTrac
namespace Mining

open Item

set_option maxRecDepth 8000

/-! ## Turning a demand of the shop into an order on the pit -/

/-- The order the shop's raw-material demand `d` places on the pit, deposit by
deposit. -/
def order (d : Workflow.Item → ℚ) (x : Item) : ℚ :=
  plant.rawDemand ironOre (d Workflow.Item.ironOre) x +
    plant.rawDemand coal (d Workflow.Item.coal) x +
    plant.rawDemand limestone (d Workflow.Item.limestone) x +
    plant.rawDemand silicaSand (d Workflow.Item.silicaSand) x +
    plant.rawDemand crudeOil (d Workflow.Item.crudeOil) x +
    plant.rawDemand latex (d Workflow.Item.latex) x +
    plant.rawDemand copperOre (d Workflow.Item.copperOre) x

/-- The machine time, in hours, of filling that order. -/
def hours (d : Workflow.Item → ℚ) : ℚ :=
  plant.laborFor ironOre (d Workflow.Item.ironOre) +
    plant.laborFor coal (d Workflow.Item.coal) +
    plant.laborFor limestone (d Workflow.Item.limestone) +
    plant.laborFor silicaSand (d Workflow.Item.silicaSand) +
    plant.laborFor crudeOil (d Workflow.Item.crudeOil) +
    plant.laborFor latex (d Workflow.Item.latex) +
    plant.laborFor copperOre (d Workflow.Item.copperOre)

/-- Twice the order is twice the digging. -/
theorem order_smul (d : Workflow.Item → ℚ) (c : ℚ) (x : Item) :
    order (fun y => c * d y) x = c * order d x := by
  simp only [order, rd_ironOre, rd_coal, rd_limestone, rd_silicaSand, rd_crudeOil, rd_latex,
    rd_copperOre]
  ring

/-- … and twice the machine time. -/
theorem hours_smul (d : Workflow.Item → ℚ) (c : ℚ) : hours (fun y => c * d y) = c * hours d := by
  simp only [hours, lf_ironOre, lf_coal, lf_limestone, lf_silicaSand, lf_crudeOil, lf_latex,
    lf_copperOre]
  ring

theorem hours_nonneg {d : Workflow.Item → ℚ} (hd : ∀ y, 0 ≤ d y) : 0 ≤ hours d := by
  have h1 := hd Workflow.Item.ironOre
  have h2 := hd Workflow.Item.coal
  have h3 := hd Workflow.Item.limestone
  have h4 := hd Workflow.Item.silicaSand
  have h5 := hd Workflow.Item.crudeOil
  have h6 := hd Workflow.Item.latex
  have h7 := hd Workflow.Item.copperOre
  simp only [hours, lf_ironOre, lf_coal, lf_limestone, lf_silicaSand, lf_crudeOil, lf_latex,
    lf_copperOre]
  positivity

/-! ## One machine -/

/-- The order one LifeTrac places on the pit. -/
def tractorOrder : Item → ℚ := order (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1)

/-- The machine time of digging the materials for one LifeTrac. -/
def tractorHours : ℚ := hours (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1)

/-- **What one tractor takes out of the ground.**  3442.80 kg from the ore
body, 1465.57 kg from the coal seam, 566.52 kg from the limestone ledge,
61.36 kg from the sand bank, 95.14 kg from the oil seep, 148.84 kg of field
latex from the grove and 70.56 kg from the copper lode. -/
theorem tractorOrder_values :
    tractorOrder oreBody = 860701107/250000 ∧
    tractorOrder coalSeam = 183195639/125000 ∧
    tractorOrder limestoneLedge = 2832617923/5000000 ∧
    tractorOrder sandBank = 1534/25 ∧
    tractorOrder oilSeep = 11893/125 ∧
    tractorOrder rubberGrove = 11907/80 ∧
    tractorOrder copperLode = 1764/25 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    · simp [tractorOrder, order, ind, Workflow.ind]
      norm_num

/-- **5850.79 kg of ground for one machine** — a fifth more than the 4760.96 kg
of clean raw material it needs, the difference being fines, screen rejects and
still bottoms. -/
theorem tractorOrder_groundTotal : groundTotal tractorOrder = 29253973123/5000000 := by
  simp [groundTotal, tractorOrder, order, ind, Workflow.ind]
  norm_num

/-- More comes out of the pit than reaches the shop. -/
theorem groundTotal_gt_rawTotal :
    Workflow.rawTotal (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1) <
      groundTotal tractorOrder := by
  rw [Workflow.lifeTrac_rawTotal, tractorOrder_groundTotal]; norm_num

/-- **Nearly four kilograms of ground for every kilogram of tractor.**  The
finished machine masses 1539.7 kg. -/
theorem groundTotal_gt_three_times_mass :
    3 * Build.lifeTrac.mass < groundTotal tractorOrder := by
  rw [Build.lifeTrac_mass, tractorOrder_groundTotal]; norm_num

/-- **7.655 hours at the face.**  That is what the machine spends ripping,
crushing, screening, tapping and hauling for one more machine. -/
theorem tractorHours_eq : tractorHours = 3827725433/500000000 := by
  simp [tractorHours, hours, Workflow.ind]
  norm_num

/-- **One working day digs the next tractor.**  Eight hours at the face wins
every kilogram of ore, coal, limestone, sand, oil, latex and copper that the
next machine needs. -/
theorem tractor_mined_in_a_day : tractorHours < 8 := by
  rw [tractorHours_eq]; norm_num

/-- **Mining is the cheap part.**  Digging the materials for a machine is
about two per cent of the work: forty-eight times the hours at the face is
still less than the 370.52 hours of shop work that turns the material into a
tractor. -/
theorem mining_is_two_percent_of_the_work :
    48 * tractorHours < Workflow.plant.laborFor Workflow.Item.lifeTrac 1 := by
  rw [tractorHours_eq, Workflow.lifeTrac_laborFor]; norm_num

/-! ## The mining kit and the shop's own tools -/

/-- The order the mining kit places on the pit. -/
noncomputable def kitOrder : Item → ℚ := order Workflow.Attachment.kitDemand

/-- The machine time of digging the materials for the mining kit. -/
noncomputable def kitHours : ℚ := hours Workflow.Attachment.kitDemand

/-- The order the nine shop-built tools place on the pit. -/
noncomputable def shopOrder : Item → ℚ := order Workflow.shopDemand

/-- The machine time of digging the materials for the nine shop-built tools. -/
noncomputable def shopHours : ℚ := hours Workflow.shopDemand

/-- The mining kit costs 4818.81 kg of ground and 5.04 hours at the face. -/
theorem kit_values :
    groundTotal kitOrder = 19275223517/4000000 ∧ kitHours = 2017094207/400000000 := by
  constructor
  · simp [groundTotal, kitOrder, order, ind, Workflow.Attachment.kitDemand,
      Workflow.Attachment.demand, Workflow.Attachment.all, Workflow.Attachment.recipe,
      Workflow.ind]
    norm_num
  · simp [kitHours, hours, Workflow.Attachment.kitDemand, Workflow.Attachment.demand,
      Workflow.Attachment.all, Workflow.Attachment.recipe, Workflow.ind]
    norm_num

/-- The nine shop-built tools cost 3410.53 kg of ground and 2.74 hours at the
face. -/
theorem shop_values :
    groundTotal shopOrder = 1364213357/400000 ∧ shopHours = 109498187/40000000 := by
  constructor
  · simp [groundTotal, shopOrder, order, ind, Workflow.shopDemand, Workflow.ind]
    norm_num
  · simp [shopHours, hours, Workflow.shopDemand, Workflow.ind]
    norm_num

/-- **The whole undertaking, dug by the machine itself.**  Equipping the shop,
building the mining kit and building the tractor takes 14 080.13 kg out of the
ground and 15.44 hours at the face — against 841.03 hours in the shop. -/
theorem whole_bootstrap :
    groundTotal shopOrder + groundTotal kitOrder + groundTotal tractorOrder =
        281602677927/20000000 ∧
      shopHours + kitHours + tractorHours = 30871282117/2000000000 ∧
      Workflow.shopLabor + Workflow.Attachment.kitLabor +
        Workflow.plant.laborFor Workflow.Item.lifeTrac 1 = 4205182431/5000000 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [shop_values.1, kit_values.1, tractorOrder_groundTotal]; norm_num
  · rw [shop_values.2, kit_values.2, tractorHours_eq]; norm_num
  · rw [Workflow.shopLabor_eq, Workflow.Attachment.kitLabor_eq, Workflow.lifeTrac_laborFor]
    norm_num

/-- Mining the whole undertaking is under two per cent of the work of building
it. -/
theorem mining_under_two_percent :
    50 * (shopHours + kitHours + tractorHours) <
      Workflow.shopLabor + Workflow.Attachment.kitLabor +
        Workflow.plant.laborFor Workflow.Item.lifeTrac 1 := by
  rw [whole_bootstrap.2.1, whole_bootstrap.2.2]; norm_num


/-! ## The capstone: nothing but what we built -/

/-- **Every device in the pit came out of the bootstrap.**  The ten devices the
pit is worked with are the LifeTrac and the nine attachments of the mining kit;
the tractor is producible by the fabrication system from raw materials and the
seed toolkit, and every attachment is made of materials that same system makes
for itself, on tools the shop already owns.  Nothing in the pit is bought
in. -/
theorem devices_come_from_the_bootstrap :
    (∀ x ∈ devices, x = tractor ∨ ∃ a : Workflow.Attachment, Item.ofAttachment a = x) ∧
      Workflow.plant.Producible Workflow.Item.lifeTrac ∧
      (∀ a : Workflow.Attachment,
        (∀ p ∈ (Workflow.Attachment.recipe a).inputs, Workflow.plant.Producible p.1) ∧
        (∀ t ∈ (Workflow.Attachment.recipe a).tools,
          t ∈ Workflow.Item.seedToolkit ∨ t ∈ Workflow.Item.shopTools)) := by
  refine ⟨by decide, Workflow.producible _, fun a => ⟨?_, ?_⟩⟩
  · exact Workflow.Attachment.kit_inputs_producible a
  · exact Workflow.Attachment.kit_needs_no_new_plant a

/-- **The ore comes out of the ground with the machines we built, and nothing
else.**  Every one of the seven raw materials the shop needs is producible in
the pit; every tool any pit workflow uses is one of the ten devices; and every
one of those devices is the tractor or a piece of its mining kit. -/
theorem ore_is_mined_with_our_own_machines :
    (∀ i ∈ products, plant.Producible i) ∧
      (∀ i r, plant.recipe i = some r → ∀ t ∈ r.tools, t ∈ devices) ∧
      devices = tractor :: Workflow.Attachment.all.map Item.ofAttachment :=
  ⟨fun i _ => producible i, mining_uses_only_built_devices, Item.devices_eq⟩

/-! ## Running the pit -/

/-- One of each device, and nothing else: the yard as the bootstrap leaves
it. -/
def deviceStock (x : Item) : ℚ := if x ∈ devices then 1 else 0

theorem deviceStock_nonneg (x : Item) : 0 ≤ deviceStock x := by
  unfold deviceStock; split <;> norm_num

theorem deviceStock_of_mem {x : Item} (h : x ∈ devices) : deviceStock x = 1 := if_pos h

theorem deviceStock_of_product {x : Item} (h : x ∈ products) : deviceStock x = 0 := by
  revert h; revert x; decide

/-- The stock the pit starts with: the deposits it is going to work, and one
of each device. -/
noncomputable def pitStock (i : Item) (q : ℚ) (x : Item) : ℚ :=
  plant.rawDemand i q x + deviceStock x

/-- Every tool the pit uses is a device, so the yard holds one of it. -/
theorem isTool_mem_devices {t : Item} (ht : plant.IsTool t) : t ∈ devices := by
  obtain ⟨j, r, hj, hr⟩ := ht
  exact mining_uses_only_built_devices j r hj t hr

/-- **The pit runs.**  Starting from a working face holding exactly the
deposit demand of the order, and a yard holding one of each of the ten devices
the bootstrap produced, the production plan for any order of ore is admissible
at every single step — nothing is missing, nothing has to be bought in — and
when the last step is done the ore is on the stockpile. -/
theorem pit_plan_works (i : Item) (hi : i ∈ products) {q : ℚ} (hq : 0 ≤ q) :
    plant.PlanOK (plant.plan i q) (pitStock i q) ∧
      q ≤ plant.runPlan (plant.plan i q) (pitStock i q) i := by
  have hs : ∀ x, plant.rawDemand i q x ≤ pitStock i q x := by
    intro x
    have := deviceStock_nonneg x
    simp only [pitStock]
    linarith
  have htool : ∀ t, plant.IsTool t → 1 ≤ pitStock i q t := by
    intro t ht
    have h1 : deviceStock t = 1 := deviceStock_of_mem (isTool_mem_devices ht)
    have h2 : 0 ≤ plant.rawDemand i q t := plant.rawDemand_nonneg hq t
    simp only [pitStock, h1]
    linarith
  obtain ⟨h1, h2⟩ := plant.plan_produces plant_toolsNotConsumed i hq (pitStock i q) hs htool
  refine ⟨h1, ?_⟩
  have hzero : plant.rawDemand i q i = 0 := by
    have : plant.recipe i ≠ none := by
      have := products_have_recipe i hi
      exact fun h => by simp [h] at this
    exact plant.rawDemand_eq_zero_of_made this i q
  simp only [pitStock, hzero, deviceStock_of_product hi] at h2 ⊢
  linarith

/-- The plan for an order of ore never asks for a negative quantity. -/
theorem pit_plan_qty_nonneg (i : Item) {q : ℚ} (hq : 0 ≤ q) : ∀ p ∈ plant.plan i q, 0 ≤ p.2 :=
  plant.plan_qty_nonneg i q hq

/-- **The iron for one tractor, dug by the tractor.**  The plan for the
2623.09 kg of iron ore that one machine needs runs to completion from the ore
body and the kit alone. -/
theorem iron_for_one_tractor_plan_works :
    plant.PlanOK (plant.plan ironOre (40985767/15625))
        (pitStock ironOre (40985767/15625)) ∧
      (40985767/15625 : ℚ) ≤
        plant.runPlan (plant.plan ironOre (40985767/15625))
          (pitStock ironOre (40985767/15625)) ironOre :=
  pit_plan_works ironOre (by decide) (by norm_num)

end Mining
end LifeTrac
