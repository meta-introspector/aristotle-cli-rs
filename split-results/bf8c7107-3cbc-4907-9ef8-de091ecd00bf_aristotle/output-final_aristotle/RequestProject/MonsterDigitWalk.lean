import Mathlib
import RequestProject.MonsterWalk

/-!
# Single–digit targeting in the Monster Walk

The original Monster Walk preserves *runs* of leading digits (of lengths 3 and 4) at a
few positions. This file records a finer follow-up observation:

> Almost every individual decimal digit of `|𝕄|` can be targeted on its own: for each
> position `p` whose digit is nonzero, there is a subset of the 15 prime-power factors
> whose removal makes the leading digit of `|𝕄|` divided by that subset equal to the
> digit of `|𝕄|` at position `p`. Only one or two factors are ever needed.

The "almost" is unavoidable and sharp: the positions that *cannot* be targeted are
exactly the ones whose digit is `0`, because the leading digit of a positive integer is
always one of `1,…,9` (`leadingDigit_mem`).

Everything is checked against the actual factorization via `MonsterWalk.monsterOrder` and
`MonsterWalk.removedProduct`.
-/

namespace MonsterDigitWalk

open MonsterWalk

/-- The decimal digit of `|𝕄|` at position `p` (as a one-character slice). -/
def digitAt (p : Nat) := ((toString monsterOrder).drop p).take 1

/-- The leading decimal digit of `n` (as a one-character slice). -/
def leadingDigitStr (n : Nat) := (toString n).take 1

/-- An explicit witness for every position with a nonzero digit: the position together
with a subset of indices into `monsterPrimes` whose removal exposes that digit as the
leading digit of the reduced number. Each witness uses only one or two factors. -/
def digitTargets : List (Nat × List Nat) :=
  [(0, [2, 12]), (2, [2, 12]), (4, [0]), (5, [1, 9]), (6, [2]), (7, [1]),
   (8, [2]), (9, [1, 9]), (10, [0, 3]), (11, [2]), (12, [0, 2]), (13, [0]),
   (14, [1]), (15, [2, 12]), (16, [1, 9]), (17, [0, 2]), (18, [2, 12]),
   (19, [2, 12]), (20, [3]), (21, [2]), (22, [0, 2]), (23, [0, 3]), (24, [0, 3]),
   (26, [2]), (27, [0, 3]), (28, [3]), (29, [0]), (30, [1, 9]), (31, [0]),
   (33, [1, 9]), (34, [0, 2]), (35, [1, 9]), (38, [0, 2]), (39, [1, 9]),
   (40, [0, 2]), (41, [2]), (42, [5]), (43, [3]), (44, [2, 12])]

/-- **Single-digit targeting.** Every recorded witness is valid: the chosen subset of
prime-power factors divides `|𝕄|`, and the leading digit of the quotient equals the digit
of `|𝕄|` at the target position. -/
theorem digitTargets_valid :
    digitTargets.all (fun pe =>
      (monsterOrder % removedProduct pe.2 == 0) &&
      (leadingDigitStr (monsterOrder / removedProduct pe.2) == digitAt pe.1)) = true := by
  native_decide

/-- Every targeted position uses at most two prime-power factors. -/
theorem digitTargets_small :
    digitTargets.all (fun pe => pe.2.length == 1 || pe.2.length == 2) = true := by
  native_decide

/-- There are 39 individually targetable positions. -/
theorem digitTargets_count : digitTargets.length = 39 := by native_decide

/-- The targeted positions are pairwise distinct. -/
theorem digitTargets_nodup : (digitTargets.map Prod.fst).Nodup := by decide

/-- **Sharpness of "almost".** Among the 54 digit positions, the ones for which we provide
*no* single-digit witness are exactly the positions whose digit is `0`. Equivalently,
every nonzero digit is targetable and every zero digit is not. -/
theorem uncovered_are_exactly_zeros :
    (List.range 54).filter (fun p => ¬ (digitTargets.map Prod.fst).contains p)
      = (List.range 54).filter (fun p => digitAt p == "0") := by
  native_decide

/-
A leading digit can never be `0`: for any positive `n`, the most significant decimal
digit `n / 10 ^ (Nat.log 10 n)` lies in `{1, …, 9}`. This is the reason the zero-valued
positions of `|𝕄|` cannot be targeted.
-/
theorem leadingDigit_mem (n : Nat) (hn : 0 < n) :
    1 ≤ n / 10 ^ (Nat.log 10 n) ∧ n / 10 ^ (Nat.log 10 n) ≤ 9 := by
  exact ⟨ Nat.div_pos ( Nat.pow_le_of_le_log ( by positivity ) ( by linarith ) ) ( by positivity ), Nat.le_of_lt_succ <| Nat.div_lt_of_lt_mul <| by rw [ mul_comm, ← Nat.pow_succ' ] ; exact Nat.lt_pow_of_log_lt ( by linarith ) ( by linarith ) ⟩

end MonsterDigitWalk