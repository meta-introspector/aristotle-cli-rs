/-
# Context Windows as Typed Backpacks

Each task/thread carries a "backpack" — a context window of configurable
size and shape. The shape determines what kinds of information fit
(CRT coordinates, Bott class, resource claims, proof state, etc.),
while the size bounds how much can be carried simultaneously.

## Design

A context window is a dependent record indexed by:
  • `capacity : ℕ` — maximum number of items
  • `Shape` — a type describing the "slots" available

The backpack functor is comonadic: you can always `extract` the current
focus, and `extend` a contextual computation across all positions.
This mirrors the Store comonad in nix/comonad.nix.

## Integration

- **Paxos**: each proposal carries a context window of resource claims;
  the capacity bounds the plan phase.
- **Speculation**: speculative claims are window items with a stake field;
  the shape includes a `SpecSlot` variant.
- **CRT torus**: the window position is a `ResTriple` on the Monster torus;
  navigation shifts the window's focus without changing its contents.
-/

import Mathlib
import RequestProject.Bootstrap
import RequestProject.Consensus

set_option maxHeartbeats 400000

open Finset

/-! ## §1. Window Shape — What Kinds of Data Fit -/

/-- The shape of a context window slot.
    Each variant describes a different kind of information that can
    be packed into the backpack. -/
inductive SlotKind where
  | crt       : SlotKind   -- CRT residue triple
  | bott      : SlotKind   -- Bott/Clifford class (Fin 8)
  | resource  : SlotKind   -- resource claim (amount + stake)
  | proof     : SlotKind   -- proof state snapshot
  | trace     : SlotKind   -- syntactic trace step
  | agent     : SlotKind   -- agent identifier
  deriving DecidableEq, Repr

/-- A window shape is a multiset of slot kinds, describing what the
    backpack can hold. Different shapes support different tasks. -/
structure WindowShape where
  slots : List SlotKind
  deriving Repr

/-- The capacity of a shape is the number of slots. -/
def WindowShape.capacity (s : WindowShape) : ℕ := s.slots.length

/-- A narrow window: just CRT + Bott. Minimal context for navigation. -/
def WindowShape.narrow : WindowShape :=
  ⟨[.crt, .bott]⟩

/-- A standard window: CRT + Bott + resource + agent. -/
def WindowShape.standard : WindowShape :=
  ⟨[.crt, .bott, .resource, .agent]⟩

/-- A wide window: full context for consensus rounds. -/
def WindowShape.wide : WindowShape :=
  ⟨[.crt, .bott, .resource, .resource, .agent, .proof, .trace]⟩

/-! ## §2. Context Window — The Backpack -/

/-- A single item in the backpack, tagged by its slot kind. -/
structure BackpackItem where
  kind  : SlotKind
  value : ℕ          -- encoded value (everything is Gödel-encoded)
  deriving Repr

/-- A context window (backpack) with bounded capacity.
    Items are a list of `BackpackItem`s, length-bounded by the shape. -/
structure ContextWindow where
  shape    : WindowShape
  items    : List BackpackItem
  focus    : ℕ                   -- index of the current focus item
  position : ℕ                   -- CRT address on the Monster torus (mod 196883)
  deriving Repr

/-- A well-formed context window: items fit within the shape's capacity,
    and the focus index is valid. -/
def ContextWindow.wellFormed (w : ContextWindow) : Prop :=
  w.items.length ≤ w.shape.capacity ∧
  (w.items.length > 0 → w.focus < w.items.length) ∧
  w.position < 196883

/-- Create an empty context window at a given position. -/
def ContextWindow.empty (shape : WindowShape) (pos : ℕ) : ContextWindow :=
  { shape := shape, items := [], focus := 0, position := pos % 196883 }

/-- Pack an item into the backpack (if capacity allows). -/
def ContextWindow.pack (w : ContextWindow) (item : BackpackItem) : ContextWindow :=
  if w.items.length < w.shape.capacity then
    { w with items := w.items ++ [item] }
  else w  -- silently drop if full

/-- Extract the focused item (comonadic extract). -/
def ContextWindow.extract (w : ContextWindow) : Option BackpackItem :=
  w.items[w.focus]?

/-- Shift focus to a different item. -/
def ContextWindow.shift (w : ContextWindow) (newFocus : ℕ) : ContextWindow :=
  { w with focus := newFocus % (max w.items.length 1) }

/-- Navigate: change the torus position without altering contents. -/
def ContextWindow.navigate (w : ContextWindow) (newPos : ℕ) : ContextWindow :=
  { w with position := newPos % 196883 }

/-! ## §3. Backpack Functor — Comonadic Structure -/

/-- Map a function over all items in the backpack. -/
def ContextWindow.map (f : BackpackItem → BackpackItem) (w : ContextWindow) : ContextWindow :=
  { w with items := w.items.map f }

