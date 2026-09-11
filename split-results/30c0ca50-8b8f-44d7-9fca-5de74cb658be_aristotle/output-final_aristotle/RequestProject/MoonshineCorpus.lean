import Mathlib
import RequestProject.GodelBrainrot

open scoped BigOperators
open scoped Function

/-!
# The Moonshine Corpus — a Gödel-Brainrot backend

This module is the *moonshine backend* that runs "inside" the Gödel-Brainrot
Colosseum UI (`RequestProject.GodelBrainrot`).

The visible game layer encodes meme phrases as Gödel numbers.  Here we build the
hidden algebraic layer the story asks for:

* the **15 supersingular primes** (Ogg's primes — the primes dividing the order of
  the Monster group), which we treat as the 15 one-blades of a Clifford multivector
  (the "supersingular sphere" / Oggioral);
* a **Chinese-Remainder ("CRT") moonshine encoding** that packs one residue per
  supersingular prime into a single canonical integer below the Ogg number;
* the **Clifford blade space** indexed by subsets of the 15 primes
  (`2^15 = 32768` blades);
* a **bridge** `RichBrainrot` that attaches a moonshine payload to each visible
  brainrot, with a `totalCode`, and a moonshine version of the Gödel
  incompleteness theorem (`richVault_always_incomplete`).

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

namespace Moonshine

/-! ## The 15 supersingular (Ogg) primes -/

/-- The 15 supersingular primes (Ogg's primes): exactly the primes dividing the
order of the Monster group.  We read them as the 15 one-blades of the Oggioral
Clifford multivector. -/
def oggPrimes : List Nat :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- There are exactly 15 supersingular primes. -/
theorem oggPrimes_length : oggPrimes.length = 15 := by decide

/-- Every entry of `oggPrimes` really is prime. -/
theorem oggPrimes_prime : ∀ p ∈ oggPrimes, Nat.Prime p := by decide

/-- The supersingular primes are distinct. -/
theorem oggPrimes_nodup : oggPrimes.Nodup := by decide

/-- Distinct primes are pairwise coprime — the moduli for the CRT encoding. -/
theorem oggPrimes_coprime : oggPrimes.Pairwise (Nat.Coprime on id) := by decide

/-- The **Ogg number**: the product of the 15 supersingular primes.  This is the
modulus of the whole moonshine CRT register. -/
def oggNumber : Nat := oggPrimes.prod

/-- The explicit value of the Ogg number. -/
theorem oggNumber_eq : oggNumber = 1618964990108856390 := by decide

/-- The Ogg number is positive, so it is a genuine CRT modulus. -/
theorem oggNumber_pos : 0 < oggNumber := by decide

/-! ## The CRT moonshine encoding -/

/-- A **moonshine payload** assigns one residue to each supersingular prime
(the value at non-supersingular inputs is irrelevant). -/
abbrev Payload : Type := Nat → Nat

/-- The CRT moonshine code of a payload: the unique natural number below
`oggNumber` that is congruent to `payload p` modulo each supersingular prime `p`.
This packs the entire 15-coordinate supersingular register into one integer. -/
def crtEncode (payload : Payload) : Nat :=
  (Nat.chineseRemainderOfList payload id oggPrimes oggPrimes_coprime).val

/-- The moonshine code lies below the Ogg number: it is a genuine residue of the
supersingular register. -/
theorem crtEncode_lt (payload : Payload) : crtEncode payload < oggNumber := by
  have h := Nat.chineseRemainderOfList_lt_prod payload id oggPrimes oggPrimes_coprime
    (by intro i hi; have := oggPrimes_prime i hi; exact this.pos.ne')
  simpa [crtEncode, oggNumber] using h

/-- The defining congruences: the moonshine code reproduces every chosen residue
modulo its supersingular prime. -/
theorem crtEncode_modEq (payload : Payload) :
    ∀ p ∈ oggPrimes, crtEncode payload ≡ payload p [MOD p] := by
  intro p hp
  have h := (Nat.chineseRemainderOfList payload id oggPrimes oggPrimes_coprime).property p hp
  simpa [crtEncode] using h

/-- The all-ones payload encodes to `1`: the "identity" of the supersingular
register. -/
theorem crtEncode_one : crtEncode (fun _ => 1) = 1 := by
  native_decide +revert

/-! ## The Oggioral: the Clifford blade space on the supersingular sphere -/

/-- A **blade** of the Oggioral is a subset of the 15 supersingular primes: a
basis element `e_S` of the Clifford algebra `Cl(0,15)`. -/
abbrev Blade : Type := Finset (Fin 15)

/-- There are exactly `2^15 = 32768` blades, the dimension of `Cl(0,15)`. -/
theorem card_blades : Fintype.card Blade = 32768 := by
  unfold Blade
  rw [Fintype.card_finset, Fintype.card_fin]
  norm_num

/-- The **grade** of a blade is the number of supersingular primes it involves
(a `k`-blade has grade `k`). -/
def grade (S : Blade) : Nat := S.card

/-- Grades never exceed 15, the top grade (the pseudoscalar) of the Oggioral. -/
theorem grade_le (S : Blade) : grade S ≤ 15 := by
  have h : S.card ≤ (Finset.univ : Finset (Fin 15)).card := S.card_le_univ
  simpa [grade, Finset.card_fin] using h

/-- A **multivector** assigns an integer coefficient to each blade. -/
abbrev Multivector : Type := Blade → Int

/-! ## Bridge: moonshine-enriched brainrot -/

open GodelBrainrot

/-- A **rich brainrot**: a visible Gödel-encoded meme phrase together with its
hidden moonshine payload over the supersingular primes. -/
structure RichBrainrot where
  ui : Brainrot
  payload : Payload

/-- The **total code** combines the visible Gödel code with the hidden moonshine
CRT code. -/
def totalCode (rb : RichBrainrot) : Nat :=
  encodeBrainrot rb.ui + crtEncode rb.payload

/-- The total code always dominates the visible Gödel code. -/
theorem encode_le_totalCode (rb : RichBrainrot) :
    encodeBrainrot rb.ui ≤ totalCode rb := by
  simp [totalCode]

/-- Total codes are unbounded: for every bound there is a rich brainrot whose
total code exceeds it.  (The moonshine layer rides on the unbounded Gödel layer.) -/
theorem totalCode_unbounded (N : Nat) : ∃ rb : RichBrainrot, N < totalCode rb := by
  obtain ⟨b, hb⟩ := encode_unbounded N
  exact ⟨⟨b, fun _ => 0⟩, lt_of_lt_of_le hb (encode_le_totalCode ⟨b, fun _ => 0⟩)⟩

/-- **Moonshine incompleteness.**  Even with the full supersingular CRT backend
attached, no finite vault can imprison all rich brainrot: there is always a rich
brainrot whose total code escapes any finite prisoner list.  This is the
moonshine-enriched analogue of `GodelBrainrot.vault_always_incomplete`. -/
theorem richVault_always_incomplete (prisoners : List RichBrainrot) :
    ∃ rb : RichBrainrot, totalCode rb ∉ prisoners.map totalCode := by
  -- Take a rich brainrot whose total code beats the largest code in the list.
  obtain ⟨rb, hrb⟩ :=
    totalCode_unbounded (Finset.sup (List.toFinset (prisoners.map totalCode)) id)
  refine ⟨rb, fun hmem => ?_⟩
  have hle : totalCode rb ≤ Finset.sup (List.toFinset (prisoners.map totalCode)) id :=
    Finset.le_sup (f := id) (List.mem_toFinset.mpr hmem)
  omega

end Moonshine