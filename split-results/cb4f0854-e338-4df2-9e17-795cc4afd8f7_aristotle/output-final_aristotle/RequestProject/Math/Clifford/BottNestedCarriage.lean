/-
# BottNestedCarriage — The 8-Periodic Russian Doll CAR

## Structure

A carriage whose payload is itself a CAR file, nested up to 8 layers deep,
with the 8th layer canonically equivalent to the 0th via Bott periodicity.

Each layer corresponds to a Clifford algebra Morita class:

| Layer | Clifford class   | Semantic role     |
|-------|------------------|-------------------|
| 0     | ℝ                | Raw j-coefficient |
| 1     | ℂ                | Transport         |
| 2     | ℍ                | Governance        |
| 3     | ℍ ⊕ ℍ            | Shadow            |
| 4     | M₂(ℍ)            | Clifford          |
| 5     | M₄(ℂ)            | Semantic          |
| 6     | M₈(ℝ)            | Boundary          |
| 7     | M₈(ℝ) ⊕ M₈(ℝ)   | Bulk              |

After 8 layers the structure returns to itself: `bottFold` maps
layer 7 back to layer 0 via the KO-periodicity isomorphism.
-/

import Mathlib
import RequestProject.Math.Monster.MonsterCarriageTrain

set_option maxHeartbeats 800000

open MonsterTrain

namespace BottNested

/-! ## §1. The Bott Layer Index -/

/-- The 8 Clifford Morita classes, indexed by Bott degree. -/
inductive CliffordClass where
  | R | C | H | HH | M2H | M4C | M8R | M8RR
  deriving DecidableEq, Repr

/-- The Bott clock: maps layer index to Clifford class. -/
def bottClock : Fin 8 → CliffordClass
  | 0 => .R | 1 => .C | 2 => .H | 3 => .HH
  | 4 => .M2H | 5 => .M4C | 6 => .M8R | 7 => .M8RR

/-- The Bott clock is injective. -/
theorem bottClock_injective : Function.Injective bottClock := by decide

/-! ## §2. Layer Payloads and the Nested Carriage -/

/-- A payload at a given Bott layer. -/
structure LayerPayload where
  cid     : CID
  payload : ℕ
  layer   : Fin 8
  deriving Repr, DecidableEq

/-- The nested carriage: a list of layer payloads forming a Russian doll. -/
structure NestedCarriage where
  layers : List LayerPayload
  deriving Repr, DecidableEq

/-- A nested carriage is *well-layered* if each layer's index = position mod 8. -/
def NestedCarriage.wellLayered (nc : NestedCarriage) : Prop :=
  ∀ i (hi : i < nc.layers.length),
    (nc.layers[i]).layer = ⟨i % 8, Nat.mod_lt _ (by omega)⟩

/-- The depth of a nested carriage. -/
def NestedCarriage.depth (nc : NestedCarriage) : ℕ := nc.layers.length

/-- The empty nested carriage. -/
def NestedCarriage.empty : NestedCarriage := ⟨[]⟩

/-- The empty carriage is well-layered (vacuously). -/
theorem empty_wellLayered : NestedCarriage.empty.wellLayered :=
  fun _ hi => absurd hi (by simp [NestedCarriage.empty])

/-- A single-layer nested carriage. -/
def NestedCarriage.single (cid : CID) (payload : ℕ) : NestedCarriage :=
  ⟨[{ cid := cid, payload := payload, layer := 0 }]⟩

/-- The single-layer carriage is well-layered. -/
theorem single_wellLayered (cid : CID) (payload : ℕ) :
    (NestedCarriage.single cid payload).wellLayered := by
  intro i hi
  simp [NestedCarriage.single] at hi; subst hi; rfl

/-! ## §3. The Nest Operation -/

/-- Add one nesting layer. -/
def nest (nc : NestedCarriage) (cid : CID) (payload : ℕ) : NestedCarriage :=
  ⟨nc.layers ++ [{ cid := cid, payload := payload,
                    layer := ⟨nc.layers.length % 8, Nat.mod_lt _ (by omega)⟩ }]⟩

/-- Nesting increases depth by 1. -/
theorem nest_depth (nc : NestedCarriage) (cid : CID) (payload : ℕ) :
    (nest nc cid payload).depth = nc.depth + 1 := by
  simp [nest, NestedCarriage.depth]

