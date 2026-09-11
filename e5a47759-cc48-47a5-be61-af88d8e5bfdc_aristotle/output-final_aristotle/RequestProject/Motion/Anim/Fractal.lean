import Mathlib

/-!
# The complex half of the language: escape time, the chaos game and L-systems

The semantics of `web/js/fractal.js`, which is what `complex on`, the
`mandelbrot` / `julia` builtins, the `ifs` block and the `lsystem` statement
mean.  The playbooks `mandelbrot`, `julia`, `attractor`, `fern` and `lsystem`
in `web/examples/` are drawn by exactly these rules.

What is proved here:

* **escape time** — `escapeCount_le` (the count never exceeds the iteration
  cap), `norm_le_of_lt_escapeCount` (every step it passed over really was
  inside the disc), `lt_norm_orbit_escapeCount` (the step it stopped at really
  is outside), `escapeCount_stable` (raising the cap never changes a count that
  already escaped, so animating `iter` only ever refines the picture) and
  `mandelbrot_eq_julia_zero` (the two builtins are one function);
* **the escape criterion is sound** — `lt_norm_step` and `escapes`: once the
  orbit passes `‖c‖` and `2` it grows without bound, so a pixel the studio
  paints as "escaped" is one whose orbit really does run away, and with a large
  enough cap the count sees it (`exists_escapeCount_lt`);
* **the smooth count** — `smoothCount_mem_Icc`: the renormalised value used to
  remove the banding lies in `[n, n+1]`, so it refines the integer count
  instead of replacing it;
* **the chaos game** — `norm_apply_le` and `norm_run_le`: contractions with a
  bounded translation keep the orbit inside one ball, so the attractor cannot
  drift off the canvas, and `run_prefix`: the first `n` points of a longer run
  are exactly the run of length `n`, which is why animating the point count
  reveals one fixed attractor rather than a new one each frame;
* **the L-system** — `rewrite_append` (rewriting is a homomorphism of words),
  `length_rewrite`, `expand_add`, `expand_append`, and for the turtle
  `balanced_run_stack` and `branch_restores`: a bracketed branch returns the
  turtle to exactly where, and to exactly the heading, it was, together with
  `length_segs_run`: one segment is drawn per drawing symbol.
-/

namespace Hesper.Fractal

open scoped Real

noncomputable section

/-! ## Escape time -/

/-- One step of the quadratic map `z ↦ z² + c`. -/
def step (c z : ℂ) : ℂ := z ^ 2 + c

/-- The orbit of `z₀` under `z ↦ z² + c`. -/
def orbit (c z₀ : ℂ) : ℕ → ℂ
  | 0 => z₀
  | n + 1 => step c (orbit c z₀ n)

@[simp] theorem orbit_zero (c z₀ : ℂ) : orbit c z₀ 0 = z₀ := rfl

@[simp] theorem orbit_succ (c z₀ : ℂ) (n : ℕ) :
    orbit c z₀ (n + 1) = step c (orbit c z₀ n) := rfl

/--
Iterations of `z ↦ z² + c` before the orbit leaves the closed disc of radius
`R`, counted from `z₀`, and `fuel` when it never does — the `escapeCount` of
`web/js/fractal.js`, whose loop is `while (n < maxIter) { if (|z| > R) return n; z = z²+c; n++ }`.
-/
def escapeCountFrom (c : ℂ) (R : ℝ) : ℕ → ℂ → ℕ
  | 0, _ => 0
  | fuel + 1, z => if R < ‖z‖ then 0 else escapeCountFrom c R fuel (step c z) + 1

/-- The iteration count the studio paints a pixel with. -/
def escapeCount (c z₀ : ℂ) (R : ℝ) (maxIter : ℕ) : ℕ :=
  escapeCountFrom c R maxIter z₀

/-- `mandelbrot(c)`: the orbit of `0` under `z ↦ z² + c`. -/
def mandelbrot (c : ℂ) (R : ℝ) (maxIter : ℕ) : ℕ := escapeCount c 0 R maxIter

/-- `julia(z, c)`: the orbit of `z` under the same map, with `c` held fixed. -/
def julia (z c : ℂ) (R : ℝ) (maxIter : ℕ) : ℕ := escapeCount c z R maxIter

