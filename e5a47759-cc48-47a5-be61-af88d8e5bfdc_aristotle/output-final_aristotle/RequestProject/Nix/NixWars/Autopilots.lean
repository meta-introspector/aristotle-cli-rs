import RequestProject.Nix.NixWars.Controls
import RequestProject.Nix.NixWars.Board

/-!
# Autopilots for the cabinets, and how short a winning run can be

`Controls.lean` flies two autopilots: the ship's and Monster Cubes'. This file
adds the ones the other cabinets need, so that an agent standing in front of a
cabinet has a policy to follow rather than a memorised tape:

* `invadersAuto` — Shard Invaders: fire when an invader is overhead, otherwise
  walk towards the leftmost one still in the sky. It clears the rank in nine
  commands (`invadersAuto_clears`) without letting the rank drop a single row
  (`invadersAuto_no_drop`), and the plan it flies is exactly the hand-played
  clearing run (`invadersAutoPlan_eq_clearingRun`).
* `dashAuto` — Shard Dash: sidestep when the obstacle is in this lane, run
  otherwise. It never loses a life (`dashAuto_no_deaths`).

The second half of the file answers a question the tape cannot: *is nine the
best you can do?* It is. Only a shot can kill (`invaders_kill_is_fire`), a shot
leaves the gun's column empty (`invaders_kill_clean`), so two kills can never be
adjacent in a plan; hence a plan that kills `k` invaders is at least `2k - 1`
commands long (`invaders_alive_le_run_add_half`), and clearing a fresh cabinet
therefore takes at least nine commands (`invaders_clearing_length_ge_nine`).
The nine-command run is optimal (`invaders_nine_is_optimal`).
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Controls

/-! ## Shard Invaders: the gun's autopilot -/

/-- The column of the leftmost invader still in the sky; if the rank is empty,
the gun's own column. -/
def invadersTarget (s : Invaders) : Nat :=
  if s.a0 = 1 then s.ox
  else if s.a1 = 1 then s.ox + 1
  else if s.a2 = 1 then s.ox + 2
  else if s.a3 = 1 then s.ox + 3
  else if s.a4 = 1 then s.ox + 4
  else s.px

/-- **The gun's autopilot.** Fire if the target is overhead, otherwise walk
towards it; with the sky empty, stand still and let the clock run. -/
def invadersAuto (s : Invaders) : InvadersCmd :=
  if invadersAlive s = 0 then InvadersCmd.tick
  else if s.px = invadersTarget s then InvadersCmd.fire
  else if s.px < invadersTarget s then InvadersCmd.right
  else InvadersCmd.left

/-- The plan the autopilot flies from a fresh cabinet. -/
def invadersAutoPlan : List InvadersCmd :=
  pilot shardInvaders invadersAuto initialInvaders 9

/-- **The autopilot rediscovers the hand-played clearing run**: fire, step
right, fire, and so on along the floor. -/
theorem invadersAutoPlan_eq_clearingRun : invadersAutoPlan = invadersClearingRun := by
  rfl

/-- Where the autopilot leaves the cabinet. -/
theorem invadersAuto_final :
    autoRun shardInvaders invadersAuto initialInvaders 9 =
      { px := 4, ox := 0, dir := 0, dy := 0, a0 := 0, a1 := 0, a2 := 0, a3 := 0, a4 := 0,
        turn := 9 } := by
  rfl

/-- **The autopilot clears the sky**, in nine commands. -/
theorem invadersAuto_clears :
    InvadersCleared (autoRun shardInvaders invadersAuto initialInvaders 9) := by
  rw [invadersAuto_final]; rfl

/-- **And it never lets the rank drop a row**: the autopilot never ticks while
an invader is still up, so the rank stays where it started. -/
theorem invadersAuto_no_drop :
    (autoRun shardInvaders invadersAuto initialInvaders 9 : Invaders).dy = 0 := by
  rw [invadersAuto_final]

/-- With the sky clear the autopilot holds its fire for ever: the rank is gone,
so nothing it does can bring one back. -/
theorem invadersAuto_holds (n : Nat) :
    InvadersCleared
      (autoRun shardInvaders invadersAuto
        (autoRun shardInvaders invadersAuto initialInvaders 9) n) := by
  have key : ∀ (m : Nat) (s : Invaders), invadersAlive s = 0 →
      invadersAlive (autoRun shardInvaders invadersAuto s m) = 0 := by
    intro m
    induction m with
    | zero => intro s hs; exact hs
    | succ m ih =>
      intro s hs
      refine ih _ ?_
      have hstep : shardInvaders.step s (invadersAuto s) = invadersStep s (invadersAuto s) := rfl
      rw [hstep]
      have hle := invadersStep_alive_le s (invadersAuto s)
      omega
  exact key n _ invadersAuto_clears

