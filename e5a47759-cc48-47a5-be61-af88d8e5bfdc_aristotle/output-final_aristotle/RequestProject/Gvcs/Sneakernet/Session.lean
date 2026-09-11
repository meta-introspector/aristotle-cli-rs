import RequestProject.Gvcs.Sneakernet.Sealed

/-!
# A worked round of the sneakernet game

Two players — `ada` and `bob` — share one 2×2 patch of ground.  Neither is
online: each seals a move under the referee's key and posts it along a bang
path (`ada!decvax!ihnp4!farm`), and the batches ride to the referee however
they ride.  A relay checks the sealed moves against the rule book *under
encryption* and the referee decrypts one verdict bit per move.

What is proved here, for these concrete keys, ciphertexts and bang paths:

* `ada_accepted` — Ada's dig of solid ground is accepted, and the acceptance is
  computed from ciphertexts alone;
* `bob_rejected` — Bob's dig of a hole he has already dug is rejected the same
  way, so the position does not move (`bob_refused`);
* `round_delivered` — both letters arrive after four courier rounds;
* `round_order_irrelevant` — because the two players worked different cells,
  the courier's delivery order does not change the patch;
* `round_result` and `round_reach` — the closing position, and the fact that it
  is one legal play could have produced.
-/

namespace LifeTrac
namespace Sneakernet
namespace Session

open Patch

/-! ### The keys -/

/-- The referee's key: the secret modulus. -/
def demoP : ℤ := 1000003

/-- The players encrypt with noise at most 2, so their ciphertexts sit at
budget `1 + 2 * 2 = 5`. -/
def demoB : ℤ := 5

/-- The rule-book circuit is small enough for this key: the noise it can reach
is 611, well under the modulus. -/
theorem demo_fit : BCirc.bound demoB Patch.game.circuit < demoP := by
  decide

/-! ### The position and the two letters -/

/-- The patch at the start of the round: cell 1 is already a hole. -/
def board : Patch.State := ![true, false, true, true]

/-- Ada digs cell 0, which is solid: legal. -/
def adaMove : Patch.Move := (0, true)

/-- Bob digs cell 1, which is already a hole: illegal. -/
def bobMove : Patch.Move := (1, true)

/-- The referee publishes the position, bit by bit, as ciphertexts. -/
def ctState (s : Patch.State) (i : Fin 4) : ℤ := enc demoP 1 (17 + i.val) (s i)

/-- A player seals a move, bit by bit. -/
def ctMove (a : Patch.Move) (i : Fin 3) : ℤ :=
  enc demoP 2 (5 + i.val) (Patch.encodeMove a i)

theorem ctState_honest (s : Patch.State) :
    ∀ i, Enc demoP demoB (Patch.game.encodeState s i) (ctState s i) := by
  intro i
  have h := enc_valid (p := demoP) (R := 2) (r := 1) (17 + i.val) (s i)
    (by norm_num) (by norm_num)
  simpa [demoB] using h

theorem ctMove_honest (a : Patch.Move) :
    ∀ i, Enc demoP demoB (Patch.game.encodeMove a i) (ctMove a i) := by
  intro i
  have h := enc_valid (p := demoP) (R := 2) (r := 2) (5 + i.val) (Patch.encodeMove a i)
    (by norm_num) (by norm_num)
  simpa [demoB] using h

/-- Ada's letter, as it travels. -/
def adaLetter : SealedGame.Sealed Patch.game := ⟨"ada", adaMove, ctMove adaMove⟩

/-- Bob's letter, as it travels. -/
def bobLetter : SealedGame.Sealed Patch.game := ⟨"bob", bobMove, ctMove bobMove⟩

/-! ### The relay's verdicts, computed without seeing the moves -/

/-- **Ada's move is accepted**, and the acceptance was computed on ciphertexts. -/
theorem ada_accepted :
    dec demoP
      (Patch.game.verdictCt (Fin.append (ctState board) (ctMove adaMove))) = true := by
  have h := Patch.game.verdict_correct (p := demoP) (B := demoB)
    (s := board) (a := adaMove)
    (Patch.game.enc_bits_append (ctState_honest board) (ctMove_honest adaMove)) demo_fit
  rw [h]
  decide

/-- **Bob's move is rejected**, likewise without decrypting it. -/
theorem bob_rejected :
    dec demoP
      (Patch.game.verdictCt (Fin.append (ctState board) (ctMove bobMove))) = false := by
  have h := Patch.game.verdict_correct (p := demoP) (B := demoB)
    (s := board) (a := bobMove)
    (Patch.game.enc_bits_append (ctState_honest board) (ctMove_honest bobMove)) demo_fit
  rw [h]
  decide