/-- The two builtins are one function: the Mandelbrot set is the Julia count at `z = 0`. -/
theorem mandelbrot_eq_julia_zero (c : ℂ) (R : ℝ) (n : ℕ) :
    mandelbrot c R n = julia 0 c R n := rfl

/-- Stepping once and starting there is the same as starting here and stepping later. -/
theorem orbit_step (c z : ℂ) (n : ℕ) : orbit c z (n + 1) = orbit c (step c z) n := by
  induction n with
  | zero => rfl
  | succ k ih => rw [orbit_succ, ih, orbit_succ]

/-- The count never exceeds the iteration cap. -/
theorem escapeCountFrom_le (c : ℂ) (R : ℝ) (fuel : ℕ) (z : ℂ) :
    escapeCountFrom c R fuel z ≤ fuel := by
  induction fuel generalizing z with
  | zero => simp [escapeCountFrom]
  | succ n ih =>
    rw [escapeCountFrom]
    split
    · exact Nat.zero_le _
    · exact Nat.succ_le_succ (ih _)

theorem escapeCount_le (c z₀ : ℂ) (R : ℝ) (n : ℕ) : escapeCount c z₀ R n ≤ n :=
  escapeCountFrom_le _ _ _ _

/-- Every step the count passed over really was inside the disc. -/
theorem norm_le_of_lt_escapeCountFrom (c : ℂ) (R : ℝ) :
    ∀ (fuel k : ℕ) (z : ℂ), k < escapeCountFrom c R fuel z → ‖orbit c z k‖ ≤ R := by
  intro fuel
  induction fuel with
  | zero => intro k z hk; simp [escapeCountFrom] at hk
  | succ n ih =>
    intro k z hk
    rw [escapeCountFrom] at hk
    split at hk
    · exact absurd hk (Nat.not_lt_zero _)
    · rename_i hout
      match k with
      | 0 => simpa using not_lt.mp hout
      | (j + 1) =>
        rw [orbit_step]
        exact ih j _ (by omega)

theorem norm_le_of_lt_escapeCount (c z₀ : ℂ) (R : ℝ) (n k : ℕ)
    (hk : k < escapeCount c z₀ R n) : ‖orbit c z₀ k‖ ≤ R :=
  norm_le_of_lt_escapeCountFrom c R n k z₀ hk

/-- If the count stopped short of the cap, the step it stopped at really is outside. -/
theorem lt_norm_orbit_escapeCountFrom (c : ℂ) (R : ℝ) :
    ∀ (fuel : ℕ) (z : ℂ), escapeCountFrom c R fuel z < fuel →
      R < ‖orbit c z (escapeCountFrom c R fuel z)‖ := by
  intro fuel
  induction fuel with
  | zero => intro z h; exact absurd h (Nat.not_lt_zero _)
  | succ n ih =>
    intro z h
    rw [escapeCountFrom] at h ⊢
    split at h
    · rename_i hout
      simp [hout]
    · rename_i hout
      have hlt : escapeCountFrom c R n (step c z) < n := by omega
      simp only [hout, if_false]
      rw [orbit_step]
      exact ih _ hlt

theorem lt_norm_orbit_escapeCount (c z₀ : ℂ) (R : ℝ) (n : ℕ)
    (h : escapeCount c z₀ R n < n) : R < ‖orbit c z₀ (escapeCount c z₀ R n)‖ :=
  lt_norm_orbit_escapeCountFrom c R n z₀ h

/-- Raising the iteration cap never changes a count that had already escaped. -/
theorem escapeCountFrom_stable (c : ℂ) (R : ℝ) :
    ∀ (m n : ℕ) (z : ℂ), m ≤ n → escapeCountFrom c R m z < m →
      escapeCountFrom c R n z = escapeCountFrom c R m z := by
  intro m
  induction m with
  | zero => intro n z _ h; exact absurd h (Nat.not_lt_zero _)
  | succ k ih =>
    intro n z hmn h
    match n, hmn with
    | (j + 1), hmn =>
      rw [escapeCountFrom, escapeCountFrom] at *
      split at h
      · rename_i hout; simp [hout]
      · rename_i hout
        simp only [hout, if_false] at *
        exact congrArg (· + 1) (ih j (step c z) (by omega) (by omega))