/-- Extend: apply a contextual computation at every position.
    Given `f : ContextWindow → BackpackItem`, produce a new window where
    each slot contains the result of `f` focused on that slot. -/
def ContextWindow.extend (f : ContextWindow → BackpackItem)
    (w : ContextWindow) : ContextWindow :=
  let newItems := List.ofFn (fun (i : Fin w.items.length) =>
    f { w with focus := i.val })
  { w with items := newItems }

/-- Duplicate: each slot becomes a window focused on that slot. -/
-- (Type-erased version: we store the focus index as encoded value.)
def ContextWindow.duplicate (w : ContextWindow) : ContextWindow :=
  let newItems := List.ofFn (fun (i : Fin w.items.length) =>
    { kind := SlotKind.trace, value := i.val : BackpackItem })
  { w with items := newItems }

/-! ## §4. Resource Claims in Context Windows -/

/-- A resource claim packed into a backpack item. -/
def packResourceClaim (amount stake : ℕ) : BackpackItem :=
  { kind := .resource, value := amount * 196883 + stake }

/-- Unpack a resource claim. -/
def unpackResourceClaim (item : BackpackItem) : ℕ × ℕ :=
  (item.value / 196883, item.value % 196883)

/-- A speculative claim: resource + stake + epoch, CRT-addressed. -/
structure SpeculativeClaim where
  agent      : ℕ      -- agent encoding
  resourceId : ℕ
  amount     : ℕ
  stake      : ℕ
  epoch      : ℕ
  deriving Repr

/-- Pack a speculative claim into the backpack. -/
def SpeculativeClaim.toItem (c : SpeculativeClaim) : BackpackItem :=
  { kind := .resource, value := c.amount * 1000 + c.stake }

/-- Create a proposal window: a context window pre-loaded with claims. -/
def proposalWindow (claims : List SpeculativeClaim) (pos : ℕ) : ContextWindow :=
  let shape : WindowShape := ⟨claims.map (fun _ => SlotKind.resource)⟩
  let items := claims.map SpeculativeClaim.toItem
  { shape := shape, items := items, focus := 0, position := pos % 196883 }

/-! ## §5. Window Size Classes -/

/-- Size class taxonomy for context windows. -/
inductive SizeClass where
  | micro  : SizeClass   -- 1-2 slots (single navigation)
  | small  : SizeClass   -- 3-4 slots (standard task)
  | medium : SizeClass   -- 5-8 slots (consensus round)
  | large  : SizeClass   -- 9-16 slots (full boardroom)
  | jumbo  : SizeClass   -- 17+ slots (bulk operations)
  deriving DecidableEq, Repr

/-- Classify a window by its capacity. -/
def classifyWindow (w : ContextWindow) : SizeClass :=
  let cap := w.shape.capacity
  if cap ≤ 2 then .micro
  else if cap ≤ 4 then .small
  else if cap ≤ 8 then .medium
  else if cap ≤ 16 then .large
  else .jumbo

/-! ## §6. Theorems -/

/-- An empty window is well-formed. -/
theorem empty_wellFormed (shape : WindowShape) (pos : ℕ) :
    (ContextWindow.empty shape pos).wellFormed := by
  unfold ContextWindow.empty ContextWindow.wellFormed
  simp [List.length]
  omega

/-- Packing into a non-full window increases length by 1. -/
theorem pack_length (w : ContextWindow) (item : BackpackItem)
    (h : w.items.length < w.shape.capacity) :
    (w.pack item).items.length = w.items.length + 1 := by
  unfold ContextWindow.pack
  simp [h, List.length_append]

/-- Navigation preserves items. -/
theorem navigate_preserves_items (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).items = w.items := by
  unfold ContextWindow.navigate
  rfl

/-- Navigation preserves shape. -/
theorem navigate_preserves_shape (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).shape = w.shape := by
  unfold ContextWindow.navigate
  rfl

/-- The position after navigation is in range. -/
theorem navigate_position_bounded (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).position < 196883 := by
  unfold ContextWindow.navigate
  simp
  omega

/-- A proposal window has as many items as claims. -/
theorem proposalWindow_length (claims : List SpeculativeClaim) (pos : ℕ) :
    (proposalWindow claims pos).items.length = claims.length := by
  unfold proposalWindow
  simp [List.length_map]

/-- Quorum intersection ensures no conflicting context windows
    can be committed simultaneously (links to Consensus.lean). -/
theorem context_quorum_safety (n : ℕ) (Q₁ Q₂ : Finset (Fin n))
    (h₁ : IsQuorum n Q₁) (h₂ : IsQuorum n Q₂) :
    (Q₁ ∩ Q₂).Nonempty :=
  quorum_intersection n Q₁ Q₂ h₁ h₂

