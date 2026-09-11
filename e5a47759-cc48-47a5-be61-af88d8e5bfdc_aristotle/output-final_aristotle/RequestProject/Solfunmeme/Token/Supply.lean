/-
# The token book: fixed supply, locks, and burn-to-mint

This file formalises the supply questions the holders actually ask, in the form
they were asked:

    "Will the supply always remain fixed at 1B, or will there be some kind of
     burn mechanism?"
    "I plan on buying and locking them ... burning the tokens to mint memes ...
     the proof is the payment."

A **book** is the aggregate state of the mint: tokens circulating, tokens held
under lock, and tokens burned.  The four things a holder can do to it are
`lock`, `unlock`, `burn` and `mint` — where `mint` is the burn-to-mint ritual:
it pays for a badge or a meme by burning tokens, and it only pays when a proof
is presented ("the proof is the payment").

What is proved here, for *every* sequence of actions from *any* book:

* `Book.step_issued`, `Book.run_issued` — the number of tokens ever issued never
  changes.  There is no action in the model that mints a token, so the 1B cap is
  a theorem about the model, not a promise;
* `Book.run_outstanding_le` — the circulating-plus-locked supply can only fall;
* `Book.outstanding_add_burned` — every token that has left the supply is in the
  burn counter, so the deflation is exactly the burn and nothing else;
* `Book.burn_strict_decrease` — a burn of a positive affordable amount strictly
  reduces the supply;
* `Book.lock_outstanding`, `Book.unlock_outstanding` — locking and unlocking move
  tokens between two pockets and change no total, so a lock-up is not a burn;
* `Book.mint_of_unproved`, `Book.mint_of_proved` — a mint without a proof is a
  no-op (nothing is burned and no badge is paid for); with a proof it burns
  exactly its cost;
* `Book.mintRun_eq`, `Book.badge_count_le` — running the ritual `k` times at
  cost `c` burns exactly `k * c`, and therefore at most `issued / c` badges can
  ever be minted against a book.  The badge supply is capped by the token supply
  divided by the price of a badge.

Nothing here says what a token is worth.  It says what the book can and cannot
do.
-/
import Mathlib

namespace SFM.Token

/-! ## The book -/

/-- The aggregate state of the mint: what circulates, what is locked, what has
been burned.  Amounts are in whole base units. -/
structure Book where
  /-- Tokens that can be moved or spent right now. -/
  circulating : ℕ
  /-- Tokens held under a lock: still owned, still counted, not spendable. -/
  locked : ℕ
  /-- Tokens destroyed, and so removed from the supply for ever. -/
  burned : ℕ
  deriving DecidableEq, Repr, Inhabited

namespace Book

/-- The live supply: everything a holder still owns, locked or not. -/
def outstanding (b : Book) : ℕ := b.circulating + b.locked

/-- Everything the mint ever issued: the live supply plus what has been burned.
This is the quantity the "fixed at 1B" question is about. -/
def issued (b : Book) : ℕ := b.outstanding + b.burned

/-- The book a mint starts from: `n` tokens, all circulating, none burned. -/
def genesis (n : ℕ) : Book := ⟨n, 0, 0⟩

@[simp] theorem genesis_issued (n : ℕ) : (genesis n).issued = n := by
  simp [genesis, issued, outstanding]

@[simp] theorem genesis_outstanding (n : ℕ) : (genesis n).outstanding = n := by
  simp [genesis, outstanding]

/-! ## What can be done to it -/

/-- The four actions.  `mint c p` is the burn-to-mint ritual: it pays `c` tokens
for a badge, and `p` records whether a proof was presented. -/
inductive Act where
  /-- Move up to `n` tokens from circulating into a lock. -/
  | lock (n : ℕ)
  /-- Release up to `n` locked tokens back into circulation. -/
  | unlock (n : ℕ)
  /-- Destroy up to `n` circulating tokens. -/
  | burn (n : ℕ)
  /-- Burn `c` tokens to mint a badge, if a proof is presented and the cost is
  affordable. -/
  | mint (c : ℕ) (proof : Bool)
  deriving DecidableEq, Repr

