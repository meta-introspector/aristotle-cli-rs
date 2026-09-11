import RequestProject.Gvcs.Minimal

set_option maxRecDepth 1000000

/-!
# The bootstrap as a game with several players

The rest of the project treats the bootstrap as one shop's problem.  This file
turns it into a **game**: a world with several players, each holding a
different kit of equipment, who mine, manufacture and ship things to one
another, and who between them have to get a LifeTrac built.

* A `World` records what each player has on the shelf and how much has been
  taken out of the ground so far.  A `Move` is one of three things: a player
  **mines** raw material from the deposits, a player **makes** something with a
  workflow of `RequestProject/Fabrication.lean` on their own stock and their
  own tools, or a player **ships** goods to another player.  `MoveOK` says when
  a move is legal — you cannot mine what is not there, run a process you have
  no tools for, or ship what you do not have.

* Four players: the **miner**, who holds the deposits; the **smelter**, who
  holds the furnace line, the mills and the foundry; the **chemist**, who holds
  the refinery, the copper smelter and the rubber mill; and the **machinist**,
  who holds the lathe, the milling machine, the welder and hand tools, and who
  builds the nine tools the shop needs for itself.  `owner` says who makes
  what, and `tools_stay_home` is the theorem that makes the division of labour
  work: every tool a workflow calls for belongs to the player who runs it, so
  no equipment ever has to change hands — only materials do.

* `civPlan` is the actual game: mine the seven deposits, then work through the
  fifty-two workflows of `RequestProject/Minimal.lean`, each player shipping
  its output on to whoever needs it next.  It is proved legal move by move,
  and it ends with a tractor in the machinist's yard.

* **You cannot do it alone.**  Give a single player unlimited raw material and
  every one of the seven deposits, and they still cannot build the tractor:
  the set of things their kit can make is closed and does not contain it
  (`smelter_alone_cannot`, `chemist_alone_cannot`, `machinist_alone_cannot`).
  Nor can any *two* of the three trades between them
  (`two_trades_cannot`) — all three kits are needed, which is why the game has
  the players it has.

* **And you cannot cheat the ground.**  However the labour is divided and
  however the goods move, the amount taken out of the deposits by the end is
  at least the raw-material demand of the tractor
  (`civilization_material_bound`): the bound of `RequestProject/Bounds.lean`
  survives the introduction of trade.
-/

namespace LifeTrac
namespace Workflow

open Item

/-! ## The players -/

/-- The four parties to the bootstrap. -/
inductive Player where
  | miner | smelter | chemist | machinist
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Player

/-- The equipment each player starts with.  The miner starts with nothing but
the deposits; the other three hold the seed toolkit between them. -/
def kit : Player → List Item
  | miner => []
  | smelter => [cokeOven, blastFurnace, inductionFurnace, rollingMill, tubeMill, foundry]
  | chemist => [refinery, copperSmelter, rubberMill]
  | machinist => [machineLathe, millingMachine, migWelder, handTools]

end Player

open Player

/-- Who makes, and holds, each item. -/
def owner : Item → Player
  -- the deposits
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre => miner
  -- the seed toolkit, with its holders
  | cokeOven | blastFurnace | inductionFurnace | rollingMill | tubeMill | foundry => smelter
  | refinery | copperSmelter | rubberMill => chemist
  | machineLathe | millingMachine | migWelder | handTools => machinist
  -- the furnace line and the mills
  | coke | pigIron | steel | hotStrip | barStock | wireRod | castIron | tubeStock => smelter
  -- the chemical, rubber and copper streams
  | plasticStock | oilStock | rubberStock | copperStock | hose => chemist
  -- the tools the shop builds for itself
  | weldingTable | cutoffSaw | drillPress | torchTable | pressBrake | arborPress
  | ironworker | wireDrawBench | blendingTank => machinist
  -- everything else is machined, fabricated and assembled by the machinist
  | steelTube4 | steelTube3 | steelTube2 | steelPlate6 | steelPlate12 | roundBar50
  | boltM12 | nutM12 | weldWire | fitting | fluid | gearPump | wheelMotor
  | cylinder | controlValve | engine | fuelTank | hydraulicTank | wheelHub | tire
  | seat | paint | electricalKit => machinist
  | frame | wheelModule | powerUnit | controlStation | loader | finishing | lifeTrac => machinist

