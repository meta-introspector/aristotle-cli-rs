import RequestProject.Gvcs.Civilization

set_option maxRecDepth 1000000

/-!
# The production ecosystem: the claims of "The Geometry of Industry", checked

`RequestProject/Civilization.lean` turns the bootstrap into a game with four
players.  This file states, and proves, the specific claims an essay about that
game would want to make, so that none of them has to be taken on trust.

* **Repackaging.**  A production run and a shipment leave the raw-material
  content of the world exactly where it was (`make_conserves_raw`,
  `ship_conserves_raw`); only mining adds to it.  Over the whole game the raw
  material embodied in the four yards is therefore precisely what came out of
  the deposits (`civPlan_worldRaw_eq_dug`, `civPlan_worldRaw_rawTotal`).

* **The bill.**  One tractor's raw-material demand, material by material, is
  the table of `lifeTrac_rawDemand`; it weighs 4760.96 kg
  (`lifeTrac_rawDemand_rawTotal`).  This is the demand of the machine itself;
  the game digs more (7529.35 kg) because the shop must also build its own
  tools.

* **The census.**  The 195 moves of `civPlan` split as 7 mining moves, 52
  production runs and 136 deliveries (`civPlan_move_census`).

* **The chemist.**  What the chemist makes, out of what, with which tools
  (`chemist_kit_eq`, `chemist_makes`, `chemist_recipes`), that the chemist is
  the only player who touches crude oil or latex
  (`organics_only_chemist`), and that without the chemist
  the tractor is unreachable however much material and labour the others have
  (`chemist_indispensable`).

* **Tools stay home.**  No move of the game ships a piece of equipment
  (`civPlan_ships_no_tools`), no workflow eats one (`seedToolkit_not_input`),
  and so every player ends the game holding exactly the kit they started with
  (`civPlan_tools_stay_put`).
-/

namespace LifeTrac
namespace Workflow

open Item Player

/-! ## Manufacturing and trade are zero-sum in raw material -/

/-- **A production run creates nothing.**  Running a workflow leaves the raw
material embodied in the world exactly as it was: it only repackages it. -/
theorem make_conserves_raw (b : Item) (w : World) (p : Player) (i : Item) (q : ℚ)
    (hm : MoveOK w (Move.make p i q)) :
    worldRaw b (w.apply (Move.make p i q)) = worldRaw b w := by
  have h := worldRaw_apply b w (Move.make p i q) hm
  have hdug : (w.apply (Move.make p i q)).dug = w.dug := rfl
  rw [hdug] at h
  linarith

/-- **A shipment creates nothing.**  Trade moves raw-material content from one
player to another and changes no total. -/
theorem ship_conserves_raw (b : Item) (w : World) (a c : Player) (x : Item) (q : ℚ)
    (hm : MoveOK w (Move.ship a c x q)) :
    worldRaw b (w.apply (Move.ship a c x q)) = worldRaw b w := by
  have h := worldRaw_apply b w (Move.ship a c x q) hm
  have hdug : (w.apply (Move.ship a c x q)).dug = w.dug := rfl
  rw [hdug] at h
  linarith

/-- **Nothing is lost and nothing is gained.**  At the end of the game the raw
material of each kind sitting in the four yards — inside ore, inside steel,
inside the tractor — is exactly what was taken out of the ground. -/
theorem civPlan_worldRaw_eq_dug {b : Item} (hb : b ∈ rawMaterials) :
    worldRaw b (start.run civPlan) = (start.run civPlan).dug b := by
  have h := worldRaw_run b civPlan start civPlan_legal
  rw [start_worldRaw hb] at h
  have hdug : start.dug b = 0 := rfl
  rw [hdug] at h
  linarith

