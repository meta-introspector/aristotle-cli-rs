import Mathlib

/-!
# The ComputerCraft `colors` API, verified

A model of the `colors` module of CC:Tweaked as it is documented in the
`lua-ls-cc-tweaked` type definitions: the sixteen colours are the bits of a
16-bit set (`colors.white = 1`, `colors.orange = 2`, …), `combine` unions sets,
`subtract` removes colours from a set, `test` asks whether a colour is in a
set, and `packRGB`/`unpackRGB` move between three channels and one hexadecimal
number.

The theorems below are the laws a program using bundled cables relies on.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace CCColors

/-- A colour set is a natural number used as a bit set; a single colour is a
set with one bit. -/
abbrev ColorSet := ℕ

/-- The `k`-th colour, `colors.white` being the `0`-th. -/
def colorOf (k : ℕ) : ColorSet := 2 ^ k

/-- `colors.white`. -/
def white : ColorSet := colorOf 0
/-- `colors.orange`. -/
def orange : ColorSet := colorOf 1
/-- `colors.magenta`. -/
def magenta : ColorSet := colorOf 2
/-- `colors.lightBlue`. -/
def lightBlue : ColorSet := colorOf 3
/-- `colors.yellow`. -/
def yellow : ColorSet := colorOf 4
/-- `colors.lime`. -/
def lime : ColorSet := colorOf 5
/-- `colors.pink`. -/
def pink : ColorSet := colorOf 6
/-- `colors.gray`. -/
def gray : ColorSet := colorOf 7

/-- `colors.combine`: the union of two colour sets. -/
def combine (s c : ColorSet) : ColorSet := s ||| c

/-- `colors.subtract`: remove from `s` every colour of `c`. -/
def subtract (s c : ColorSet) : ColorSet := s ^^^ (s &&& c)

/-- `colors.test`: is any colour of `c` present in `s`? -/
def test (s c : ColorSet) : Bool := ! ((s &&& c) == 0)

-- The examples from the CC:Tweaked documentation.
#guard combine (combine white magenta) lightBlue == 13
#guard subtract (combine lime (combine orange white)) (combine orange white) == 32
#guard test (combine white (combine magenta lightBlue)) lightBlue == true

/-! ## Bit-level description of the operations -/

theorem testBit_combine (s c : ColorSet) (k : ℕ) :
    (combine s c).testBit k = (s.testBit k || c.testBit k) := by
  simp [combine, Nat.testBit_or]

theorem testBit_subtract (s c : ColorSet) (k : ℕ) :
    (subtract s c).testBit k = (s.testBit k && !c.testBit k) := by
  simp only [subtract, Nat.testBit_xor, Nat.testBit_and]
  cases s.testBit k <;> cases c.testBit k <;> rfl

theorem test_iff (s c : ColorSet) :
    test s c = true ↔ ∃ k, s.testBit k ∧ c.testBit k := by
  have hchar : test s c = true ↔ (s &&& c) ≠ 0 := by simp [test]
  rw [hchar]
  constructor
  · intro h
    obtain ⟨k, hk⟩ := Nat.exists_testBit_of_ne_zero h
    rw [Nat.testBit_and, Bool.and_eq_true] at hk
    exact ⟨k, hk.1, hk.2⟩
  · rintro ⟨k, hs, hc⟩ h0
    have hbit := congrArg (fun n => Nat.testBit n k) h0
    simp [Nat.testBit_and, hs, hc] at hbit

/-! ## The laws -/

theorem combine_comm (s c : ColorSet) : combine s c = combine c s := by
  simp [combine, Nat.lor_comm]

theorem combine_assoc (s c d : ColorSet) :
    combine (combine s c) d = combine s (combine c d) := by
  simp [combine, Nat.lor_assoc]

theorem combine_self (s : ColorSet) : combine s s = s := by
  simp [combine]

theorem combine_zero (s : ColorSet) : combine s 0 = s := by
  simp [combine]

/-- **A colour just combined into a set is in the set.** -/
theorem test_combine_right (s c : ColorSet) (hc : c ≠ 0) :
    test (combine s c) c = true := by
  obtain ⟨k, hck⟩ := Nat.exists_testBit_of_ne_zero hc
  exact (test_iff _ _).2 ⟨k, by simp [testBit_combine, hck], hck⟩

/-- **A colour just subtracted from a set is not in the set.** -/
theorem test_subtract_self (s c : ColorSet) : test (subtract s c) c = false := by
  by_contra h
  simp only [Bool.not_eq_false] at h
  obtain ⟨k, h1, h2⟩ := (test_iff _ _).1 h
  rw [testBit_subtract] at h1
  simp [h2] at h1

/-- **Subtracting is idempotent.** -/
theorem subtract_subtract (s c : ColorSet) :
    subtract (subtract s c) c = subtract s c := by
  refine Nat.eq_of_testBit_eq (fun k => ?_)
  simp only [testBit_subtract]
  cases s.testBit k <;> cases c.testBit k <;> rfl