/-- Every seed tool is in the kit of the player who holds it, and no tool is in
two kits. -/
theorem kit_owner : ∀ t ∈ seedToolkit, ∀ p : Player, t ∈ p.kit ↔ p = owner t := by decide

/-- The seed toolkit is exactly the three kits put together. -/
theorem kits_cover_seedToolkit :
    ∀ i : Item, i ∈ seedToolkit ↔ ∃ p : Player, i ∈ p.kit := by decide

/-- The deposits belong to the miner. -/
theorem owner_rawMaterials : ∀ b ∈ rawMaterials, owner b = miner := by decide

/-- **The division of labour is consistent.**  Every tool that a workflow calls
for belongs to the very player who runs that workflow, so no equipment ever
has to change hands: the players trade materials, not machines. -/
theorem tools_stay_home (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ t ∈ r.tools, owner t = owner i := by
  revert i r h; decide

/-! ## The world and its moves -/

/-- A state of the game: what each player has on the shelf, and how much has
been taken out of the deposits so far. -/
structure World where
  /-- Each player's own stock. -/
  stock : Player → Item → ℚ
  /-- Cumulative extraction from the deposits, by material. -/
  dug : Item → ℚ

/-- The three things a player can do. -/
inductive Move where
  /-- Take raw material out of the ground. -/
  | mine (p : Player) (b : Item) (q : ℚ)
  /-- Run a workflow on one's own stock, with one's own tools. -/
  | make (p : Player) (i : Item) (q : ℚ)
  /-- Send goods to another player. -/
  | ship (source target : Player) (x : Item) (q : ℚ)

/-- The world after a move. -/
def World.apply (w : World) : Move → World
  | .mine p b q =>
      { stock := fun p' x => w.stock p' x + (if p' = p then (if x = b then q else 0) else 0),
        dug := fun x => w.dug x + (if x = b then q else 0) }
  | .make p i q =>
      { stock := fun p' => if p' = p then plant.step i q (w.stock p) else w.stock p',
        dug := w.dug }
  | .ship a c x q =>
      { stock := fun p' y =>
          w.stock p' y - (if p' = a then (if y = x then q else 0) else 0)
            + (if p' = c then (if y = x then q else 0) else 0),
        dug := w.dug }

/-- When a move is legal: only the miner may work the deposits, and only for
raw material; a workflow needs its inputs and its tools in the player's own
stock; and nobody may ship what they have not got. -/
def MoveOK (w : World) : Move → Prop
  | .mine p b q => p = miner ∧ b ∈ rawMaterials ∧ 0 ≤ q
  | .make p i q => 0 ≤ q ∧ plant.StepOK i q (w.stock p)
  | .ship a _ x q => 0 ≤ q ∧ q ≤ w.stock a x

/-- The world after a whole history of moves. -/
def World.run (w : World) : List Move → World
  | [] => w
  | m :: ms => (w.apply m).run ms

/-- A history is legal when each move is legal in the world the earlier moves
leave behind. -/
def MovesOK (w : World) : List Move → Prop
  | [] => True
  | m :: ms => MoveOK w m ∧ MovesOK (w.apply m) ms

@[simp] theorem World.run_nil (w : World) : w.run [] = w := rfl

@[simp] theorem World.run_cons (w : World) (m : Move) (ms : List Move) :
    w.run (m :: ms) = (w.apply m).run ms := rfl

/-! ### A Boolean checker for histories -/

/-- Decision procedure for `MoveOK`. -/
def moveOKb (w : World) : Move → Bool
  | .mine p b q => decide (p = miner) && decide (b ∈ rawMaterials) && decide (0 ≤ q)
  | .make p i q => decide (0 ≤ q) && plant.stepOKb i q (w.stock p)
  | .ship a _ x q => decide (0 ≤ q) && decide (q ≤ w.stock a x)

/-- Decision procedure for `MovesOK`. -/
def movesOKb (w : World) : List Move → Bool
  | [] => true
  | m :: ms => moveOKb w m && movesOKb (w.apply m) ms

theorem moveOKb_sound (w : World) (m : Move) (h : moveOKb w m = true) : MoveOK w m := by
  cases m with
  | mine p b q =>
      simp only [moveOKb, Bool.and_eq_true, decide_eq_true_eq] at h
      exact ⟨h.1.1, h.1.2, h.2⟩
  | make p i q =>
      simp only [moveOKb, Bool.and_eq_true, decide_eq_true_eq] at h
      exact ⟨h.1, plant.stepOKb_sound h.2⟩
  | ship a b x q =>
      simp only [moveOKb, Bool.and_eq_true, decide_eq_true_eq] at h
      exact ⟨h.1, h.2⟩

/-- **The checker is sound.**  If the Boolean test passes, every move of the
history is legal in turn. -/
theorem movesOKb_sound : ∀ (ms : List Move) (w : World), movesOKb w ms = true → MovesOK w ms := by
  intro ms
  induction ms with
  | nil => intro w _; trivial
  | cons m ms ih =>
      intro w h
      rw [movesOKb, Bool.and_eq_true] at h
      exact ⟨moveOKb_sound w m h.1, ih _ h.2⟩

/-! ## What the world is worth: the conservation law -/

/-- The raw material of kind `b` embodied in everything every player holds. -/
def worldRaw (b : Item) (w : World) : ℚ := ∑ p : Player, plant.rawContent b (w.stock p)

/-- **Trade and manufacture create nothing.**  The raw material embodied in the
world grows by exactly what is dug out of the ground, and by nothing else: a
shipment moves content between players and a workflow only repackages it. -/
theorem worldRaw_apply (b : Item) (w : World) (m : Move) (hm : MoveOK w m) :
    worldRaw b (w.apply m) - (w.apply m).dug b = worldRaw b w - w.dug b := by
  cases m with
  | mine p bb q =>
      obtain ⟨rfl, hbb, hq⟩ := hm
      have hraw : plant.recipe bb = none := rawMaterials_base bb hbb
      have hone : plant.rawDemand bb 1 b = if b = bb then 1 else 0 := by
        rw [plant.rawDemand_base hraw]
      have hstock : ∀ p' : Player,
          plant.rawContent b (fun x => w.stock p' x + (if p' = miner then (if x = bb then q else 0) else 0))
            = plant.rawContent b (w.stock p')
              + (if p' = miner then q * plant.rawDemand bb 1 b else 0) := by
        intro p'
        rw [Plant.rawContent_add]
        congr 1
        by_cases hp : p' = miner
        · simp only [if_pos hp]
          exact plant.rawContent_single b bb q
        · simp only [if_neg hp]
          exact plant.rawContent_zero b
      have hsum : worldRaw b (w.apply (Move.mine miner bb q))
          = worldRaw b w + q * plant.rawDemand bb 1 b := by
        simp only [worldRaw, World.apply, hstock, Finset.sum_add_distrib]
        congr 1
        rw [Finset.sum_eq_single miner]
        · simp
        · intro y _ hy; simp [hy]
        · intro hc; exact absurd (Finset.mem_univ miner) hc
      have hdug : (w.apply (Move.mine miner bb q)).dug b = w.dug b + (if b = bb then q else 0) := rfl
      rw [hsum, hdug, hone]
      by_cases hbbb : b = bb
      · subst hbbb; simp
      · simp [hbbb]
  | make p i q =>
      have hdug : (w.apply (Move.make p i q)).dug b = w.dug b := rfl
      have hstock : worldRaw b (w.apply (Move.make p i q)) = worldRaw b w := by
        simp only [worldRaw, World.apply]
        refine Finset.sum_congr rfl ?_
        intro p' _
        by_cases hp : p' = p
        · rw [if_pos hp, hp]
          exact plant.rawContent_step b (w.stock p)
        · rw [if_neg hp]
      rw [hstock, hdug]
  | ship a c x q =>
      have hdug : (w.apply (Move.ship a c x q)).dug b = w.dug b := rfl
      have hstock : ∀ p' : Player,
          plant.rawContent b (fun y => w.stock p' y
              - (if p' = a then (if y = x then q else 0) else 0)
              + (if p' = c then (if y = x then q else 0) else 0))
            = plant.rawContent b (w.stock p')
              - (if p' = a then q * plant.rawDemand x 1 b else 0)
              + (if p' = c then q * plant.rawDemand x 1 b else 0) := by
        intro p'
        rw [Plant.rawContent_add (d := fun y => if p' = c then (if y = x then q else 0) else 0),
          Plant.rawContent_sub]
        congr 1
        · congr 1
          by_cases hp : p' = a
          · simp only [if_pos hp]
            exact plant.rawContent_single b x q
          · simp only [if_neg hp]
            exact plant.rawContent_zero b
        · by_cases hp : p' = c
          · simp only [if_pos hp]
            exact plant.rawContent_single b x q
          · simp only [if_neg hp]
            exact plant.rawContent_zero b
      have hA : ∑ p' : Player, (if p' = a then q * plant.rawDemand x 1 b else 0)
          = q * plant.rawDemand x 1 b := by
        rw [Finset.sum_eq_single a]
        · simp
        · intro y _ hy; simp [hy]
        · intro hc; exact absurd (Finset.mem_univ a) hc
      have hC : ∑ p' : Player, (if p' = c then q * plant.rawDemand x 1 b else 0)
          = q * plant.rawDemand x 1 b := by
        rw [Finset.sum_eq_single c]
        · simp
        · intro y _ hy; simp [hy]
        · intro hc; exact absurd (Finset.mem_univ c) hc
      have hsum : worldRaw b (w.apply (Move.ship a c x q)) = worldRaw b w := by
        simp only [worldRaw, World.apply, hstock, Finset.sum_add_distrib, Finset.sum_sub_distrib,
          hA, hC]
        ring
      rw [hsum, hdug]

theorem worldRaw_run (b : Item) :
    ∀ (ms : List Move) (w : World), MovesOK w ms →
      worldRaw b (w.run ms) - (w.run ms).dug b = worldRaw b w - w.dug b := by
  intro ms
  induction ms with
  | nil => intro w _; rfl
  | cons m ms ih =>
      intro w h
      rw [World.run_cons, ih _ h.2, worldRaw_apply b w m h.1]

/-! ### Nobody's shelf goes negative -/

theorem stock_nonneg_apply {w : World} (hs : ∀ p x, 0 ≤ w.stock p x) {m : Move}
    (hm : MoveOK w m) : ∀ p x, 0 ≤ (w.apply m).stock p x := by
  cases m with
  | mine p b q =>
      obtain ⟨rfl, _, hq⟩ := hm
      intro p' x
      have h0 := hs p' x
      have h1 : (0:ℚ) ≤ (if p' = miner then (if x = b then q else 0) else 0) := by
        by_cases hp : p' = miner <;> by_cases hx : x = b <;> simp [hp, hx, hq]
      simp only [World.apply]
      linarith
  | make p i q =>
      obtain ⟨hq, hOK⟩ := hm
      intro p' x
      simp only [World.apply]
      by_cases hp : p' = p
      · rw [if_pos hp]
        exact plant.step_nonneg plant_inputsNodup hq (hs p) hOK x
      · rw [if_neg hp]
        exact hs p' x
  | ship a c x q =>
      obtain ⟨hq, hle⟩ := hm
      intro p' y
      have h0 := hs p' y
      have hA : (if p' = a then (if y = x then q else 0) else 0) ≤ w.stock p' y := by
        by_cases hp : p' = a
        · subst hp
          by_cases hy : y = x
          · subst hy; simpa using hle
          · simpa [hy] using h0
        · simpa [hp] using h0
      have hB : (0:ℚ) ≤ (if p' = c then (if y = x then q else 0) else 0) := by
        by_cases hp : p' = c <;> by_cases hy : y = x <;> simp [hp, hy, hq]
      simp only [World.apply]
      linarith

theorem stock_nonneg_run : ∀ (ms : List Move) (w : World), MovesOK w ms →
    (∀ p x, 0 ≤ w.stock p x) → ∀ p x, 0 ≤ (w.run ms).stock p x := by
  intro ms
  induction ms with
  | nil => intro w _ hs; exact hs
  | cons m ms ih =>
      intro w h hs
      exact ih _ h.2 (stock_nonneg_apply hs h.1)

/-! ## The pristine world -/

/-- The world at the start of the game: each player holding their own kit and
nothing else, and not a gram taken out of the ground. -/
def start : World where
  stock := fun p x => if x ∈ p.kit then 1 else 0
  dug := fun _ => 0

theorem start_stock_nonneg : ∀ p x, 0 ≤ start.stock p x := by
  intro p x; simp only [start]; split <;> norm_num

theorem start_worldRaw {b : Item} (hb : b ∈ rawMaterials) : worldRaw b start = 0 := by
  have hbase : plant.recipe b = none := rawMaterials_base b hb
  refine Finset.sum_eq_zero ?_
  intro p _
  refine Finset.sum_eq_zero ?_
  intro x _
  by_cases hx : x ∈ p.kit
  · have hxb : x ≠ b := by
      intro hxb
      subst hxb
      revert hb hx
      revert p x
      decide
    have hxbase : plant.recipe x = none := by
      have : x ∈ seedToolkit := kits_cover_seedToolkit x |>.2 ⟨p, hx⟩
      exact seedToolkit_base x this
    rw [plant.rawDemand_base hxbase]
    simp [Ne.symm hxb]
  · simp [start, hx]

/-- **The civilization cannot cheat the ground.**  However many players there
are, however the work is divided and however the goods are traded, if the game
starts from the pristine world and ends with somebody holding a tractor, then
at least the tractor's raw-material demand has come out of the deposits. -/
theorem civilization_material_bound {b : Item} (hb : b ∈ rawMaterials) (ms : List Move)
    (hms : MovesOK start ms) (p : Player) (hp : 1 ≤ (start.run ms).stock p lifeTrac) :
    plant.rawDemand lifeTrac 1 b ≤ (start.run ms).dug b := by
  have hbase : plant.recipe b = none := rawMaterials_base b hb
  have hcons := worldRaw_run b ms start hms
  rw [start_worldRaw hb] at hcons
  have hdug0 : start.dug b = 0 := rfl
  rw [hdug0, sub_zero] at hcons
  have hnn := stock_nonneg_run ms start hms start_stock_nonneg
  -- the tractor alone accounts for its own raw-material demand
  have hone : plant.rawDemand lifeTrac 1 b ≤ plant.rawContent b ((start.run ms).stock p) := by
    have hterm : ∀ x ∈ (Finset.univ : Finset Item),
        0 ≤ (start.run ms).stock p x * plant.rawDemand x 1 b :=
      fun x _ => mul_nonneg (hnn p x) (plant.rawDemand_nonneg zero_le_one b)
    have hsingle := Finset.single_le_sum hterm (Finset.mem_univ lifeTrac)
    have hrd : (0:ℚ) ≤ plant.rawDemand lifeTrac 1 b := plant.rawDemand_nonneg zero_le_one b
    have : plant.rawDemand lifeTrac 1 b
        ≤ (start.run ms).stock p lifeTrac * plant.rawDemand lifeTrac 1 b := by nlinarith
    exact this.trans hsingle
  have hrest : ∀ p' ∈ (Finset.univ : Finset Player),
      0 ≤ plant.rawContent b ((start.run ms).stock p') := by
    intro p' _
    refine Finset.sum_nonneg ?_
    intro x _
    exact mul_nonneg (hnn p' x) (plant.rawDemand_nonneg zero_le_one b)
  have hworld : plant.rawContent b ((start.run ms).stock p) ≤ worldRaw b (start.run ms) :=
    Finset.single_le_sum hrest (Finset.mem_univ p)
  have hfin : worldRaw b (start.run ms) = (start.run ms).dug b := by linarith
  linarith [hone.trans hworld]


/-! ## The game: mine, make, ship

`civPlan` is the whole bootstrap played out.  The miner works the seven
deposits; then the fifty-two workflows of `RequestProject/Minimal.lean` are run
in build order, each by the player who owns it, with the inputs shipped in
from whoever made them just before they are needed.  No tool ever moves
(`tools_stay_home`); only materials do. -/

/-- The shipments a production run needs: each input sent from the player who
makes it to the player who is about to use it. -/
def shipsFor (i : Item) (q : ℚ) : List Move :=
  match recipe i with
  | none => []
  | some r => r.inputs.map fun p => Move.ship (owner p.1) (owner i) p.1 (q * p.2 / r.batch)

/-- One production run of the bootstrap, as moves of the game: ship the inputs
in, then make the thing. -/
def movesFor (s : Item × ℚ) : List Move := shipsFor s.1 s.2 ++ [Move.make (owner s.1) s.1 s.2]

/-- **The game.**  Mine the seven deposits, then work through the fifty-two
workflows, shipping as you go. -/
def civPlan : List Move :=
  rawMaterials.map (fun b => Move.mine miner b (demandTable b)) ++
    (minimalPlan.map movesFor).flatten

/-- The game is a hundred and ninety-five moves long: seven at the deposits,
fifty-two at the machines and a hundred and thirty-six deliveries. -/
theorem civPlan_length : civPlan.length = 195 := by decide +kernel

/-- The production runs of the game are exactly the fifty-two runs of the
minimal plan, in the same order. -/
theorem civPlan_makes :
    civPlan.filterMap (fun m => match m with | .make _ i q => some (i, q) | _ => none)
      = minimalPlan := by decide +kernel

set_option maxHeartbeats 4000000 in
/-- **Every move of the game is legal.**  Nobody mines what is not theirs to
mine, runs a process they have no tools for, or ships what they have not
got. -/
theorem civPlan_legal : MovesOK start civPlan :=
  movesOKb_sound civPlan start (by decide +kernel)

set_option maxHeartbeats 4000000 in
/-- **… and at the end there is a tractor.**  It stands in the machinist's
yard. -/
theorem civPlan_builds : (start.run civPlan).stock machinist lifeTrac = 1 := by
  decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_ironOre : (start.run civPlan).dug ironOre = 132262859/31250 := by
  decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_coal : (start.run civPlan).dug coal = 26838099/12500 := by decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_limestone : (start.run civPlan).dug limestone = 397188577/500000 := by
  decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_silicaSand : (start.run civPlan).dug silicaSand = 351/5 := by decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_crudeOil : (start.run civPlan).dug crudeOil = 1789/25 := by decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_latex : (start.run civPlan).dug latex = 567/4 := by decide +kernel

set_option maxHeartbeats 4000000 in
theorem civPlan_dug_copperOre : (start.run civPlan).dug copperOre = 72 := by decide +kernel

/-- **The game takes 7529.35 kg out of the ground** — the figure of
`RequestProject/Minimal.lean`, reached here by four players trading with one
another instead of one shop working alone. -/
theorem civPlan_rawTotal : rawTotal (start.run civPlan).dug = 3764673281/500000 := by
  unfold rawTotal
  rw [civPlan_dug_ironOre, civPlan_dug_coal, civPlan_dug_limestone, civPlan_dug_silicaSand,
    civPlan_dug_crudeOil, civPlan_dug_latex, civPlan_dug_copperOre]
  norm_num

/-- The items a player makes in the course of the game. -/
def madeBy (p : Player) : List Item := nonBase.filter (fun i => owner i = p)

/-- **The division of labour, in numbers.**  The miner works the seven
deposits, the smelter runs eight workflows, the chemist five and the machinist
thirty-nine. -/
theorem civPlan_workload :
    (madeBy miner).length = 0 ∧ (madeBy smelter).length = 8 ∧
      (madeBy chemist).length = 5 ∧ (madeBy machinist).length = 39 := by decide +kernel

/-- **The civilization bootstraps itself.**  From a pristine world — four
players, three toolkits between them, seven deposits and nothing else — a
hundred and ninety-five legal moves put a working LifeTrac in the machinist's
yard, having taken 7529.35 kg out of the ground. -/
theorem civilization_bootstrap :
    MovesOK start civPlan ∧
      (start.run civPlan).stock machinist lifeTrac = 1 ∧
      rawTotal (start.run civPlan).dug = 3764673281/500000 :=
  ⟨civPlan_legal, civPlan_builds, civPlan_rawTotal⟩

/-! ## Why there has to be more than one of them

A player — or a group of players — can only ever hold something they can make
with the tools they have, out of things they can already hold.  That gives a
set of items closed under the workflows available to them, and if the tractor
is not in that set, no amount of ore, work or ingenuity will produce one. -/

/-- The Boolean test that a list of items is closed under the workflows: if
everything a workflow consumes in positive quantity and every tool it needs is
in the list, then so is what it makes. -/
def closedb (C : List Item) : Bool :=
  buildOrder.all fun i =>
    match recipe i with
    | none => true
    | some r => !((r.inputs.all fun p => !(decide (0 < p.2)) || C.contains p.1)
                  && (r.tools.all fun t => C.contains t)) || C.contains i

theorem closedb_sound {C : List Item} (h : closedb C = true) :
    ∀ i r, plant.recipe i = some r → (∀ p ∈ r.inputs, 0 < p.2 → p.1 ∈ C) →
      (∀ t ∈ r.tools, t ∈ C) → i ∈ C := by
  intro i r hr hin htool
  have hi := List.all_eq_true.1 h i (mem_buildOrder i)
  rw [plant_recipe] at hr
  simp only [hr] at hi
  have h1 : (r.inputs.all fun p => !(decide (0 < p.2)) || C.contains p.1) = true := by
    refine List.all_eq_true.2 ?_
    intro p hp
    by_cases hq : 0 < p.2
    · simp only [hq, decide_true, Bool.not_true, Bool.false_or, List.elem_eq_mem,
        decide_eq_true_eq]
      exact hin p hp hq
    · simp [hq]
  have h2 : (r.tools.all fun t => C.contains t) = true := by
    refine List.all_eq_true.2 ?_
    intro t ht
    simp only [List.elem_eq_mem, decide_eq_true_eq]
    exact htool t ht
  rw [h1, h2] at hi
  simp at hi
  exact hi

/-- **What a closed set forbids.**  If everything on the shelf at the start
lies in a set closed under the workflows, and the tractor is not in that set,
then no plan whatever will produce one. -/
theorem cannot_produce {C : List Item} (hclosed : closedb C = true) (hno : lifeTrac ∉ C)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 < s x → x ∈ C) : plant.runPlan l s lifeTrac ≤ 0 := by
  by_contra hc
  push_neg at hc
  exact hno (plant.pos_runPlan_mem (fun x => x ∈ C) (fun _ => True)
    (fun i r hr _ hin ht => closedb_sound hclosed i r hr hin ht) l s hq hOK
    (fun _ _ => trivial) hs lifeTrac hc)

/-- One round of "what else could they make with what they have". -/
def growCapability (avail : List Item) : List Item :=
  (avail ++ buildOrder.filter (fun i =>
     match recipe i with
     | none => false
     | some r => (r.inputs.all fun p => !(decide (0 < p.2)) || avail.contains p.1)
                 && (r.tools.all fun t => avail.contains t))).dedup

/-- Everything a group holding the toolkits `kits` could ever make, given
unlimited raw material: eight rounds saturate the system. -/
def capability (kits : List Item) : List Item :=
  growCapability (growCapability (growCapability (growCapability (growCapability
    (growCapability (growCapability (growCapability (rawMaterials ++ kits))))))))

theorem capability_closed_sc : closedb (capability (smelter.kit ++ chemist.kit)) = true := by
  decide +kernel

theorem capability_closed_sm : closedb (capability (smelter.kit ++ machinist.kit)) = true := by
  decide +kernel

theorem capability_closed_cm : closedb (capability (chemist.kit ++ machinist.kit)) = true := by
  decide +kernel

theorem lifeTrac_not_sc : lifeTrac ∉ capability (smelter.kit ++ chemist.kit) := by decide +kernel

theorem lifeTrac_not_sm : lifeTrac ∉ capability (smelter.kit ++ machinist.kit) := by decide +kernel

theorem lifeTrac_not_cm : lifeTrac ∉ capability (chemist.kit ++ machinist.kit) := by decide +kernel

theorem mem_capability_of_raw (kits : List Item) :
    ∀ x ∈ rawMaterials, x ∈ capability kits := by
  intro x hx
  have h1 : ∀ a : List Item, ∀ y ∈ a, y ∈ growCapability a := by
    intro a y hy
    simp only [growCapability, List.mem_dedup, List.mem_append]
    exact Or.inl hy
  have h0 : x ∈ rawMaterials ++ kits := List.mem_append.2 (Or.inl hx)
  exact h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ h0)))))))

theorem mem_capability_of_kit (kits : List Item) :
    ∀ x ∈ kits, x ∈ capability kits := by
  intro x hx
  have h1 : ∀ a : List Item, ∀ y ∈ a, y ∈ growCapability a := by
    intro a y hy
    simp only [growCapability, List.mem_dedup, List.mem_append]
    exact Or.inl hy
  have h0 : x ∈ rawMaterials ++ kits := List.mem_append.2 (Or.inr hx)
  exact h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ (h1 _ _ h0)))))))

