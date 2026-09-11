import RequestProject.Gvcs.TechTree.Slice

/-!
# The splitter bake-off: one machine, or two?

`RequestProject/TechTree/Slice.lean` builds the press and the stamp as two
separate machines — the press makes blank tablets, the stamp embosses a program
onto a blank — and its docstring promises a reason.  This file is the reason: a
bake-off between the split design and the obvious cheaper alternative, a single
combined press-and-stamp sharing one frame and one set of dies.

Both designs are run through the same checker from the same raw site, so
neither is being flattered:

* `combo_selfHosting` — the combined design works.  It is a genuine bootstrap:
  it runs, it ends holding a complete machine, and every tool it used was built
  on site or is one of the eight declared exceptions.
* `combo_cheaper_to_build` — and it is cheaper: 647 units of labour against 653,
  and one iron bar less, because there is one frame instead of two.

So on the first build the splitter *loses*.  The case for splitting is what
happens afterwards, when the program on the tablet changes — which for a
machine whose program is its own build sequence is not a rare event:

* `stamp_recut_leaves_the_press_alone` — re-cutting the stamp touches neither
  the press nor anything the press needs, so blanks can go on being pressed
  while the new program is cut;
* `combo_recut_hits_the_blank_supply` — in the combined design the one machine
  that has to be re-cut is exactly the machine the blanks depend on;
* `combo_cheaper_iff_program_never_changes` — counting labour over `k` program
  changes, the combined design wins if and only if `k = 0`, and
  `split_wins_from_the_first_change` says the split design is strictly ahead
  from the first change onwards.  The crossover is immediate: the combined
  machine costs 34 to re-cut where the stamp costs 20, which is more than the
  six units the shared frame saved.

`bakeoff` bundles the verdict.  As with the rest of this layer, no physics is
claimed: the two designs differ here only in their parts, their labour and
their dependency structure, not in how well they actually press clay.
-/

namespace LifeTrac
namespace TechTree

/-! ## The combined machine, and the nodes that change with it -/

/-- **The alternative**: one machine that both presses blanks and embosses
them, sharing a frame and a die set.  Cheaper than the two machines it
replaces — 34 units of labour and four bars against 40 and five. -/
def comboMachine : Tech :=
  { id := "tablet_pressstamp", tier := .clockwork
    inputs := [("iron_bar", 4)], outputs := [("tablet_pressstamp", 1)]
    tools := ["press_frame", "mold_die_set", "treadle_lathe"], erects := []
    baseLabor := 34, obsDiscount := 0, humanStep := true }

/-- Blanks, pressed on the combined machine. -/
def comboBlanks : Tech := { blankTablets with tools := ["tablet_pressstamp"] }

/-- The program, embossed on the same combined machine. -/
def comboProgram : Tech := { programTablet with tools := ["tablet_pressstamp"] }

/-- Final assembly, which now carries away one machine instead of two. -/
def comboComplete : Tech :=
  { completeMachine with
      inputs := [("boiler_shell", 1), ("steam_valve", 2), ("tablet_reader", 1),
                 ("program_tablet_for_self", 1), ("tablet_pressstamp", 1),
                 ("iron_bar", 4)] }

/-- The combined design's catalogue. -/
def comboCatalog : List Tech :=
  [charcoalBurn, forgeHearth, ironBar, treadleLathe, moldDieSet, pressFrame,
   comboMachine, tabletReader, comboBlanks, comboProgram, observatory,
   boilerShell, steamValve, comboComplete]

/-- The combined design's bootstrap, step for step the slice's except that the
press and the stamp have become one machine. -/
def comboSeq : BootstrapSeq :=
  [ observatory
  , forgeHearth
  , charcoalBurn, ironBar
  , charcoalBurn, ironBar
  , charcoalBurn, ironBar
  , treadleLathe
  , moldDieSet
  , pressFrame
  , comboMachine
  , tabletReader
  , comboBlanks
  , comboProgram
  , boilerShell
  , steamValve
  , comboComplete ]

/-! ## Both designs work -/

theorem combo_valid : ValidSequence comboSeq rawSite := by decide

/-- **The combined design is self-hosting too**, on the same eight
exceptions — so the bake-off is between two working bootstraps. -/
theorem combo_selfHosting : SelfHosting comboSeq rawSite BootstrapExceptions := by decide

