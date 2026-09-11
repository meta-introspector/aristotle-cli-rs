import Mathlib

/-!
# The arena: votes, points and ratings

The formal counterpart of `web/js/arena.js`, where renderings battle for votes
and points with no server anywhere: a ballot is a line in a URL, and everyone's
league table is computed from the ballots they hold.

Two things have to be true for that to work.

*The scoring must be sound.*  A battle awards `WIN` points to the winner, and
moves rating from one side to the other by the classical Elo rule.  Proved
below: the expected score is a probability, the two expectations of a battle
add to one, a battle is exactly zero-sum in rating, no battle moves a rating by
more than `K`, the winner strictly gains, and beating a stronger opponent is
worth more than beating a weaker one.  Over a whole tournament the total rating
in the field is unchanged (`sum_foldl_applyBallot`) and the points awarded are
exactly `WIN` per ballot (`sum_points`).

*The table must not depend on how the ballots arrived.*  Ballots reach a
browser in whatever order links are opened, and the same link may be opened
twice.  Ballots are therefore kept as a grow-only set, merged by union
(`toFinset_merge`, and idempotence, commutativity and associativity from it),
and counted in a canonical order: `canon_of_perm` says two people holding the
same ballots sort them the same way, so `foldl_canon_of_perm` — the league
table itself — is a function of the set of ballots alone.

Finally `copeland_lt_of_condorcet`: whoever beats every other rendering head to
head comes first on the Copeland ranking the studio also offers.
-/

namespace Hesper.Arena

/-! ## The Elo model -/

/-- The chance the Elo model gives a rating of `ra` against a rating of `rb`. -/
noncomputable def expected (ra rb : ℝ) : ℝ := 1 / (1 + (10 : ℝ) ^ ((rb - ra) / 400))

theorem ten_rpow_pos (x : ℝ) : 0 < (10 : ℝ) ^ x := Real.rpow_pos_of_pos (by norm_num) x

theorem one_add_pos (x : ℝ) : 0 < 1 + (10 : ℝ) ^ x := by
  have := ten_rpow_pos x; linarith

theorem expected_pos (ra rb : ℝ) : 0 < expected ra rb := by
  unfold expected
  exact div_pos one_pos (one_add_pos _)

theorem expected_lt_one (ra rb : ℝ) : expected ra rb < 1 := by
  unfold expected
  rw [div_lt_one (one_add_pos _)]
  have := ten_rpow_pos ((rb - ra) / 400)
  linarith

/-- The two sides of a battle have expectations that add to one. -/
theorem expected_add_expected (ra rb : ℝ) : expected ra rb + expected rb ra = 1 := by
  unfold expected
  set x : ℝ := (rb - ra) / 400 with hx
  have hneg : (ra - rb) / 400 = -x := by rw [hx]; ring
  have hp : (0 : ℝ) < (10 : ℝ) ^ x := ten_rpow_pos x
  rw [hneg, Real.rpow_neg (by norm_num : (0:ℝ) ≤ 10)]
  have h1 : (1 : ℝ) + (10 : ℝ) ^ x ≠ 0 := ne_of_gt (one_add_pos x)
  have h2 : (1 : ℝ) + ((10 : ℝ) ^ x)⁻¹ ≠ 0 := by
    have : (0:ℝ) < ((10:ℝ) ^ x)⁻¹ := inv_pos.mpr hp
    linarith
  field_simp
  ring

/-- Equal ratings are an even match. -/
@[simp] theorem expected_self (r : ℝ) : expected r r = 1 / 2 := by
  unfold expected
  norm_num

