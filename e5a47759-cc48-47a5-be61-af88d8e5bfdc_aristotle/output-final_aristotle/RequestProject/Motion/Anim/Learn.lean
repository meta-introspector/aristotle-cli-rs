import Mathlib

/-!
# The learner behind the mutate button

The formal counterpart of `web/js/kb.js`: the small generative model the studio
fits to its knowledge base — every rendering this browser has seen, weighted by
the points it has won in the arena — and samples from when you ask it to
predict a new one.

Three things have to be true for a button that writes playbooks to be safe to
press.

*The weights must be weights.*  `weights_nonneg`, `sum_weights` — the fitness
weights of a population are non-negative and sum to one, and `fitness_le` makes
them monotone in points, so a rendering that wins battles shapes the next
generation more, and one that has never been voted on still counts.

*A prediction must stay inside what was learned.*  `wmean_mem_Icc` — the
weighted mean of the values the KB has shown for a slot lies between the
smallest and the largest of them; `predictValue_mem_Icc` — so does the value
finally written, whatever the random draw and however wide the spread;
`predictValue_of_const` — and when the KB has only ever shown one value, that
is exactly the value predicted.  A prediction therefore cannot run away.

*The model must not invent syntax.*  A statement order is drawn from a Markov
chain over statement heads.  `sum_normalize` says each row of that chain is a
probability distribution, `normalize_eq_zero_iff` that a head never seen keeps
weight zero, and `weight_pick_pos` — the substantial one — that the weighted
draw always lands on an entry of *positive* weight.  Together
(`pick_support`): every statement the model emits is a statement the knowledge
base showed it.