/-- Nesting preserves well-layeredness. -/
theorem nest_wellLayered (nc : NestedCarriage) (cid : CID) (payload : ℕ)
    (h : nc.wellLayered) : (nest nc cid payload).wellLayered := by
  intro i hi
  simp [nest] at hi
  by_cases hlt : i < nc.layers.length
  · simp [nest, List.getElem_append_left hlt]
    exact h i hlt
  · have heq : i = nc.layers.length := by omega
    subst heq
    simp [nest, List.getElem_append_right (by omega)]

/-! ## §4. The Bott Fold — 8-Periodic Collapse -/

/-- The Bott fold: re-assign all layer indices to (position mod 8). -/
def bottFold (nc : NestedCarriage) : NestedCarriage :=
  ⟨nc.layers.zipIdx.map (fun ⟨lp, i⟩ =>
    { lp with layer := ⟨i % 8, Nat.mod_lt _ (by omega)⟩ })⟩

/-- bottFold produces a well-layered carriage. -/
theorem bottFold_wellLayered (nc : NestedCarriage) :
    (bottFold nc).wellLayered := by
  intro i hi
  simp [bottFold, List.length_zipIdx] at hi
  simp [bottFold, List.getElem_map, List.getElem_zipIdx]

/-- bottFold preserves depth. -/
theorem bottFold_depth (nc : NestedCarriage) :
    (bottFold nc).depth = nc.depth := by
  simp [bottFold, NestedCarriage.depth, List.length_zipIdx]

/-
bottFold is idempotent.
-/
theorem bottFold_idempotent (nc : NestedCarriage) :
    bottFold (bottFold nc) = bottFold nc := by
  unfold bottFold; aesop;

/-
On a well-layered carriage, bottFold is the identity.
-/
theorem bottFold_on_wellLayered (nc : NestedCarriage) (h : nc.wellLayered) :
    bottFold nc = nc := by
  cases nc;
  rename_i layers;
  have h_map_id : ∀ (lp : LayerPayload) (i : ℕ), lp ∈ layers → lp.layer = ⟨i % 8, Nat.mod_lt _ (by omega)⟩ → { lp with layer := ⟨i % 8, Nat.mod_lt _ (by omega)⟩ } = lp := by
                                                                                                                exact fun lp i h₁ h₂ => by cases lp; aesop;
  exact congr_arg _ ( List.ext_getElem ( by aesop ) ( by aesop ) )

/-! ## §5. The Cyclic Advance -/

/-- Advance by adding a layer. If depth ≥ 8, fold first. -/
def cyclicAdvance (nc : NestedCarriage) (cid : CID) (payload : ℕ) : NestedCarriage :=
  if nc.depth ≥ 8 then nest (bottFold nc) cid payload
  else nest nc cid payload

/-! ## §6. The Flatten Bridge — Nested ↔ Flat CAR -/