/-- What one action does to the book. -/
def step (b : Book) : Act → Book
  | .lock n =>
      { b with circulating := b.circulating - min n b.circulating,
               locked := b.locked + min n b.circulating }
  | .unlock n =>
      { b with circulating := b.circulating + min n b.locked,
               locked := b.locked - min n b.locked }
  | .burn n =>
      { b with circulating := b.circulating - min n b.circulating,
               burned := b.burned + min n b.circulating }
  | .mint _ false => b
  | .mint c true =>
      if c ≤ b.circulating then
        { b with circulating := b.circulating - c, burned := b.burned + c }
      else b

/-- A sequence of actions, applied in order. -/
def run (b : Book) (as : List Act) : Book := as.foldl step b

@[simp] theorem run_nil (b : Book) : run b [] = b := rfl

@[simp] theorem run_cons (b : Book) (a : Act) (as : List Act) :
    run b (a :: as) = run (step b a) as := rfl

/-! ## Nothing mints a token -/

/-- **No action mints a token.**  Whatever is done to a book, the number of
tokens ever issued is unchanged. -/
@[simp] theorem step_issued (b : Book) (a : Act) : (step b a).issued = b.issued := by
  cases a with
  | lock n => simp only [step, issued, outstanding]; omega
  | unlock n => simp only [step, issued, outstanding]; omega
  | burn n => simp only [step, issued, outstanding]; omega
  | mint c p =>
      cases p with
      | false => rfl
      | true =>
          by_cases h : c ≤ b.circulating
          · simp only [step, if_pos h, issued, outstanding]; omega
          · simp only [step, if_neg h]

/-- **The supply is fixed, for every history.**  From a book that has issued `n`
tokens, no sequence of actions can ever change that number. -/
@[simp] theorem run_issued (b : Book) (as : List Act) : (run b as).issued = b.issued := by
  induction as generalizing b with
  | nil => rfl
  | cons a as ih => simp [run_cons, ih]

/-- Applied to the 1B genesis book: after any history, exactly 1B tokens have
ever existed. -/
theorem fixed_cap (n : ℕ) (as : List Act) : (run (genesis n) as).issued = n := by
  simp

/-- Every token that has left the live supply is in the burn counter. -/
theorem outstanding_add_burned (b : Book) : b.outstanding + b.burned = b.issued := rfl

/-! ## The supply only falls, and only by burning -/

/-- One action never raises the live supply. -/
theorem step_outstanding_le (b : Book) (a : Act) : (step b a).outstanding ≤ b.outstanding := by
  cases a with
  | lock n => simp only [step, outstanding]; omega
  | unlock n => simp only [step, outstanding]; omega
  | burn n => simp only [step, outstanding]; omega
  | mint c p =>
      cases p with
      | false => exact le_refl _
      | true =>
          by_cases h : c ≤ b.circulating
          · simp only [step, if_pos h, outstanding]; omega
          · simp only [step, if_neg h]; exact le_refl _

/-- One action never lowers the burn counter: a burn cannot be undone. -/
theorem step_burned_ge (b : Book) (a : Act) : b.burned ≤ (step b a).burned := by
  cases a with
  | lock n => simp [step]
  | unlock n => simp [step]
  | burn n => simp [step]
  | mint c p =>
      cases p with
      | false => exact le_refl _
      | true =>
          by_cases h : c ≤ b.circulating
          · simp only [step, if_pos h]; omega
          · simp only [step, if_neg h]; exact le_refl _

/-- **The live supply is monotone downwards over any history.** -/
theorem run_outstanding_le (b : Book) (as : List Act) :
    (run b as).outstanding ≤ b.outstanding := by
  induction as generalizing b with
  | nil => exact le_refl _
  | cons a as ih => exact le_trans (ih (step b a)) (step_outstanding_le b a)

/-- **Burning is the only sink.**  Over any history the supply falls by exactly
the tokens burned in it. -/
theorem run_outstanding_eq (b : Book) (as : List Act) :
    (run b as).outstanding + (run b as).burned = b.outstanding + b.burned := by
  have := run_issued b as
  simpa [issued] using this

