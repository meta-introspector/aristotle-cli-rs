import RequestProject.Nix.NixWars.Shards

/-!
# The Monster Crown, and winning by j-invariant navigation

In the shards world the j-invariant navigation of NixWars is not a cheat code:
it is unlocked by finding the Monster Crown, which lives on shard 47. This file
connects the shard theory to the game.

* `crownUnlock` is the unlock as the board performs it: it works on the crown
  shard and nowhere else (`crownUnlock_on_crown`, `crownUnlock_elsewhere`);
* `crown_quest` says the crown is always reachable — from any home shard, at
  most seven Chord hops away;
* `jnav_progress`: an unlocked j-nav strictly closes the gap to Sgr A*;
* `jnav_free`: inside the last thousand light-years j-nav costs no fuel at all;
* `crown_endgame`: from anywhere inside that last thousand light-years, an
  unlocked ship reaches Sgr A* — within the ten light-years the game asks for —
  on j-nav alone, without burning a drop of fuel.
-/

namespace NixWars

/-! ## The unlock -/

/-- Unlocking j-invariant navigation by finding the Monster Crown. It only
happens on shard 47. -/
def crownUnlock (s : GameSession nixWars) : GameSession nixWars :=
  if s.shard = crownShard then { s with state := { s.state with unlocked := true } } else s

/-- On the crown shard, the crown unlocks j-nav. -/
theorem crownUnlock_on_crown (s : GameSession nixWars) (h : s.shard = crownShard) :
    (crownUnlock s).state.unlocked = true := by simp [crownUnlock, h]

/-- Anywhere else, nothing happens. -/
theorem crownUnlock_elsewhere (s : GameSession nixWars) (h : s.shard ≠ crownShard) :
    crownUnlock s = s := by simp [crownUnlock, h]

/-- Finding the crown twice is finding it once. -/
theorem crownUnlock_idempotent (s : GameSession nixWars) :
    crownUnlock (crownUnlock s) = crownUnlock s := by
  by_cases h : s.shard = crownShard <;> simp [crownUnlock, h]

/-- **The crown is always reachable**: from any home shard, the Monster Crown is
at most seven Chord hops away. -/
theorem crown_quest (home : Nat) (h : home < numShards) :
    ∃ route : List Nat, route.length ≤ 7 ∧ chordPath home route = crownShard :=
  ⟨chordRoute home crownShard, length_chordRoute_le _ _,
    chordPath_chordRoute home h crownShard crownShard_lt⟩

/-! ## Navigating by the j-invariant -/

/-- Inside the last thousand light-years a j-nav hop is free. -/
theorem jnav_free (s : Ship) (h : s.dist < 1000) : warpCost (s.dist / 10) = 0 := by
  unfold warpCost
  omega

/-- What a j-nav does inside that range: closes a tenth of the gap, turns the
clock, and costs nothing. -/
theorem jnav_step (s : Ship) (hu : s.unlocked = true) (h : s.dist < 1000) :
    shipStep s .jnav =
      { s with dist := s.dist - s.dist / 10, turn := s.turn + 1 } := by
  simp [shipStep, hu, warpShip, jnav_free s h]

/-- **j-nav makes progress**: while the galactic centre is more than ten
light-years away, an affordable j-nav strictly closes the gap. -/
theorem jnav_progress (s : Ship) (hu : s.unlocked = true) (hd : 10 ≤ s.dist)
    (hf : warpCost (s.dist / 10) ≤ s.fuel) :
    (shipStep s .jnav).dist < s.dist := by
  have hpos : 0 < s.dist / 10 := Nat.div_pos hd (by norm_num)
  simp only [shipStep, hu, if_pos, warpShip, if_pos hf]
  omega

/-- The unlock survives a j-nav. -/
theorem jnav_unlocked (s : Ship) (hu : s.unlocked = true) :
    (shipStep s .jnav).unlocked = true := by
  simp only [shipStep, hu, if_pos, warpShip]
  split_ifs <;> simp [hu]

/-- Fuel is untouched inside the last thousand light-years. -/
theorem jnav_fuel (s : Ship) (hu : s.unlocked = true) (h : s.dist < 1000) :
    (shipStep s .jnav).fuel = s.fuel := by rw [jnav_step s hu h]

/-- The endgame, by induction on the budget of hops. -/
theorem jnav_endgame_aux : ∀ (n : Nat) (s : Ship), s.unlocked = true → s.dist < 1000 →
    s.dist ≤ n + 9 →
    (nixWars.run s (List.replicate n .jnav)).dist < 10 ∧
      (nixWars.run s (List.replicate n .jnav)).fuel = s.fuel := by
  intro n
  induction n with
  | zero => intro s _ _ hb; simpa using by omega
  | succ n ih =>
      intro s hu hlt hb
      have hstep : nixWars.run s (List.replicate (n + 1) ShipCmd.jnav)
          = nixWars.run (shipStep s .jnav) (List.replicate n ShipCmd.jnav) := by
        rw [List.replicate_succ]; rfl
      have hs := jnav_step s hu hlt
      have hu' : (shipStep s .jnav).unlocked = true := jnav_unlocked s hu
      have hd' : (shipStep s .jnav).dist = s.dist - s.dist / 10 := by rw [hs]
      have hf' : (shipStep s .jnav).fuel = s.fuel := jnav_fuel s hu hlt
      rw [hstep]
      rcases lt_or_ge s.dist 10 with hsmall | hbig
      · have hdist : (shipStep s .jnav).dist < 10 := by
          rw [hd']; omega
        refine ⟨lt_of_le_of_lt ?_ hdist, ?_⟩
        · exact run_dist_le _ _
        · rw [ih (shipStep s .jnav) hu' (by omega) (by omega) |>.2, hf']
      · have hpos : 0 < s.dist / 10 := Nat.div_pos hbig (by norm_num)
        obtain ⟨h1, h2⟩ := ih (shipStep s .jnav) hu' (by omega) (by omega)
        exact ⟨h1, by rw [h2, hf']⟩

/-- **The crown wins the game.** From anywhere inside the last thousand
light-years, an unlocked ship reaches Sgr A* — the ten light-years the game
counts as arrival — on j-nav alone, and lands with exactly the fuel it set out
with. -/
theorem crown_endgame (s : Ship) (hu : s.unlocked = true) (h : s.dist < 1000) :
    (nixWars.run s (List.replicate 991 .jnav)).dist < 10 ∧
      (nixWars.run s (List.replicate 991 .jnav)).fuel = s.fuel :=
  jnav_endgame_aux 991 s hu h (by omega)

end NixWars
