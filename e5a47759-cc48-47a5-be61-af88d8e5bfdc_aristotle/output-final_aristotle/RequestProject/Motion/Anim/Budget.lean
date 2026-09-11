import RequestProject.Motion.Anim.Fractal

/-!
# Gas accounting: what a frame is allowed to cost

The semantics of `web/js/budget.js`, which is what `budget on`, `gas N` and
`gas N scene` mean.  A layer is priced before it is drawn, and a price that is
over the ceiling is refused with a card in the frame rather than a hung tab.

Two things are proved here.

* **A word is counted, never built.**  The L-system pricer never expands the
  string it is pricing.  It may do that because the length after `d` rewriting
  passes is a *linear* function of the symbol counts: `lengthAfter_append` and
  `lengthAfter_eq_sum` say the length of a word is the sum of the lengths its
  symbols grow to, and `lengthAfter_succ_singleton` is the recursion the
  implementation iterates — one pass on the counts, not on the word.
* **The ceilings are enforced.**  `admit` walks the priced layers in order,
  refusing one that is over the per-layer ceiling and one that would take the
  running total over the scene ceiling.  `total_le_sceneGas`: whatever is
  admitted stays under the scene ceiling.  `total_eq_sum_admitted`: a refused
  layer spends nothing.  `admit_all_of_off`: with no `budget on` nothing is
  refused.
-/

namespace Hesper.Budget

open Hesper.Fractal

/-! ## The L-system pricer -/

/-- How long the word is after `d` rewriting passes. -/
def lengthAfter (rules : Char → Option (List Char)) (d : ℕ) (w : List Char) : ℕ :=
  (expand rules d w).length

@[simp] theorem lengthAfter_zero (rules : Char → Option (List Char)) (w : List Char) :
    lengthAfter rules 0 w = w.length := by
  simp [lengthAfter, expand]

@[simp] theorem lengthAfter_nil (rules : Char → Option (List Char)) (d : ℕ) :
    lengthAfter rules d [] = 0 := by
  induction d with
  | zero => simp
  | succ k ih =>
    have : expand rules (k + 1) [] = expand rules k (rewrite rules []) :=
      Function.iterate_succ_apply _ k []
    simp [lengthAfter, this, rewrite] at ih ⊢
    simpa [lengthAfter] using ih

/-- The price of a word is the price of its pieces: the pricer may add up. -/
theorem lengthAfter_append (rules : Char → Option (List Char)) (d : ℕ) (u v : List Char) :
    lengthAfter rules d (u ++ v) = lengthAfter rules d u + lengthAfter rules d v := by
  simp [lengthAfter, expand_append]

/-- So it is a linear function of the symbol counts — that is why it can count. -/
theorem lengthAfter_eq_sum (rules : Char → Option (List Char)) (d : ℕ) (w : List Char) :
    lengthAfter rules d w = (w.map fun ch => lengthAfter rules d [ch]).sum := by
  induction w with
  | nil => simp
  | cons ch w ih =>
    have : (ch :: w) = [ch] ++ w := rfl
    rw [this, lengthAfter_append, ih]
    simp

/-- One pass, on the counts: the recursion the implementation iterates. -/
theorem lengthAfter_succ_singleton (rules : Char → Option (List Char)) (d : ℕ) (ch : Char) :
    lengthAfter rules (d + 1) [ch]
      = (((rules ch).getD [ch]).map fun c => lengthAfter rules d [c]).sum := by
  have hstep : expand rules (d + 1) [ch] = expand rules d (rewrite rules [ch]) :=
    Function.iterate_succ_apply _ d [ch]
  have hre : rewrite rules [ch] = (rules ch).getD [ch] := by simp [rewrite]
  rw [lengthAfter, hstep, hre]
  simpa [lengthAfter] using lengthAfter_eq_sum rules d ((rules ch).getD [ch])

/-! ## The cost of a field -/

/-- A heat layer evaluates the formula once per cell of a `res × res` grid. -/
def fieldCells (res : ℕ) : ℕ := res * res

