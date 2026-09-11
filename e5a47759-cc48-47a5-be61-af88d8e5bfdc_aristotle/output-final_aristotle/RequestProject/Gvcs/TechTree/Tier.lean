import RequestProject.Gvcs.TechTree.Core

/-!
# You cannot skip the skill tree

The tiers are ordered clockwork < steam < hydraulic.  The claim this file makes
checkable is that no node reaches *upwards* for its tools: a clockwork-tier
step may not be built with a hydraulic press, because then the clockwork tier
would not be a starting point at all and the greenfield claim would be empty.

* `toolTier` — the tier of a tool, looked up in a catalogue by the id of the
  node that makes it.  A tool that no node makes is one of the bootstrap
  exceptions and is taken to be clockwork-tier: hand tools, a hearth, a human.
  That default is an assumption, and `exceptions_are_clockwork` states it
  rather than hiding it.
* `tierSound` — the executable check.
* `tier_monotonicity` — the theorem: if the check passes, every tool of every
  step is of that step's tier or below.
* `tiers_nondecreasing` — a stronger property a good bootstrap has: the tiers
  of the steps, read in order, never go down.
-/

namespace LifeTrac
namespace TechTree

/-- The tier of a tool: the tier of the node that makes it, or clockwork if no
node makes it (a bootstrap exception). -/
def toolTier (cat : List Tech) (tool : String) : TechTier :=
  match cat.find? (fun t => t.id == tool) with
  | some t => t.tier
  | none => TechTier.clockwork

/-- **The declared default.**  A tool that the catalogue does not make is a
bootstrap exception, and is treated as clockwork-tier: hand tools and human
hands, nothing that presupposes a later tier. -/
theorem exceptions_are_clockwork (cat : List Tech) (tool : String)
    (h : ∀ t ∈ cat, t.id ≠ tool) : toolTier cat tool = TechTier.clockwork := by
  unfold toolTier
  cases hf : cat.find? (fun t => t.id == tool) with
  | none => rfl
  | some t =>
      have hmem := List.find?_some hf
      have : t ∈ cat := List.mem_of_find?_eq_some hf
      simp only [beq_iff_eq] at hmem
      exact absurd hmem (h t this)

/-- The executable check: no step reaches above its own tier for a tool. -/
def tierSound (cat : List Tech) (seq : BootstrapSeq) : Bool :=
  seq.all (fun t => t.tools.all (fun tool => decide (toolTier cat tool ≤ t.tier)))

/-- **Tier monotonicity.**  If the check passes, no node's tools reach into a
higher tier than the node's own — the formal version of "you cannot skip the
skill tree". -/
theorem tier_monotonicity {cat : List Tech} {seq : BootstrapSeq} (h : tierSound cat seq = true) :
    ∀ t ∈ seq, ∀ tool ∈ t.tools, toolTier cat tool ≤ t.tier := by
  intro t ht tool htool
  have h1 := (List.all_eq_true.1 h) t ht
  have h2 := (List.all_eq_true.1 h1) tool htool
  simpa using h2

/-- The tiers of a sequence, in order. -/
def tierTrace (seq : BootstrapSeq) : List TechTier := seq.map Tech.tier

/-- A sequence climbs the tree: its tiers never go down. -/
def tiersNondecreasing (seq : BootstrapSeq) : Prop := List.IsChain (· ≤ ·) (tierTrace seq)

instance (seq : BootstrapSeq) : Decidable (tiersNondecreasing seq) :=
  inferInstanceAs (Decidable (List.IsChain _ _))

end TechTree
end LifeTrac