/-- Helper: build parent link from index. -/
private def mkParent (layers : List LayerPayload) (i : ℕ) : Option CID :=
  if h : 0 < i ∧ i ≤ layers.length then
    some (layers[i - 1]'(by omega)).cid
  else none

def flatten (nc : NestedCarriage) : List CARBlock :=
  nc.layers.zipIdx.map (fun ⟨lp, i⟩ =>
    { cid := lp.cid,
      payload := lp.payload,
      parent := mkParent nc.layers i })

/-- Flattening preserves length. -/
theorem flatten_length (nc : NestedCarriage) :
    (flatten nc).length = nc.depth := by
  simp [flatten, NestedCarriage.depth, List.length_zipIdx]

/-- Lift a flat CAR to a nested carriage (with Bott indices assigned). -/
def liftCAR (blocks : List CARBlock) : NestedCarriage :=
  ⟨blocks.zipIdx.map (fun ⟨b, i⟩ =>
    { cid := b.cid, payload := b.payload,
      layer := ⟨i % 8, Nat.mod_lt _ (by omega)⟩ })⟩

/-- Lifting produces a well-layered carriage. -/
theorem liftCAR_wellLayered (blocks : List CARBlock) :
    (liftCAR blocks).wellLayered := by
  intro i hi
  simp [liftCAR, List.length_zipIdx] at hi
  simp [liftCAR, List.getElem_map, List.getElem_zipIdx]

/-- Lifting preserves length. -/
theorem liftCAR_length (blocks : List CARBlock) :
    (liftCAR blocks).depth = blocks.length := by
  simp [liftCAR, NestedCarriage.depth, List.length_zipIdx]

/-! ## §7. The Full Bott-Periodic Monster Limo -/

/-- A limo carriage: nested structure with j-coefficient capacity. -/
structure LimoCarriage where
  grade    : ℕ
  nested   : NestedCarriage
  capacity : ℕ
  deriving Repr

/-- Well-formedness: capacity matches j-coefficient. -/
def LimoCarriage.wellFormed (lc : LimoCarriage) : Prop :=
  lc.capacity = jCoefficient lc.grade

/-- Canonical limo carriage at grade n: single-layer nesting. -/
def LimoCarriage.canonical (n : ℕ) : LimoCarriage where
  grade := n
  nested := NestedCarriage.single ⟨n⟩ (jCoefficient n)
  capacity := jCoefficient n

/-- Canonical limo carriages are well-formed. -/
theorem canonical_limo_wf (n : ℕ) : (LimoCarriage.canonical n).wellFormed := rfl

/-- The full Bott-periodic Monster limo. -/
structure BottLimo where
  king     : King
  cars     : List LimoCarriage
  location : City
  deriving Repr

/-- The limo is well-formed if every carriage is. -/
def BottLimo.wellFormed (bl : BottLimo) : Prop :=
  ∀ lc ∈ bl.cars, lc.wellFormed

/-- Initial Bott limo at Rome with N carriages. -/
def BottLimo.initial (depth : ℕ) : BottLimo where
  king := King.initial
  cars := List.ofFn (fun (i : Fin depth) => LimoCarriage.canonical i.val)
  location := City.rome

/-- The initial Bott limo is well-formed. -/
theorem initial_bott_wf (depth : ℕ) : (BottLimo.initial depth).wellFormed := by
  intro lc hlc
  simp [BottLimo.initial] at hlc
  obtain ⟨i, rfl⟩ := hlc
  exact canonical_limo_wf i.val

/-- Advance the Bott limo one step along the route. -/
def advanceBottLimo (bl : BottLimo) : BottLimo where
  king := { legitimacy := bl.king.legitimacy + 1,
            resolve := bl.king.resolve + resistance bl.location }
  cars := bl.cars
  location := bl.location.next

/-- Advance preserves well-formedness. -/
theorem advanceBottLimo_preserves_wf (bl : BottLimo)
    (h : bl.wellFormed) : (advanceBottLimo bl).wellFormed :=
  fun lc hlc => h lc hlc

/-! ## §8. Bott Period 8 — Concrete Example -/

/-- Build a full 8-layer nested carriage using j-coefficients. -/
def nest8 : NestedCarriage :=
  let f := fun (nc : NestedCarriage) (i : ℕ) => nest nc ⟨i⟩ (jCoefficient i)
  f (f (f (f (f (f (f (f NestedCarriage.empty 0) 1) 2) 3) 4) 5) 6) 7

/-- nest8 has depth exactly 8. -/
theorem nest8_depth : nest8.depth = 8 := by native_decide

/-- The first 4 j-coefficients appear as payloads. -/
theorem nest8_payloads :
    (nest8.layers.map (·.payload)).take 4 =
    [jCoefficient 0, jCoefficient 1, jCoefficient 2, jCoefficient 3] := by
  native_decide

/-- Folding nest8 preserves depth. -/
theorem nest8_fold_depth : (bottFold nest8).depth = 8 := by
  rw [bottFold_depth]; exact nest8_depth

/-- The layer indices of nest8 are 0, 1, 2, 3, 4, 5, 6, 7. -/
theorem nest8_layer_indices :
    nest8.layers.map (fun lp => lp.layer.val) = [0, 1, 2, 3, 4, 5, 6, 7] := by
  native_decide

/-! ## §9. Summary

| Object           | Type                  | Role                              |
|------------------|-----------------------|-----------------------------------|
| LayerPayload     | CID × ℕ × Fin 8      | One shell of the Russian doll     |
| NestedCarriage   | List LayerPayload     | The full doll with layering       |
| nest             | NC → NC               | Add one shell                     |
| bottFold         | NC → NC               | 8-periodic normalization          |
| cyclicAdvance    | NC → NC               | Add shell + fold if full          |
| flatten          | NC → List CARBlock    | Bridge to flat CAR layer          |
| liftCAR          | List CARBlock → NC    | Bridge from flat CAR              |
| LimoCarriage     | grade × NC × capacity | Train carriage with nesting       |
| BottLimo         | King + cars + City    | The full Bott-periodic limo       |

The nested carriage is the Monster limo upgraded from a flat list
into a Bott-periodic, self-nested, content-addressed organism. -/

end BottNested