/-- A higher rating is favoured. -/
theorem expected_lt_expected {ra ra' rb : ℝ} (h : ra < ra') :
    expected ra rb < expected ra' rb := by
  unfold expected
  have hmono : (10 : ℝ) ^ ((rb - ra') / 400) < (10 : ℝ) ^ ((rb - ra) / 400) := by
    apply Real.rpow_lt_rpow_left_iff (by norm_num : (1:ℝ) < 10) |>.mpr
    linarith
  have h1 := one_add_pos ((rb - ra') / 400)
  have h2 := one_add_pos ((rb - ra) / 400)
  exact one_div_lt_one_div_of_lt h1 (by linarith)

/-- One battle.  `sa` is 1 when the first side won, 0 when it lost. -/
noncomputable def update (K ra rb sa : ℝ) : ℝ × ℝ :=
  (ra + K * (sa - expected ra rb), rb - K * (sa - expected ra rb))

/-- **A battle is zero-sum**: it moves rating from one side to the other and
creates none. -/
theorem update_sum (K ra rb sa : ℝ) :
    (update K ra rb sa).1 + (update K ra rb sa).2 = ra + rb := by
  unfold update; ring

/-- No battle moves a rating by more than `K`. -/
theorem abs_update_sub_le {K ra rb sa : ℝ} (hK : 0 ≤ K) (h0 : 0 ≤ sa) (h1 : sa ≤ 1) :
    |(update K ra rb sa).1 - ra| ≤ K := by
  have hp := expected_pos ra rb
  have hl := expected_lt_one ra rb
  have hd : |sa - expected ra rb| ≤ 1 := by
    rw [abs_le]; constructor <;> linarith
  unfold update
  simp only [add_sub_cancel_left, abs_mul, abs_of_nonneg hK]
  calc K * |sa - expected ra rb| ≤ K * 1 := by
        exact mul_le_mul_of_nonneg_left hd hK
    _ = K := by ring

/-- The winner of a battle strictly gains. -/
theorem update_win {K ra rb : ℝ} (hK : 0 < K) : ra < (update K ra rb 1).1 := by
  have hl := expected_lt_one ra rb
  unfold update
  have : 0 < K * (1 - expected ra rb) := mul_pos hK (by linarith)
  simpa using this

/-- The loser of a battle strictly loses. -/
theorem update_loss {K ra rb : ℝ} (hK : 0 < K) : (update K ra rb 0).1 < ra := by
  have hp := expected_pos ra rb
  unfold update
  have : K * (0 - expected ra rb) < 0 := by
    have : 0 < K * expected ra rb := mul_pos hK hp
    linarith
  simpa using this

/-- Beating a stronger opponent is worth more. -/
theorem update_gain_mono {K ra rb rb' : ℝ} (hK : 0 < K) (h : rb < rb') :
    (update K ra rb 1).1 < (update K ra rb' 1).1 := by
  have hmono : expected ra rb' < expected ra rb := by
    unfold expected
    have : (10 : ℝ) ^ ((rb - ra) / 400) < (10 : ℝ) ^ ((rb' - ra) / 400) := by
      apply Real.rpow_lt_rpow_left_iff (by norm_num : (1:ℝ) < 10) |>.mpr
      linarith
    exact one_div_lt_one_div_of_lt (one_add_pos _) (by linarith)
  unfold update
  have := mul_lt_mul_of_pos_left (show (1 - expected ra rb) < (1 - expected ra rb') by linarith) hK
  linarith

/-! ## Ballots -/

/-- One person saying which of two renderings they prefer. -/
structure Ballot where
  a : String
  b : String
  /-- `true` when `a` won. -/
  win : Bool
  voter : String
  ts : ℕ
  deriving DecidableEq, Inhabited

def winner (x : Ballot) : String := if x.win then x.a else x.b
def loser (x : Ballot) : String := if x.win then x.b else x.a

/-! ### Points

The winner takes `WIN` points and the loser none, so the points in the arena
are exactly `WIN` per ballot cast. -/

/-- How many battles `id` has won. -/
def wins (bs : List Ballot) (id : String) : ℕ := bs.countP (fun x => winner x = id)

/-- The points `id` holds. -/
def points (WIN : ℕ) (bs : List Ballot) (id : String) : ℕ := WIN * wins bs id

/-- Summed over the field, every ballot is one win. -/
theorem sum_wins (ids : Finset String) :
    ∀ (bs : List Ballot), (∀ x ∈ bs, winner x ∈ ids) →
      ∑ i ∈ ids, wins bs i = bs.length := by
  intro bs
  induction bs with
  | nil => intro _; simp [wins]
  | cons x xs ih =>
    intro hcov
    have hx : winner x ∈ ids := hcov x (by simp)
    have hrest : ∀ y ∈ xs, winner y ∈ ids := fun y hy => hcov y (by simp [hy])
    have hsplit : ∀ i, wins (x :: xs) i = wins xs i + (if winner x = i then 1 else 0) := by
      intro i
      unfold wins
      by_cases h : winner x = i <;> simp [h]
    rw [Finset.sum_congr rfl (fun i _ => hsplit i), Finset.sum_add_distrib, ih hrest,
      Finset.sum_ite_eq ids (winner x) (fun _ => 1)]
    simp [hx]

/-- **The books balance**: summed over the field, the points are `WIN` times
the number of ballots cast. -/
theorem sum_points (WIN : ℕ) (ids : Finset String) (bs : List Ballot)
    (hcov : ∀ x ∈ bs, winner x ∈ ids) :
    ∑ i ∈ ids, points WIN bs i = WIN * bs.length := by
  unfold points
  rw [← Finset.mul_sum, sum_wins ids bs hcov]

/-! ### Ratings over a tournament -/

/-- Every contestant's rating, as a function of its id. -/
abbrev Ratings := String → ℝ

/-- Fold one ballot into the ratings. -/
noncomputable def applyBallot (K : ℝ) (r : Ratings) (x : Ballot) : Ratings :=
  fun id =>
    if id = winner x then r (winner x) + K * (1 - expected (r (winner x)) (r (loser x)))
    else if id = loser x then r (loser x) - K * (1 - expected (r (winner x)) (r (loser x)))
    else r id

/-- Folding one ballot leaves the total rating in the field unchanged. -/
theorem sum_applyBallot (K : ℝ) (r : Ratings) (x : Ballot) (ids : Finset String)
    (hw : winner x ∈ ids) (hl : loser x ∈ ids) (hne : winner x ≠ loser x) :
    ∑ i ∈ ids, applyBallot K r x i = ∑ i ∈ ids, r i := by
  set d : ℝ := K * (1 - expected (r (winner x)) (r (loser x))) with hd
  have hpoint : ∀ i ∈ ids, applyBallot K r x i
      = r i + ((if i = winner x then d else 0) + (if i = loser x then -d else 0)) := by
    intro i _
    unfold applyBallot
    by_cases h1 : i = winner x
    · subst h1; simp [hne, hd]
    · by_cases h2 : i = loser x
      · subst h2; simp [h1, hd]; ring
      · simp [h1, h2]
  rw [Finset.sum_congr rfl hpoint, Finset.sum_add_distrib, Finset.sum_add_distrib,
    Finset.sum_ite_eq' ids (winner x) (fun _ => d), Finset.sum_ite_eq' ids (loser x) (fun _ => -d)]
  simp [hw, hl]

/-- **Rating is conserved over a whole tournament.** -/
theorem sum_foldl_applyBallot (K : ℝ) (ids : Finset String) :
    ∀ (bs : List Ballot) (r : Ratings),
      (∀ x ∈ bs, winner x ∈ ids ∧ loser x ∈ ids ∧ winner x ≠ loser x) →
      ∑ i ∈ ids, (bs.foldl (applyBallot K) r) i = ∑ i ∈ ids, r i := by
  intro bs
  induction bs with
  | nil => intro r _; simp
  | cons x xs ih =>
    intro r h
    obtain ⟨hw, hl, hne⟩ := h x (by simp)
    have hrest : ∀ y ∈ xs, winner y ∈ ids ∧ loser y ∈ ids ∧ winner y ≠ loser y :=
      fun y hy => h y (by simp [hy])
    simp only [List.foldl_cons]
    rw [ih (applyBallot K r x) hrest, sum_applyBallot K r x ids hw hl hne]

/-! ## Ballots as a grow-only set

Links carry ballots, and the same link may be opened twice, so the ballots a
browser holds are a *set*: merging is union. -/

/-- Merge two collections of ballots. -/
def merge (a b : List Ballot) : List Ballot := (a ++ b).dedup

@[simp] theorem mem_merge {x : Ballot} {a b : List Ballot} :
    x ∈ merge a b ↔ x ∈ a ∨ x ∈ b := by
  unfold merge; simp

theorem toFinset_merge (a b : List Ballot) :
    (merge a b).toFinset = a.toFinset ∪ b.toFinset := by
  ext x; simp

/-- Merging is idempotent: opening the same link twice changes nothing. -/
theorem merge_idem (a : List Ballot) : (merge a a).toFinset = a.toFinset := by
  rw [toFinset_merge]; simp

/-- Merging is commutative: the order the links arrive in does not matter. -/
theorem merge_comm (a b : List Ballot) :
    (merge a b).toFinset = (merge b a).toFinset := by
  rw [toFinset_merge, toFinset_merge, Finset.union_comm]

/-- Merging is associative. -/
theorem merge_assoc (a b c : List Ballot) :
    (merge (merge a b) c).toFinset = (merge a (merge b c)).toFinset := by
  rw [toFinset_merge, toFinset_merge, toFinset_merge, toFinset_merge, Finset.union_assoc]

/-! ### The canonical order

The table is folded in a canonical order, so that two people holding the same
ballots read the same table.  `key` is the ballot's own fingerprint in the
runtime; here it is any injective labelling. -/

variable {κ : Type} [LinearOrder κ]

/-- Sort ballots by an injective key. -/
def canon (key : Ballot → κ) (bs : List Ballot) : List Ballot :=
  bs.mergeSort (fun x y => decide (key x ≤ key y))

theorem canon_perm (key : Ballot → κ) (bs : List Ballot) :
    List.Perm (canon key bs) bs :=
  List.mergeSort_perm _ _

/-- Holding the same ballots means sorting them the same way. -/
theorem canon_of_perm {key : Ballot → κ} (hkey : Function.Injective key)
    {l₁ l₂ : List Ballot} (h : List.Perm l₁ l₂) : canon key l₁ = canon key l₂ := by
  have htrans : ∀ a b c : Ballot, decide (key a ≤ key b) = true →
      decide (key b ≤ key c) = true → decide (key a ≤ key c) = true := by
    intro a b c h1 h2
    simp only [decide_eq_true_eq] at *
    exact le_trans h1 h2
  have htot : ∀ a b : Ballot,
      (decide (key a ≤ key b) || decide (key b ≤ key a)) = true := by
    intro a b
    rcases le_total (key a) (key b) with h' | h' <;> simp [h']
  have hs₁ := List.pairwise_mergeSort htrans htot l₁
  have hs₂ := List.pairwise_mergeSort htrans htot l₂
  have hperm : List.Perm (canon key l₁) (canon key l₂) :=
    ((canon_perm key l₁).trans h).trans (canon_perm key l₂).symm
  refine List.Perm.eq_of_pairwise ?_ hs₁ hs₂ hperm
  intro a b _ _ h1 h2
  simp only [decide_eq_true_eq] at h1 h2
  exact hkey (le_antisymm h1 h2)

/-- **The league table is a function of the set of ballots.**  Whatever order
the links arrived in, folding the canonical order gives the same answer. -/
theorem foldl_canon_of_perm {α : Type} {key : Ballot → κ} (hkey : Function.Injective key)
    (f : α → Ballot → α) (init : α) {l₁ l₂ : List Ballot} (h : List.Perm l₁ l₂) :
    (canon key l₁).foldl f init = (canon key l₂).foldl f init := by
  rw [canon_of_perm hkey h]

/-- Points, too, do not care about the order ballots arrived in — they are a
count. -/
theorem points_of_perm (WIN : ℕ) {l₁ l₂ : List Ballot} (h : List.Perm l₁ l₂) (id : String) :
    points WIN l₁ id = points WIN l₂ id := by
  unfold points wins
  rw [h.countP_eq]

/-! ## Copeland's rule

Each contestant scores +1 for every opponent it beats more often than it loses
to, −1 for the reverse.  A Condorcet winner — one that beats every other head
to head — comes first. -/

/-- How often `x` has beaten `y`. -/
def beats (bs : List Ballot) (x y : String) : ℕ :=
  bs.countP (fun t => winner t = x ∧ loser t = y)

/-- The Copeland score of `x` within a field. -/
def copeland (bs : List Ballot) (ids : Finset String) (x : String) : ℤ :=
  ∑ y ∈ ids.erase x,
    (if beats bs y x < beats bs x y then 1 else if beats bs x y < beats bs y x then -1 else 0)

/-- A Condorcet winner scores the maximum. -/
theorem copeland_condorcet {bs : List Ballot} {ids : Finset String} {x : String}
    (h : ∀ y ∈ ids.erase x, beats bs y x < beats bs x y) :
    copeland bs ids x = (ids.erase x).card := by
  unfold copeland
  rw [Finset.sum_congr rfl (fun y hy => show
      (if beats bs y x < beats bs x y then (1:ℤ)
       else if beats bs x y < beats bs y x then -1 else 0) = 1 by simp [h y hy])]
  simp

/-- **A Condorcet winner comes first.** -/
theorem copeland_lt_of_condorcet {bs : List Ballot} {ids : Finset String} {x z : String}
    (hx : x ∈ ids) (hz : z ∈ ids) (hne : z ≠ x)
    (h : ∀ y ∈ ids.erase x, beats bs y x < beats bs x y) :
    copeland bs ids z < copeland bs ids x := by
  have hxz : x ∈ ids.erase z := Finset.mem_erase.mpr ⟨fun h' => hne h'.symm, hx⟩
  have hzx : z ∈ ids.erase x := Finset.mem_erase.mpr ⟨hne, hz⟩
  have hterm : (if beats bs x z < beats bs z x then (1:ℤ)
      else if beats bs z x < beats bs x z then -1 else 0) = -1 := by
    have hlt := h z hzx
    have : ¬ (beats bs x z < beats bs z x) := by omega
    simp [this, hlt]
  have hsplit : copeland bs ids z
      = (∑ y ∈ (ids.erase z).erase x,
          (if beats bs y z < beats bs z y then (1:ℤ)
           else if beats bs z y < beats bs y z then -1 else 0)) + (-1) := by
    unfold copeland
    rw [← Finset.sum_erase_add _ _ hxz, hterm]
  have hbound : ∑ y ∈ (ids.erase z).erase x,
      (if beats bs y z < beats bs z y then (1:ℤ)
       else if beats bs z y < beats bs y z then -1 else 0)
      ≤ ((ids.erase z).erase x).card := by
    calc ∑ y ∈ (ids.erase z).erase x,
          (if beats bs y z < beats bs z y then (1:ℤ)
           else if beats bs z y < beats bs y z then -1 else 0)
        ≤ ∑ _y ∈ (ids.erase z).erase x, (1:ℤ) := by
          refine Finset.sum_le_sum ?_
          intro y _
          split
          · rfl
          · split <;> norm_num
      _ = ((ids.erase z).erase x).card := by simp
  have hcard : (ids.erase x).card = (ids.erase z).card := by
    rw [Finset.card_erase_of_mem hx, Finset.card_erase_of_mem hz]
  have hcard2 : ((ids.erase z).erase x).card + 1 = (ids.erase z).card := by
    rw [Finset.card_erase_of_mem hxz]
    have : 1 ≤ (ids.erase z).card := Finset.card_pos.mpr ⟨x, hxz⟩
    omega
  have hcast : (((ids.erase z).erase x).card : ℤ) + 1 = ((ids.erase z).card : ℤ) := by
    exact_mod_cast congrArg (Nat.cast : ℕ → ℤ) hcard2
  have hcast2 : ((ids.erase x).card : ℤ) = ((ids.erase z).card : ℤ) := by
    exact_mod_cast congrArg (Nat.cast : ℕ → ℤ) hcard
  rw [copeland_condorcet h, hsplit]
  omega

end Hesper.Arena