`tests/node/test_lab.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Learn

/-! ## Fitness and weights -/

/-- How much an entry counts when learning: never zero, and monotone in the
points it has won. -/
noncomputable def fitness (points : ℝ) : ℝ := 1 + max 0 points

theorem fitness_pos (p : ℝ) : 0 < fitness p := by
  unfold fitness
  have : (0:ℝ) ≤ max 0 p := le_max_left _ _
  linarith

theorem fitness_le {p q : ℝ} (h : p ≤ q) : fitness p ≤ fitness q := by
  unfold fitness
  have : max 0 p ≤ max 0 q := max_le_max le_rfl h
  linarith

/-- Dividing a whole list by one number divides its sum. -/
theorem sum_map_div (l : List ℝ) (c : ℝ) : (l.map (fun x => x / c)).sum = l.sum / c := by
  induction l with
  | nil => simp
  | cons a l ih => simp [ih, add_div]

/-- The fitness weights of a population. -/
noncomputable def weights (ps : List ℝ) : List ℝ :=
  (ps.map fitness).map (fun x => x / (ps.map fitness).sum)

theorem sum_fitness_pos {ps : List ℝ} (h : ps ≠ []) : 0 < (ps.map fitness).sum := by
  induction ps with
  | nil => exact absurd rfl h
  | cons p ps ih =>
    simp only [List.map_cons, List.sum_cons]
    rcases List.eq_nil_or_concat ps with rfl | ⟨_, _, _⟩
    · simpa using fitness_pos p
    · have hne : ps ≠ [] := by
        intro hcon
        simp [hcon] at *
      have := ih hne
      have := fitness_pos p
      linarith

theorem weights_nonneg {ps : List ℝ} (h : ps ≠ []) : ∀ w ∈ weights ps, 0 ≤ w := by
  intro w hw
  unfold weights at hw
  simp only [List.mem_map] at hw
  obtain ⟨x, hx, rfl⟩ := hw
  obtain ⟨p, _, rfl⟩ := hx
  exact div_nonneg (le_of_lt (fitness_pos p)) (le_of_lt (sum_fitness_pos h))

/-- The weights of a population are a probability distribution. -/
theorem sum_weights {ps : List ℝ} (h : ps ≠ []) : (weights ps).sum = 1 := by
  unfold weights
  rw [sum_map_div, div_self (ne_of_gt (sum_fitness_pos h))]

/-! ## What the model predicts for a numeric slot -/

/-- One observation of a value, with the weight of the rendering it came from. -/
structure Obs where
  value : ℝ
  weight : ℝ

/-- The weighted mean of a list of observations. -/
noncomputable def wmean (obs : List Obs) : ℝ :=
  (obs.map (fun o => o.weight * o.value)).sum / (obs.map (fun o => o.weight)).sum

/-- **A weighted mean lies between the extremes of what was observed.**  This
is what stops a prediction from leaving the world the KB describes. -/
theorem wmean_mem_Icc {obs : List Obs} {lo hi : ℝ}
    (hw : ∀ o ∈ obs, 0 ≤ o.weight) (hpos : 0 < (obs.map (fun o => o.weight)).sum)
    (hlo : ∀ o ∈ obs, lo ≤ o.value) (hhi : ∀ o ∈ obs, o.value ≤ hi) :
    wmean obs ∈ Set.Icc lo hi := by
  have hsum := hpos
  constructor
  · rw [wmean, le_div_iff₀ hsum]
    have : ∀ o ∈ obs, lo * o.weight ≤ o.weight * o.value := by
      intro o ho
      have := mul_le_mul_of_nonneg_left (hlo o ho) (hw o ho)
      calc lo * o.weight = o.weight * lo := by ring
        _ ≤ o.weight * o.value := this
    calc lo * (obs.map (fun o => o.weight)).sum
        = (obs.map (fun o => lo * o.weight)).sum := by
          rw [List.sum_map_mul_left]
      _ ≤ (obs.map (fun o => o.weight * o.value)).sum := by
          refine List.sum_le_sum ?_
          intro o ho
          simpa using this o ho
  · rw [wmean, div_le_iff₀ hsum]
    have : ∀ o ∈ obs, o.weight * o.value ≤ hi * o.weight := by
      intro o ho
      have := mul_le_mul_of_nonneg_left (hhi o ho) (hw o ho)
      calc o.weight * o.value ≤ o.weight * hi := this
        _ = hi * o.weight := by ring
    calc (obs.map (fun o => o.weight * o.value)).sum
        ≤ (obs.map (fun o => hi * o.weight)).sum := by
          refine List.sum_le_sum ?_
          intro o ho
          simpa using this o ho
      _ = hi * (obs.map (fun o => o.weight)).sum := by rw [List.sum_map_mul_left]

/-- What the model writes into a slot: the learned mean, displaced by the draw,
clamped back into the observed range. -/
noncomputable def predictValue (mean sd lo hi u spread : ℝ) : ℝ :=
  min hi (max lo (mean + (2 * u - 1) * spread * sd))

/-- **A predicted number is one the knowledge base could have shown.** -/
theorem predictValue_mem_Icc {mean sd lo hi u spread : ℝ} (h : lo ≤ hi) :
    predictValue mean sd lo hi u spread ∈ Set.Icc lo hi := by
  unfold predictValue
  constructor
  · exact le_min h (le_max_left _ _)
  · exact min_le_left _ _

/-- When the knowledge base has only ever shown one value for a slot, that is
exactly what is predicted — the learner does not add noise of its own. -/
theorem predictValue_of_const {v u spread mean : ℝ} :
    predictValue mean 0 v v u spread = v := by
  unfold predictValue
  simp

/-! ## The chain over statement heads -/

/-- Normalise a row of counts into a distribution. -/
noncomputable def normalize (row : List ℝ) : List ℝ :=
  row.map (fun w => w / row.sum)

/-- Every row of the learned chain is a probability distribution. -/
theorem sum_normalize {row : List ℝ} (h : 0 < row.sum) : (normalize row).sum = 1 := by
  unfold normalize
  rw [sum_map_div, div_self (ne_of_gt h)]

/-- A head the knowledge base never showed keeps weight zero — normalisation
cannot bring a statement into existence. -/
theorem normalize_eq_zero_iff {row : List ℝ} (h : 0 < row.sum) (w : ℝ) :
    w / row.sum = 0 ↔ w = 0 := by
  rw [div_eq_zero_iff]
  constructor
  · rintro (hw | hs)
    · exact hw
    · exact absurd hs (ne_of_gt h)
  · intro hw; exact Or.inl hw

/-! ## The weighted draw

`pick` walks the cumulative weights and stops where the draw lands.  What has
to be proved is that it never stops on an entry of weight zero: that is exactly
the statement that the model only ever emits something it has seen. -/

/-- The positive part of a weight — the runtime ignores negative weights. -/
noncomputable def pos (w : ℝ) : ℝ := max w 0

theorem pos_nonneg (w : ℝ) : 0 ≤ pos w := le_max_right _ _

theorem sum_pos_nonneg (ws : List ℝ) : 0 ≤ (ws.map pos).sum := by
  refine List.sum_nonneg ?_
  intro x hx
  simp only [List.mem_map] at hx
  obtain ⟨w, _, rfl⟩ := hx
  exact pos_nonneg w

/-- Walk the cumulative weights from `acc`, stopping where `x` lands. -/
noncomputable def pickAux (x : ℝ) : ℝ → List ℝ → ℕ
  | _, [] => 0
  | acc, w :: ws => if x < acc + pos w then 0 else 1 + pickAux x (acc + pos w) ws

/-- Draw an index from a list of weights with a draw `u ∈ [0,1)`. -/
noncomputable def pick (ws : List ℝ) (u : ℝ) : ℕ :=
  pickAux (u * (ws.map pos).sum) 0 ws

theorem pickAux_spec : ∀ (ws : List ℝ) (acc x : ℝ), acc ≤ x →
    x < acc + (ws.map pos).sum →
    pickAux x acc ws < ws.length ∧ 0 < ws.getD (pickAux x acc ws) 0 := by
  intro ws
  induction ws with
  | nil =>
    intro acc x hacc hlt
    simp at hlt
    linarith
  | cons w ws ih =>
    intro acc x hacc hlt
    by_cases hstop : x < acc + pos w
    · have hw : 0 < w := by
        have : 0 < pos w := by linarith
        unfold pos at this
        rcases max_cases w 0 with ⟨he, _⟩ | ⟨he, _⟩
        · rw [he] at this; exact this
        · rw [he] at this; linarith
      refine ⟨by simp [pickAux, hstop], ?_⟩
      simp [pickAux, hstop, hw]
    · have hacc' : acc + pos w ≤ x := by linarith [not_lt.mp hstop]
      have hlt' : x < acc + pos w + (ws.map pos).sum := by
        simp only [List.map_cons, List.sum_cons] at hlt
        linarith
      obtain ⟨h1, h2⟩ := ih (acc + pos w) x hacc' hlt'
      refine ⟨by simp [pickAux, hstop]; omega, ?_⟩
      have hidx : (w :: ws).getD (1 + pickAux x (acc + pos w) ws) 0
          = ws.getD (pickAux x (acc + pos w) ws) 0 := by
        rw [Nat.add_comm]
        simp
      simp only [pickAux, hstop, if_false]
      rw [hidx]
      exact h2

/-- **The draw lands on something that was actually seen.** -/
theorem weight_pick_pos {ws : List ℝ} {u : ℝ} (h0 : 0 ≤ u) (h1 : u < 1)
    (hpos : 0 < (ws.map pos).sum) :
    pick ws u < ws.length ∧ 0 < ws.getD (pick ws u) 0 := by
  have hx0 : 0 ≤ u * (ws.map pos).sum := mul_nonneg h0 (le_of_lt hpos)
  have hx1 : u * (ws.map pos).sum < 0 + (ws.map pos).sum := by
    have : u * (ws.map pos).sum < 1 * (ws.map pos).sum :=
      mul_lt_mul_of_pos_right h1 hpos
    simpa using this
  exact pickAux_spec ws 0 (u * (ws.map pos).sum) hx0 hx1

/-- Said the way the studio needs it: whatever the model emits, its weight in
the knowledge base was positive — nothing is invented. -/
theorem pick_support {ws : List ℝ} {u : ℝ} (h0 : 0 ≤ u) (h1 : u < 1)
    (hpos : 0 < (ws.map pos).sum) :
    ∃ i, i < ws.length ∧ pick ws u = i ∧ 0 < ws.getD i 0 := by
  obtain ⟨hlt, hval⟩ := weight_pick_pos h0 h1 hpos
  exact ⟨pick ws u, hlt, rfl, hval⟩

end Hesper.Learn
