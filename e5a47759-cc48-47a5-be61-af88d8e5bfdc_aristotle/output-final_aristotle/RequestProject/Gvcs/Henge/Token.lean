import Mathlib
import RequestProject.Gvcs.Henge.Game

/-!
# Tokens, seals and receipts

A player who wants to boast needs more than a number: they need something a
stranger can check.  This file builds that.

* `digest` — a deterministic rolling digest of a list of numbers, always below
  the modulus (`digest_lt`).
* `sealOf` — a *keyed* digest: the digest of the key placed in front of the
  message.  `verifySeal_iff` says the checker accepts exactly the right seal
  and nothing else.
* `Claim` — what a shared token asserts: the day, the tokens held, the stake,
  the score, the balance, and the seal of the save.
* `Receipt` — the opening position and the list of moves that produced it.
* `checkReceipt` — replays the moves and compares.  Two theorems tie it down:
  `checkReceipt_sound`, which says an accepted claim is *true* — the tokens
  claimed are exactly the mints in the receipt, and the balance really is above
  zero — and `checkReceipt_complete`, which says an honest player is always
  accepted.

**What this is not.**  The seal is a keyed digest computed with ordinary
arithmetic, and the receipt contains the whole play.  A verifier who checks a
receipt learns everything the player did; nothing here is zero-knowledge, and
nothing here is claimed to be collision-resistant.  What *is* proved is that the
checker is exact: it accepts a claim if and only if the claim is what the play
actually produced.
-/

namespace LifeTrac
namespace Henge

/-! ## A digest -/

/-- The modulus: the Mersenne prime `2 ^ 31 - 1`. -/
def digestMod : ℕ := 2147483647

theorem digestMod_pos : 0 < digestMod := by norm_num [digestMod]

/-- One step of the rolling digest. -/
def digestStep (h x : ℕ) : ℕ := (h * 131 + x + 7) % digestMod

theorem digestStep_lt (h x : ℕ) : digestStep h x < digestMod :=
  Nat.mod_lt _ digestMod_pos

/-- The digest of a list of numbers. -/
def digest (l : List ℕ) : ℕ := l.foldl digestStep 1

theorem foldl_digestStep_lt (l : List ℕ) (h : ℕ) (hh : h < digestMod) :
    l.foldl digestStep h < digestMod := by
  induction l generalizing h with
  | nil => simpa using hh
  | cons x xs ih => exact ih _ (digestStep_lt h x)

/-- **A digest is always a number the page can print.** -/
theorem digest_lt (l : List ℕ) : digest l < digestMod :=
  foldl_digestStep_lt l 1 (by norm_num [digestMod])

/-! ## Seals -/

/-- The seal of a message under a key. -/
def sealOf (key : ℕ) (msg : List ℕ) : ℕ := digest (key :: msg)

/-- The check a verifier runs. -/
def verifySeal (key : ℕ) (msg : List ℕ) (s : ℕ) : Bool := s == sealOf key msg

/-- **The checker is exact.**  It accepts the seal of the message, and no other
number. -/
theorem verifySeal_iff (key : ℕ) (msg : List ℕ) (s : ℕ) :
    verifySeal key msg s = true ↔ s = sealOf key msg := by
  simp [verifySeal]

theorem verifySeal_sealOf (key : ℕ) (msg : List ℕ) :
    verifySeal key msg (sealOf key msg) = true := by
  simp [verifySeal]

/-! ## Claims and receipts -/

/-- What a shared token asserts about the play behind it. -/
structure Claim where
  day : ℕ
  memes : ℕ
  stake : ℕ
  score : ℕ
  coins : ℕ
  mark : ℕ
deriving DecidableEq, Repr

/-- The honest claim a save supports. -/
def claimOf (key : ℕ) (s : Save) : Claim :=
  { day := s.day, memes := s.memes, stake := s.stake, score := score s, coins := s.coins,
    mark := sealOf key (encodeSave s) }

/-- The play behind a claim. -/
structure Receipt where
  start : Save
  moves : List Move
deriving DecidableEq, Repr

/-- Replay the receipt and compare. -/
def checkReceipt (key : ℕ) (r : Receipt) (c : Claim) : Bool :=
  match run r.start r.moves with
  | none => false
  | some t => decide (c = claimOf key t)

/-- **An accepted claim is a true claim.**  If the checker accepts, then the
receipt really does replay; the number of tokens claimed is exactly the number
of `mint` moves in the receipt on top of what the player started with; the score
claimed is the score of the finished build; and — provided the opening position
was solvent — the balance claimed really is above zero. -/
theorem checkReceipt_sound {key : ℕ} {r : Receipt} {c : Claim}
    (hstart : Solvent r.start) (h : checkReceipt key r c = true) :
    ∃ t, run r.start r.moves = some t ∧ c = claimOf key t ∧
      c.memes = r.start.memes + r.moves.count Move.mint ∧
      c.score = score t ∧ 0 < c.coins := by
  unfold checkReceipt at h
  cases hrun : run r.start r.moves with
  | none => rw [hrun] at h; simp at h
  | some t =>
      rw [hrun] at h
      have hc : c = claimOf key t := by simpa using h
      refine ⟨t, rfl, hc, ?_, ?_, ?_⟩
      · rw [hc]; exact run_memes hrun
      · rw [hc]; rfl
      · rw [hc]; exact solvent_run hstart hrun

/-- **An honest player is always accepted.** -/
theorem checkReceipt_complete {key : ℕ} {r : Receipt} {t : Save}
    (h : run r.start r.moves = some t) : checkReceipt key r (claimOf key t) = true := by
  unfold checkReceipt
  rw [h]
  simp

/-- **A claim that names the wrong number of tokens is rejected.** -/
theorem checkReceipt_rejects_overclaim {key : ℕ} {r : Receipt} {c : Claim}
    (hstart : Solvent r.start)
    (hbad : c.memes ≠ r.start.memes + r.moves.count Move.mint) :
    checkReceipt key r c = false := by
  by_contra hne
  simp only [Bool.not_eq_false] at hne
  obtain ⟨_, _, _, hmem, _⟩ := checkReceipt_sound hstart hne
  exact hbad hmem

/-! ## Days held -/

/-- The stake a claim is worth after being held: a token earns one a day. -/
def heldValue (c : Claim) (days : ℕ) : ℕ := c.stake + days * c.memes

/-- **A longer hold is worth strictly more, and only while a token is held.** -/
theorem heldValue_strictMono {c : Claim} (hk : 0 < c.memes) {m n : ℕ} (h : m < n) :
    heldValue c m < heldValue c n :=
  Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right h hk) _

theorem heldValue_zero (c : Claim) : heldValue c 0 = c.stake := by simp [heldValue]

/-- **Holding matches playing.**  The value a claim accrues over `n` days is the
stake the game itself would have paid over those `n` days. -/
theorem heldValue_eq_hold (s : Save) (key : ℕ) (n : ℕ) {t : Save}
    (h : run s (holdDays n) = some t) : heldValue (claimOf key s) n = t.stake := by
  rw [hold_stake] at h
  have ht := (Option.some_inj.1 h).symm
  subst ht
  simp [heldValue, claimOf]

end Henge
end LifeTrac
