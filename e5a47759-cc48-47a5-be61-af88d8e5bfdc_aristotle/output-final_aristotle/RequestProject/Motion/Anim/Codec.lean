import Mathlib

/-!
# The prime-basis codec `C(2,3)` and its cipher maps

The mathematics the `codec` playbook (`web/examples/codec.hesper`) draws.

A node of the codec is an exponent pair `(a, b)`, standing for the number
`2^a · 3^b`.  A substitution of the basis

  `σ_s : 2 ↦ 2 + s,  3 ↦ 3 + 2s`

lifts to the *cipher map* `Φ_s (a, b) = (2+s)^a · (3+2s)^b`, which is what the
example animates as `s` runs from `0` to `2`.

What is proved here:

* `phi_zero` — at `s = 0` the cipher map is the codec itself, `2^a 3^b`;
* `phi_add`, `phiN_add` — **morphism preservation**: adding exponent vectors
  multiplies values, for every substitution;
* `val_injective` — a number determines its exponent pair, so the picture's
  nodes are the numbers they are labelled with;
* `val_dvd_iff` — **order preservation**: one node divides another exactly when
  its exponent vector is componentwise smaller;
* `phi_lt_of_le_of_ne` — the *retraction hierarchy is well founded under every
  cipher*: an edge of the pyramid still strictly descends after the morph;
* `height_add` — the height the studio draws (`log₂` of the value) turns the
  multiplicative action into a translation, which is why the animation is a
  rigid upward drift rather than an explosion;
* `pyramid_values`, `pyramid_descends`, `pyramid_dvd_omega` — the seven nodes
  of the structural pyramid have the stated values, every edge descends
  strictly, and every node divides the Ur-meme `Ω = (4,2) ↦ 144`.
-/

namespace Hesper.Codec

/-- A node of the codec: the exponent pair `(a, b)` of `2^a · 3^b`. -/
abbrev Pair := ℕ × ℕ

/-- The number an exponent pair stands for. -/
def val (p : Pair) : ℕ := 2 ^ p.1 * 3 ^ p.2

/-- The cipher map over the naturals: the basis `{2, 3}` is replaced by
`{2+s, 3+2s}`. -/
def phiN (s : ℕ) (p : Pair) : ℕ := (2 + s) ^ p.1 * (3 + 2 * s) ^ p.2

/-- The cipher map with a real parameter — the one the animation sweeps. -/
noncomputable def phi (s : ℝ) (p : Pair) : ℝ := (2 + s) ^ p.1 * (3 + 2 * s) ^ p.2

@[simp] theorem phiN_zero (p : Pair) : phiN 0 p = val p := by
  simp [phiN, val]

@[simp] theorem phi_zero (p : Pair) : phi 0 p = (val p : ℝ) := by
  simp [phi, val]

/-- The cipher map agrees with its natural-number version at natural `s`. -/
theorem phi_natCast (s : ℕ) (p : Pair) : phi (s : ℝ) p = (phiN s p : ℝ) := by
  simp [phi, phiN]

/-- **Morphism preservation** (`Φ(a·b) = Φ(a)·Φ(b)`, written on exponents):
adding exponent vectors multiplies the values, for every substitution. -/
theorem phi_add (s : ℝ) (p q : Pair) :
    phi s (p.1 + q.1, p.2 + q.2) = phi s p * phi s q := by
  simp [phi, pow_add]
  ring

/-- Morphism preservation over the naturals. -/
theorem phiN_add (s : ℕ) (p q : Pair) :
    phiN s (p.1 + q.1, p.2 + q.2) = phiN s p * phiN s q := by
  simp [phiN, pow_add]
  ring

theorem val_pos (p : Pair) : 0 < val p := by
  have h1 : 0 < 2 ^ p.1 := Nat.pow_pos (by norm_num)
  have h2 : 0 < 3 ^ p.2 := Nat.pow_pos (by norm_num)
  simp [val, Nat.mul_pos h1 h2]

theorem val_ne_zero (p : Pair) : val p ≠ 0 := (val_pos p).ne'

