import RequestProject.Gvcs.TechTree.Tier
import RequestProject.Gvcs.TechTree.Tablet

/-!
# The smallest self-copying machine

**The entry.**  A deck of two rows of relief.  Read it, and it tells you to
turn a stylus out of bronze, and then to press a tablet with that stylus.  Do
those two things, look at the shop you now have, and write down what is
standing in it — and what you write down is, cell for cell, the deck you
started from.

That is the fixed point, and it is `=`, not "equivalent to":

```
def SelfCopying (d : Deck) : Prop :=
  ∃ seq : BootstrapSeq, ValidSequence seq (interpret d) ∧ emit seq = d
```

* `interpret d` — the deck read as a bill of materials and a site: exactly the
  stock the deck's own steps call for, plus the declared exceptions.
* `emit seq` — the tablet the shop presses: a description of every node
  standing in it, one row each.
* `theDeck` — two rows, eighty cells of clay.
* `theDeck_selfCopying` — **the claim**, proved, and `#eval`-checkable by
  `emitCheck` below.

## Why it closes

It closes because the two codecs are inverse and *both* are total on
well-formed data:

* `planOf_deckOf` — rows decode to the plan they were written from;
* `planOfSeq_seqOf` — a shop, read off the floor, is the plan it was built
  from;
* `emit_seqOf` — therefore the shop presses the deck it came from, **for any
  well-formed plan whatsoever**.

So `selfCopying_of_valid` says: any plan whose own bill lets it run is a
self-copying deck.  The competition entry is then just the smallest plan for
which the resource check passes, and its proof is one `decide`.  The fixed
point is not a trick played by one hand-written deck; it is a property of the
encoding, and the deck is the smallest witness.

## Honesty, which is a judging criterion

`quineExceptions` is five names: bronze, clay, labour, hand tools, and the
human who turns the treadle.  Nothing else is free.  In particular the
**stylus is not free** — the deck builds it, and the stamping step's tool
requirement is met by that build, which `stylus_is_earned` checks against the
general ordering theorem rather than by inspection.

`degenerateDeck` is included precisely because it is *not* the entry: a
one-node deck that stamps itself using only hand tools.  It satisfies
`SelfCopying` too (`degenerate_selfCopying`), and it is smaller, and it is
worse — it is self-copying only because the tool it needs was moved into the
exceptions list.  It is here as the counterexample that shows what the
exceptions list is for.

## What is not claimed

No physics: no clay, no firing, no shrinkage, no wear on the stylus, no claim
that a bronze point survives eighty impressions.  This is the dependency and
resource layer only.  The deck is *sufficient to rebuild the tree it came
from* in the sense the model defines — every node, its material, its tool and
its tier — and not in the sense of a machinist's drawing.
-/

namespace LifeTrac
namespace TechTree

open Steampunk (writeNat readNat readNat_writeNat writeNat_length)

/-! ## The vocabulary

Five names and a null, so that a row of relief can name a material, an
artefact and a tool in eight cells each. -/

/-- Everything the little machine can name. -/
def names : List String :=
  ["initial_hand_tools", "bronze", "clay", "stylus", "deck_tablet", "nothing"]

/-- The name of a code. -/
def nameOf (i : ℕ) : String := names.getD i "nothing"

/-- The code of a name. -/
def codeOf (s : String) : ℕ := names.idxOf s

theorem codeOf_nameOf {i : ℕ} (h : i < names.length) : codeOf (nameOf i) = i := by
  simp only [names, List.length_cons, List.length_nil] at h
  interval_cases i <;> decide

/-- Tiers by number. -/
def tierOf : ℕ → TechTier
  | 0 => .clockwork
  | 1 => .steam
  | _ => .hydraulic

theorem rank_tierOf {i : ℕ} (h : i < 3) : (tierOf i).rank = i := by
  interval_cases i <;> decide

/-! ## The plan, and the deck that carries it -/

/-- One step of a build plan: make this, out of that much of that, with this
tool, at this tier. -/
structure Step where
  /-- Code of the artefact made. -/
  make : ℕ
  /-- Code of the material consumed. -/
  matl : ℕ
  /-- How much of it. -/
  qty : ℕ
  /-- Code of the tool used, which the step does not consume. -/
  tool : ℕ
  /-- Tier of the step. -/
  tier : ℕ
  deriving DecidableEq, Repr, Inhabited

/-- A build plan. -/
abbrev Blueprint := List Step

/-- A deck: rows of relief, exactly as they come off the tablets. -/
abbrev Deck := List (List Bool)