theorem combo_makes_one_machine :
    qty (finalState rawSite comboSeq).consumables "complete_machine" = 1 := by decide

theorem combo_tier_sound : tierSound comboCatalog comboSeq = true := by decide

theorem combo_tiers_nondecreasing : tiersNondecreasing comboSeq := by decide

/-! ## Round one: the first build -/

/-- The slice spends 653 units of labour. -/
theorem split_labor : totalLabor rawSite sliceSeq = 653 := by decide

/-- The combined design spends 647. -/
theorem combo_labor : totalLabor rawSite comboSeq = 647 := by decide

/-- **Round one goes to the combined machine.** -/
theorem combo_cheaper_to_build :
    totalLabor rawSite comboSeq < totalLabor rawSite sliceSeq := by decide

/-- It uses one bar of iron less, as well: four against the five the two
separate machines take. -/
theorem combo_uses_less_iron :
    comboMachine.inputs = [("iron_bar", 4)] ∧
    tabletPress.inputs = [("iron_bar", 2)] ∧ tabletStamp.inputs = [("iron_bar", 3)] := by
  decide

/-! ## Round two: changing the program -/

/-- Cutting a new program means cutting new dies for whatever machine carries
them: the stamp in the split design, the whole machine in the combined one. -/
def recutCost (t : Tech) : ℕ := t.baseLabor

/-- The labour the split design spends on the first build and `k` later program
changes. -/
def splitLifetime (k : ℕ) : ℕ := totalLabor rawSite sliceSeq + k * recutCost tabletStamp

/-- The same for the combined design. -/
def comboLifetime (k : ℕ) : ℕ := totalLabor rawSite comboSeq + k * recutCost comboMachine

/-- **Re-cutting the stamp leaves the press alone.**  The stamp is not built out
of the press, does not use it as a tool, and produces nothing the press needs —
so the shop can go on pressing blanks while a new program is cut. -/
theorem stamp_recut_leaves_the_press_alone :
    "tablet_press" ∉ tabletStamp.tools ∧
    "tablet_press" ∉ tabletStamp.inputs.map Prod.fst ∧
    "tablet_press" ∉ tabletStamp.outputs.map Prod.fst := by decide

/-- **In the combined design the re-cut hits the blank supply.**  The machine
that has to be re-cut is exactly the tool the blanks depend on. -/
theorem combo_recut_hits_the_blank_supply :
    comboBlanks.tools = ["tablet_pressstamp"] ∧
    comboMachine.outputs.map Prod.fst = ["tablet_pressstamp"] := by decide

/-- **The verdict on labour.**  Over a lifetime with `k` program changes, the
combined machine is the cheaper design exactly when the program never
changes. -/
theorem combo_cheaper_iff_program_never_changes (k : ℕ) :
    comboLifetime k ≤ splitLifetime k ↔ k = 0 := by
  unfold comboLifetime splitLifetime recutCost
  rw [split_labor, combo_labor]
  constructor
  · intro h
    by_contra hk
    have : 1 ≤ k := Nat.one_le_iff_ne_zero.2 hk
    simp only [tabletStamp, comboMachine] at h
    omega
  · rintro rfl
    simp

/-- **And from the first change onwards the splitter is strictly ahead.** -/
theorem split_wins_from_the_first_change {k : ℕ} (hk : 1 ≤ k) :
    splitLifetime k < comboLifetime k := by
  unfold comboLifetime splitLifetime recutCost
  rw [split_labor, combo_labor]
  simp only [tabletStamp, comboMachine]
  omega

/-- **The bake-off.**  Both designs bootstrap themselves from the same site and
the same eight exceptions.  The combined machine is cheaper to build; the split
one is cheaper to live with, from the first program change onwards, and its
re-cut does not stop the blanks. -/
theorem bakeoff :
    SelfHosting sliceSeq rawSite BootstrapExceptions ∧
    SelfHosting comboSeq rawSite BootstrapExceptions ∧
    totalLabor rawSite comboSeq < totalLabor rawSite sliceSeq ∧
    (∀ k : ℕ, 1 ≤ k → splitLifetime k < comboLifetime k) ∧
    "tablet_press" ∉ tabletStamp.tools :=
  ⟨slice_selfHosting, combo_selfHosting, combo_cheaper_to_build,
    fun _ hk => split_wins_from_the_first_change hk,
    stamp_recut_leaves_the_press_alone.1⟩

end TechTree
end LifeTrac