/-- **You cannot bootstrap without all three trades.**  Take any coalition of
players that is missing the smelter, or the chemist, or the machinist.  Pool
everything they own, give them as much raw material as they like, and let them
work as long as they please: they will never hold a LifeTrac. -/
theorem incomplete_coalition_cannot (C : List Player)
    (hmiss : smelter ∉ C ∨ chemist ∉ C ∨ machinist ∉ C)
    (l : List (Item × ℚ)) (s : Item → ℚ) (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 < s x → x ∈ rawMaterials ∨ ∃ p ∈ C, x ∈ p.kit) :
    plant.runPlan l s lifeTrac ≤ 0 := by
  rcases hmiss with hm | hm | hm
  · have hkit : ∀ p : Player, p ≠ smelter → ∀ x ∈ p.kit, x ∈ chemist.kit ++ machinist.kit := by
      decide
    refine cannot_produce capability_closed_cm lifeTrac_not_cm l s hq hOK ?_
    intro x hx
    rcases hs x hx with h | ⟨p, hp, hxp⟩
    · exact mem_capability_of_raw _ x h
    · refine mem_capability_of_kit _ x (hkit p (fun hpe => hm (hpe ▸ hp)) x hxp)
  · have hkit : ∀ p : Player, p ≠ chemist → ∀ x ∈ p.kit, x ∈ smelter.kit ++ machinist.kit := by
      decide
    refine cannot_produce capability_closed_sm lifeTrac_not_sm l s hq hOK ?_
    intro x hx
    rcases hs x hx with h | ⟨p, hp, hxp⟩
    · exact mem_capability_of_raw _ x h
    · refine mem_capability_of_kit _ x (hkit p (fun hpe => hm (hpe ▸ hp)) x hxp)
  · have hkit : ∀ p : Player, p ≠ machinist → ∀ x ∈ p.kit, x ∈ smelter.kit ++ chemist.kit := by
      decide
    refine cannot_produce capability_closed_sc lifeTrac_not_sc l s hq hOK ?_
    intro x hx
    rcases hs x hx with h | ⟨p, hp, hxp⟩
    · exact mem_capability_of_raw _ x h
    · refine mem_capability_of_kit _ x (hkit p (fun hpe => hm (hpe ▸ hp)) x hxp)

/-- **Nobody can do it alone.**  Whichever of the four players it is, working
by themselves with their own kit and all the raw material in the world, they
cannot build a tractor.  The game needs its players. -/
theorem alone_cannot (p : Player) (l : List (Item × ℚ)) (s : Item → ℚ)
    (hq : ∀ p ∈ l, 0 ≤ p.2) (hOK : plant.PlanOK l s)
    (hs : ∀ x, 0 < s x → x ∈ rawMaterials ∨ x ∈ p.kit) :
    plant.runPlan l s lifeTrac ≤ 0 := by
  have hmiss : ∀ q : Player, smelter ∉ [q] ∨ chemist ∉ [q] ∨ machinist ∉ [q] := by decide
  refine incomplete_coalition_cannot [p] (hmiss p) l s hq hOK ?_
  intro x hx
  rcases hs x hx with h | h
  · exact Or.inl h
  · exact Or.inr ⟨p, List.mem_singleton.2 rfl, h⟩

end Workflow
end LifeTrac