theorem escapeCount_stable (c z₀ : ℂ) (R : ℝ) {m n : ℕ} (hmn : m ≤ n)
    (h : escapeCount c z₀ R m < m) : escapeCount c z₀ R n = escapeCount c z₀ R m :=
  escapeCountFrom_stable c R m n z₀ hmn h

/-- Raising the cap never lowers the count. -/
theorem escapeCountFrom_mono (c : ℂ) (R : ℝ) :
    ∀ (m n : ℕ) (z : ℂ), m ≤ n → escapeCountFrom c R m z ≤ escapeCountFrom c R n z := by
  intro m
  induction m with
  | zero => intro n z _; exact Nat.zero_le _
  | succ k ih =>
    intro n z hmn
    match n, hmn with
    | (j + 1), hmn =>
      rw [escapeCountFrom, escapeCountFrom]
      split
      · exact Nat.zero_le _
      · exact Nat.succ_le_succ (ih j (step c z) (by omega))

theorem escapeCount_mono (c z₀ : ℂ) (R : ℝ) {m n : ℕ} (hmn : m ≤ n) :
    escapeCount c z₀ R m ≤ escapeCount c z₀ R n :=
  escapeCountFrom_mono c R m n z₀ hmn

/-! ### The escape criterion is sound -/

/-- Outside the disc of radius `max ‖c‖ 2` the orbit grows by a factor `‖z‖ - 1 > 1`. -/
theorem le_norm_step (c z : ℂ) : ‖z‖ ^ 2 - ‖c‖ ≤ ‖step c z‖ := by
  have h : ‖z ^ 2‖ ≤ ‖step c z‖ + ‖c‖ := by
    have : z ^ 2 = (z ^ 2 + c) - c := by ring
    calc ‖z ^ 2‖ = ‖(z ^ 2 + c) - c‖ := by rw [← this]
      _ ≤ ‖z ^ 2 + c‖ + ‖c‖ := norm_sub_le _ _
      _ = ‖step c z‖ + ‖c‖ := rfl
  have hp : ‖z ^ 2‖ = ‖z‖ ^ 2 := by rw [norm_pow]
  linarith [hp ▸ h]

theorem lt_norm_step {c z : ℂ} (h2 : 2 < ‖z‖) (hc : ‖c‖ < ‖z‖) : ‖z‖ < ‖step c z‖ := by
  have h := le_norm_step c z
  nlinarith [h, h2, hc]

/-- Once past the criterion the orbit stays past it, and grows geometrically. -/
theorem norm_orbit_aux {c z₀ : ℂ} (h2 : 2 < ‖z₀‖) (hc : ‖c‖ < ‖z₀‖) (n : ℕ) :
    ‖z₀‖ * (‖z₀‖ - 1) ^ n ≤ ‖orbit c z₀ n‖ ∧ ‖z₀‖ ≤ ‖orbit c z₀ n‖ := by
  induction n with
  | zero => simp
  | succ k ih =>
    obtain ⟨hgeom, hlow⟩ := ih
    have hstep := le_norm_step c (orbit c z₀ k)
    have hr : (1 : ℝ) < ‖z₀‖ - 1 := by linarith
    have hpow : (0 : ℝ) < (‖z₀‖ - 1) ^ k := by positivity
    have hkey : ‖orbit c z₀ k‖ * (‖z₀‖ - 1) ≤ ‖orbit c z₀ (k + 1)‖ := by
      rw [orbit_succ]
      nlinarith [hstep, hlow, hc, h2]
    constructor
    · calc ‖z₀‖ * (‖z₀‖ - 1) ^ (k + 1)
          = (‖z₀‖ * (‖z₀‖ - 1) ^ k) * (‖z₀‖ - 1) := by ring
        _ ≤ ‖orbit c z₀ k‖ * (‖z₀‖ - 1) := by nlinarith
        _ ≤ ‖orbit c z₀ (k + 1)‖ := hkey
    · nlinarith [hkey, hlow, hr]

theorem norm_orbit_ge {c z₀ : ℂ} (h2 : 2 < ‖z₀‖) (hc : ‖c‖ < ‖z₀‖) (n : ℕ) :
    ‖z₀‖ * (‖z₀‖ - 1) ^ n ≤ ‖orbit c z₀ n‖ := (norm_orbit_aux h2 hc n).1

