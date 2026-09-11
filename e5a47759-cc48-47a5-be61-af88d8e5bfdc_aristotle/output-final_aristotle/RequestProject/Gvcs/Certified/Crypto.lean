import Mathlib

/-!
# Certified mode, layer 1: hiding a strategy from the people who execute it

`docs/bootstrap-and-certified-mode.md` describes *certified mode*: a player
submits a **program** rather than clicking moves, the network executes it under
the same rule book everybody else runs, and the resulting run is checkable by
anyone.  The obvious objection is that a submitted program is a strategy, and a
strategy is the one thing a competitive player will not hand over.

This file is the cryptographic core of the answer.  Everything is stated for
the **additive one-time pad over bytes** — the scheme that is simultaneously
*perfectly secret* and *additively homomorphic*, so the two properties the
protocol needs can be proved rather than assumed.  A deployment would swap in a
computationally secure additively homomorphic scheme (Paillier, BFV); the
interface used by `RequestProject/Certified/Protocol.lean` is exactly the four
operations proved here (`otpEnc`, `otpDec`, `vadd`, `weightedSum`), so the
protocol layer does not care which one is underneath.

Contents:

* `otpDec_otpEnc` — decryption undoes encryption.
* `otp_perfect_secrecy` — for *every* candidate plaintext there is exactly one
  key that turns it into the observed ciphertext.  So an observer who sees the
  ciphertext learns nothing whatever about the program: every program of the
  right length remains exactly as plausible as it was.
* `otpEnc_vadd` — the scheme is additively homomorphic.
* `weightedSum_otpEnc`, `score_recover` — a public linear score (weights are
  public; the moves are not) can be evaluated *on the ciphertext*, and the
  result opened with a single number, `weightedSum w k`, that reveals only the
  score.  This is the "score a strategy without seeing it" step of certified
  mode.
-/

namespace LifeTrac
namespace Certified

/-- A wire digit: one byte.  Programs, keys and the low-order noise of a public
market feed are all lists of these. -/
abbrev Digit := ZMod 256

/-! ## Vector operations on wire words -/

/-- Componentwise addition of two words.  Truncates to the shorter word, which
is why every theorem below carries an explicit length hypothesis. -/
def vadd (x y : List Digit) : List Digit := List.zipWith (· + ·) x y

/-- Componentwise subtraction of two words. -/
def vsub (x y : List Digit) : List Digit := List.zipWith (· - ·) x y

@[simp] theorem vadd_cons_cons (a b : Digit) (x y : List Digit) :
    vadd (a :: x) (b :: y) = (a + b) :: vadd x y := rfl

@[simp] theorem vsub_cons_cons (a b : Digit) (x y : List Digit) :
    vsub (a :: x) (b :: y) = (a - b) :: vsub x y := rfl

@[simp] theorem vadd_length (x y : List Digit) :
    (vadd x y).length = min x.length y.length := by
  simp [vadd]

@[simp] theorem vsub_length (x y : List Digit) :
    (vsub x y).length = min x.length y.length := by
  simp [vsub]

/-! ## The one-time pad -/

/-- Encryption: add the key to the message, digit by digit. -/
def otpEnc (k m : List Digit) : List Digit := vadd k m

/-- Decryption: subtract the key from the ciphertext. -/
def otpDec (k c : List Digit) : List Digit := vsub c k

@[simp] theorem otpEnc_length (k m : List Digit) :
    (otpEnc k m).length = min k.length m.length := by simp [otpEnc]

/-- Subtracting the key off recovers the message. -/
theorem vsub_vadd_left {k m : List Digit} (h : k.length = m.length) :
    vsub (vadd k m) k = m := by
  induction k generalizing m with
  | nil => cases m with
    | nil => rfl
    | cons b m => simp at h
  | cons a k ih =>
      cases m with
      | nil => simp at h
      | cons b m =>
          simp only [List.length_cons, Nat.add_right_cancel_iff] at h
          simp [vadd_cons_cons, vsub_cons_cons, ih h]

/-- Subtracting the message off recovers the key. -/
theorem vsub_vadd_right {k m : List Digit} (h : k.length = m.length) :
    vsub (vadd k m) m = k := by
  induction k generalizing m with
  | nil => cases m with
    | nil => rfl
    | cons b m => simp at h
  | cons a k ih =>
      cases m with
      | nil => simp at h
      | cons b m =>
          simp only [List.length_cons, Nat.add_right_cancel_iff] at h
          simp [vadd_cons_cons, vsub_cons_cons, ih h]

/-- Adding the message back to the difference recovers the ciphertext. -/
theorem vadd_vsub {c m : List Digit} (h : m.length = c.length) :
    vadd (vsub c m) m = c := by
  induction m generalizing c with
  | nil => cases c with
    | nil => rfl
    | cons x c => simp at h
  | cons b m ih =>
      cases c with
      | nil => simp at h
      | cons x c =>
          simp only [List.length_cons, Nat.add_right_cancel_iff] at h
          simp [vadd_cons_cons, vsub_cons_cons, ih h]

