import Mathlib

/-!
# Targeting an export at a place that will host it

The formal counterpart of `HesperExport.ladder` / `HesperExport.fit` /
`HesperExport.plan` (`web/js/exporter.js`), the search behind the studio's
*share target* menu.

A share target (a GIF on X, a square post, a story, a chat preview) fixes a
frame box, a frame rate, a running time and — the interesting constraint — a
maximum *file size*.  The exporter builds a **ladder** of complete renderable
settings, ordered so that the estimated encoded size never increases as one
walks down it, and then takes the first rung whose cost is within the budget.

What is proved about that search: the rung it returns is one of the rungs
(`fit_mem`), it really is within budget (`fit_le`), it fails only when every
rung is over budget (`fit_eq_none_iff`, `fit_isSome_iff`), the choice does not
depend on how the ladder is described beyond its costs (`fit_congr`), and —
the property the studio's claim of "best quality that fits" rests on — when the
ladder is ordered by non-increasing cost, the chosen rung is a *maximal-cost*
rung among those that fit (`fit_best`), so nothing better was passed over.
Finally `plan` never comes back empty-handed on a non-empty ladder
(`plan_isSome`), which is what lets the studio always offer an export, flagged
`fits: false` when the budget cannot be met.

`tests/node/test_exporter.mjs` checks the shipped JavaScript against the same
statements, including `fit`'s optimality against a brute-force search.
-/

namespace Hesper.Export

variable {α : Type*}

/-- The first element of `l` whose cost is within the budget `b`.

The runtime's `fit(rungs, budget, cost)`: it walks the ladder from the best
rung down and stops at the first one that fits. -/
def fit (c : α → ℕ) (b : ℕ) : List α → Option α
  | [] => none
  | x :: xs => if c x ≤ b then some x else fit c b xs

@[simp] theorem fit_nil (c : α → ℕ) (b : ℕ) : fit c b ([] : List α) = none := rfl

theorem fit_cons (c : α → ℕ) (b : ℕ) (x : α) (xs : List α) :
    fit c b (x :: xs) = if c x ≤ b then some x else fit c b xs := rfl

@[simp] theorem fit_cons_pos {c : α → ℕ} {b : ℕ} {x : α} (xs : List α) (h : c x ≤ b) :
    fit c b (x :: xs) = some x := by
  simp [fit_cons, h]

@[simp] theorem fit_cons_neg {c : α → ℕ} {b : ℕ} {x : α} (xs : List α) (h : ¬ c x ≤ b) :
    fit c b (x :: xs) = fit c b xs := by
  simp [fit_cons, h]

/-- The chosen rung is a rung of the ladder. -/
theorem fit_mem {c : α → ℕ} {b : ℕ} : ∀ {l : List α} {r : α}, fit c b l = some r → r ∈ l
  | [], _, h => by simp [fit] at h
  | x :: xs, r, h => by
      by_cases hx : c x ≤ b
      · rw [fit_cons_pos xs hx] at h
        obtain rfl : r = x := (Option.some.inj h).symm
        exact List.mem_cons_self ..
      · rw [fit_cons_neg xs hx] at h
        exact List.mem_cons_of_mem _ (fit_mem h)

/-- The chosen rung is within budget. -/
theorem fit_le {c : α → ℕ} {b : ℕ} : ∀ {l : List α} {r : α}, fit c b l = some r → c r ≤ b
  | [], _, h => by simp [fit] at h
  | x :: xs, r, h => by
      by_cases hx : c x ≤ b
      · rw [fit_cons_pos xs hx] at h
        obtain rfl : r = x := (Option.some.inj h).symm
        exact hx
      · rw [fit_cons_neg xs hx] at h
        exact fit_le h

/-- The search comes back empty exactly when every rung is over budget. -/
theorem fit_eq_none_iff {c : α → ℕ} {b : ℕ} {l : List α} :
    fit c b l = none ↔ ∀ x ∈ l, b < c x := by
  induction l with
  | nil => simp [fit]
  | cons x xs ih =>
      by_cases hx : c x ≤ b
      · simp only [fit_cons_pos xs hx, List.mem_cons, forall_eq_or_imp]
        exact ⟨by simp, fun h => absurd h.1 (Nat.not_lt.2 hx)⟩
      · rw [fit_cons_neg xs hx, ih]
        simp only [List.mem_cons, forall_eq_or_imp]
        exact ⟨fun h => ⟨Nat.lt_of_not_le hx, h⟩, fun h => h.2⟩

