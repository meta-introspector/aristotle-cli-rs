/-
  TokenDays.lean — the "interest integral" of SOLFUNMEME issue #86.

  The proposal measures loyalty by the *area under the holding curve*:

      "Think of it like a graph — X-axis is time, Y-axis is tokens held.
       The 'area' (tokens × time) is your total interest earned."
      "Held 1000 tokens × 365 days = 365,000 token-days."

  Here a holding history is a step function given by a list of segments
  `(balance, days)`, `tokenDays` is its area, and the first theorem below is
  exactly the Riemann statement: the area equals the sum of the daily balances.

  The rest of the file checks the economics the issue claims for it:

    * the worked example (Chad: 1000 tokens for a year = 365 000 token-days,
      365 tokens of interest at 0.1% per day);
    * "hold longer, earn more" and "time beats size", as monotonicity theorems;
    * the anti-rug reset ("dump your stack, back to zero token-days");
    * the two claims that do *not* hold up — 0.1% per day compounded is not
      36.5% per year (it is more than 44%, and the supply more than doubles
      inside the Senate's two-year lock), and paying every holder the same
      rate in the same token leaves every holder's share of the supply, and
      the whole ranking, exactly where it was.
-/

import Mathlib

namespace Badges

/-! ### Holding histories and their area -/

/-- A holding history: consecutive segments `(balance, days)`, oldest first. -/
abbrev History := List (ℕ × ℕ)

/-- Token-days accumulated by a history: the area under the holding curve. -/
def tokenDays (h : History) : ℕ := (h.map fun s => s.1 * s.2).sum

/-- Total length of a history, in days. -/
def duration (h : History) : ℕ := (h.map Prod.snd).sum

/-- The balance held on day `t` of the history (0 once the history runs out). -/
def balanceOn : History → ℕ → ℕ
  | [], _ => 0
  | (b, d) :: rest, t => if t < d then b else balanceOn rest (t - d)

@[simp] theorem balanceOn_cons (b d : ℕ) (h : History) (t : ℕ) :
    balanceOn ((b, d) :: h) t = if t < d then b else balanceOn h (t - d) := rfl

@[simp] theorem tokenDays_nil : tokenDays [] = 0 := rfl

@[simp] theorem tokenDays_cons (b d : ℕ) (h : History) :
    tokenDays ((b, d) :: h) = b * d + tokenDays h := rfl

@[simp] theorem duration_nil : duration [] = 0 := rfl

@[simp] theorem duration_cons (b d : ℕ) (h : History) :
    duration ((b, d) :: h) = d + duration h := rfl

/-- **The integral.**  Token-days really is the area under the holding curve:
the sum, over every day of the history, of the balance held on that day. -/
theorem tokenDays_eq_sum_balanceOn (h : History) :
    tokenDays h = ∑ t ∈ Finset.range (duration h), balanceOn h t := by
  induction h with
  | nil => simp
  | cons s rest ih =>
      obtain ⟨b, d⟩ := s
      rw [tokenDays_cons, duration_cons, Finset.sum_range_add, ih]
      congr 1
      · have hconst : ∀ t ∈ Finset.range d, balanceOn ((b, d) :: rest) t = b := by
          intro t ht
          simp only [Finset.mem_range] at ht
          simp [ht]
        rw [Finset.sum_congr rfl hconst, Finset.sum_const, Finset.card_range,
          smul_eq_mul, mul_comm]
      · refine Finset.sum_congr rfl (fun t _ => ?_)
        simp

/-- Histories concatenate: the area of a two-part history is the sum of the
areas. -/
theorem tokenDays_append (h k : History) :
    tokenDays (h ++ k) = tokenDays h + tokenDays k := by
  induction h with
  | nil => simp
  | cons s rest ih => obtain ⟨b, d⟩ := s; simp [ih, Nat.add_assoc]

/-- **Hold longer, earn more**: extending a history never decreases its area. -/
theorem tokenDays_le_append (h k : History) : tokenDays h ≤ tokenDays (h ++ k) := by
  simp [tokenDays_append]

/-- Holding a positive balance for at least one more day strictly increases the
area. -/
theorem tokenDays_lt_append (h : History) {b d : ℕ} (hb : 0 < b) (hd : 0 < d) :
    tokenDays h < tokenDays (h ++ [(b, d)]) := by
  rw [tokenDays_append]
  have : 0 < b * d := Nat.mul_pos hb hd
  simp only [tokenDays_cons, tokenDays_nil, Nat.add_zero]
  omega

/-- Holding more, for the same times, never decreases the area. -/
theorem tokenDays_mono_balance {h k : History} (hlen : h.length = k.length)
    (hb : ∀ i : Fin h.length, (h.get i).1 ≤ (k.get (Fin.cast hlen i)).1)
    (hd : ∀ i : Fin h.length, (h.get i).2 = (k.get (Fin.cast hlen i)).2) :
    tokenDays h ≤ tokenDays k := by
  induction h generalizing k with
  | nil => simp [tokenDays]
  | cons s rest ih =>
      obtain ⟨b, d⟩ := s
      match k with
      | [] => simp at hlen
      | (b', d') :: rest' =>
          have hb0 := hb ⟨0, by simp⟩
          have hd0 := hd ⟨0, by simp⟩
          simp only [List.get_eq_getElem, Fin.cast, List.getElem_cons_zero] at hb0 hd0
          have hlen' : rest.length = rest'.length := by simpa using hlen
          have hb' : ∀ i : Fin rest.length, (rest.get i).1 ≤ (rest'.get (Fin.cast hlen' i)).1 := by
            intro i
            have := hb ⟨i.1 + 1, by simp [Nat.succ_lt_succ i.2]⟩
            simpa using this
          have hd' : ∀ i : Fin rest.length, (rest.get i).2 = (rest'.get (Fin.cast hlen' i)).2 := by
            intro i
            have := hd ⟨i.1 + 1, by simp [Nat.succ_lt_succ i.2]⟩
            simpa using this
          have := ih hlen' hb' hd'
          simp only [tokenDays_cons]
          have : b * d ≤ b' * d' := by
            rw [hd0]; exact Nat.mul_le_mul_right _ hb0
          omega

/-! ### The worked example from the issue -/

/-- "Chad": 1000 tokens held for 365 days. -/
def chadHistory : History := [(1000, 365)]

theorem chad_tokenDays : tokenDays chadHistory = 365000 := by decide

/-- Interest paid on accumulated token-days at rate `rate` per token-day. -/
def interest (rate : ℚ) (h : History) : ℚ := rate * tokenDays h

/-- At 0.1% per day, Chad's year of holding pays 365 tokens — as the issue says. -/
theorem chad_interest : interest (1 / 1000) chadHistory = 365 := by
  rw [interest, chad_tokenDays]
  norm_num

/-- **Time beats size**: a year of 1000 tokens outranks a week of 1500. -/
theorem time_beats_size : tokenDays [(1500, 7)] < tokenDays chadHistory := by decide

/-- Interest is linear in the area, hence additive over concatenated histories. -/
theorem interest_append (rate : ℚ) (h k : History) :
    interest rate (h ++ k) = interest rate h + interest rate k := by
  simp [interest, tokenDays_append, mul_add]

/-! ### The anti-rug reset -/

/-- Accrual with the proposal's reset rule: a holder who ever drops below the
tier threshold `tau` loses everything banked so far ("dump your stack? back to
zero token-days"). -/
def accrue (tau : ℕ) : ℕ → History → ℕ
  | acc, [] => acc
  | acc, (b, d) :: rest => if b < tau then accrue tau 0 rest else accrue tau (acc + b * d) rest

@[simp] theorem accrue_nil (tau acc : ℕ) : accrue tau acc [] = acc := rfl

theorem accrue_dip (tau acc b d : ℕ) (h : b < tau) (rest : History) :
    accrue tau acc ((b, d) :: rest) = accrue tau 0 rest := by
  simp [accrue, h]

theorem accrue_hold (tau acc b d : ℕ) (h : tau ≤ b) (rest : History) :
    accrue tau acc ((b, d) :: rest) = accrue tau (acc + b * d) rest := by
  simp [accrue, Nat.not_lt.mpr h]

theorem accrue_mono_acc (tau : ℕ) (h : History) {a a' : ℕ} (hle : a ≤ a') :
    accrue tau a h ≤ accrue tau a' h := by
  induction h generalizing a a' with
  | nil => simpa using hle
  | cons s rest ih =>
      obtain ⟨b, d⟩ := s
      by_cases hb : b < tau
      · simp [accrue, hb]
      · simp only [accrue, if_neg hb]
        exact ih (Nat.add_le_add_right hle _)

/-- Accrual with reset never exceeds the raw area. -/
theorem accrue_le_tokenDays (tau acc : ℕ) (h : History) :
    accrue tau acc h ≤ acc + tokenDays h := by
  induction h generalizing acc with
  | nil => simp
  | cons s rest ih =>
      obtain ⟨b, d⟩ := s
      by_cases hb : b < tau
      · simp only [accrue, if_pos hb, tokenDays_cons]
        have := ih 0
        omega
      · simp only [accrue, if_neg hb, tokenDays_cons]
        have := ih (acc + b * d)
        omega

/-- A holder who never dips below the threshold keeps the whole area. -/
theorem accrue_eq_tokenDays (tau acc : ℕ) (h : History)
    (hall : ∀ s ∈ h, tau ≤ s.1) : accrue tau acc h = acc + tokenDays h := by
  induction h generalizing acc with
  | nil => simp
  | cons s rest ih =>
      obtain ⟨b, d⟩ := s
      have hb : tau ≤ b := hall (b, d) (by simp)
      rw [accrue_hold tau acc b d hb, ih _ (fun s hs => hall s (by simp [hs]))]
      simp [Nat.add_assoc]

/-- Chad, who never sells, banks his whole year. -/
theorem chad_accrue : accrue 500 0 chadHistory = 365000 := by decide

/-- **Selling is punished**: the same 365 000 token-days interrupted by a single
day below the threshold banks only what came after the dip. -/
theorem dip_wipes_history :
    accrue 500 0 [(1000, 200), (0, 1), (1000, 165)] = 165000 := by decide

theorem dip_loses_area :
    accrue 500 0 [(1000, 200), (0, 1), (1000, 165)]
      < tokenDays [(1000, 200), (0, 1), (1000, 165)] := by decide

/-! ### The interest rate: 0.1% per day is not 36.5% per year -/

/-- Compounded daily, 0.1% per day is more than 44% per year, not the 36.5%
that the issue's "365 tokens on 1000" example assumes. -/
theorem daily_rate_compounds_above_44_percent :
    (1.44 : ℚ) < (1 + 1 / 1000) ^ 365 := by
  have hnat : (144 : ℕ) * 1000 ^ 365 < 1001 ^ 365 * 100 := by decide +kernel
  have h : ((1 : ℚ) + 1 / 1000) ^ 365 = 1001 ^ 365 / 1000 ^ 365 := by
    rw [show ((1 : ℚ) + 1 / 1000) = 1001 / 1000 by norm_num, div_pow]
  rw [h, show (1.44 : ℚ) = 144 / 100 by norm_num,
    div_lt_div_iff₀ (by norm_num) (by positivity)]
  exact_mod_cast hnat

/-- Simple interest on the area understates the compounded figure: Chad's 365
tokens are less than the 440-plus he would get if the drip really compounded. -/
theorem simple_understates_compound :
    interest (1 / 1000) chadHistory < 1000 * ((1 + 1 / 1000 : ℚ) ^ 365 - 1) := by
  have h := daily_rate_compounds_above_44_percent
  rw [chad_interest]
  generalize ((1 : ℚ) + 1 / 1000) ^ 365 = X at h ⊢
  linarith

/-- **The supply more than doubles inside the Senate's two-year lock.**  If the
0.1% daily drip is minted in the same token, two years of it multiply the
supply by more than 2. -/
theorem supply_more_than_doubles_in_two_years :
    (2 : ℚ) < (1 + 1 / 1000) ^ 730 := by
  have hnat : (2 : ℕ) * 1000 ^ 730 < 1001 ^ 730 := by decide +kernel
  have h : ((1 : ℚ) + 1 / 1000) ^ 730 = 1001 ^ 730 / 1000 ^ 730 := by
    rw [show ((1 : ℚ) + 1 / 1000) = 1001 / 1000 by norm_num, div_pow]
  rw [h, lt_div_iff₀ (by positivity)]
  exact_mod_cast hnat

/-! ### Uniform interest is nominal -/

/-- **Everybody's share is unchanged.**  If every holder is paid the same rate
in the same token, each holder's fraction of the supply after the payment is
exactly what it was before: the reward is purely nominal. -/
theorem uniform_interest_share_invariant (r bal total : ℚ) (hr : 1 + r ≠ 0) :
    ((1 + r) * bal) / ((1 + r) * total) = bal / total :=
  mul_div_mul_left bal total hr

/-- **And so is the ranking.**  Uniform interest never reorders holders, so no
amount of holding lets a rank-101 holder overtake a rank-100 senator: the tiers
are frozen by the rule that is supposed to reward loyalty. -/
theorem uniform_interest_rank_invariant (r b₁ b₂ : ℚ) (hr : 0 < 1 + r) :
    (1 + r) * b₁ ≤ (1 + r) * b₂ ↔ b₁ ≤ b₂ :=
  mul_le_mul_iff_of_pos_left hr

/-- Token-day-weighted interest, by contrast, *can* reorder holders: a smaller
but older stack overtakes a larger, newer one. -/
theorem tokenDays_weighting_can_reorder :
    tokenDays [(1000, 365)] > tokenDays [(1500, 7)] ∧ (1000 : ℕ) < 1500 := by
  refine ⟨by decide, by decide⟩

end Badges