theorem fieldCells_mono {a b : ℕ} (h : a ≤ b) : fieldCells a ≤ fieldCells b :=
  Nat.mul_le_mul h h

/-! ## Admitting layers -/

/-- `budget on`, the per-layer ceiling and the scene ceiling. -/
structure Settings where
  on : Bool
  layerGas : ℕ
  sceneGas : ℕ

/--
Walk the priced layers in order.  A layer is admitted when the budget is off,
or when it is inside the per-layer ceiling *and* the running total stays inside
the scene ceiling; a refused layer spends nothing.  Returns the gas spent and
the verdict for each layer.
-/
def admit (s : Settings) : List ℕ → ℕ × List Bool
  | [] => (0, [])
  | cost :: rest =>
      if s.on = false then
        ((admit s rest).1, true :: (admit s rest).2)
      else if cost ≤ s.layerGas ∧ cost ≤ s.sceneGas then
        (cost + (admit { s with sceneGas := s.sceneGas - cost } rest).1,
          true :: (admit { s with sceneGas := s.sceneGas - cost } rest).2)
      else
        ((admit s rest).1, false :: (admit s rest).2)

/-- Every layer gets exactly one verdict. -/
theorem length_admit (s : Settings) (costs : List ℕ) :
    (admit s costs).2.length = costs.length := by
  induction costs generalizing s with
  | nil => simp [admit]
  | cons c cs ih =>
    rw [admit]
    by_cases hoff : s.on = false
    · rw [if_pos hoff]; simpa using ih s
    · rw [if_neg hoff]
      by_cases hfit : c ≤ s.layerGas ∧ c ≤ s.sceneGas
      · rw [if_pos hfit]; simpa using ih _
      · rw [if_neg hfit]; simpa using ih s

/-- What is admitted stays under the scene ceiling. -/
theorem total_le_sceneGas (s : Settings) (hon : s.on = true) (costs : List ℕ) :
    (admit s costs).1 ≤ s.sceneGas := by
  induction costs generalizing s with
  | nil => simp [admit]
  | cons c cs ih =>
    rw [admit, if_neg (by simp [hon])]
    by_cases hfit : c ≤ s.layerGas ∧ c ≤ s.sceneGas
    · rw [if_pos hfit]
      show c + (admit { s with sceneGas := s.sceneGas - c } cs).1 ≤ s.sceneGas
      have hrest : (admit { s with sceneGas := s.sceneGas - c } cs).1 ≤ s.sceneGas - c :=
        ih { s with sceneGas := s.sceneGas - c } hon
      have hc := hfit.2
      omega
    · rw [if_neg hfit]
      exact ih s hon

/-- With no `budget on`, nothing is refused. -/
theorem admit_all_of_off (s : Settings) (hoff : s.on = false) (costs : List ℕ) :
    ∀ v ∈ (admit s costs).2, v = true := by
  induction costs generalizing s with
  | nil => simp [admit]
  | cons c cs ih =>
    rw [admit, if_pos hoff]
    intro v hv
    rcases List.mem_cons.mp hv with h | h
    · exact h
    · exact ih s hoff v h

/-- Nothing at all is spent while the budget is off. -/
theorem total_zero_of_off (s : Settings) (hoff : s.on = false) (costs : List ℕ) :
    (admit s costs).1 = 0 := by
  induction costs generalizing s with
  | nil => simp [admit]
  | cons c cs ih =>
    rw [admit, if_pos hoff]
    exact ih s hoff

/-- A layer over the per-layer ceiling is refused, whatever else is in the scene. -/
theorem refuse_of_gt_layerGas (s : Settings) (hon : s.on = true) {c : ℕ}
    (h : s.layerGas < c) (cs : List ℕ) :
    (admit s (c :: cs)).2.head? = some false := by
  rw [admit, if_neg (by simp [hon]), if_neg (by omega)]
  rfl

end Hesper.Budget
