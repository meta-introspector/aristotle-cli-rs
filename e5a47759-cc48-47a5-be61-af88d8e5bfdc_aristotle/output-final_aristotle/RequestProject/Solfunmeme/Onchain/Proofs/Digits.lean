import Mathlib
import RequestProject.Solfunmeme.Onchain.Digits

/-!
Correctness of the positional numeral layer.

The two facts we need downstream are that `digitsBE` and `ofDigitsBE` are mutually
inverse: reading back an expansion recovers the number, and expanding a normalized
digit list recovers the list.  Base 58 (public keys) and base 10 (amount strings)
are then just instances.
-/

namespace Solana.Digits

/-- Reading a digit list left to right: appending a digit shifts by one place. -/
theorem ofDigitsBE_append_singleton (base : Nat) (ds : List Nat) (d : Nat) :
    ofDigitsBE base (ds ++ [d]) = ofDigitsBE base ds * base + d := by
  simp [ofDigitsBE, List.foldl_append]

@[simp] theorem ofDigitsBE_nil (base : Nat) : ofDigitsBE base [] = 0 := rfl

/-- The accumulator in `ofDigitsBE` never decreases. -/
theorem le_foldl_ofDigits (base : Nat) (hb : 1 ≤ base) :
    ∀ (ds : List Nat) (acc : Nat), acc ≤ ds.foldl (fun a d => a * base + d) acc := by
  intro ds
  induction ds with
  | nil => intro acc; simp
  | cons d t ih =>
      intro acc
      refine le_trans ?_ (ih (acc * base + d))
      calc acc = acc * 1 := (Nat.mul_one acc).symm
        _ ≤ acc * base := Nat.mul_le_mul_left acc hb
        _ ≤ acc * base + d := Nat.le_add_right _ _

/-- A digit list whose leading digit is nonzero denotes a positive number. -/
theorem ofDigitsBE_pos (base : Nat) (hb : 1 ≤ base) (d : Nat) (hd : d ≠ 0) (t : List Nat) :
    0 < ofDigitsBE base (d :: t) := by
  have h := le_foldl_ofDigits base hb t (0 * base + d)
  simp only [ofDigitsBE, List.foldl_cons]
  omega

/-- `digitsBE` unfolded at a positive argument. -/
theorem digitsBE_pos (base n : Nat) (hb : 2 ≤ base) (hn : 0 < n) :
    digitsBE base n = digitsBE base (n / base) ++ [n % base] := by
  rw [digitsBE]
  simp [hb, hn]

@[simp] theorem digitsBE_zero (base : Nat) : digitsBE base 0 = [] := by
  rw [digitsBE]; simp

/-- Expanding then reading recovers the number. -/
theorem ofDigitsBE_digitsBE (base : Nat) (hb : 2 ≤ base) :
    ∀ n : Nat, ofDigitsBE base (digitsBE base n) = n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · rw [digitsBE_pos base n hb hn, ofDigitsBE_append_singleton,
        ih (n / base) (Nat.div_lt_self hn (by omega))]
      rw [Nat.mul_comm (n / base) base]
      exact Nat.div_add_mod n base

/-- Every digit produced by `digitsBE` is a genuine digit. -/
theorem digitsBE_lt (base : Nat) (hb : 2 ≤ base) :
    ∀ (n : Nat), ∀ d ∈ digitsBE base n, d < base := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · rw [digitsBE_pos base n hb hn]
      intro d hd
      rcases List.mem_append.mp hd with h | h
      · exact ih (n / base) (Nat.div_lt_self hn (by omega)) d h
      · simp only [List.mem_singleton] at h
        exact h ▸ Nat.mod_lt _ (by omega)

/-- `digitsBE` never emits a leading zero. -/
theorem digitsBE_head?_ne_zero (base : Nat) (hb : 2 ≤ base) :
    ∀ n : Nat, (digitsBE base n).head? ≠ some 0 := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · rw [digitsBE_pos base n hb hn]
      cases hq : digitsBE base (n / base) with
      | nil =>
          -- then `n < base`, so the single digit is `n % base = n ≠ 0`
          have hdiv : n / base = 0 := by
            have := ofDigitsBE_digitsBE base hb (n / base)
            rw [hq] at this; simpa using this.symm
          have hlt : n < base := (Nat.div_eq_zero_iff_lt (by omega)).mp hdiv
          simp [Nat.mod_eq_of_lt hlt]
          omega
      | cons e s =>
          have := ih (n / base) (Nat.div_lt_self hn (by omega))
          rw [hq] at this
          simpa using this

/-- `digitsBE` produces normalized digit lists. -/
theorem digitsBE_normalized (base : Nat) (hb : 2 ≤ base) (n : Nat) :
    Normalized base (digitsBE base n) :=
  ⟨digitsBE_lt base hb n, digitsBE_head?_ne_zero base hb n⟩

/-- Reading then expanding recovers a normalized digit list. -/
theorem digitsBE_ofDigitsBE (base : Nat) (hb : 2 ≤ base) :
    ∀ ds : List Nat, Normalized base ds → digitsBE base (ofDigitsBE base ds) = ds := by
  intro ds
  induction ds using List.reverseRecOn with
  | nil => intro _; simp
  | append_singleton ds d ih =>
      intro hnorm
      obtain ⟨hlt, hhd⟩ := hnorm
      have hd : d < base := hlt d (by simp)
      rw [ofDigitsBE_append_singleton]
      have key : ∀ m : Nat, 0 < m * base + d →
          digitsBE base (m * base + d) = digitsBE base m ++ [d] := by
        intro m hpos
        have hdiv : (m * base + d) / base = m := by
          rw [Nat.mul_comm, Nat.mul_add_div (by omega), Nat.div_eq_of_lt hd, Nat.add_zero]
        have hmod : (m * base + d) % base = d := by
          rw [Nat.mul_comm, Nat.mul_add_mod, Nat.mod_eq_of_lt hd]
        rw [digitsBE_pos base _ hb hpos, hdiv, hmod]
      cases hds : ds with
      | nil =>
          subst hds
          have hd0 : d ≠ 0 := by simpa using hhd
          simp only [ofDigitsBE_nil, Nat.zero_mul, Nat.zero_add]
          rw [digitsBE_pos base d hb (by omega), Nat.div_eq_of_lt hd, Nat.mod_eq_of_lt hd]
          simp
      | cons e t =>
          subst hds
          have he : e ≠ 0 := by simpa using hhd
          have hm : 0 < ofDigitsBE base (e :: t) := ofDigitsBE_pos base (by omega) e he t
          have hpos : 0 < ofDigitsBE base (e :: t) * base + d :=
            Nat.lt_of_lt_of_le (Nat.mul_pos hm (by omega)) (Nat.le_add_right _ _)
          rw [key _ hpos,
            ih ⟨fun x hx => hlt x (List.mem_append_left _ hx), by simpa using hhd⟩]

end Solana.Digits
