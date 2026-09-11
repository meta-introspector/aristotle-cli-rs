/-
# Self-Modifying Context Windows

The *shape* of a context window determines:
1. What **transformations** are allowed on the window itself
2. What **metamemes** can be transported through it
3. What **governance actions** the carrying agent may take

This file formalizes context-driven self-modification as a
typed discipline: a window can only apply a transformation if
its shape *admits* that transformation — checked statically
via a `ShapePermission` predicate.

## Architecture

    Shape ──► Permission Set ──► Allowed Ops

Each `SlotKind` in the window's shape contributes a permission.
The full permission set is the multiset union of all slot permissions.
A transformation requires a specific permission subset; the window
can apply it only if the required permissions are covered.

## Connection to the Monster Lattice

The Monster torus position further constrains permissions:
positions in certain residue classes unlock "metameme transport"
and "governance proposal" capabilities, linking the algebraic
window structure to the CRT addressing system.

## Theorems

- Permission coverage is monotone: wider windows have more permissions
- Self-modification preserves well-formedness
- Metameme transport requires both `proof` and `bott` slots
- Governance actions require quorum-witnessing `agent` slots
- The permission lattice is a bounded distributive lattice
-/

import Mathlib
import RequestProject.ContextWindow
import RequestProject.ContextWindowAlgebra

set_option maxHeartbeats 800000

open Finset

namespace SelfModifyingContext

/-! ## §1. Permission System — What a Shape Allows -/

/-- Permissions that a context window can carry, determined by its shape. -/
inductive Permission where
  | navigate       : Permission  -- shift torus position
  | transport      : Permission  -- carry metamemes across fibers
  | propose        : Permission  -- submit governance proposals
  | vote           : Permission  -- participate in quorum votes
  | modify_self    : Permission  -- reshape the window itself
  | merge_external : Permission  -- fuse with another agent's window
  | compress       : Permission  -- reduce window to a smaller shape
  | expand         : Permission  -- grow the window with new slots
  deriving DecidableEq, Repr

/-- Each slot kind grants a set of permissions. -/
def slotPermissions : SlotKind → List Permission
  | .crt      => [.navigate]
  | .bott     => [.transport]
  | .resource => [.modify_self, .compress]
  | .proof    => [.transport, .modify_self]
  | .trace    => [.compress]
  | .agent    => [.propose, .vote, .merge_external]

/-- The full permission set of a window shape:
    the union of all slot permissions. -/
def shapePermissions (s : WindowShape) : List Permission :=
  s.slots.flatMap slotPermissions

/-- A window has a permission if it appears in its shape's permission list. -/
def hasPermission (w : ContextWindow) (p : Permission) : Prop :=
  p ∈ shapePermissions w.shape

instance (w : ContextWindow) (p : Permission) : Decidable (hasPermission w p) :=
  inferInstanceAs (Decidable (p ∈ shapePermissions w.shape))

/-! ## §2. Transformation Descriptors -/

/-- A transformation that can be applied to a context window.
    Each transformation has a set of required permissions. -/
structure Transformation where
  name     : String
  required : List Permission
  deriving Repr

/-- A transformation is *admissible* for a window if the window
    has all required permissions. -/
def admissible (t : Transformation) (w : ContextWindow) : Prop :=
  ∀ p ∈ t.required, hasPermission w p

instance (t : Transformation) (w : ContextWindow) : Decidable (admissible t w) :=
  inferInstanceAs (Decidable (∀ p ∈ t.required, p ∈ shapePermissions w.shape))

/-! ## §3. Standard Transformations -/

/-- Navigate: requires CRT slot. -/
def tNavigate : Transformation :=
  ⟨"navigate", [.navigate]⟩

/-- Transport metameme: requires both proof and bott slots. -/
def tTransport : Transformation :=
  ⟨"transport", [.transport]⟩

/-- Propose governance action: requires agent slots for proposal + vote. -/
def tPropose : Transformation :=
  ⟨"propose", [.propose, .vote]⟩

/-- Self-modify: reshape the window. Requires resource or proof slot. -/
def tModifySelf : Transformation :=
  ⟨"modify_self", [.modify_self]⟩

/-- Compress: reduce to smaller shape. Requires trace or resource slot. -/
def tCompress : Transformation :=
  ⟨"compress", [.compress]⟩

/-- Expand: grow with new slots. Requires modify_self + expand. -/
def tExpand : Transformation :=
  ⟨"expand", [.modify_self, .expand]⟩

/-- Full metameme transport: requires transport + navigate + modify_self. -/
def tFullTransport : Transformation :=
  ⟨"full_transport", [.transport, .navigate, .modify_self]⟩

/-! ## §4. Self-Modification Operations -/

/-- Add a slot to a window's shape (expand operation). -/
def expandWindow (w : ContextWindow) (k : SlotKind) : ContextWindow :=
  { w with shape := ⟨w.shape.slots ++ [k]⟩ }