/-- A point the criterion calls escaped is one whose orbit really does run away. -/
theorem escapes {c z₀ : ℂ} (h2 : 2 < ‖z₀‖) (hc : ‖c‖ < ‖z₀‖) (R : ℝ) :
    ∃ n, R < ‖orbit c z₀ n‖ := by
  have hr : (1 : ℝ) < ‖z₀‖ - 1 := by linarith
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (max R 0) hr
  refine ⟨n, ?_⟩
  have hR : R ≤ max R 0 := le_max_left _ _
  have hpow : (0 : ℝ) < (‖z₀‖ - 1) ^ n := by positivity
  have hscale : (‖z₀‖ - 1) ^ n ≤ ‖z₀‖ * (‖z₀‖ - 1) ^ n := by nlinarith
  linarith [norm_orbit_ge h2 hc n]

/-- With a large enough iteration cap the count sees the escape. -/
theorem exists_escapeCount_lt {c z₀ : ℂ} (h2 : 2 < ‖z₀‖) (hc : ‖c‖ < ‖z₀‖) (R : ℝ) :
    ∃ N, escapeCount c z₀ R N < N := by
  obtain ⟨n, hn⟩ := escapes h2 hc R
  refine ⟨n + 1, ?_⟩
  rcases lt_or_eq_of_le (escapeCount_le c z₀ R (n + 1)) with h | h
  · exact h
  · exact absurd (norm_le_of_lt_escapeCount c z₀ R (n + 1) n (by omega)) (not_le.mpr hn)

/-! ### The smooth count -/

/--
The renormalised count `ν = n + 1 − log₂(log‖z‖ / log R)` of `escapeSmooth`,
clamped to `[n, n+1]` exactly as the runtime clamps it.
-/
noncomputable def smoothCount (n : ℕ) (z : ℂ) (R : ℝ) : ℝ :=
  min ((n : ℝ) + 1) (max (n : ℝ) ((n : ℝ) + 1 - Real.logb 2 (Real.log ‖z‖ / Real.log R)))

/-- The smooth count refines the integer one: it never leaves `[n, n+1]`. -/
theorem smoothCount_mem_Icc (n : ℕ) (z : ℂ) (R : ℝ) :
    smoothCount n z R ∈ Set.Icc (n : ℝ) ((n : ℝ) + 1) := by
  refine ⟨le_min (by linarith) (le_max_left _ _), min_le_left _ _⟩

/-! ## The chaos game -/

/-- A complex affine map `z ↦ a z + b`; `affine A B C D E F` and `map` both build one. -/
structure Aff where
  a : ℂ
  b : ℂ

/-- Applying a map of the system. -/
def Aff.apply (w : Aff) (z : ℂ) : ℂ := w.a * z + w.b

/-- The orbit of the chaos game along a given list of draws. -/
def run (maps : ℕ → Aff) (choices : List ℕ) (z₀ : ℂ) : ℂ :=
  choices.foldl (fun z i => (maps i).apply z) z₀

/-- Every point the game visits, in order (the drawn points are a tail of this). -/
def runPoints (maps : ℕ → Aff) (choices : List ℕ) (z₀ : ℂ) : List ℂ :=
  choices.scanl (fun z i => (maps i).apply z) z₀

/-- A contraction with a bounded translation keeps the ball of radius `B / (1 - L)`. -/
theorem norm_apply_le {w : Aff} {L B : ℝ} (hL : ‖w.a‖ ≤ L) (hL1 : L < 1) (hL0 : 0 ≤ L)
    (hB : ‖w.b‖ ≤ B) {z : ℂ} (hz : ‖z‖ ≤ B / (1 - L)) :
    ‖w.apply z‖ ≤ B / (1 - L) := by
  have h1 : 0 < 1 - L := by linarith
  have hnorm : ‖w.apply z‖ ≤ ‖w.a‖ * ‖z‖ + ‖w.b‖ := by
    simpa [Aff.apply, norm_mul] using norm_add_le (w.a * z) w.b
  have hmul : ‖w.a‖ * ‖z‖ ≤ L * (B / (1 - L)) :=
    mul_le_mul hL hz (norm_nonneg _) hL0
  have hsplit : B / (1 - L) - L * (B / (1 - L)) = B := by
    field_simp
  linarith

