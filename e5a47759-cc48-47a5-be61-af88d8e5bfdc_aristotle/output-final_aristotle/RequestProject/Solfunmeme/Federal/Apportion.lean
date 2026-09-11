/-
  Apportion.lean — how a chamber's seats are shared out between the divisions
  of the union.

  A *federal* legislature combines two different answers to the question "how
  much of the chamber does a division get?":

    * the Senate answers "the same as every other division, whatever its size"
      (`senateSeats`), and
    * the House answers "in proportion to its size" (`houseSeats`).

  The proportional answer is never exact, because seats are whole numbers.  The
  rule used here is the classical *largest-remainder* (Hamilton) rule: every
  division first receives the whole part of its exact share, and the seats left
  over go, one each, to the divisions with the largest fractional parts, ties
  broken in favour of the division listed first.

  Everything is exact natural-number arithmetic: `pop * H / P` is a floor
  division and `pop * H % P` is the fractional part scaled by `P`, so no
  rounding is hidden anywhere.  The sort is an ordinary insertion sort written
  by structural recursion, so the kernel can evaluate an apportionment — the
  concrete figures in `RequestProject/Federal/Facts.lean` are checked by
  `decide`, not by the compiler.

  What is proved:

    * `apportion_total` — the whole chamber is handed out: the seats sum to `H`;
    * `seats_ge_lower_quota`, `seats_le_upper_quota` — every division gets the
      whole part of its share and at most one seat more (the *quota rule*);
    * `senate_equal` — the Senate gives every division the same number of seats,
      whatever its population;
    * `small_division_overrepresented` — and that is why a federal legislature
      is not a proportional one: a below-average division holds a strictly
      larger fraction of the Senate than of the people.
-/

import Mathlib

namespace Federal

/-! ### Divisions -/

/-- A division ("state") of the union: a name and a population. -/
structure Division where
  /-- The division's name. -/
  name : String
  /-- Its population: the number of citizens it is represented for. -/
  pop : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The population of the whole union. -/
def totalPop (ds : List Division) : Nat := (ds.map Division.pop).sum

/-! ### The Senate: equal representation -/

/-- Every division gets `perDivision` senators, whatever its population. -/
def senateSeats (ds : List Division) (perDivision : Nat) : List (String × Nat) :=
  ds.map (fun d => (d.name, perDivision))

/-- **Equal representation.**  Population plays no part in the Senate. -/
theorem senate_equal (ds : List Division) (k : Nat) {p : String × Nat}
    (hp : p ∈ senateSeats ds k) : p.2 = k := by
  obtain ⟨d, -, rfl⟩ := List.mem_map.mp hp
  rfl

theorem senateSeats_total (ds : List Division) (k : Nat) :
    ((senateSeats ds k).map Prod.snd).sum = ds.length * k := by
  induction ds with
  | nil => simp [senateSeats]
  | cons d t ih =>
    simp only [senateSeats, List.map_cons, List.map_map, List.sum_cons, List.length_cons] at ih ⊢
    rw [Nat.succ_mul]
    omega

/-! ### Two facts about floor division -/

/-- Whole parts and remainders reconstruct the numbers they came from. -/
theorem sum_div_mod (P : Nat) (xs : List Nat) :
    P * (xs.map (· / P)).sum + (xs.map (· % P)).sum = xs.sum := by
  induction xs with
  | nil => simp
  | cons x t ih =>
    simp only [List.map_cons, List.sum_cons]
    have hsplit :
        P * (x / P + (t.map (· / P)).sum) + (x % P + (t.map (· % P)).sum)
          = (P * (x / P) + x % P) + (P * (t.map (· / P)).sum + (t.map (· % P)).sum) := by
      ring
    rw [hsplit, Nat.div_add_mod, ih]

/-- The remainders, all told, leave room for one whole unit per entry. -/
theorem sum_mod_bound {P : Nat} (hP : 0 < P) (xs : List Nat) :
    (xs.map (· % P)).sum + xs.length ≤ xs.length * P := by
  induction xs with
  | nil => simp
  | cons x t ih =>
    have hx : x % P < P := Nat.mod_lt _ hP
    simp only [List.map_cons, List.sum_cons, List.length_cons]
    rw [Nat.succ_mul]
    omega

/-! ### The House: largest-remainder apportionment -/