/-- The 2-adic and 3-adic valuations of a codec value are its exponents. -/
theorem factorization_val (p : Pair) :
    (val p).factorization 2 = p.1 ∧ (val p).factorization 3 = p.2 := by
  have h2 : Nat.Prime 2 := Nat.prime_two
  have h3 : Nat.Prime 3 := Nat.prime_three
  have hne : (2 : ℕ) ^ p.1 ≠ 0 := by positivity
  have hne' : (3 : ℕ) ^ p.2 ≠ 0 := by positivity
  have hmul : (val p).factorization = p.1 • (Nat.factorization 2) + p.2 • (Nat.factorization 3) := by
    simp [val, Nat.factorization_mul hne hne', Nat.factorization_pow]
  constructor
  · simp [hmul, h2.factorization, h3.factorization]
  · simp [hmul, h2.factorization, h3.factorization]

/-- **A number determines its exponent pair**: the nodes of the picture are the
numbers they are labelled with. -/
theorem val_injective : Function.Injective val := by
  intro p q h
  have hp := factorization_val p
  have hq := factorization_val q
  have h1 : p.1 = q.1 := by rw [← hp.1, ← hq.1, h]
  have h2 : p.2 = q.2 := by rw [← hp.2, ← hq.2, h]
  exact Prod.ext h1 h2

/-- **Order preservation**: one codec value divides another exactly when its
exponent vector is componentwise smaller. -/
theorem val_dvd_iff (p q : Pair) : val p ∣ val q ↔ p.1 ≤ q.1 ∧ p.2 ≤ q.2 := by
  constructor
  · intro h
    have hle : (val p).factorization ≤ (val q).factorization :=
      (Nat.factorization_le_iff_dvd (val_ne_zero p) (val_ne_zero q)).mpr h
    have h2 := Finsupp.le_def.mp hle 2
    have h3 := Finsupp.le_def.mp hle 3
    rw [(factorization_val p).1, (factorization_val q).1] at h2
    rw [(factorization_val p).2, (factorization_val q).2] at h3
    exact ⟨h2, h3⟩
  · rintro ⟨h1, h2⟩
    exact Nat.mul_dvd_mul (pow_dvd_pow 2 h1) (pow_dvd_pow 3 h2)

/-- **Every cipher keeps the hierarchy well founded**: if one exponent vector
is componentwise below another and different from it, its cipher value is
strictly smaller, for every `s ≥ 0`. -/
theorem phi_lt_of_le_of_ne {s : ℝ} (hs : 0 ≤ s) {p q : Pair}
    (h1 : p.1 ≤ q.1) (h2 : p.2 ≤ q.2) (hne : p ≠ q) : phi s p < phi s q := by
  have hb1 : (1 : ℝ) < 2 + s := by linarith
  have hb2 : (1 : ℝ) < 3 + 2 * s := by linarith
  have hp1 : (0 : ℝ) < (2 + s) ^ p.1 := by positivity
  have hp2 : (0 : ℝ) < (3 + 2 * s) ^ p.2 := by positivity
  have hmono1 : (2 + s) ^ p.1 ≤ (2 + s) ^ q.1 := pow_le_pow_right₀ (le_of_lt hb1) h1
  have hmono2 : (3 + 2 * s) ^ p.2 ≤ (3 + 2 * s) ^ q.2 := pow_le_pow_right₀ (le_of_lt hb2) h2
  have hcase : p.1 < q.1 ∨ p.2 < q.2 := by
    rcases lt_or_eq_of_le h1 with h | h
    · exact Or.inl h
    · rcases lt_or_eq_of_le h2 with h' | h'
      · exact Or.inr h'
      · exact absurd (Prod.ext h h') hne
  rcases hcase with h | h
  · have hs1 : (2 + s) ^ p.1 < (2 + s) ^ q.1 := pow_lt_pow_right₀ hb1 h
    calc phi s p = (2 + s) ^ p.1 * (3 + 2 * s) ^ p.2 := rfl
      _ < (2 + s) ^ q.1 * (3 + 2 * s) ^ p.2 := by
          exact mul_lt_mul_of_pos_right hs1 hp2
      _ ≤ (2 + s) ^ q.1 * (3 + 2 * s) ^ q.2 := by
          have : (0 : ℝ) < (2 + s) ^ q.1 := by positivity
          exact mul_le_mul_of_nonneg_left hmono2 (le_of_lt this)
      _ = phi s q := rfl
  · have hs2 : (3 + 2 * s) ^ p.2 < (3 + 2 * s) ^ q.2 := pow_lt_pow_right₀ hb2 h
    calc phi s p = (2 + s) ^ p.1 * (3 + 2 * s) ^ p.2 := rfl
      _ < (2 + s) ^ p.1 * (3 + 2 * s) ^ q.2 := by
          exact mul_lt_mul_of_pos_left hs2 hp1
      _ ≤ (2 + s) ^ q.1 * (3 + 2 * s) ^ q.2 := by
          have : (0 : ℝ) < (3 + 2 * s) ^ q.2 := by positivity
          exact mul_le_mul_of_nonneg_right hmono1 (le_of_lt this)
      _ = phi s q := rfl

theorem phi_pos {s : ℝ} (hs : 0 ≤ s) (p : Pair) : 0 < phi s p := by
  have h1 : (0 : ℝ) < 2 + s := by linarith
  have h2 : (0 : ℝ) < 3 + 2 * s := by linarith
  have : (0 : ℝ) < (2 + s) ^ p.1 * (3 + 2 * s) ^ p.2 := by positivity
  simpa [phi] using this

/-- **The height the studio draws turns the group action into a translation**:
the picture's height is `log₂` of the value, and the cipher map is
multiplicative, so composing nodes adds heights. -/
theorem height_add {s : ℝ} (hs : 0 ≤ s) (p q : Pair) :
    Real.logb 2 (phi s (p.1 + q.1, p.2 + q.2)) =
      Real.logb 2 (phi s p) + Real.logb 2 (phi s q) := by
  rw [phi_add, Real.logb, Real.logb, Real.logb,
    Real.log_mul (phi_pos hs p).ne' (phi_pos hs q).ne']
  ring

/-! ## The structural pyramid

The retraction hierarchy of the codec, descending from the Ur-meme coordinate
`Ω = (4,2) ↦ 144` to the prime seeds `(1,0) ↦ 2` and `(0,1) ↦ 3`. -/

/-- The Ur-meme coordinate. -/
def omega : Pair := (4, 2)

/-- The seven nodes of the structural pyramid. -/
def nodes : List Pair := [(4, 2), (2, 2), (2, 1), (1, 1), (0, 2), (1, 0), (0, 1)]

/-- The edges of the structural pyramid, as `(parent, child)` pairs. -/
def edges : List (Pair × Pair) :=
  [((4, 2), (2, 2)), ((4, 2), (2, 1)),
   ((2, 2), (1, 1)), ((2, 2), (0, 2)),
   ((2, 1), (1, 0)), ((2, 1), (0, 1))]

@[simp] theorem val_omega : val omega = 144 := by decide

/-- The numbers the pyramid's nodes stand for. -/
theorem pyramid_values : nodes.map val = [144, 36, 12, 6, 9, 2, 3] := by decide

/-- **Every edge descends strictly**, so the hierarchy is well founded. -/
theorem pyramid_descends : ∀ e ∈ edges, val e.2 < val e.1 := by decide

/-- Every edge descends componentwise, which is what makes the cipher images
descend too. -/
theorem pyramid_le : ∀ e ∈ edges, e.2.1 ≤ e.1.1 ∧ e.2.2 ≤ e.1.2 ∧ e.2 ≠ e.1 := by decide

/-- **The hierarchy survives every cipher**: after the morph by `Φ_s`, an edge
of the pyramid still descends strictly. -/
theorem pyramid_cipher_descends {s : ℝ} (hs : 0 ≤ s) :
    ∀ e ∈ edges, phi s e.2 < phi s e.1 := by
  intro e he
  obtain ⟨h1, h2, hne⟩ := pyramid_le e he
  exact phi_lt_of_le_of_ne hs h1 h2 hne

/-- Every node of the pyramid divides the Ur-meme's value. -/
theorem pyramid_dvd_omega : ∀ p ∈ nodes, val p ∣ val omega := by decide

/-- The leaves of the hierarchy are the prime seeds `2` and `3`. -/
theorem seeds : val (1, 0) = 2 ∧ val (0, 1) = 3 := by decide

end Hesper.Codec
