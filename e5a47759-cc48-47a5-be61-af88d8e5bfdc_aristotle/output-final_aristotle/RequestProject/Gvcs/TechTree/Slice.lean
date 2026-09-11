import RequestProject.Gvcs.TechTree.Tier

/-!
# The minimal slice, and its proof

This is deliverable §4: not the whole machine, but the smallest slice worth
claiming — raw stock and hand tools, through a charcoal hearth and a treadle
lathe, to a clay-tablet program store and one steam-tier subassembly.

Every node is written out with its inputs, its tools, the labour it costs and
whether it needs a human.  Then:

* `slice_valid` — the checker runs the sequence and it goes through;
* `slice_selfHosting` — **the claim**: valid start to finish, ends holding a
  complete machine, and every tool it used was built by the sequence itself or
  is one of the eight declared `BootstrapExceptions`;
* `slice_tier_monotone`, `slice_tiers_nondecreasing` — no node reaches above
  its tier for a tool, and the sequence climbs the tree;
* `press_before_program` — the press is built before the program tablet that
  encodes the machine's own build sequence, and `press_before_program_reason`
  says *why* it must be, from the general ordering theorem rather than from
  inspection of this one list;
* `slice_human_steps` — the human-step count, listed by name;
* `slice_no_hydraulic` — the slice reaches steam and stops, as scoped.

## What the slice does not claim

`complete_machine` here is the slice's target artefact: a tablet-driven steam
subassembly with its own press, stamp and reader.  That the *copy* can then run
this same sequence again — the generational fixed point — is not proved here
and is not claimed; it is the later milestone flagged in §2a.2.  Nor is any
physical claim made: no tolerances, no thermodynamics, no wear.  The
`observatory` node's mould-wear and stone-dressing costs are exactly the sort
of thing this layer does not model.
-/

namespace LifeTrac
namespace TechTree

/-! ## The bootstrap exceptions

Eight names, and nothing else, are free at the start.  §5's report in
`docs/tech-tree.md` says in plain English what each one is. -/

/-- The irreducible non-self-replicating base case: what the sequence is
allowed to start with. -/
def BootstrapExceptions : List String :=
  [ "raw_ore_stock"        -- smeltable ore or bar stock, bought or dug
  , "clay"                 -- dug clay for the hearth and the tablets
  , "water"                -- for tempering the clay
  , "timber"               -- fuel stock and structural wood
  , "large_stone"          -- undressed sarsens for the observatory
  , "labor"                -- human working time, in units
  , "initial_hand_tools"   -- hammer, files, saw, chisel, square
  , "human_operator" ]     -- the person; every node declares if it needs one

/-! ## The nodes -/

/-- Burn a stack of timber to charcoal in an earth clamp. -/
def charcoalBurn : Tech :=
  { id := "charcoal", tier := .clockwork
    inputs := [("timber", 30)], outputs := [("charcoal", 20)]
    tools := ["initial_hand_tools"], erects := []
    baseLabor := 20, obsDiscount := 0, humanStep := true }

/-- Raise a clay-and-timber hearth with a hand bellows. -/
def forgeHearth : Tech :=
  { id := "forge_hearth", tier := .clockwork
    inputs := [("clay", 20), ("timber", 10)], outputs := [("forge_hearth", 1)]
    tools := ["initial_hand_tools"], erects := []
    baseLabor := 30, obsDiscount := 0, humanStep := true }

/-- Smelt and draw bar stock. -/
def ironBar : Tech :=
  { id := "iron_bar", tier := .clockwork
    inputs := [("raw_ore_stock", 40), ("charcoal", 20)], outputs := [("iron_bar", 20)]
    tools := ["forge_hearth", "initial_hand_tools"], erects := []
    baseLabor := 40, obsDiscount := 0, humanStep := true }

/-- A treadle lathe: the first machine tool, human-powered. -/
def treadleLathe : Tech :=
  { id := "treadle_lathe", tier := .clockwork
    inputs := [("iron_bar", 8), ("timber", 20)], outputs := [("treadle_lathe", 1)]
    tools := ["initial_hand_tools", "forge_hearth"], erects := []
    baseLabor := 60, obsDiscount := 0, humanStep := true }

/-- Dies and moulds, turned and filed on the lathe. -/
def moldDieSet : Tech :=
  { id := "mold_die_set", tier := .clockwork
    inputs := [("iron_bar", 4)], outputs := [("mold_die_set", 1)]
    tools := ["treadle_lathe", "forge_hearth"], erects := []
    baseLabor := 25, obsDiscount := 0, humanStep := true }