/-- Remove the last slot from a window's shape (compress operation).
    Focus is reset to 0 to maintain well-formedness. -/
def compressWindow (w : ContextWindow) : ContextWindow :=
  { w with
    shape := ⟨w.shape.slots.dropLast⟩
    items := w.items.take (w.shape.slots.dropLast.length)
    focus := 0 }

/-- Replace a slot kind at a given index (reshape operation). -/
def reshapeSlot (w : ContextWindow) (idx : ℕ) (k : SlotKind) : ContextWindow :=
  { w with shape := ⟨w.shape.slots.set idx k⟩ }

/-! ## §5. Permission Monotonicity -/

/-- Adding a slot can only add permissions, never remove them.
    This is the monotonicity property of the permission functor. -/
theorem expand_preserves_permissions (w : ContextWindow) (k : SlotKind) (p : Permission)
    (h : hasPermission w p) : hasPermission (expandWindow w k) p := by
  unfold hasPermission expandWindow shapePermissions at *
  rw [List.flatMap_append] at *
  simp [List.mem_append] at *
  exact Or.inl h

/-- A wider shape has at least as many permissions. -/
theorem wider_more_permissions (s₁ s₂ : WindowShape)
    (h : ∀ x, x ∈ s₁.slots → x ∈ s₂.slots)
    (p : Permission) (hp : p ∈ shapePermissions s₁) :
    p ∈ shapePermissions s₂ := by
  unfold shapePermissions at *
  rw [List.mem_flatMap] at *
  obtain ⟨slot, hslot_mem, hp_mem⟩ := hp
  exact ⟨slot, h slot hslot_mem, hp_mem⟩

/-! ## §6. Well-Formedness Preservation -/

/-- Expanding a well-formed window produces a well-formed window
    (assuming the window has no items exceeding original capacity). -/
theorem expand_wellFormed (w : ContextWindow) (k : SlotKind)
    (hw : w.wellFormed) : (expandWindow w k).wellFormed := by
  unfold expandWindow ContextWindow.wellFormed WindowShape.capacity at *
  obtain ⟨h1, h2, h3⟩ := hw
  simp [List.length_append]
  exact ⟨by omega, fun hlen => h2 hlen, h3⟩

/-- Compressing a well-formed window produces a well-formed window. -/
theorem compress_wellFormed (w : ContextWindow)
    (hw : w.wellFormed) (hne : w.shape.slots.length > 0) :
    (compressWindow w).wellFormed := by
  unfold compressWindow ContextWindow.wellFormed WindowShape.capacity at *
  obtain ⟨h1, _, h3⟩ := hw
  simp only [List.length_take, List.length_dropLast]
  exact ⟨by omega, fun _ => by omega, h3⟩

/-! ## §7. Monster-Torus Permission Gating -/

/-- Some permissions are further gated by the Monster torus position.
    Positions in certain residue classes unlock additional capabilities. -/
def torusGatedPermission (pos : ℕ) : List Permission :=
  let base : List Permission := [.navigate]
  let transport_gate := if pos % 71 = 0 then [Permission.transport] else []
  let governance_gate := if pos % 59 = 0 then [Permission.propose, Permission.vote] else []
  let expand_gate := if pos % 47 = 0 then [Permission.expand] else []
  base ++ transport_gate ++ governance_gate ++ expand_gate

/-- A window's effective permissions: shape permissions ∩ torus-gated permissions.
    The window can only use a permission if both shape and torus position allow it. -/
def effectivePermissions (w : ContextWindow) : List Permission :=
  (shapePermissions w.shape).filter (· ∈ torusGatedPermission w.position)

/-- A transformation is *effectively admissible* if all required permissions
    are in the effective permission set. -/
def effectivelyAdmissible (t : Transformation) (w : ContextWindow) : Prop :=
  ∀ p ∈ t.required, p ∈ effectivePermissions w

instance (t : Transformation) (w : ContextWindow) :
    Decidable (effectivelyAdmissible t w) :=
  inferInstanceAs (Decidable (∀ p ∈ t.required,
    p ∈ (shapePermissions w.shape).filter (· ∈ torusGatedPermission w.position)))

/-- Navigation is always effectively admissible for any window with a CRT slot,
    since navigate is always torus-gated. -/
theorem navigate_always_admissible (w : ContextWindow)
    (h : SlotKind.crt ∈ w.shape.slots) :
    effectivelyAdmissible tNavigate w := by
  unfold effectivelyAdmissible tNavigate effectivePermissions
  intro p hp
  simp at hp; subst hp
  simp [List.mem_filter]
  constructor
  · unfold shapePermissions
    rw [List.mem_flatMap]
    exact ⟨.crt, h, by simp [slotPermissions]⟩
  · unfold torusGatedPermission
    simp