/-- The referee applies Ada's move: cell 0 becomes a hole. -/
theorem ada_applied :
    Patch.game.refereeStep (p := demoP) board (ctState board) adaLetter
      = Patch.apply board adaMove := by
  rw [Patch.game.refereeStep_eq_applyChecked (ctState_honest board)
    (show adaLetter.Honest demoP demoB from ctMove_honest adaMove) demo_fit]
  simp only [SealedGame.applyChecked, adaLetter]
  rw [show Patch.game.legal board adaMove = true from by decide]
  rfl

/-- The referee refuses Bob's move: the patch is untouched. -/
theorem bob_refused :
    Patch.game.refereeStep (p := demoP) board (ctState board) bobLetter = board := by
  rw [Patch.game.refereeStep_eq_applyChecked (ctState_honest board)
    (show bobLetter.Honest demoP demoB from ctMove_honest bobMove) demo_fit]
  simp only [SealedGame.applyChecked, bobLetter]
  rw [show Patch.game.legal board bobMove = false from by decide]
  simp

/-! ### The post -/

/-- Ada posts from her machine, three hops from the referee. -/
def adaPacket : Packet Patch.Move := ⟨"ada", ["decvax", "ihnp4", "farm"], adaMove⟩

/-- Bob is closer: two hops. -/
def bobPacket : Packet Patch.Move := ⟨"bob", ["ihnp4", "farm"], bobMove⟩

/-- The night's mail. -/
def round : Wire Patch.Move := ⟨{adaPacket, bobPacket}, 0⟩

theorem round_maxHops : Wire.maxHops round < 4 := by
  have h : Wire.maxHops round ≤ 3 := by
    refine Wire.maxHops_le ?_
    intro q hq
    simp only [round, Multiset.insert_eq_cons, Multiset.mem_cons,
      Multiset.mem_singleton] at hq
    rcases hq with rfl | rfl <;> simp [Packet.hops, adaPacket, bobPacket]
  omega

/-- **Both letters arrive**: four courier rounds are enough for the longest
bang path, and the bag of delivered moves is exactly the bag that was posted. -/
theorem round_delivered :
    ((Wire.steps round 4).inbox.map Delivery.payload) = {adaMove, bobMove} := by
  rw [Wire.delivered_all round round_maxHops]
  simp [Wire.payloads, round, adaPacket, bobPacket]

/-! ### Order of delivery does not matter here -/

/-- Checked moves on different cells commute, so the courier may deliver the
night's mail in either order. -/
theorem applyChecked_comm {s : Patch.State} {a b : Patch.Move} (h : a.1 ≠ b.1) :
    Patch.game.applyChecked (Patch.game.applyChecked s a) b
      = Patch.game.applyChecked (Patch.game.applyChecked s b) a := by
  obtain ⟨ia, da⟩ := a
  obtain ⟨ib, db⟩ := b
  simp only [ne_eq] at h
  have key : ∀ (t : Patch.State) (m : Patch.Move),
      Patch.game.applyChecked t m = if Patch.legal t m then Patch.apply t m else t :=
    fun _ _ => rfl
  have hab : Patch.legal (Patch.apply s (ia, da)) (ib, db) = Patch.legal s (ib, db) := by
    simp [Patch.legal, Patch.apply, Function.update_of_ne (Ne.symm h)]
  have hba : Patch.legal (Patch.apply s (ib, db)) (ia, da) = Patch.legal s (ia, da) := by
    simp [Patch.legal, Patch.apply, Function.update_of_ne h]
  have hupd : Patch.apply (Patch.apply s (ia, da)) (ib, db)
      = Patch.apply (Patch.apply s (ib, db)) (ia, da) := by
    simp only [Patch.apply]
    exact Function.update_comm h _ _ _
  cases hA : Patch.legal s (ia, da) <;> cases hB : Patch.legal s (ib, db) <;>
    simp [key, hA, hB, hab, hba, hupd]

/-- The night's mail, processed in the order it happened to arrive. -/
theorem round_result :
    ∀ i, Patch.game.runMail board [adaMove, bobMove] i = ![false, false, true, true] i := by
  decide

/-- The other order gives the same patch. -/
theorem round_order_irrelevant :
    Patch.game.runMail board [adaMove, bobMove]
      = Patch.game.runMail board [bobMove, adaMove] := by
  simp only [SealedGame.runMail_cons, SealedGame.runMail_nil]
  exact applyChecked_comm (by decide)

/-- **No cheating in this round**: the closing position is one that legal play
could have produced — Bob's illegal dig simply did not happen. -/
theorem round_reach : Patch.game.Reach board (Patch.game.runMail board [adaMove, bobMove]) :=
  Patch.game.reach_runMail board [adaMove, bobMove]

end Session
end Sneakernet
end LifeTrac