/-- So the whole game stays inside that ball: the attractor cannot drift off the canvas. -/
theorem norm_run_le {maps : ℕ → Aff} {L B : ℝ} (hL1 : L < 1) (hL0 : 0 ≤ L)
    (hmaps : ∀ i, ‖(maps i).a‖ ≤ L ∧ ‖(maps i).b‖ ≤ B)
    (choices : List ℕ) {z₀ : ℂ} (hz : ‖z₀‖ ≤ B / (1 - L)) :
    ‖run maps choices z₀‖ ≤ B / (1 - L) := by
  induction choices generalizing z₀ with
  | nil => simpa [run] using hz
  | cons i cs ih =>
    have hstep : ‖(maps i).apply z₀‖ ≤ B / (1 - L) :=
      norm_apply_le (hmaps i).1 hL1 hL0 (hmaps i).2 hz
    simpa [run] using ih hstep

/-- Prefix stability: the points of a longer run start with the points of the shorter one. -/
theorem run_prefix (maps : ℕ → Aff) (u v : List ℕ) (z₀ : ℂ) :
    (runPoints maps (u ++ v) z₀).take (u.length + 1) = runPoints maps u z₀ := by
  induction u generalizing z₀ with
  | nil => cases v <;> simp [runPoints]
  | cons i u ih => simpa [runPoints] using ih ((maps i).apply z₀)

/-! ### The 32-bit generator behind the draws -/

/-- The linear congruential generator of `web/js/fractal.js` (Numerical Recipes constants). -/
def lcg (s : ℕ) : ℕ := (1664525 * s + 1013904223) % 4294967296

/-- Its state is a 32-bit word, so `unit()` really does land in `[0, 1)`. -/
theorem lcg_lt (s : ℕ) : lcg s < 4294967296 := Nat.mod_lt _ (by norm_num)

/-- The draw index the runtime picks: the first slot whose cumulative weight exceeds `u`. -/
def pickIndex (u : ℝ) : List ℝ → ℕ
  | [] => 0
  | c :: cs => if u < c then 0 else pickIndex u cs + 1

/-- The pick is always a map of the system (the last slot when nothing else matches). -/
theorem pickIndex_le (u : ℝ) (cum : List ℝ) : pickIndex u cum ≤ cum.length := by
  induction cum with
  | nil => simp [pickIndex]
  | cons c cs ih =>
    rw [pickIndex]
    split
    · exact Nat.zero_le _
    · simpa using ih

/-- The pick is the *first* slot whose cumulative weight exceeds `u`. -/
theorem lt_getElem_pickIndex {u : ℝ} {cum : List ℝ} (h : pickIndex u cum < cum.length) :
    u < cum[pickIndex u cum] := by
  induction cum with
  | nil => simp [pickIndex] at h
  | cons c cs ih =>
    by_cases hlt : u < c
    · simp [pickIndex, hlt]
    · have h' : pickIndex u cs < cs.length := by
        simp only [pickIndex, hlt, if_false, List.length_cons] at h; omega
      simpa [pickIndex, hlt] using ih h'