/-- Cells per field. -/
def stepField : ℕ := 8

/-- Cells per row: five fields. -/
def stepBits : ℕ := 5 * stepField

theorem stepBits_eq : stepBits = 40 := by decide

/-- A step is writable when each of its fields fits its field. -/
def StepFits (s : Step) : Prop :=
  s.make < names.length ∧ s.matl < names.length ∧ s.qty < 2 ^ stepField ∧
    s.tool < names.length ∧ s.tier < 3

instance (s : Step) : Decidable (StepFits s) := inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _ ∧ _))

theorem names_length_le : names.length ≤ 2 ^ stepField := by decide

/-- One step, as one row of relief. -/
def encodeStep (s : Step) : List Bool :=
  writeNat stepField s.make ++ writeNat stepField s.matl ++ writeNat stepField s.qty ++
    writeNat stepField s.tool ++ writeNat stepField s.tier

/-- One row of relief, read back as a step. -/
def decodeStep (row : List Bool) : Option Step := do
  let (a, r₁) ← readNat stepField row
  let (b, r₂) ← readNat stepField r₁
  let (c, r₃) ← readNat stepField r₂
  let (d, r₄) ← readNat stepField r₃
  let (e, _) ← readNat stepField r₄
  pure { make := a, matl := b, qty := c, tool := d, tier := e }

@[simp] theorem encodeStep_length (s : Step) : (encodeStep s).length = stepBits := by
  simp [encodeStep, stepBits, stepField]

theorem decodeStep_encodeStep {s : Step} (h : StepFits s) : decodeStep (encodeStep s) = some s := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := h
  have hb : ∀ {m : ℕ}, m < names.length → m < 2 ^ stepField := fun hm =>
    lt_of_lt_of_le hm names_length_le
  have e4 := readNat_writeNat stepField s.tool (writeNat stepField s.tier) (hb h4)
  have e3 := readNat_writeNat stepField s.qty
    (writeNat stepField s.tool ++ writeNat stepField s.tier) h3
  have e2 := readNat_writeNat stepField s.matl
    (writeNat stepField s.qty ++ (writeNat stepField s.tool ++ writeNat stepField s.tier)) (hb h2)
  have e1 := readNat_writeNat stepField s.make
    (writeNat stepField s.matl ++
      (writeNat stepField s.qty ++ (writeNat stepField s.tool ++ writeNat stepField s.tier))) (hb h1)
  have e5 : readNat stepField (writeNat stepField s.tier) = some (s.tier, []) := by
    simpa using readNat_writeNat stepField s.tier [] (lt_of_lt_of_le h5 (by decide))
  simp [encodeStep, decodeStep, List.append_assoc, e1, e2, e3, e4, e5]

/-- The deck a plan is written on. -/
def deckOf (b : Blueprint) : Deck := b.map encodeStep

/-- The plan a deck carries. -/
def planOf (d : Deck) : Option Blueprint := d.mapM decodeStep

/-- **The deck round-trips.** -/
theorem planOf_deckOf : ∀ (b : Blueprint), (∀ s ∈ b, StepFits s) → planOf (deckOf b) = some b
  | [], _ => rfl
  | s :: rest, h => by
      have hs := decodeStep_encodeStep (h s (by simp))
      have hrest := planOf_deckOf rest (fun t ht => h t (by simp [ht]))
      simp only [planOf, deckOf, List.map_cons, List.mapM_cons] at hrest ⊢
      rw [hs, hrest]
      rfl

theorem deckOf_row_length {b : Blueprint} : ∀ r ∈ deckOf b, r.length = stepBits := by
  intro r hr
  obtain ⟨s, _, rfl⟩ := List.mem_map.1 hr
  exact encodeStep_length s

/-! ## The shop: a plan built, and a shop read back -/

/-- The node a step calls for. -/
def techOf (s : Step) : Tech :=
  { id := nameOf s.make
    tier := tierOf s.tier
    inputs := [(nameOf s.matl, s.qty)]
    outputs := [(nameOf s.make, 1)]
    tools := [nameOf s.tool]
    erects := []
    baseLabor := 1
    obsDiscount := 0
    humanStep := s.tool == 0 }

/-- The build sequence a plan calls for. -/
def seqOf (b : Blueprint) : BootstrapSeq := b.map techOf