/-! ## Shard Dash: the runner's autopilot -/

/-- **The runner's autopilot.** If the obstacle is in this lane, sidestep;
otherwise run on. -/
def dashAuto (s : Dash) : DashCmd :=
  if s.lane = obstacleLane s.turn then (if s.lane = 0 then DashCmd.right else DashCmd.left)
  else DashCmd.tick

/-- The autopilot never runs into the obstacle, so a command of it never costs
a life. -/
theorem dashAuto_lives_step (s : Dash) : (dashStep s (dashAuto s)).lives = s.lives := by
  unfold dashAuto
  split_ifs with h h0 <;>
    first
      | rfl
      | (simp only [dashStep]; split_ifs <;> simp_all)

/-- **The runner never dies.** However long the autopilot runs, all three lives
are still there. -/
theorem dashAuto_no_deaths (n : Nat) :
    (autoRun monsterDash dashAuto initialDash n : Dash).lives = 3 := by
  have key : ∀ (m : Nat) (s : Dash), s.lives = 3 →
      (autoRun monsterDash dashAuto s m : Dash).lives = 3 := by
    intro m
    induction m with
    | zero => intro s hs; exact hs
    | succ m ih =>
      intro s hs
      refine ih _ ?_
      have hstep : monsterDash.step s (dashAuto s) = dashStep s (dashAuto s) := rfl
      rw [hstep, dashAuto_lives_step s]
      exact hs
  exact key n initialDash rfl

/-- Forty commands of autopilot score twenty-four: sixteen of them are
sidesteps, and every tick it does take scores. -/
theorem dashAuto_score :
    (autoRun monsterDash dashAuto initialDash 40 : Dash).score = 24 := by
  rfl

/-! ## How short a clearing run can be

Only a shot kills, and a shot leaves the gun's column empty; so no two
commands in a row can both kill, and a plan that kills five invaders is at
least nine commands long. -/

/-- The gun's column is empty: no invader still in the sky stands over it. -/
def InvadersClean (s : Invaders) : Prop :=
  (s.ox = s.px → s.a0 = 0) ∧ (s.ox + 1 = s.px → s.a1 = 0) ∧ (s.ox + 2 = s.px → s.a2 = 0) ∧
    (s.ox + 3 = s.px → s.a3 = 0) ∧ (s.ox + 4 = s.px → s.a4 = 0)

/-- **Only a shot kills.** Walking and the clock leave the rank alone. -/
theorem invaders_kill_is_fire (s : Invaders) (c : InvadersCmd)
    (h : invadersAlive (invadersStep s c) < invadersAlive s) : c = .fire := by
  cases c
  · exfalso
    simp only [invadersStep] at h
    split_ifs at h <;> simp [invadersAlive] at h
  · exfalso
    simp only [invadersStep] at h
    split_ifs at h <;> simp [invadersAlive] at h
  · rfl
  · exfalso
    simp only [invadersStep, invadersTick] at h
    split_ifs at h <;> simp [invadersAlive] at h

/-- **A shot empties the gun's column.** -/
theorem invadersFire_clean (s : Invaders) : InvadersClean (invadersFire s) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> intro hh
  · have hp : s.ox = s.px := hh
    show (if s.ox = s.px then 0 else s.a0) = 0
    exact if_pos hp
  · have hp : s.ox + 1 = s.px := hh
    show (if s.ox + 1 = s.px then 0 else s.a1) = 0
    exact if_pos hp
  · have hp : s.ox + 2 = s.px := hh
    show (if s.ox + 2 = s.px then 0 else s.a2) = 0
    exact if_pos hp
  · have hp : s.ox + 3 = s.px := hh
    show (if s.ox + 3 = s.px then 0 else s.a3) = 0
    exact if_pos hp
  · have hp : s.ox + 4 = s.px := hh
    show (if s.ox + 4 = s.px then 0 else s.a4) = 0
    exact if_pos hp

/-- **A shot at a live column empties it.** After a command that kills, no
invader stands over the gun. -/
theorem invaders_kill_clean (s : Invaders) (c : InvadersCmd)
    (h : invadersAlive (invadersStep s c) < invadersAlive s) :
    InvadersClean (invadersStep s c) := by
  have hc : c = InvadersCmd.fire := invaders_kill_is_fire s c h
  subst hc
  by_cases hy : s.dy = 5
  · exfalso; simp [invadersStep, hy] at h
  · have hstep : invadersStep s .fire = invadersFire s := by simp [invadersStep, hy]
    rw [hstep]
    exact invadersFire_clean s