/-- One division's line of the apportionment work sheet. -/
structure Row where
  /-- The division's name. -/
  name : String
  /-- The whole part of its exact share of the chamber. -/
  base : Nat
  /-- Its fractional part, scaled by the total population. -/
  rem : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The work sheet: for a chamber of `H` seats and a union of `P` people, each
division's whole share and its remainder. -/
def rowsWith (P : Nat) (ds : List Division) (H : Nat) : List Row :=
  ds.map (fun d => ⟨d.name, d.pop * H / P, d.pop * H % P⟩)

/-- The work sheet of the union itself. -/
def rowsOf (ds : List Division) (H : Nat) : List Row := rowsWith (totalPop ds) ds H

/-- Insert into a list already ordered by decreasing remainder.  A new row goes
in front of every row it ties with, so ties are broken in favour of the
division that appears first. -/
def insertDesc (x : Row) : List Row → List Row
  | [] => [x]
  | y :: t => if y.rem ≤ x.rem then x :: y :: t else y :: insertDesc x t

/-- Insertion sort by decreasing remainder. -/
def sortDesc : List Row → List Row
  | [] => []
  | x :: t => insertDesc x (sortDesc t)

/-- Hand one leftover seat to each of the first `k` rows. -/
def handOut : Nat → List Row → List Row
  | 0, l => l
  | _, [] => []
  | k + 1, r :: t => { r with base := r.base + 1 } :: handOut k t

/-- The total of the whole shares. -/
def baseTotal (ds : List Division) (H : Nat) : Nat :=
  ((rowsOf ds H).map Row.base).sum

/-- The completed work sheet: whole shares, plus the leftover seats given to the
largest remainders. -/
def apportion (ds : List Division) (H : Nat) : List Row :=
  handOut (H - baseTotal ds H) (sortDesc (rowsOf ds H))

/-- The House of `H` seats, as a division-to-seats table. -/
def houseSeats (ds : List Division) (H : Nat) : List (String × Nat) :=
  (apportion ds H).map (fun r => (r.name, r.base))

/-! ### The sort is a permutation -/

theorem insertDesc_perm (x : Row) (l : List Row) : (insertDesc x l).Perm (x :: l) := by
  induction l with
  | nil => simp [insertDesc]
  | cons y t ih =>
    by_cases h : y.rem ≤ x.rem
    · simp [insertDesc, h]
    · simp only [insertDesc, h, if_false]
      exact (ih.cons y).trans (List.Perm.swap x y t)

theorem sortDesc_perm (l : List Row) : (sortDesc l).Perm l := by
  induction l with
  | nil => simp [sortDesc]
  | cons x t ih => exact (insertDesc_perm x (sortDesc t)).trans (ih.cons x)

theorem sortDesc_length (l : List Row) : (sortDesc l).length = l.length :=
  (sortDesc_perm l).length_eq

theorem sortDesc_base_sum (l : List Row) :
    ((sortDesc l).map Row.base).sum = (l.map Row.base).sum :=
  ((sortDesc_perm l).map Row.base).sum_eq

/-! ### Handing out the leftovers -/

theorem handOut_length (k : Nat) (l : List Row) : (handOut k l).length = l.length := by
  induction k generalizing l with
  | zero => simp [handOut]
  | succ k ih =>
    cases l with
    | nil => simp [handOut]
    | cons r t => simp [handOut, ih]

theorem handOut_sum (k : Nat) (l : List Row) :
    ((handOut k l).map Row.base).sum = (l.map Row.base).sum + min k l.length := by
  induction k generalizing l with
  | zero => simp [handOut]
  | succ k ih =>
    cases l with
    | nil => simp [handOut]
    | cons r t =>
      simp only [handOut, List.map_cons, List.sum_cons, List.length_cons, ih]
      omega

/-- Every row of the finished sheet is a row of the work sheet, with at most one
seat added. -/
theorem handOut_mem (k : Nat) {l : List Row} {r : Row} (hr : r ∈ handOut k l) :
    ∃ s ∈ l, s.name = r.name ∧ (r.base = s.base ∨ r.base = s.base + 1) := by
  induction k generalizing l with
  | zero => exact ⟨r, by simpa [handOut] using hr, rfl, Or.inl rfl⟩
  | succ k ih =>
    cases l with
    | nil => simp [handOut] at hr
    | cons s t =>
      rcases List.mem_cons.mp (by simpa [handOut] using hr) with rfl | hmem
      · exact ⟨s, List.mem_cons_self .., rfl, Or.inr rfl⟩
      · obtain ⟨u, hu, h1, h2⟩ := ih hmem
        exact ⟨u, List.mem_cons_of_mem _ hu, h1, h2⟩