/-- **Combining then subtracting the same colours undoes the combination**, as
long as those colours were not there to begin with. -/
theorem subtract_combine (s c : ColorSet)
    (h : ∀ k, c.testBit k = true → s.testBit k = false) :
    subtract (combine s c) c = s := by
  refine Nat.eq_of_testBit_eq (fun k => ?_)
  simp only [testBit_subtract, testBit_combine]
  cases hc : c.testBit k
  · simp
  · simp [h k hc]

/-- **`test` decides membership of a single colour.** -/
theorem test_colorOf (s : ColorSet) (k : ℕ) :
    test s (colorOf k) = s.testBit k := by
  rw [Bool.eq_iff_iff, test_iff]
  constructor
  · rintro ⟨j, h1, h2⟩
    rw [colorOf, Nat.testBit_two_pow, decide_eq_true_eq] at h2
    exact h2 ▸ h1
  · intro hs
    exact ⟨k, hs, by simp [colorOf]⟩

/-! ## Packing and unpacking colours -/

/-- `colors.packRGB` on 8-bit channels. -/
def packRGB8 (r g b : ℕ) : ℕ := r * 65536 + g * 256 + b

/-- `colors.unpackRGB` on 8-bit channels. -/
def unpackRGB8 (hex : ℕ) : ℕ × ℕ × ℕ :=
  ((hex / 65536) % 256, (hex / 256) % 256, hex % 256)

#guard packRGB8 178 51 153 == 0xb23399
#guard unpackRGB8 0xb23399 == (178, 51, 153)

/-- **Packing and unpacking are inverse** on 8-bit channels. -/
theorem unpackRGB8_packRGB8 (r g b : ℕ) (hr : r < 256) (hg : g < 256) (hb : b < 256) :
    unpackRGB8 (packRGB8 r g b) = (r, g, b) := by
  simp only [unpackRGB8, packRGB8, Prod.mk.injEq]
  refine ⟨by omega, by omega, by omega⟩

/-- `colors.packRGB` as documented: three channels in `[0, 1]`. -/
noncomputable def packRGB (r g b : ℝ) : ℕ :=
  packRGB8 ⌊r * 255⌋₊ ⌊g * 255⌋₊ ⌊b * 255⌋₊

/-- `colors.unpackRGB` as documented: three channels in `[0, 1]`. -/
noncomputable def unpackRGB (hex : ℕ) : ℝ × ℝ × ℝ :=
  let p := unpackRGB8 hex
  ((p.1 : ℝ) / 255, (p.2.1 : ℝ) / 255, (p.2.2 : ℝ) / 255)

/-- **A packed colour is recovered to within one part in 255.** -/
theorem unpackRGB_packRGB_approx (r g b : ℝ) (hr : 0 ≤ r) (hr1 : r ≤ 1)
    (hg : 0 ≤ g) (hg1 : g ≤ 1) (hb : 0 ≤ b) (hb1 : b ≤ 1) :
    |(unpackRGB (packRGB r g b)).1 - r| ≤ 1 / 255 := by
  have key : ∀ x : ℝ, 0 ≤ x → x ≤ 1 → ⌊x * 255⌋₊ < 256 ∧
      |(⌊x * 255⌋₊ : ℝ) / 255 - x| ≤ 1 / 255 := by
    intro x hx hx1
    have hx255 : (0:ℝ) ≤ x * 255 := by positivity
    have hle : (⌊x * 255⌋₊ : ℝ) ≤ x * 255 := Nat.floor_le hx255
    have hlt : x * 255 < (⌊x * 255⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one _
    constructor
    · have h1 : (⌊x * 255⌋₊ : ℝ) < 256 := by nlinarith
      exact_mod_cast h1
    · rw [abs_le]
      constructor <;> linarith
  obtain ⟨hrb, hrapp⟩ := key r hr hr1
  obtain ⟨hgb, -⟩ := key g hg hg1
  obtain ⟨hbb, -⟩ := key b hb hb1
  simp only [unpackRGB, packRGB, unpackRGB8_packRGB8 _ _ _ hrb hgb hbb]
  exact hrapp

/-! ## `colors.toBlit` -/

/-- The hexadecimal digits `term.blit` uses. -/
def blitDigits : List Char :=
  ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']

/-- `colors.toBlit` for the `k`-th colour. -/
def toBlitIdx (k : ℕ) : Char := blitDigits.getD k '0'

#guard toBlitIdx 2 == '2'
#guard toBlitIdx 15 == 'f'

/-- **Distinct colours get distinct blit characters.** -/
theorem toBlitIdx_injOn (k l : ℕ) (hk : k < 16) (hl : l < 16)
    (h : toBlitIdx k = toBlitIdx l) : k = l := by
  interval_cases k <;> interval_cases l <;> simp_all [toBlitIdx, blitDigits]

end CCColors
