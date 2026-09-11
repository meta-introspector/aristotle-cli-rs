/-
# Landing Instructions: Self-Steering in the CRT Torus

A **landing instruction** is a statement whose semantics is:

> Compute and append a suffix that steers identifier `s` to target
> residue `t` in `F₄₇ × F₅₉ × F₇₁`.

This is the transition from *self-description* to *self-navigation*:
a name that can locate itself can also compute a suffix that moves it
to any chosen coordinate in the Monster irrep residue space.

## Architecture

    identifier s
        ↓ encodeResidue
    current position r ∈ F₄₇ × F₅₉ × F₇₁
        ↓ compute delta = t - r
    target delta δ
        ↓ CRT reconstruction → d < 196883
    suffix w with encodeString(w) = d
        ↓ append
    s ++ w lands at t

## Key results

- `findSuffix_correct_delta`: the suffix solver hits every delta (`native_decide`)
- `findSuffix_lands`: for any base string and target, appending the suffix lands
- `self_steering_complete`: "land_at_self" is registered and fully self-steering
-/

import Mathlib
import RequestProject.Bootstrap

set_option maxHeartbeats 3200000
set_option maxRecDepth 4096

namespace LandingInstruction

/-! ## §1. The Residue Triple Type -/

/-- A residue triple in the CRT torus F₄₇ × F₅₉ × F₇₁.
    196883 = 47 × 59 × 71 points — the Monster's smallest nontrivial irrep. -/
abbrev ResTriple := Fin 47 × Fin 59 × Fin 71

/-- Component-wise addition of residue triples. -/
instance : Add ResTriple where
  add a b := (a.1 + b.1, a.2.1 + b.2.1, a.2.2 + b.2.2)

/-- Component-wise subtraction of residue triples. -/
instance : Sub ResTriple where
  sub a b := (a.1 - b.1, a.2.1 - b.2.1, a.2.2 - b.2.2)

/-- `a + (b - a) = b` in the residue torus. -/
private theorem add_sub_eq (a b : ResTriple) : a + (b - a) = b := by
  simp only [HAdd.hAdd, HSub.hSub, Add.add, Sub.sub]
  ext <;> dsimp <;>
    (show ((_ : Fin _) + ((_ : Fin _) - (_ : Fin _))).val = _) <;>
    simp [add_sub_cancel]

/-! ## §2. Encoding and Landing -/

/-- Encode a string to its residue triple in F₄₇ × F₅₉ × F₇₁. -/
def encodeResidue (s : String) : ResTriple :=
  let n := encodeString s
  (⟨n % 47, Nat.mod_lt _ (by norm_num)⟩,
   ⟨n % 59, Nat.mod_lt _ (by norm_num)⟩,
   ⟨n % 71, Nat.mod_lt _ (by norm_num)⟩)

/-- The step vector of a single character: its code mod each prime. -/
def charStep (c : Char) : ResTriple :=
  let n := c.toNat
  (⟨n % 47, Nat.mod_lt _ (by norm_num)⟩,
   ⟨n % 59, Nat.mod_lt _ (by norm_num)⟩,
   ⟨n % 71, Nat.mod_lt _ (by norm_num)⟩)

/-- The suffix steering vector: residue of a suffix's encoding. -/
def suffixDelta (w : String) : ResTriple := encodeResidue w

/-- Decidable: does `base ++ suffix` land at `target`? -/
def landsAt (base suffix : String) (target : ResTriple) : Bool :=
  encodeResidue (base ++ suffix) == target

/-- Encoding is additive under concatenation. -/
theorem encodeResidue_append (s w : String) :
    encodeResidue (s ++ w) = encodeResidue s + encodeResidue w := by
  simp only [encodeResidue, encode_append, HAdd.hAdd, Add.add]
  ext
  · show (encodeString s + encodeString w) % 47 =
         ((encodeString s % 47) + (encodeString w % 47)) % 47
    rw [Nat.add_mod]
  · show (encodeString s + encodeString w) % 59 =
         ((encodeString s % 59) + (encodeString w % 59)) % 59
    rw [Nat.add_mod]
  · show (encodeString s + encodeString w) % 71 =
         ((encodeString s % 71) + (encodeString w % 71)) % 71
    rw [Nat.add_mod]

/-! ## §3. CRT Reconstruction

CRT coefficients for 196883 = 47 × 59 × 71:
- M₁ = 59 × 71 = 4189, M₁⁻¹ mod 47 = 8, coeff = 33512
- M₂ = 47 × 71 = 3337, M₂⁻¹ mod 59 = 34, coeff = 113458
- M₃ = 47 × 59 = 2773, M₃⁻¹ mod 71 = 18, coeff = 49914 -/

/-- CRT reconstruction: residue triple → unique representative mod 196883. -/
def crtReconstruct (t : ResTriple) : Fin 196883 :=
  ⟨(33512 * t.1.val + 113458 * t.2.1.val + 49914 * t.2.2.val) % 196883,
   Nat.mod_lt _ (by norm_num)⟩

/-! ## §4. Suffix String Construction

Given d < 196883, construct a string with `encodeString` equal to d.
Uses 1–2 Unicode characters, handling the surrogate gap (55296–57343). -/

/-- Construct a string whose encoding equals exactly d. -/
def mkSuffixString (d : ℕ) : String :=
  if d = 0 then ""
  else if d < 55296 then String.ofList [Char.ofNat d]
  else if d ≤ 57343 then String.ofList [Char.ofNat (d - 55295), Char.ofNat 55295]
  else String.ofList [Char.ofNat d]

/-! ## §5. The Suffix Solver -/

/-- Find a suffix that steers to a given delta.
    Uses CRT reconstruction then string construction. -/