/-- And conversely every row of the work sheet survives into the finished
sheet. -/
theorem handOut_covers {k : Nat} {l : List Row} {s : Row} (hs : s ∈ l) :
    ∃ r ∈ handOut k l, r.name = s.name ∧ (r.base = s.base ∨ r.base = s.base + 1) := by
  induction k generalizing l with
  | zero => exact ⟨s, by simpa [handOut] using hs, rfl, Or.inl rfl⟩
  | succ k ih =>
    cases l with
    | nil => simp at hs
    | cons u t =>
      rcases List.mem_cons.mp hs with rfl | hmem
      · exact ⟨{ s with base := s.base + 1 }, by simp [handOut], rfl, Or.inr rfl⟩
      · obtain ⟨r, hr, h1, h2⟩ := ih hmem
        exact ⟨r, by simp [handOut, hr], h1, h2⟩

/-! ### The arithmetic of the work sheet -/

theorem rowsOf_length (ds : List Division) (H : Nat) : (rowsOf ds H).length = ds.length := by
  simp [rowsOf, rowsWith]

/-- Scaled populations add up to the total population times the chamber size. -/
theorem sum_pop_mul (ds : List Division) (H : Nat) :
    (ds.map (fun d => d.pop * H)).sum = totalPop ds * H := by
  induction ds with
  | nil => simp [totalPop]
  | cons d t ih =>
    simp only [totalPop, List.map_cons, List.sum_cons] at ih ⊢
    rw [Nat.add_mul, ih]

theorem base_map (P : Nat) (ds : List Division) (H : Nat) :
    (rowsWith P ds H).map Row.base = (ds.map (fun d => d.pop * H)).map (· / P) := by
  simp [rowsWith, List.map_map, Function.comp_def]

theorem rem_map (P : Nat) (ds : List Division) (H : Nat) :
    (rowsWith P ds H).map Row.rem = (ds.map (fun d => d.pop * H)).map (· % P) := by
  simp [rowsWith, List.map_map, Function.comp_def]

/-- Whole shares and remainders reconstruct the union's scaled population. -/
theorem base_rem_split (ds : List Division) (H : Nat) :
    totalPop ds * baseTotal ds H + ((rowsOf ds H).map Row.rem).sum = totalPop ds * H := by
  rw [baseTotal, rowsOf, base_map, rem_map, sum_div_mod, sum_pop_mul]

/-- **The whole shares never exceed the chamber.** -/
theorem baseTotal_le (ds : List Division) (H : Nat) (hP : 0 < totalPop ds) :
    baseTotal ds H ≤ H := by
  have h := base_rem_split ds H
  have hle : totalPop ds * baseTotal ds H ≤ totalPop ds * H := by omega
  exact Nat.le_of_mul_le_mul_left hle hP

/-- Each remainder is below the total population. -/
theorem rem_lt (ds : List Division) (H : Nat) (hP : 0 < totalPop ds) {r : Row}
    (hr : r ∈ rowsOf ds H) : r.rem < totalPop ds := by
  obtain ⟨d, -, rfl⟩ := List.mem_map.mp hr
  exact Nat.mod_lt _ hP

/-- The remainders, all told, are less than one seat's worth per division. -/
theorem rem_sum_bound (ds : List Division) (H : Nat) (hP : 0 < totalPop ds) :
    ((rowsOf ds H).map Row.rem).sum + ds.length ≤ ds.length * totalPop ds := by
  have h := sum_mod_bound hP (ds.map (fun d => d.pop * H))
  rw [rowsOf, rem_map]
  simpa using h

/-- **The leftovers are fewer than the divisions**, so every leftover seat goes
to a different division. -/
theorem extras_le (ds : List Division) (H : Nat) (hP : 0 < totalPop ds) :
    H - baseTotal ds H ≤ ds.length := by
  have hsplit := base_rem_split ds H
  have hbound := rem_sum_bound ds H hP
  have hmul : totalPop ds * (H - baseTotal ds H) ≤ totalPop ds * ds.length := by
    rw [Nat.mul_sub]
    calc totalPop ds * H - totalPop ds * baseTotal ds H
        = ((rowsOf ds H).map Row.rem).sum := by omega
      _ ≤ ds.length * totalPop ds := by omega
      _ = totalPop ds * ds.length := Nat.mul_comm _ _
  exact Nat.le_of_mul_le_mul_left hmul hP