/-- **A shot at an empty column changes nothing in the sky.** -/
theorem invaders_clean_no_kill (s : Invaders) (h : InvadersClean s) (c : InvadersCmd) :
    ¬ invadersAlive (invadersStep s c) < invadersAlive s := by
  intro hlt
  have hc : c = InvadersCmd.fire := invaders_kill_is_fire s c hlt
  subst hc
  obtain ⟨h0, h1, h2, h3, h4⟩ := h
  by_cases hy : s.dy = 5
  · simp [invadersStep, hy] at hlt
  · simp only [invadersStep, hy, invadersFire, invadersAlive, if_false] at hlt
    split_ifs at hlt <;> simp_all

/-- **One command kills at most one invader.** The invaders stand over distinct
columns, so a shot can take out only the one overhead. -/
theorem invaders_step_alive_ge (s : Invaders) (h : InvadersBinary s) (c : InvadersCmd) :
    invadersAlive s ≤ invadersAlive (invadersStep s c) + 1 := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := h
  cases c <;>
    simp only [invadersStep, invadersFire, invadersTick, invadersAlive] <;>
    split_ifs <;> simp_all <;> omega

/-- Anything that is not a kill leaves the rank exactly as it was. -/
theorem invaders_no_kill_alive (s : Invaders) (c : InvadersCmd)
    (h : ¬ invadersAlive (invadersStep s c) < invadersAlive s) :
    invadersAlive (invadersStep s c) = invadersAlive s := by
  have hle := invadersStep_alive_le s c
  omega

/-- **How much of the rank a plan can take down.** From a clean cabinet a plan
of `n` commands kills at most `n / 2` invaders; from any cabinet, at most
`(n + 1) / 2`. Two kills can never be adjacent, which is what the halves
record. -/
theorem invaders_alive_le_run_add_half (cs : List InvadersCmd) :
    (∀ s : Invaders, InvadersBinary s → InvadersClean s →
        invadersAlive s ≤ invadersAlive (shardInvaders.run s cs) + cs.length / 2) ∧
      (∀ s : Invaders, InvadersBinary s →
        invadersAlive s ≤ invadersAlive (shardInvaders.run s cs) + (cs.length + 1) / 2) := by
  induction cs with
  | nil => exact ⟨fun s _ _ => by simp [DoorGame.run], fun s _ => by simp [DoorGame.run]⟩
  | cons c cs ih =>
    obtain ⟨ih1, ih2⟩ := ih
    constructor
    · intro s hbin hclean
      have hnk : invadersAlive (invadersStep s c) = invadersAlive s :=
        invaders_no_kill_alive s c (invaders_clean_no_kill s hclean c)
      have hrest := ih2 (invadersStep s c) (invadersStep_binary s hbin c)
      have hrun : shardInvaders.run s (c :: cs) = shardInvaders.run (invadersStep s c) cs := rfl
      rw [hrun]
      simp only [List.length_cons]
      omega
    · intro s hbin
      have hrun : shardInvaders.run s (c :: cs) = shardInvaders.run (invadersStep s c) cs := rfl
      rw [hrun]
      have hdrop := invaders_step_alive_ge s hbin c
      by_cases hkill : invadersAlive (invadersStep s c) < invadersAlive s
      · have hclean := invaders_kill_clean s c hkill
        have hrest := ih1 (invadersStep s c) (invadersStep_binary s hbin c) hclean
        simp only [List.length_cons]
        omega
      · have hnk := invaders_no_kill_alive s c hkill
        have hrest := ih2 (invadersStep s c) (invadersStep_binary s hbin c)
        simp only [List.length_cons]
        omega

/-- **Clearing a fresh cabinet takes at least nine commands.** -/
theorem invaders_clearing_length_ge_nine (cs : List InvadersCmd)
    (h : InvadersCleared (shardInvaders.run initialInvaders cs)) : 9 ≤ cs.length := by
  have hbin : InvadersBinary initialInvaders :=
    ⟨Nat.le_refl 1, Nat.le_refl 1, Nat.le_refl 1, Nat.le_refl 1, Nat.le_refl 1⟩
  have key := (invaders_alive_le_run_add_half cs).2 initialInvaders hbin
  have h0 : invadersAlive (shardInvaders.run initialInvaders cs) = 0 := h
  have h5 : invadersAlive initialInvaders = 5 := rfl
  omega

/-- **The nine-command clearing run is optimal**: it clears the sky, and no
shorter plan can. -/
theorem invaders_nine_is_optimal :
    InvadersCleared (shardInvaders.run initialInvaders invadersClearingRun) ∧
      invadersClearingRun.length = 9 ∧
      ∀ cs : List InvadersCmd,
        InvadersCleared (shardInvaders.run initialInvaders cs) → 9 ≤ cs.length :=
  ⟨invaders_run_cleared, rfl, invaders_clearing_length_ge_nine⟩

end Controls
end NixWars