/-- A node on the shop floor, read back as a step. -/
def stepOfTech (t : Tech) : Step :=
  { make := codeOf t.id
    matl := codeOf ((t.inputs.headD ("nothing", 0)).1)
    qty := (t.inputs.headD ("nothing", 0)).2
    tool := codeOf (t.tools.headD "nothing")
    tier := t.tier.rank }

/-- The shop, read off the floor. -/
def planOfSeq (seq : BootstrapSeq) : Blueprint := seq.map stepOfTech

theorem stepOfTech_techOf {s : Step} (h : StepFits s) : stepOfTech (techOf s) = s := by
  obtain ⟨h1, h2, _, h4, h5⟩ := h
  simp only [stepOfTech, techOf, List.headD_cons, rank_tierOf h5,
    codeOf_nameOf h1, codeOf_nameOf h2, codeOf_nameOf h4]

theorem planOfSeq_seqOf : ∀ (b : Blueprint), (∀ s ∈ b, StepFits s) → planOfSeq (seqOf b) = b
  | [], _ => rfl
  | s :: rest, h => by
      simp only [planOfSeq, seqOf, List.map_cons, List.map_map] at *
      rw [stepOfTech_techOf (h s (by simp))]
      have := planOfSeq_seqOf rest (fun t ht => h t (by simp [ht]))
      simp only [planOfSeq, seqOf, List.map_map] at this
      rw [this]

/-! ## Interpreting a deck, and emitting one -/

/-- The bill a plan calls for: every step's material, and a unit of labour per
step. -/
def billOf (b : Blueprint) : Tally :=
  b.foldl (fun r s => addRes r (nameOf s.matl) s.qty) [("labor", b.length)]

/-- **Reading the deck**: the site it calls for — its own bill of materials,
the hand tools, and nothing else. -/
def interpret (d : Deck) : ResourceState :=
  match planOf d with
  | some b => { consumables := billOf b, toolsBuilt := ["initial_hand_tools"], infrastructure := [] }
  | none => { consumables := [], toolsBuilt := [], infrastructure := [] }

/-- **Pressing a tablet**: the shop writes down what is standing in it, one row
per node. -/
def emit (seq : BootstrapSeq) : Deck := deckOf (planOfSeq seq)

/-- **The shop presses the deck it came from** — for any well-formed plan. -/
theorem emit_seqOf {b : Blueprint} (h : ∀ s ∈ b, StepFits s) : emit (seqOf b) = deckOf b := by
  unfold emit
  rw [planOfSeq_seqOf b h]

/-! ## The property -/

/-- **Self-copying.**  Run the deck's own plan from the site the deck calls
for, and the tablet the shop presses is that deck again. -/
def SelfCopying (d : Deck) : Prop :=
  ∃ seq : BootstrapSeq, ValidSequence seq (interpret d) ∧ emit seq = d

/-- **The general fixed point.**  Any plan whose own bill lets it run is a
self-copying deck. -/
theorem selfCopying_of_valid {b : Blueprint} (hfit : ∀ s ∈ b, StepFits s)
    (hvalid : ValidSequence (seqOf b) (interpret (deckOf b))) : SelfCopying (deckOf b) :=
  ⟨seqOf b, hvalid, emit_seqOf hfit⟩

/-! ## The entry: two rows -/

/-- Turn a stylus out of bronze, by hand. -/
def stylusStep : Step := { make := 3, matl := 1, qty := 1, tool := 0, tier := 0 }

/-- Press a tablet of clay, with the stylus. -/
def stampStep : Step := { make := 4, matl := 2, qty := 1, tool := 3, tier := 0 }

/-- The plan: two steps. -/
def theBlueprint : Blueprint := [stylusStep, stampStep]

/-- **The deck**: two rows of forty cells. -/
def theDeck : Deck := deckOf theBlueprint

/-- The shop the deck calls for. -/
def theShop : BootstrapSeq := seqOf theBlueprint

theorem theBlueprint_fits : ∀ s ∈ theBlueprint, StepFits s := by decide

theorem theDeck_rows : theDeck.length = 2 ∧ ∀ r ∈ theDeck, r.length = stepBits := by
  refine ⟨by decide, deckOf_row_length⟩

theorem theShop_valid : ValidSequence theShop (interpret theDeck) := by decide

/-- **The claim.**  The two-row deck is self-copying. -/
theorem theDeck_selfCopying : SelfCopying theDeck :=
  selfCopying_of_valid theBlueprint_fits theShop_valid

/-- And the fixed point holds on the nose, as an equation between decks. -/
theorem theDeck_fixed_point : emit theShop = theDeck := emit_seqOf theBlueprint_fits