/-- A burn of a positive, affordable amount strictly reduces the supply. -/
theorem burn_strict_decrease (b : Book) {n : ℕ} (hn : 0 < n) (h : n ≤ b.circulating) :
    (step b (.burn n)).outstanding < b.outstanding := by
  simp only [step, outstanding]
  omega

/-! ## Locking is not burning -/

/-- Locking moves tokens between pockets; the supply is untouched. -/
@[simp] theorem lock_outstanding (b : Book) (n : ℕ) :
    (step b (.lock n)).outstanding = b.outstanding := by
  simp only [step, outstanding]; omega

/-- Unlocking is likewise supply-neutral. -/
@[simp] theorem unlock_outstanding (b : Book) (n : ℕ) :
    (step b (.unlock n)).outstanding = b.outstanding := by
  simp only [step, outstanding]; omega

/-- Locking burns nothing. -/
@[simp] theorem lock_burned (b : Book) (n : ℕ) : (step b (.lock n)).burned = b.burned := rfl

/-- An affordable lock removes exactly that much from the spendable float, which
is what "buy them, and then spend them with locks to prevent spending" does. -/
theorem lock_circulating (b : Book) {n : ℕ} (h : n ≤ b.circulating) :
    (step b (.lock n)).circulating = b.circulating - n ∧
      (step b (.lock n)).locked = b.locked + n := by
  simp [step, Nat.min_eq_left h]

/-! ## The proof is the payment -/

/-- **A mint without a proof pays nothing and mints nothing.** -/
@[simp] theorem mint_of_unproved (b : Book) (c : ℕ) : step b (.mint c false) = b := rfl

/-- A proved, affordable mint burns exactly its cost. -/
theorem mint_of_proved (b : Book) {c : ℕ} (h : c ≤ b.circulating) :
    step b (.mint c true) = ⟨b.circulating - c, b.locked, b.burned + c⟩ := by
  simp only [step, if_pos h]

/-- A mint nobody can pay for changes nothing either. -/
theorem mint_of_unaffordable (b : Book) {c : ℕ} (h : b.circulating < c) :
    step b (.mint c true) = b := by
  simp only [step, if_neg (Nat.not_le.mpr h)]

/-- `k` badges minted at price `c`. -/
def mintRun (b : Book) (c k : ℕ) : Book := run b (List.replicate k (.mint c true))

/-- Minting `k` affordable badges at price `c` burns exactly `k * c`. -/
theorem mintRun_eq (b : Book) (c k : ℕ) (h : k * c ≤ b.circulating) :
    mintRun b c k = ⟨b.circulating - k * c, b.locked, b.burned + k * c⟩ := by
  induction k generalizing b with
  | zero => cases b; simp [mintRun]
  | succ k ih =>
      have h' : k * c + c ≤ b.circulating := by rw [Nat.succ_mul] at h; exact h
      have hc : c ≤ b.circulating := by omega
      have hb : step b (.mint c true) = ⟨b.circulating - c, b.locked, b.burned + c⟩ :=
        mint_of_proved b hc
      have hstep : k * c ≤ (step b (.mint c true)).circulating := by
        rw [hb]; show k * c ≤ b.circulating - c; omega
      have hrec := ih (step b (.mint c true)) hstep
      simp only [mintRun, List.replicate_succ, run_cons] at hrec ⊢
      rw [hrec, hb]
      simp only [Book.mk.injEq, Nat.succ_mul]
      refine ⟨by omega, ?_, by omega⟩
      trivial

/-- **Badges are capped by the token supply.**  However many badges have been
minted against a book at price `c > 0`, their number is at most the tokens ever
issued divided by the price. -/
theorem badge_count_le (b : Book) {c k : ℕ} (hc : 0 < c) (h : k * c ≤ b.circulating) :
    k ≤ b.issued / c := by
  have hb : k * c ≤ b.issued := by
    have : b.circulating ≤ b.issued := by simp [issued, outstanding]; omega
    omega
  exact Nat.le_div_iff_mul_le hc |>.2 hb

end Book

end SFM.Token