/-- The frame that carries the press screw. -/
def pressFrame : Tech :=
  { id := "press_frame", tier := .clockwork
    inputs := [("iron_bar", 6), ("timber", 6)], outputs := [("press_frame", 1)]
    tools := ["treadle_lathe"], erects := []
    baseLabor := 25, obsDiscount := 0, humanStep := true }

/-- **The press**: it makes blank tablets, and nothing else. -/
def tabletPress : Tech :=
  { id := "tablet_press", tier := .clockwork
    inputs := [("iron_bar", 2)], outputs := [("tablet_press", 1)]
    tools := ["press_frame", "mold_die_set", "treadle_lathe"], erects := []
    baseLabor := 20, obsDiscount := 0, humanStep := true }

/-- **The stamp**: it embosses a program onto a blank.  Separate from the press
so that changing the program does not touch the press — see
`RequestProject/TechTree/Bakeoff.lean`. -/
def tabletStamp : Tech :=
  { id := "tablet_stamp", tier := .clockwork
    inputs := [("iron_bar", 3)], outputs := [("tablet_stamp", 1)]
    tools := ["treadle_lathe", "mold_die_set"], erects := []
    baseLabor := 20, obsDiscount := 0, humanStep := true }

/-- The feeler-arm reader: a stylus that traces the relief and emits the
bitstream the gate deck already consumes. -/
def tabletReader : Tech :=
  { id := "tablet_reader", tier := .clockwork
    inputs := [("iron_bar", 3), ("timber", 2)], outputs := [("tablet_reader", 1)]
    tools := ["treadle_lathe"], erects := []
    baseLabor := 25, obsDiscount := 0, humanStep := true }

/-- A batch of twelve blank tablets, pressed from tempered clay. -/
def blankTablets : Tech :=
  { id := "blank_tablet", tier := .clockwork
    inputs := [("clay", 30), ("water", 10)], outputs := [("blank_tablet", 12)]
    tools := ["tablet_press"], erects := []
    baseLabor := 10, obsDiscount := 0, humanStep := true }

/-- The machine's own build program, embossed onto the twelve blanks. -/
def programTablet : Tech :=
  { id := "program_tablet_for_self", tier := .clockwork
    inputs := [("blank_tablet", 12)], outputs := [("program_tablet_for_self", 1)]
    tools := ["tablet_stamp"], erects := []
    baseLabor := 8, obsDiscount := 0, humanStep := true }

/-- **The observatory**: aligned stones giving timing, calendar and a survey
reference.  It outputs nothing and is consumed by nothing; it *stands*. -/
def observatory : Tech :=
  { id := "observatory", tier := .clockwork
    inputs := [("large_stone", 24)], outputs := []
    tools := ["initial_hand_tools"], erects := ["observatory"]
    baseLabor := 120, obsDiscount := 0, humanStep := true }

/-- A riveted boiler shell: the first steam-tier part. -/
def boilerShell : Tech :=
  { id := "boiler_shell", tier := .steam
    inputs := [("iron_bar", 10)], outputs := [("boiler_shell", 1)]
    tools := ["forge_hearth", "treadle_lathe"], erects := []
    baseLabor := 50, obsDiscount := 0, humanStep := true }

/-- Two cast and reamed valve bodies. -/
def steamValve : Tech :=
  { id := "steam_valve", tier := .steam
    inputs := [("iron_bar", 2)], outputs := [("steam_valve", 2)]
    tools := ["treadle_lathe", "mold_die_set"], erects := []
    baseLabor := 20, obsDiscount := 0, humanStep := true }

/-- Final assembly.  This is the one node in the slice that the observatory
actually helps: setting the machine up square and level against a fixed survey
reference instead of striking a baseline from scratch. -/
def completeMachine : Tech :=
  { id := "complete_machine", tier := .steam
    inputs := [("boiler_shell", 1), ("steam_valve", 2), ("tablet_reader", 1),
               ("program_tablet_for_self", 1), ("tablet_press", 1), ("tablet_stamp", 1),
               ("iron_bar", 4)]
    outputs := [("complete_machine", 1)]
    tools := ["treadle_lathe", "forge_hearth", "initial_hand_tools"], erects := []
    baseLabor := 80, obsDiscount := 20, humanStep := true }

/-- Every node of the slice, as a catalogue. -/
def sliceCatalog : List Tech :=
  [charcoalBurn, forgeHearth, ironBar, treadleLathe, moldDieSet, pressFrame,
   tabletPress, tabletStamp, tabletReader, blankTablets, programTablet, observatory,
   boilerShell, steamValve, completeMachine]