/-- **The invariant mass of the game, material by material.** -/
theorem civPlan_worldRaw_table :
    worldRaw ironOre (start.run civPlan) = 132262859/31250 ∧
    worldRaw coal (start.run civPlan) = 26838099/12500 ∧
    worldRaw limestone (start.run civPlan) = 397188577/500000 ∧
    worldRaw silicaSand (start.run civPlan) = 351/5 ∧
    worldRaw crudeOil (start.run civPlan) = 1789/25 ∧
    worldRaw latex (start.run civPlan) = 567/4 ∧
    worldRaw copperOre (start.run civPlan) = 72 :=
  ⟨(civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_ironOre,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_coal,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_limestone,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_silicaSand,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_crudeOil,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_latex,
   (civPlan_worldRaw_eq_dug (by decide)).trans civPlan_dug_copperOre⟩

/-- **7529.35 kg, still there at the end.**  The raw material embodied in what
the four players hold when the tractor is finished weighs exactly what was
mined. -/
theorem civPlan_worldRaw_rawTotal :
    rawTotal (fun b => worldRaw b (start.run civPlan)) = 3764673281/500000 := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := civPlan_worldRaw_table
  simp only [rawTotal, h1, h2, h3, h4, h5, h6, h7]
  norm_num

/-! ## The bill for one tractor -/

/-- **4760.96 kg.**  The raw-material demand of a single LifeTrac — the table
of `lifeTrac_rawDemand` added up.  It is less than the 7529.35 kg the game digs
(`civPlan_rawTotal`), the difference being the ore that goes into the nine
tools the shop has to build for itself. -/
theorem lifeTrac_rawDemand_rawTotal :
    rawTotal (plant.rawDemand lifeTrac 1) = 1190240053/250000 := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := lifeTrac_rawDemand
  unfold rawTotal
  rw [h1, h2, h3, h4, h5, h6, h7]
  norm_num

/-- The tractor's own demand really is lighter than what the game digs. -/
theorem lifeTrac_rawDemand_lt_civPlan :
    rawTotal (plant.rawDemand lifeTrac 1) < rawTotal (start.run civPlan).dug := by
  rw [lifeTrac_rawDemand_rawTotal, civPlan_rawTotal]
  norm_num

/-! ## The census of the 195 moves -/

/-- **Seven mining moves, fifty-two production runs, a hundred and thirty-six
deliveries.**  That is the whole of the game. -/
theorem civPlan_move_census :
    (civPlan.countP fun m => match m with | .mine _ _ _ => true | _ => false) = 7 ∧
    (civPlan.countP fun m => match m with | .make _ _ _ => true | _ => false) = 52 ∧
    (civPlan.countP fun m => match m with | .ship _ _ _ _ => true | _ => false) = 136 := by
  refine ⟨by decide +kernel, by decide +kernel, by decide +kernel⟩

/-! ## The chemist -/

/-- The chemist's kit: the refinery, the copper smelter and the rubber mill. -/
theorem chemist_kit_eq : chemist.kit = [refinery, copperSmelter, rubberMill] := rfl

/-- **What the chemist makes**: plastic, oil, rubber, copper and hose — the
five workflows that bridge the raw hydrocarbons and organics to industrial
stock. -/
theorem chemist_makes :
    madeBy chemist = [plasticStock, oilStock, rubberStock, copperStock, hose] := by
  decide +kernel

/-- **The chemist's recipes**, with their inputs and their tools: plastic and
lubricating oil out of crude oil at the refinery, rubber out of latex and coal
at the rubber mill, copper out of copper ore at the copper smelter, and
hydraulic hose out of rubber and wire rod. -/
theorem chemist_recipes :
    plant.recipe plasticStock = some ⟨1, [(crudeOil, 6/5)], [refinery], 1/100⟩ ∧
    plant.recipe oilStock = some ⟨1, [(crudeOil, 13/10)], [refinery], 1/100⟩ ∧
    plant.recipe rubberStock = some ⟨1, [(latex, 9/10), (coal, 1/20)], [rubberMill], 1/50⟩ ∧
    plant.recipe copperStock = some ⟨1, [(copperOre, 8)], [copperSmelter], 1/20⟩ ∧
    plant.recipe hose = some ⟨1, [(rubberStock, 3/4), (wireRod, 1/5)], [rubberMill], 1/20⟩ := by
  refine ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **The chemist is the sole consumer of the organic and hydrocarbon
inputs.**  Any workflow that eats crude oil or latex belongs to the chemist. -/
theorem organics_only_chemist (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ p ∈ r.inputs, 0 < p.2 → (p.1 = crudeOil ∨ p.1 = latex) → owner i = chemist := by
  revert i r h; decide +kernel

/-- **No chemist, no tractor.**  Give every other player unlimited raw
material, all the other kits and as long as they like: without the chemist's
three machines the LifeTrac is unreachable. -/
theorem chemist_indispensable (C : List Player) (hno : chemist ∉ C)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 < s x → x ∈ rawMaterials ∨ ∃ p ∈ C, x ∈ p.kit) :
    plant.runPlan l s lifeTrac ≤ 0 :=
  incomplete_coalition_cannot C (Or.inr (Or.inl hno)) l s hq hOK hs

/-! ## Tools stay home -/

/-- **No workflow eats a machine.**  No seed tool appears as an input to any
recipe; tools are used, never used up. -/
theorem seedToolkit_not_input (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ p ∈ r.inputs, p.1 ∉ seedToolkit := by
  revert i r h; decide

/-- A deposit is not a machine. -/
theorem rawMaterials_not_seedToolkit : ∀ x ∈ rawMaterials, x ∉ seedToolkit := by decide

/-- A production run leaves the stock of a seed tool alone. -/
theorem step_tool_eq {t : Item} (ht : t ∈ seedToolkit) (i : Item) (q : ℚ) (s : Item → ℚ) :
    plant.step i q s t = s t := by
  cases hr : plant.recipe i with
  | none => rw [Plant.step, hr]
  | some r =>
      have hti : t ≠ i := by
        intro hti
        subst hti
        rw [seedToolkit_base t ht] at hr
        exact absurd hr.symm (Option.some_ne_none r)
      have hused : Plant.usedQty r q t = 0 := by
        refine List.sum_eq_zero ?_
        intro z hz
        simp only [List.mem_map] at hz
        obtain ⟨p, hp, rfl⟩ := hz
        have hne : t ≠ p.1 := by
          intro hh
          exact (seedToolkit_not_input i r hr p hp) (hh ▸ ht)
        simp [hne]
      rw [Plant.step, hr]
      simp [hused, hti]

/-- A move that is not a shipment of `t` leaves everyone's stock of the seed
tool `t` alone. -/
theorem apply_tool_eq {t : Item} (ht : t ∈ seedToolkit) (w : World) (m : Move)
    (hm : MoveOK w m) (hship : ∀ a c x q, m = Move.ship a c x q → x ≠ t) :
    ∀ p, (w.apply m).stock p t = w.stock p t := by
  cases m with
  | mine p b q =>
      obtain ⟨rfl, hb, _⟩ := hm
      intro p'
      have hbt : t ≠ b := by
        intro hbt
        exact rawMaterials_not_seedToolkit b hb (hbt ▸ ht)
      simp [World.apply, hbt]
  | make p i q =>
      intro p'
      simp only [World.apply]
      by_cases hp : p' = p
      · rw [if_pos hp, hp, step_tool_eq ht]
      · rw [if_neg hp]
  | ship a c x q =>
      intro p'
      have hxt : t ≠ x := Ne.symm (hship a c x q rfl)
      simp [World.apply, hxt]

/-- **Equipment never changes hands.**  Along a history in which no shipment
carries the seed tool `t`, every player's holding of `t` is unchanged. -/
theorem run_tool_eq {t : Item} (ht : t ∈ seedToolkit) :
    ∀ (ms : List Move) (w : World), MovesOK w ms →
      (∀ m ∈ ms, ∀ a c x q, m = Move.ship a c x q → x ≠ t) →
      ∀ p, (w.run ms).stock p t = w.stock p t := by
  intro ms
  induction ms with
  | nil => intro w _ _ p; rfl
  | cons m ms ih =>
      intro w h hship p
      rw [World.run_cons,
        ih _ h.2 (fun m' hm' => hship m' (List.mem_cons_of_mem _ hm')) p,
        apply_tool_eq ht w m h.1 (hship m (List.mem_cons_self ..)) p]

/-- **The game never ships a machine.**  Every delivery of `civPlan` carries
material, not equipment. -/
theorem civPlan_ships_no_tools :
    ∀ m ∈ civPlan, ∀ a c x q, m = Move.ship a c x q → x ∉ seedToolkit := by
  have h : civPlan.all (fun m => match m with
      | Move.ship _ _ x _ => !(seedToolkit.contains x)
      | _ => true) = true := by decide +kernel
  intro m hm a c x q hmeq
  have hm' := List.all_eq_true.1 h m hm
  subst hmeq
  simpa using hm'

/-- **Tools stay home, over the whole game.**  After all 195 moves each player
still holds exactly the kit they started with: the materials rotated through
the yards, the machines did not move. -/
theorem civPlan_tools_stay_put (p : Player) (t : Item) (ht : t ∈ seedToolkit) :
    (start.run civPlan).stock p t = if t ∈ p.kit then 1 else 0 := by
  have hship : ∀ m ∈ civPlan, ∀ a c x q, m = Move.ship a c x q → x ≠ t := by
    intro m hm a c x q hmeq hxt
    exact civPlan_ships_no_tools m hm a c x q hmeq (hxt ▸ ht)
  rw [run_tool_eq ht civPlan start civPlan_legal hship p]
  rfl

end Workflow
end LifeTrac
