import RequestProject.Nix.NixWars.WellClock
import RequestProject.Nix.NixWars.Autopilots

/-!
# The experiment: one AI, seven clocks, and the difference it records

`BlackHole.lean` hangs seven cabinets at radii `72 … 143` above a horizon of
`71` shards and gives them periods `72, 36, 24, 11, 3, 2, 1` ticks per step.
`WellClock.lean` says what kind of clock the room needs and how a difference
in speed can be detected at all. This file actually *runs the games*.

The pilot is the project's own autopilot — `invadersAuto` from
`Autopilots.lean`, which clears a fresh Shard Invaders cabinet in nine
commands and provably cannot do it in eight — and the same policy flies the
same cartridge at all seven depths. The room clock runs for one frame, `792`
ticks, and the log is read off at the end.

**What the AI records.**

* Every cabinet is cleared, and the winning screen is *identical* at all seven
  depths (`ai_final_screen_invariant`): the AI plays exactly the same nine
  moves whatever the dilation, because the policy only ever looks at the
  screen.
* The wall-clock time it takes is not: the clearing tick is `9·p`
  (`clear_tick_eq`), so the seven cabinets are cleared at
  `648, 324, 216, 99, 27, 18, 9` ticks (`clearTicks_eq`), all inside one room
  frame (`clearTicks_within_frame`), and the deeper the cabinet the later it
  finishes (`clear_tick_antitone`). The reading is sharp: one tick earlier the
  cabinet is not cleared (`ai_not_cleared_before`).
* On a game that never ends — Monster Dash, where `dashAuto` provably never
  loses a life — the difference shows up as score. In one frame the seven
  cabinets score `7, 13, 20, 43, 159, 238, 475` (`dash_scores_eq`) with all
  three lives intact everywhere (`dash_lives_intact`), and score is monotone
  in the number of steps taken (`dash_score_mono`), so the ranking is the
  ranking of depths and nothing else.

**So what does the experiment prove?** That the whole difference lives in the
clock. Fix the number of the AI's *own* steps and every cabinet shows the same
thing (`ai_record_invariance`); fix the room clock instead and they fan out by
a factor of seventy-two. That is the effect the video shows.
-/

set_option maxRecDepth 100000

namespace NixWars

namespace BlackHole

open NixWars.Controls

/-! ## The rig -/

/-- How many steps the AI at radius `r` has taken by tick `t` of the room
clock. -/
def aiSteps (r t : Nat) : Nat := steps (sgrA.period 1 r) t

/-- The Shard Invaders cabinet at radius `r`, as it stands at tick `t` of the
room clock, with the autopilot at the controls. -/
def invadersAt (r t : Nat) : Invaders :=
  autoRun shardInvaders invadersAuto initialInvaders (aiSteps r t)

/-- The Monster Dash cabinet at radius `r` at tick `t`. -/
def dashAt (r t : Nat) : Dash :=
  autoRun monsterDash dashAuto initialDash (aiSteps r t)

/-- The tick of the room clock at which the AI at radius `r` finishes clearing
the sky. -/
def clearTick (r : Nat) : Nat := 9 * sgrA.period 1 r

/-! ## The AI plays the same game at every depth -/

/-- **Same steps, same screen.** Two cabinets that have taken the same number
of their own steps are showing the same frame, however different the ticks at
which they got there. -/
theorem ai_record_invariance {r₁ t₁ r₂ t₂ : Nat} (h : aiSteps r₁ t₁ = aiSteps r₂ t₂) :
    invadersAt r₁ t₁ = invadersAt r₂ t₂ := by
  show autoRun shardInvaders invadersAuto initialInvaders (aiSteps r₁ t₁)
      = autoRun shardInvaders invadersAuto initialInvaders (aiSteps r₂ t₂)
  rw [h]

/-- The clearing tick is nine of the cabinet's own steps. -/
theorem clear_tick_eq (r : Nat) : clearTick r = 9 * sgrA.period 1 r := rfl

/-- At its clearing tick the AI has taken exactly nine steps. -/
theorem aiSteps_clearTick {r : Nat} (h : sgrA.rs < r) : aiSteps r (clearTick r) = 9 := by
  have hp : 0 < sgrA.period 1 r := sgrA.period_pos Nat.one_pos h
  exact Nat.mul_div_cancel 9 hp

/-- One tick earlier it has taken only eight. -/
theorem aiSteps_before_clearTick {r : Nat} (h : sgrA.rs < r) :
    aiSteps r (clearTick r - 1) = 8 := by
  have hp : 0 < sgrA.period 1 r := sgrA.period_pos Nat.one_pos h
  have key : ∀ p : Nat, 0 < p → (9 * p - 1) / p = 8 := fun p hp =>
    Nat.div_eq_of_lt_le (by omega) (by omega)
  exact key _ hp

/-- **The AI wins at every depth.** -/
theorem ai_clears {r : Nat} (h : sgrA.rs < r) : InvadersCleared (invadersAt r (clearTick r)) := by
  show InvadersCleared
    (autoRun shardInvaders invadersAuto initialInvaders (aiSteps r (clearTick r)))
  rw [aiSteps_clearTick h]
  exact invadersAuto_clears