/-! ### The chamber is handed out exactly -/

/-- **The House is exactly `H` seats.**  Whole shares plus leftovers use up the
chamber and no more. -/
theorem apportion_total (ds : List Division) (H : Nat) (hP : 0 < totalPop ds) :
    ((houseSeats ds H).map Prod.snd).sum = H := by
  have hlen : (sortDesc (rowsOf ds H)).length = ds.length := by
    rw [sortDesc_length, rowsOf_length]
  have hsum := handOut_sum (H - baseTotal ds H) (sortDesc (rowsOf ds H))
  have hbase := baseTotal_le ds H hP
  have hextra := extras_le ds H hP
  have hmap : ((houseSeats ds H).map Prod.snd).sum = ((apportion ds H).map Row.base).sum := by
    simp [houseSeats, List.map_map, Function.comp_def]
  rw [hmap, apportion, hsum, hlen, sortDesc_base_sum, ← baseTotal]
  omega

/-! ### The quota rule -/

/-- **Nobody is short-changed.**  Every division receives at least the whole
part of its exact share. -/
theorem seats_ge_lower_quota (ds : List Division) (H : Nat) {d : Division} (hd : d ∈ ds) :
    ∃ n, (d.name, n) ∈ houseSeats ds H ∧ d.pop * H / totalPop ds ≤ n := by
  have hrow : (⟨d.name, d.pop * H / totalPop ds, d.pop * H % totalPop ds⟩ : Row) ∈ rowsOf ds H :=
    List.mem_map_of_mem hd
  have hsort := (sortDesc_perm (rowsOf ds H)).mem_iff.mpr hrow
  obtain ⟨r, hr, hname, hbase⟩ := handOut_covers (k := H - baseTotal ds H) hsort
  refine ⟨r.base, ?_, by simp only at hbase; omega⟩
  refine List.mem_map.mpr ⟨r, by simpa [apportion] using hr, ?_⟩
  simp [hname]

/-- **Nobody is over-paid.**  No division receives more than one seat above the
whole part of its exact share. -/
theorem seats_le_upper_quota (ds : List Division) (H : Nat) {nm : String} {n : Nat}
    (h : (nm, n) ∈ houseSeats ds H) :
    ∃ d ∈ ds, d.name = nm ∧ n ≤ d.pop * H / totalPop ds + 1 := by
  obtain ⟨r, hr, hnm⟩ := List.mem_map.mp h
  obtain ⟨s, hs, hname, hbase⟩ := handOut_mem (H - baseTotal ds H) (by simpa [apportion] using hr)
  have hs' : s ∈ rowsOf ds H := (sortDesc_perm (rowsOf ds H)).mem_iff.mp hs
  obtain ⟨d, hd, rfl⟩ := List.mem_map.mp hs'
  refine ⟨d, hd, ?_, ?_⟩
  · exact hname.trans (congrArg Prod.fst hnm)
  · have hn : n = r.base := (congrArg Prod.snd hnm).symm
    simp only at hbase
    omega

/-! ### Why this is a federal legislature and not a proportional one -/

/-- **The small division is over-represented.**  If a division holds less than
its equal share of the people, then its share of the Senate — one division in
`n` — is strictly larger than its share of the population. -/
theorem small_division_overrepresented (ds : List Division) {d : Division} (hd : d ∈ ds)
    (hsmall : d.pop * ds.length < totalPop ds) :
    (d.pop : ℚ) / totalPop ds < 1 / ds.length := by
  have hn : 0 < ds.length := List.length_pos_of_mem hd
  have hP : 0 < totalPop ds := lt_of_le_of_lt (Nat.zero_le _) hsmall
  have hnQ : (0 : ℚ) < ds.length := by exact_mod_cast hn
  have hPQ : (0 : ℚ) < totalPop ds := by exact_mod_cast hP
  rw [div_lt_div_iff₀ hPQ hnQ]
  have : (d.pop : ℚ) * ds.length < (totalPop ds : ℚ) := by exact_mod_cast hsmall
  simpa using this

end Federal