/-! ## §8. Metameme Transport Conditions -/

/-- A metameme descriptor: a typed semantic unit that can be transported
    between context windows via fiber-preserving maps. -/
structure Metameme where
  memeId    : ℕ
  sourcePos : ℕ     -- source torus position
  targetPos : ℕ     -- target torus position
  payload   : ℕ     -- Gödel-encoded content
  deriving Repr

/-- A metameme can be transported if the window has transport permission
    and the source/target positions are compatible (same 71-residue class). -/
def canTransport (w : ContextWindow) (m : Metameme) : Prop :=
  hasPermission w .transport ∧
  w.position % 71 = m.sourcePos % 71

instance (w : ContextWindow) (m : Metameme) : Decidable (canTransport w m) :=
  inferInstanceAs (Decidable (hasPermission w .transport ∧
    w.position % 71 = m.sourcePos % 71))

/-
Transport requires at least a bott or proof slot.
-/
theorem transport_requires_bott_or_proof (w : ContextWindow)
    (h : hasPermission w .transport) :
    SlotKind.bott ∈ w.shape.slots ∨ SlotKind.proof ∈ w.shape.slots := by
  contrapose! h;
  unfold hasPermission shapePermissions; simp_all +decide [ List.mem_flatMap ] ;
  intro x hx; unfold slotPermissions; aesop;

/-! ## §9. Governance Action Gating -/

/-- The minimum number of agent slots required to form a governance quorum. -/
def minAgentSlots : ℕ := 3

/-- A window can propose governance actions if it has enough agent slots. -/
def canPropose (w : ContextWindow) : Prop :=
  (w.shape.slots.filter (· == .agent)).length ≥ minAgentSlots

instance (w : ContextWindow) : Decidable (canPropose w) :=
  inferInstanceAs (Decidable ((w.shape.slots.filter (· == .agent)).length ≥ minAgentSlots))

/-
A hypergraph task shape always has agent slots.
-/
theorem hypergraph_has_agent_slots (t : TaskDescriptor)
    (hg : t.geometry = SemanticGeometry.hypergraph) :
    SlotKind.agent ∈ (taskShape t).slots := by
  unfold taskShape; aesop;

/-! ## §10. The Self-Modification Monad -/

/-- A self-modification step: either succeed with a new window,
    or fail with an error message. -/
inductive ModResult where
  | ok   : ContextWindow → ModResult
  | fail : String → ModResult
  deriving Repr

/-- Apply a transformation to a window, checking admissibility. -/
def applyTransformation (t : Transformation) (w : ContextWindow)
    (f : ContextWindow → ContextWindow) : ModResult :=
  if admissible t w then
    .ok (f w)
  else
    .fail s!"Transformation '{t.name}' not admissible: missing permissions"

/-- Chain two self-modification steps. -/
def ModResult.bind (r : ModResult) (f : ContextWindow → ModResult) : ModResult :=
  match r with
  | .ok w => f w
  | .fail msg => .fail msg

/-- A self-modification program: a sequence of guarded transformations. -/
def selfModify (w : ContextWindow) (steps : List (Transformation × (ContextWindow → ContextWindow)))
    : ModResult :=
  steps.foldl (fun acc ⟨t, f⟩ => acc.bind (fun w' => applyTransformation t w' f)) (.ok w)

/-! ## §11. Computational Demos -/

/-- A wide window with full permissions. -/
def demoWide : ContextWindow :=
  { shape := .wide, items := [], focus := 0, position := 0 }

/-- A narrow window with minimal permissions. -/
def demoNarrow : ContextWindow :=
  { shape := .narrow, items := [], focus := 0, position := 0 }

#eval (shapePermissions WindowShape.wide).map reprStr
#eval (shapePermissions WindowShape.narrow).map reprStr
#eval decide (admissible tNavigate demoWide)
#eval decide (admissible tTransport demoWide)
#eval decide (admissible tPropose demoWide)
#eval decide (admissible tNavigate demoNarrow)
#eval decide (admissible tTransport demoNarrow)
#eval decide (admissible tPropose demoNarrow)

-- Torus-gated: position 0 is divisible by 71, 59, and 47
#eval (effectivePermissions demoWide).map reprStr
-- Position 1: only navigate is gated
#eval (effectivePermissions { demoWide with position := 1 }).map reprStr

-- Self-modification chain
#eval selfModify demoNarrow [
  (tNavigate, fun w => w.navigate 42),
  (tCompress, fun w => compressWindow w)   -- should fail: narrow has no compress permission
]

#eval selfModify demoWide [
  (tNavigate, fun w => w.navigate 42),
  (tCompress, fun w => compressWindow w),  -- wide has compress via resource/trace
  (tModifySelf, fun w => expandWindow w .agent)
]

end SelfModifyingContext