/-- **And not one tick sooner.** The clearing tick is exactly the tick at
which the sky empties, so the log entry is a sharp measurement. -/
theorem ai_not_cleared_before {r : Nat} (h : sgrA.rs < r) :
    ¬ InvadersCleared (invadersAt r (clearTick r - 1)) := by
  show ¬ InvadersCleared
    (autoRun shardInvaders invadersAuto initialInvaders (aiSteps r (clearTick r - 1)))
  rw [aiSteps_before_clearTick h]
  show invadersAlive (autoRun shardInvaders invadersAuto initialInvaders 8) ≠ 0
  decide

/-- **The winning screen is the same everywhere.** Two cabinets at any two
depths finish on identical frames; only the tick at which they get there
differs. -/
theorem ai_final_screen_invariant {r₁ r₂ : Nat} (h₁ : sgrA.rs < r₁) (h₂ : sgrA.rs < r₂) :
    invadersAt r₁ (clearTick r₁) = invadersAt r₂ (clearTick r₂) :=
  ai_record_invariance (by rw [aiSteps_clearTick h₁, aiSteps_clearTick h₂])

/-- **Deeper takes longer.** -/
theorem clear_tick_antitone {r₁ r₂ : Nat} (h₁ : sgrA.rs < r₁) (h₂ : r₁ ≤ r₂) :
    clearTick r₂ ≤ clearTick r₁ :=
  Nat.mul_le_mul_left 9 (sgrA.period_antitone h₁ h₂)

/-! ## The log of one room frame -/

/-- The seven clearing ticks, in the order the cabinets hang. -/
def clearTicks : List Nat := depths.map clearTick

theorem clearTicks_eq : clearTicks = [648, 324, 216, 99, 27, 18, 9] := by decide

/-- Every cabinet is cleared inside one room frame. -/
theorem clearTicks_within_frame : ∀ t ∈ clearTicks, t ≤ frame sunkPeriods := by decide

/-- Seven different finishing times: the depths are told apart by the clock
alone. -/
theorem clearTicks_nodup : clearTicks.Nodup := by decide

/-- The deepest cabinet takes seventy-two times as long as the shallowest to
play the identical nine moves. -/
theorem clear_tick_spread : clearTick 72 = 72 * clearTick 143 := by decide

/-- The log the AI writes at the frame boundary: radius, period, steps taken,
clearing tick, and the Monster Dash score. -/
def frameLog : List (Nat × Nat × Nat × Nat × Nat) :=
  depths.map (fun r =>
    (r, sgrA.period 1 r, aiSteps r 792, clearTick r, (dashAt r 792).score))

theorem frameLog_eq :
    frameLog =
      [(72, 72, 11, 648, 7), (73, 36, 22, 324, 13), (74, 24, 33, 216, 20),
       (78, 11, 72, 99, 43), (100, 3, 264, 27, 159), (142, 2, 396, 18, 238),
       (143, 1, 792, 9, 475)] := by
  decide

/-! ## The endless game: score as the recorded difference -/

/-- A command never costs score. -/
theorem dashStep_score_ge (s : Dash) (c : DashCmd) : s.score ≤ (dashStep s c).score := by
  cases c
  · exact Nat.le_refl _
  · exact Nat.le_refl _
  · simp only [dashStep]
    split_ifs
    · exact Nat.le_refl _
    · exact Nat.le_refl _
    · exact Nat.le_succ _

/-- Running the autopilot on never loses score either. -/
theorem dashAuto_score_ge (s : Dash) (m : Nat) :
    s.score ≤ (autoRun monsterDash dashAuto s m).score := by
  induction m generalizing s with
  | zero => exact Nat.le_refl _
  | succ m ih =>
    rw [autoRun_succ]
    exact le_trans (dashStep_score_ge s (dashAuto s)) (ih (monsterDash.step s (dashAuto s)))

/-- Monster Dash never ends, so the difference between the depths shows up as
score: the autopilot's score never falls as it is given more steps. -/
theorem dash_score_mono (s : Dash) (m n : Nat) :
    (autoRun monsterDash dashAuto s n).score ≤ (autoRun monsterDash dashAuto s (n + m)).score := by
  rw [autoRun_add]
  exact dashAuto_score_ge _ m

/-- **Deeper scores less.** By the frame boundary, the cabinet nearer the hole
has scored no more than the one further out — playing the identical policy on
the identical cartridge. -/
theorem dash_score_antitone {r₁ r₂ t : Nat} (h₁ : sgrA.rs < r₁) (h₂ : r₁ ≤ r₂) :
    (dashAt r₁ t).score ≤ (dashAt r₂ t).score := by
  have hle : aiSteps r₁ t ≤ aiSteps r₂ t :=
    deeper_is_slower sgrA Nat.one_pos h₁ h₂
  obtain ⟨m, hm⟩ : ∃ m, aiSteps r₂ t = aiSteps r₁ t + m := ⟨aiSteps r₂ t - aiSteps r₁ t, by omega⟩
  show (autoRun monsterDash dashAuto initialDash (aiSteps r₁ t)).score
      ≤ (autoRun monsterDash dashAuto initialDash (aiSteps r₂ t)).score
  rw [hm]
  exact dash_score_mono initialDash m (aiSteps r₁ t)

/-- The scores in the log, read off at the frame boundary. -/
theorem dash_scores_eq :
    depths.map (fun r => (dashAt r 792).score) = [7, 13, 20, 43, 159, 238, 475] := by
  decide

/-- **And nobody died.** The whole spread of scores is the clock, not the
play: the autopilot finishes the frame with all three lives at every depth. -/
theorem dash_lives_intact (r t : Nat) : (dashAt r t).lives = 3 :=
  dashAuto_no_deaths (aiSteps r t)

end BlackHole

end NixWars