/-- Every slot it skipped really did end at or below `u`. -/
theorem getElem_le_of_lt_pickIndex {u : ℝ} {cum : List ℝ} {k : ℕ}
    (hk : k < pickIndex u cum) (hk' : k < cum.length) : cum[k] ≤ u := by
  induction cum generalizing k with
  | nil => simp [pickIndex] at hk
  | cons c cs ih =>
    by_cases hlt : u < c
    · simp only [pickIndex, hlt, if_true] at hk
      exact absurd hk (Nat.not_lt_zero _)
    · simp only [pickIndex, hlt, if_false] at hk
      match k with
      | 0 => simpa using not_lt.mp hlt
      | (j + 1) =>
        have h1 : j < pickIndex u cs := by omega
        have h2 : j < cs.length := by simpa using hk'
        simpa using ih h1 h2

/-- So a pick lands on a slot of positive width: a map of weight zero is never chosen. -/
theorem pickIndex_width_pos {u : ℝ} {cum : List ℝ} {k : ℕ}
    (hk : pickIndex u cum = k + 1) (h : k + 1 < cum.length) : cum[k] < cum[k + 1] := by
  have hlow : cum[k] ≤ u := getElem_le_of_lt_pickIndex (by omega) (by omega)
  have key : ∀ i : ℕ, i = pickIndex u cum → ∀ hi : i < cum.length, u < cum[i] := by
    intro i hi hlen
    subst hi
    exact lt_getElem_pickIndex hlen
  exact lt_of_le_of_lt hlow (key (k + 1) hk.symm h)

/-! ## The L-system -/

/-- One rewriting pass: a symbol with a rule is replaced by it, one without is kept. -/
def rewrite (rules : Char → Option (List Char)) (w : List Char) : List Char :=
  w.flatMap fun ch => (rules ch).getD [ch]

/-- Rewriting is a homomorphism of words: it can be done piece by piece. -/
theorem rewrite_append (rules : Char → Option (List Char)) (u v : List Char) :
    rewrite rules (u ++ v) = rewrite rules u ++ rewrite rules v := by
  simp [rewrite, List.flatMap_append]

/-- The length of a rewritten word is the sum of the lengths of the replacements. -/
theorem length_rewrite (rules : Char → Option (List Char)) (w : List Char) :
    (rewrite rules w).length = (w.map fun ch => ((rules ch).getD [ch]).length).sum := by
  induction w with
  | nil => simp [rewrite]
  | cons ch w ih => simp [rewrite]

/-- `depth` rewriting passes. -/
def expand (rules : Char → Option (List Char)) (depth : ℕ) (w : List Char) : List Char :=
  (rewrite rules)^[depth] w

theorem expand_add (rules : Char → Option (List Char)) (m n : ℕ) (w : List Char) :
    expand rules (m + n) w = expand rules m (expand rules n w) :=
  Function.iterate_add_apply _ m n w

theorem expand_append (rules : Char → Option (List Char)) (n : ℕ) (u v : List Char) :
    expand rules n (u ++ v) = expand rules n u ++ expand rules n v := by
  induction n generalizing u v with
  | zero => simp [expand]
  | succ k ih =>
    have hstep : ∀ w : List Char, expand rules (k + 1) w = expand rules k (rewrite rules w) := by
      intro w; simp [expand, Function.iterate_succ_apply]
    rw [hstep, rewrite_append, ih, hstep, hstep]

/-! ### The turtle -/

/-- The symbols the turtle understands. -/
inductive Sym where
  | draw    -- `F G A B`
  | move    -- `f g a b`
  | left    -- `+`
  | right   -- `-`
  | turn    -- `|`
  | push    -- `[`
  | pop     -- `]`
  deriving DecidableEq, Repr

/-- Where the turtle is and where it is looking. -/
structure Turtle where
  x : ℝ
  y : ℝ
  a : ℝ

/-- The turtle, its saved states and the segments drawn so far. -/
structure Machine where
  t : Turtle
  stack : List Turtle
  segs : List (ℝ × ℝ × ℝ × ℝ)

/-- One symbol, read with a turning angle and a step length. -/
def stepSym (ang len : ℝ) (m : Machine) : Sym → Machine
  | .draw =>
      let x' := m.t.x + len * Real.cos m.t.a
      let y' := m.t.y + len * Real.sin m.t.a
      { m with t := ⟨x', y', m.t.a⟩, segs := m.segs ++ [(m.t.x, m.t.y, x', y')] }
  | .move =>
      { m with t := ⟨m.t.x + len * Real.cos m.t.a, m.t.y + len * Real.sin m.t.a, m.t.a⟩ }
  | .left => { m with t := { m.t with a := m.t.a + ang } }
  | .right => { m with t := { m.t with a := m.t.a - ang } }
  | .turn => { m with t := { m.t with a := m.t.a + Real.pi } }
  | .push => { m with stack := m.t :: m.stack }
  | .pop =>
      match m.stack with
      | [] => m
      | u :: rest => { m with t := u, stack := rest }

/-- Reading a whole word. -/
def runSyms (ang len : ℝ) (w : List Sym) (m : Machine) : Machine :=
  w.foldl (stepSym ang len) m

theorem runSyms_append (ang len : ℝ) (u v : List Sym) (m : Machine) :
    runSyms ang len (u ++ v) m = runSyms ang len v (runSyms ang len u m) := by
  simp [runSyms, List.foldl_append]

/-- Popping a saved state, when there is one. -/
theorem stepSym_pop (ang len : ℝ) {m : Machine} {t : Turtle} {rest : List Turtle}
    (h : m.stack = t :: rest) :
    stepSym ang len m Sym.pop = { m with t := t, stack := rest } := by
  simp only [stepSym, h]

/-- Popping an empty stack leaves the turtle alone. -/
theorem stepSym_pop_nil (ang len : ℝ) {m : Machine} (h : m.stack = []) :
    stepSym ang len m Sym.pop = m := by
  simp only [stepSym, h]

/-- Words whose brackets match. -/
inductive Balanced : List Sym → Prop
  | nil : Balanced []
  | cons {s : Sym} (h : s ≠ Sym.push) (h' : s ≠ Sym.pop) {w : List Sym} :
      Balanced w → Balanced (s :: w)
  | bracket {u w : List Sym} : Balanced u → Balanced w →
      Balanced (Sym.push :: (u ++ Sym.pop :: w))

/-- A balanced word leaves the saved states exactly as it found them. -/
theorem balanced_run_stack {w : List Sym} (hw : Balanced w) (ang len : ℝ) (m : Machine) :
    (runSyms ang len w m).stack = m.stack := by
  induction hw generalizing m with
  | nil => simp [runSyms]
  | @cons s hs hs' w hw ih =>
    have hstep : (stepSym ang len m s).stack = m.stack := by
      cases s <;> simp_all [stepSym]
    have : runSyms ang len (s :: w) m = runSyms ang len w (stepSym ang len m s) := rfl
    rw [this, ih, hstep]
  | @bracket u w hu hw ihu ihw =>
    show (runSyms ang len (u ++ Sym.pop :: w) (stepSym ang len m Sym.push)).stack = m.stack
    rw [runSyms_append]
    have hstk : (runSyms ang len u (stepSym ang len m Sym.push)).stack = m.t :: m.stack := by
      rw [ihu]; rfl
    show (runSyms ang len (Sym.pop :: w)
      (runSyms ang len u (stepSym ang len m Sym.push))).stack = m.stack
    have e : runSyms ang len (Sym.pop :: w) (runSyms ang len u (stepSym ang len m Sym.push))
        = runSyms ang len w
            (stepSym ang len (runSyms ang len u (stepSym ang len m Sym.push)) Sym.pop) := rfl
    rw [e, ihw, stepSym_pop ang len hstk]

/-- A branch returns the turtle to where it was, and to the heading it had. -/
theorem branch_restores {u : List Sym} (hu : Balanced u) (ang len : ℝ) (m : Machine) :
    (runSyms ang len (Sym.push :: (u ++ [Sym.pop])) m).t = m.t ∧
      (runSyms ang len (Sym.push :: (u ++ [Sym.pop])) m).stack = m.stack := by
  have hs1 : (stepSym ang len m Sym.push).stack = m.t :: m.stack := rfl
  have hstk : (runSyms ang len u (stepSym ang len m Sym.push)).stack = m.t :: m.stack := by
    rw [balanced_run_stack hu, hs1]
  have e1 : runSyms ang len (Sym.push :: (u ++ [Sym.pop])) m
      = runSyms ang len [Sym.pop] (runSyms ang len u (stepSym ang len m Sym.push)) := by
    show runSyms ang len (u ++ [Sym.pop]) (stepSym ang len m Sym.push) = _
    rw [runSyms_append]
  have e2 : runSyms ang len [Sym.pop] (runSyms ang len u (stepSym ang len m Sym.push))
      = stepSym ang len (runSyms ang len u (stepSym ang len m Sym.push)) Sym.pop := rfl
  rw [e1, e2, stepSym_pop ang len hstk]
  exact ⟨rfl, rfl⟩

/-- One segment is drawn per drawing symbol — the `segmentCount` of the runtime. -/
theorem length_segs_run (ang len : ℝ) (w : List Sym) (m : Machine) :
    (runSyms ang len w m).segs.length = m.segs.length + w.count Sym.draw := by
  induction w generalizing m with
  | nil => simp [runSyms]
  | cons s w ih =>
    have e : runSyms ang len (s :: w) m = runSyms ang len w (stepSym ang len m s) := rfl
    rw [e, ih]
    cases s
    case draw => simp [stepSym]; omega
    case move => simp [stepSym]
    case left => simp [stepSym]
    case right => simp [stepSym]
    case turn => simp [stepSym]
    case push => simp [stepSym]
    case pop =>
      cases hcase : m.stack with
      | nil => simp [stepSym_pop_nil ang len hcase]
      | cons a rest => simp [stepSym_pop ang len hcase]

end

end Hesper.Fractal