/-! ## The raw materials and the sequence -/

/-- What is on the site on day one: the bootstrap exceptions, in quantity. -/
def rawSite : ResourceState :=
  { consumables := [("raw_ore_stock", 140), ("clay", 60), ("water", 30),
                    ("timber", 160), ("large_stone", 30), ("labor", 700)]
    toolsBuilt := ["initial_hand_tools"]
    infrastructure := [] }

/-- The candidate bootstrap: survey the site, raise the hearth, make iron three
times over, build the lathe and from it the dies, the frame, the press, the
stamp and the reader, press and emboss the program, then the steam parts and
the assembly. -/
def sliceSeq : BootstrapSeq :=
  [ observatory
  , forgeHearth
  , charcoalBurn, ironBar
  , charcoalBurn, ironBar
  , charcoalBurn, ironBar
  , treadleLathe
  , moldDieSet
  , pressFrame
  , tabletPress
  , tabletStamp
  , tabletReader
  , blankTablets
  , programTablet
  , boilerShell
  , steamValve
  , completeMachine ]

/-- The same bootstrap with the observatory left out. -/
def sliceSeqNoObs : BootstrapSeq := sliceSeq.filter (fun t => t.id ≠ observatoryId)

/-! ## The proofs -/

/-- **The sequence runs.** -/
theorem slice_valid : ValidSequence sliceSeq rawSite := by decide

/-- **The minimal slice is self-hosting**, given the eight declared
exceptions. -/
theorem slice_selfHosting : SelfHosting sliceSeq rawSite BootstrapExceptions := by decide

/-- It really does end holding a machine, and exactly one. -/
theorem slice_makes_one_machine :
    qty (finalState rawSite sliceSeq).consumables "complete_machine" = 1 := by decide

/-- Nothing in the sequence uses a tool from a higher tier than its own. -/
theorem slice_tier_sound : tierSound sliceCatalog sliceSeq = true := by decide

/-- **Tier monotonicity for the slice.** -/
theorem slice_tier_monotone :
    ∀ t ∈ sliceSeq, ∀ tool ∈ t.tools, toolTier sliceCatalog tool ≤ t.tier :=
  tier_monotonicity slice_tier_sound

/-- **The slice climbs the tree**: clockwork throughout, then steam, and never
back down. -/
theorem slice_tiers_nondecreasing : tiersNondecreasing sliceSeq := by decide

/-- The slice stops at steam, as scoped: no hydraulic node appears. -/
theorem slice_no_hydraulic : ∀ t ∈ sliceSeq, t.tier ≠ TechTier.hydraulic := by decide

/-! ## The ordering constraint on the program medium -/

/-- Where a step with a given id first appears. -/
def seqIndexOf (id : String) (seq : BootstrapSeq) : ℕ :=
  (seq.map Tech.id).idxOf id

/-- **The press comes before the program.**  The tablet that carries the
machine's own build sequence cannot exist until there is a press to make blanks
with. -/
theorem press_before_program :
    seqIndexOf "tablet_press" sliceSeq < seqIndexOf "program_tablet_for_self" sliceSeq := by
  decide

/-- **And not by accident.**  In *any* valid sequence from a raw state that
holds no blank tablets, a step that stamps a program out of blanks is preceded
by a step that produced blanks — which, in this catalogue, is the only node
that has the press as a tool.  So the ordering is forced by the resource
accounting, not by the order this particular list happens to be written in. -/
theorem press_before_program_reason
    {before : BootstrapSeq} {after : BootstrapSeq} {raw : ResourceState}
    (hvalid : ValidSequence (before ++ programTablet :: after) raw)
    (hraw : qty raw.consumables "blank_tablet" = 0) :
    ∃ u ∈ before, "blank_tablet" ∈ u.outputs.map Prod.fst :=
  resource_needs_earlier_producer hvalid (k := "blank_tablet") (n := 12)
    (by decide) (by norm_num) hraw

/-- In this catalogue, the only node that makes blanks is the one that needs
the press. -/
theorem only_press_makes_blanks :
    ∀ t ∈ sliceCatalog, "blank_tablet" ∈ t.outputs.map Prod.fst → "tablet_press" ∈ t.tools := by
  decide

/-! ## Humans, and labour -/

/-- Every step of this slice needs a human; none of them pretends otherwise. -/
theorem slice_all_human : ∀ t ∈ sliceSeq, t.humanStep = true := by decide

/-- The nineteen human steps, by name. -/
theorem slice_human_steps : (humanSteps sliceSeq).length = 19 := by decide

end TechTree
end LifeTrac