/-- The mechanical check a judge can run: `#eval emitCheck` prints `true`. -/
def emitCheck : Bool := emit theShop == theDeck

theorem emitCheck_true : emitCheck = true := by decide

/-! ## The correctness gate -/

/-- What the entry admits it starts with. -/
def quineExceptions : List String :=
  [ "bronze"               -- a bronze blank for the stylus
  , "clay"                 -- a lump of tempered clay
  , "labor"                -- two units of human working time
  , "initial_hand_tools"   -- a file and a hammer
  , "human_operator" ]     -- the person; the stylus step declares that it needs one

/-- No node reaches above its tier for a tool. -/
theorem theShop_tier_sound : tierSound theShop theShop = true := by decide

/-- **Tier monotonicity for the entry.** -/
theorem theShop_tier_monotone :
    ∀ t ∈ theShop, ∀ tool ∈ t.tools, toolTier theShop tool ≤ t.tier :=
  tier_monotonicity theShop_tier_sound

/-- **The exceptions are honest**: every tool the shop uses is either built by
the shop or one of the five declared exceptions. -/
theorem theShop_exceptions_honest :
    ∀ tool ∈ toolsUsed theShop, tool ∈ producedIds theShop ∨ tool ∈ quineExceptions := by
  decide

/-- The stylus is *not* free: it is not in the exceptions. -/
theorem stylus_not_an_exception : "stylus" ∉ quineExceptions := by decide

/-- **And the stylus is earned.**  The stamping step's tool was not available
on the site, so — by the general ordering theorem, not by inspection of this
list — some earlier step must have produced it. -/
theorem stylus_is_earned :
    ∃ u ∈ [techOf stylusStep], "stylus" ∈ u.outputs.map Prod.fst ∨ "stylus" ∈ u.erects := by
  have hsplit : theShop = [techOf stylusStep] ++ techOf stampStep :: [] := by decide
  have hvalid : ValidSequence ([techOf stylusStep] ++ techOf stampStep :: [])
      (interpret theDeck) := by
    rw [← hsplit]; exact theShop_valid
  refine tool_needs_earlier_producer hvalid (tool := "stylus") (by decide) ?_
  intro h
  revert h
  decide

/-- Every step of the shop needs a human, or does not, and says which: the
stylus is filed by hand, the tablet is pressed by the stylus. -/
theorem theShop_human_steps : humanSteps theShop = ["stylus"] := by decide

/-! ## The physical form: it survives the clay -/

/-- The deck, pressed into tablets. -/
def theTablets : List Tablet := stampRows stepBits theDeck

/-- **The entry in its physical form.**  Stamp the two rows into clay, trace
them back with the feeler arm, and you have the deck again. -/
theorem theDeck_survives_clay : readRows theTablets = theDeck :=
  readRows_stampRows stepBits theDeck deckOf_row_length

/-- One tablet, two rows, forty cells across. -/
theorem theTablets_eq : theTablets = [tabletOfW stepBits theDeck] := by
  have h : chunks (tabletRows - 1) theDeck = [theDeck] := by decide
  simp [theTablets, stampRows, h]

/-- One tablet, two rows, forty cells across. -/
theorem theTablets_shape :
    theTablets.length = 1 ∧ ∀ t ∈ theTablets, t.width = stepBits ∧ t.height = 2 := by
  rw [theTablets_eq]
  refine ⟨rfl, ?_⟩
  intro t ht
  simp only [List.mem_singleton] at ht
  subst ht
  exact ⟨rfl, by decide⟩

/-! ## The counterexample the entry is measured against -/

/-- One step: press a tablet of clay with the bare hand tools. -/
def degenerateStep : Step := { make := 4, matl := 2, qty := 1, tool := 0, tier := 0 }

/-- A one-row deck that also copies itself — by having no tool to build. -/
def degenerateDeck : Deck := deckOf [degenerateStep]

theorem degenerate_selfCopying : SelfCopying degenerateDeck :=
  selfCopying_of_valid (by decide) (by decide)

/-- **Which is why the exceptions list is the judging criterion it is.**  The
one-row deck is smaller and passes the same mechanical check, and it is not a
self-copying machine in any interesting sense: the only tool it uses is one it
was given.  The two-row entry uses exactly one tool, and builds it. -/
theorem degenerate_uses_no_tool_it_builds :
    ∀ tool ∈ toolsUsed (seqOf [degenerateStep]), tool ∉ producedIds (seqOf [degenerateStep]) := by
  decide

end TechTree
end LifeTrac