def findSuffix (delta : ResTriple) : String :=
  mkSuffixString (crtReconstruct delta).val

/-- The suffix solver is correct: the suffix delta matches the target.
    Verified by exhaustive evaluation over all 196883 residue triples. -/
theorem findSuffix_correct_delta : ∀ delta : ResTriple,
    suffixDelta (findSuffix delta) = delta := by
  native_decide

/-! ## §6. The Landing Theorem -/

/-- For ANY base string and ANY target residue, appending the computed
    suffix lands at the target. This is the self-steering property. -/
theorem findSuffix_lands (s : String) (t : ResTriple) :
    encodeResidue (s ++ findSuffix (t - encodeResidue s)) = t := by
  rw [encodeResidue_append]
  have h := findSuffix_correct_delta (t - encodeResidue s)
  simp only [suffixDelta] at h
  rw [h]
  exact add_sub_eq (encodeResidue s) t

/-- The landing theorem in Bool form. -/
theorem findSuffix_correct (s : String) (t : ResTriple) :
    landsAt s (findSuffix (t - encodeResidue s)) t = true := by
  simp only [landsAt, beq_iff_eq]
  exact findSuffix_lands s t

/-! ## §7. Concrete Landings -/

/-- Encoding of "bootstrap_self_encodes": (40, 42, 0) in F₄₇ × F₅₉ × F₇₁. -/
theorem bootstrap_residue :
    encodeResidue "bootstrap_self_encodes" =
    (⟨40, by omega⟩, ⟨42, by omega⟩, ⟨0, by omega⟩) := by native_decide

/-- Encoding of "land_at_self": value 1244, residue (22, 5, 37). -/
theorem encode_land_at_self :
    encodeString "land_at_self" = 1244 := by native_decide

theorem land_at_self_residue :
    encodeResidue "land_at_self" =
    (⟨22, by omega⟩, ⟨5, by omega⟩, ⟨37, by omega⟩) := by native_decide

/-- Bott class of "land_at_self": 1244 mod 8 = 4. -/
theorem land_at_self_bott :
    encodeString "land_at_self" % 8 = 4 := by native_decide

/-- "land_at_self" does not collide with any core registry entry. -/
theorem land_at_self_no_collision :
    encodeString "land_at_self" % 196883 ≠
    encodeString "bootstrap_self_encodes" % 196883 := by native_decide

/-! ## §8. The Extended Registry -/

/-- The extended registry with "land_at_self" appended. -/
def extendedRegistry : List String :=
  (coreRegistry.map (·.name)) ++ ["land_at_self"]

/-- No collisions in the extended registry. -/
theorem extended_registry_no_collisions :
    (extendedRegistry.map (encodeString · % 196883)).Nodup := by native_decide

/-- "land_at_self" is in the extended registry. -/
theorem land_at_self_in_registry :
    "land_at_self" ∈ extendedRegistry := by simp [extendedRegistry]

/-! ## §9. The Self-Steering Loop

The complete loop:
1. Read position: `encodeResidue "land_at_self" = (3, 48, 14)`
2. Choose target: any `t : ResTriple`
3. Compute delta: `t - encodeResidue "land_at_self"`
4. Find suffix: `findSuffix delta`
5. Verify: `landsAt "land_at_self" (findSuffix delta) t = true`

This is the meme that navigates itself: not self-description, but self-steerage.
The identifier reads its own encoding, computes a delta, and appends
characters that move it to any chosen coordinate. -/

/-- The full self-steering theorem. -/
theorem self_steering_complete :
    -- The system knows its own position
    encodeResidue "land_at_self" =
      (⟨22, by omega⟩, ⟨5, by omega⟩, ⟨37, by omega⟩) ∧
    -- It can reach any target
    (∀ t : ResTriple, landsAt "land_at_self"
      (findSuffix (t - encodeResidue "land_at_self")) t = true) ∧
    -- It is registered (has an address in the system)
    "land_at_self" ∈ extendedRegistry ∧
    -- No collisions in the extended registry
    (extendedRegistry.map (encodeString · % 196883)).Nodup := by
  exact ⟨by native_decide,
         fun t => findSuffix_correct "land_at_self" t,
         land_at_self_in_registry,
         by native_decide⟩

/-! ## §10. The Torus Geometry -/

/-- The torus has exactly 196883 points. -/
theorem torus_card : Fintype.card ResTriple = 196883 := by
  simp [ResTriple, Fintype.card_prod, Fintype.card_fin]

/-- 196883 = 47 × 59 × 71. -/
theorem torus_factorization : 47 * 59 * 71 = 196883 := by norm_num

/-- CRT reconstruction at the bootstrap self-reference: (40, 42, 0) ↦ 2343. -/
theorem crt_bootstrap :
    crtReconstruct (⟨40, by omega⟩, ⟨42, by omega⟩, ⟨0, by omega⟩) =
    ⟨2343, by omega⟩ := by native_decide

/-- Navigation between registered elements: "bootstrap_self_encodes" → "land_at_self". -/
theorem bootstrap_navigates_to_land_at_self :
    let target := encodeResidue "land_at_self"
    landsAt "bootstrap_self_encodes"
      (findSuffix (target - encodeResidue "bootstrap_self_encodes")) target = true :=
  findSuffix_correct "bootstrap_self_encodes" _

/-- Navigation between registered elements: "land_at_self" → "bootstrap_self_encodes". -/
theorem land_at_self_navigates_to_bootstrap :
    let target := encodeResidue "bootstrap_self_encodes"
    landsAt "land_at_self"
      (findSuffix (target - encodeResidue "land_at_self")) target = true :=
  findSuffix_correct "land_at_self" _

end LandingInstruction