/-- The search succeeds exactly when some rung fits. -/
theorem fit_isSome_iff {c : α → ℕ} {b : ℕ} {l : List α} :
    (fit c b l).isSome ↔ ∃ x ∈ l, c x ≤ b := by
  rcases h : fit c b l with _ | r
  · simp only [Option.isSome_none, Bool.false_eq_true, false_iff, not_exists]
    intro x
    simp only [not_and]
    exact fun hx => Nat.not_le.2 (fit_eq_none_iff.1 h x hx)
  · exact ⟨fun _ => ⟨r, fit_mem h, fit_le h⟩, fun _ => rfl⟩

/-- The choice only depends on the ladder through the costs of its rungs. -/
theorem fit_congr {c c' : α → ℕ} {b : ℕ} {l : List α} (h : ∀ x ∈ l, c x = c' x) :
    fit c b l = fit c' b l := by
  induction l with
  | nil => rfl
  | cons x xs ih =>
      have hx : c x = c' x := h x (List.mem_cons_self ..)
      simp only [fit_cons, hx, ih fun y hy => h y (List.mem_cons_of_mem _ hy)]

/-- **The ladder search returns the best rung that fits.**

If the ladder is ordered by non-increasing cost, then no rung that fits is more
expensive — i.e. of higher quality — than the one that was chosen. -/
theorem fit_best {c : α → ℕ} {b : ℕ} :
    ∀ {l : List α}, l.Pairwise (fun a a' => c a' ≤ c a) →
      ∀ {r : α}, fit c b l = some r → ∀ x ∈ l, c x ≤ b → c x ≤ c r
  | [], _, _, h, _, _, _ => by simp [fit] at h
  | x :: xs, hp, r, h, y, hy, hyb => by
      rw [List.pairwise_cons] at hp
      by_cases hx : c x ≤ b
      · rw [fit_cons_pos xs hx] at h
        obtain rfl : r = x := (Option.some.inj h).symm
        rcases List.mem_cons.1 hy with rfl | hy
        · exact le_rfl
        · exact hp.1 y hy
      · rw [fit_cons_neg xs hx] at h
        rcases List.mem_cons.1 hy with rfl | hy
        · exact absurd hyb hx
        · exact fit_best hp.2 h y hy hyb

/-- The runtime's `plan`: the best rung that fits, or — when nothing fits — the
last (cheapest) rung, which the studio still offers, flagged as over budget. -/
def plan (c : α → ℕ) (b : ℕ) (l : List α) : Option α :=
  (fit c b l).orElse fun _ => l.getLast?

/-- A plan is always offered for a non-empty ladder. -/
theorem plan_isSome {c : α → ℕ} {b : ℕ} {l : List α} (hl : l ≠ []) :
    (plan c b l).isSome := by
  rcases h : fit c b l with _ | r
  · simp [plan, h, List.getLast?_eq_some_getLast hl]
  · simp [plan, h]

/-- The plan is one of the rungs. -/
theorem plan_mem {c : α → ℕ} {b : ℕ} {l : List α} {r : α} (h : plan c b l = some r) : r ∈ l := by
  rcases hf : fit c b l with _ | r'
  · have hp : plan c b l = l.getLast? := by simp [plan, hf]
    exact List.mem_of_getLast? (hp ▸ h)
  · have hp : plan c b l = some r' := by simp [plan, hf]
    exact fit_mem (hf.trans (hp.symm.trans h))

/-- When some rung fits, the plan is that rung: within budget and, on an ordered
ladder, the best one available. -/
theorem plan_eq_fit {c : α → ℕ} {b : ℕ} {l : List α} {r : α} (h : fit c b l = some r) :
    plan c b l = some r := by
  simp [plan, h]

end Hesper.Export