/-- **Correctness.**  The holder of the key gets the program back. -/
theorem otpDec_otpEnc {k m : List Digit} (h : k.length = m.length) :
    otpDec k (otpEnc k m) = m :=
  vsub_vadd_left h

/-- **Perfect secrecy (Shannon).**  Fix any ciphertext the world can see.  For
*every* program of the same length there is exactly one key that would have
produced it.  So the ciphertext, on its own, rules nothing out: a rival who
downloads the public feed learns nothing at all about the strategy hidden in
it, however much computing power he has. -/
theorem otp_perfect_secrecy {m c : List Digit} (h : m.length = c.length) :
    ∃! k : List Digit, k.length = m.length ∧ otpEnc k m = c := by
  refine ⟨vsub c m, ⟨by simp [h], vadd_vsub h⟩, ?_⟩
  rintro k ⟨hk, hkc⟩
  rw [← hkc, otpEnc, vsub_vadd_right hk]

/-- A corollary in the form a designer wants: any ciphertext at all is
consistent with any program.  There is no "wrong-looking" feed. -/
theorem otp_every_program_consistent {m c : List Digit} (h : m.length = c.length) :
    ∃ k : List Digit, k.length = m.length ∧ otpEnc k m = c := by
  obtain ⟨k, hk, -⟩ := otp_perfect_secrecy h
  exact ⟨k, hk⟩

/-! ## Homomorphism: arithmetic on encrypted programs -/

theorem vadd_comm (x y : List Digit) : vadd x y = vadd y x := by
  induction x generalizing y with
  | nil => cases y <;> rfl
  | cons a x ih => cases y with
    | nil => rfl
    | cons b y => simp [ih, add_comm]

/-- **Additive homomorphism.**  Two encrypted programs add up, under the sum of
their keys, to the encryption of the sum of the programs.  This is what lets an
executor combine or aggregate submissions without opening any of them. -/
theorem otpEnc_vadd {k₁ k₂ m₁ m₂ : List Digit}
    (h₁ : k₁.length = m₁.length) (h₂ : k₂.length = m₂.length) :
    otpEnc (vadd k₁ k₂) (vadd m₁ m₂) = vadd (otpEnc k₁ m₁) (otpEnc k₂ m₂) := by
  induction k₁ generalizing k₂ m₁ m₂ with
  | nil => cases m₁ with
    | nil => rfl
    | cons b m => simp at h₁
  | cons a k₁ ih =>
      cases m₁ with
      | nil => simp at h₁
      | cons b m₁ =>
          cases k₂ with
          | nil => cases m₂ with
            | nil => rfl
            | cons d m₂ => simp at h₂
          | cons c k₂ =>
              cases m₂ with
              | nil => simp at h₂
              | cons d m₂ =>
                  simp only [List.length_cons, Nat.add_right_cancel_iff] at h₁ h₂
                  have hih := ih (k₂ := k₂) (m₁ := m₁) (m₂ := m₂) h₁ h₂
                  simp only [otpEnc, vadd_cons_cons] at hih ⊢
                  rw [hih]
                  congr 1
                  ring

/-! ## Scoring an encrypted program -/

/-- A public linear functional of a word: the weights `w` are public (they are
the league's scoring rule), the word may be a program or a ciphertext. -/
def weightedSum (w x : List Digit) : Digit := (List.zipWith (· * ·) w x).sum

/-- **Homomorphic evaluation.**  The score of the ciphertext splits into the
score of the program and the score of the key. -/
theorem weightedSum_otpEnc {w k m : List Digit}
    (hw : w.length = k.length) (h : k.length = m.length) :
    weightedSum w (otpEnc k m) = weightedSum w k + weightedSum w m := by
  induction w generalizing k m with
  | nil => simp [weightedSum]
  | cons a w ih =>
      cases k with
      | nil => simp at hw
      | cons b k =>
          cases m with
          | nil => simp at h
          | cons c m =>
              simp only [List.length_cons, Nat.add_right_cancel_iff] at hw h
              have hih := ih (k := k) (m := m) hw h
              simp only [weightedSum, otpEnc, vadd_cons_cons, List.zipWith_cons_cons,
                List.sum_cons] at hih ⊢
              rw [hih]; ring

/-- **Score without seeing the strategy.**  An executor evaluates the public
scoring rule on the encrypted program; the player opens the result by
publishing the single digit `weightedSum w k`.  What comes out is exactly the
score of the program, and nothing about the program itself has been
transmitted. -/
theorem score_recover {w k m : List Digit}
    (hw : w.length = k.length) (h : k.length = m.length) :
    weightedSum w (otpEnc k m) - weightedSum w k = weightedSum w m := by
  rw [weightedSum_otpEnc hw h]; ring

end Certified
end LifeTrac
