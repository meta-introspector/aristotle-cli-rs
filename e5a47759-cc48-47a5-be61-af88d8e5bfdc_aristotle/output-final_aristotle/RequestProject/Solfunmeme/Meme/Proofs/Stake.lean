import Mathlib
import RequestProject.Solfunmeme.Meme.Stake
import RequestProject.Solfunmeme.Meme.Proofs.Engine

/-!
# Staking pays for holding

The properties a staker cares about, all unconditional:

* `payout_mono_days` / `payout_strict_mono_days` — holding longer never pays
  less, and pays strictly more whenever the balance is nonzero;
* `payout_add_days` — the schedule is additive in days, so a position can be
  settled in instalments without changing what it pays in total;
* `payout_mono_memes` — minting more memes never lowers the payout;
* `payout_ticks` — a pure hold from a fresh save pays exactly the stake the
  engine accrued, which is what makes the game state and the staking pool agree.
-/

namespace Meme.Stake

open Meme.Engine

theorem payout_mono_days {b m d e : Nat} (h : d ≤ e) :
    payout ⟨b, d, m⟩ ≤ payout ⟨b, e, m⟩ := by
  simp only [payout]
  exact Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ h)

theorem payout_strict_mono_days {b m d e : Nat} (hb : 0 < b) (h : d < e) :
    payout ⟨b, d, m⟩ < payout ⟨b, e, m⟩ := by
  simp only [payout]
  have h1 : b * d < b * e := Nat.mul_lt_mul_of_pos_left h hb
  exact Nat.mul_lt_mul_of_pos_right h1 (by omega)

theorem payout_add_days (b m d e : Nat) :
    payout ⟨b, d + e, m⟩ = payout ⟨b, d, m⟩ + payout ⟨b, e, m⟩ := by
  simp only [payout]
  ring

theorem payout_mono_memes {b d m n : Nat} (h : m ≤ n) :
    payout ⟨b, d, m⟩ ≤ payout ⟨b, d, n⟩ := by
  simp only [payout]
  exact Nat.mul_le_mul_left _ (by omega)

/-! ## Agreement with the engine -/

theorem memes_ticks (s : State) (d : Nat) :
    (run s (List.replicate d .tick)).memes = s.memes := by
  induction d generalizing s with
  | zero => simp
  | succ n ih => simpa [List.replicate_succ, step] using ih (step s .tick)

/-- A pure hold pays exactly the stake the engine accrued. -/
theorem payout_ticks (b d : Nat) :
    payout (ofState (run (start b) (List.replicate d .tick)))
      = (run (start b) (List.replicate d .tick)).stake := by
  have hb : (run (start b) (List.replicate d .tick)).blocks = b := by
    simpa [start] using blocks_ticks (start b) d
  have hd : (run (start b) (List.replicate d .tick)).day = d := by
    simpa [start] using day_ticks (start b) d
  have hm : (run (start b) (List.replicate d .tick)).memes = 0 := by
    simpa [start] using memes_ticks (start b) d
  have hs : (run (start b) (List.replicate d .tick)).stake = d * b := by
    simpa [start] using stake_ticks (start b) d
  simp [payout, ofState, hb, hd, hm, hs, Nat.mul_comm]

end Meme.Stake
