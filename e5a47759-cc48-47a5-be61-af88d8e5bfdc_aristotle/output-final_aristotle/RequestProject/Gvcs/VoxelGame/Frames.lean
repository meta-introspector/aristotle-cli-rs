import RequestProject.Gvcs.VoxelGame.Draw
import RequestProject.Gvcs.Tycoon

/-!
# The verified playthrough, seen as voxels

`RequestProject/Tycoon.lean` proves a concrete game: a homesteader orders the
bill of materials, welds the tractor together, fills the tank and puts twenty
hectares into wheat, ending with 18 449 in cash, 40 litres in the tank and a
LifeTrac in the shed.  That proof is about rational numbers.  This file turns
the same playthrough into a sequence of *worlds*.

* `frames` — the states a script passes through, the scan of `run`.  It has one
  more entry than the script has moves (`frames_length`), it starts where the
  player started (`frames_head`), it ends where `run` ends (`frames_getLast`),
  and every state along the way is legal (`frames_legal`).
* `worlds` — the same sequence, drawn: one voxel scene per move.
* `finalState`, and the counted view of it: the cash column is 184 voxels tall,
  the fuel gauge 8, the field 160 crop voxels, and the shed holds a LifeTrac.
  Those are theorems about `World.tally` — about *counting voxels in the
  picture* — not about the rationals the game engine keeps.
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Build

/-! ## The states a script passes through -/

/-- The states a script passes through, from the opening position onwards: the
scan of `run`.  A move the market refuses ends the sequence. -/
def frames (mk : Market) (s : GameState) : List Action → List GameState
  | [] => [s]
  | a :: l =>
      s :: (match step mk s a with
            | some t => frames mk t l
            | none => [])

theorem frames_nil (mk : Market) (s : GameState) : frames mk s [] = [s] := rfl

theorem frames_cons_some {mk : Market} {s t : GameState} {a : Action} (l : List Action)
    (h : step mk s a = some t) : frames mk s (a :: l) = s :: frames mk t l := by
  simp [frames, h]

theorem frames_cons_none {mk : Market} {s : GameState} {a : Action} (l : List Action)
    (h : step mk s a = none) : frames mk s (a :: l) = [s] := by
  simp [frames, h]

theorem frames_ne_nil (mk : Market) (s : GameState) (l : List Action) :
    frames mk s l ≠ [] := by
  cases l with
  | nil => simp [frames]
  | cons a l =>
      cases h : step mk s a with
      | none => simp [frames_cons_none l h]
      | some t => simp [frames_cons_some l h]

/-- The sequence starts where the player started. -/
theorem frames_head (mk : Market) (s : GameState) (l : List Action) :
    (frames mk s l).head? = some s := by
  cases l with
  | nil => rfl
  | cons a l =>
      cases h : step mk s a with
      | none => simp [frames_cons_none l h]
      | some t => simp [frames_cons_some l h]

/-- A script the market allows all the way through gives one frame per move,
plus the opening position. -/
theorem frames_length {mk : Market} :
    ∀ {l : List Action} {s t : GameState}, run mk s l = some t →
      (frames mk s l).length = l.length + 1
  | [], _, _, _ => rfl
  | a :: l, s, t, h => by
      rw [run_cons] at h
      cases hs : step mk s a with
      | none => rw [hs] at h; simp at h
      | some u =>
          rw [hs, Option.bind_some] at h
          rw [frames_cons_some l hs, List.length_cons, List.length_cons,
            frames_length (t := t) h]

/-- The sequence ends where `run` ends. -/
theorem frames_getLast {mk : Market} :
    ∀ {l : List Action} {s t : GameState}, run mk s l = some t →
      (frames mk s l).getLast? = some t
  | [], s, t, h => by
      rw [run_nil] at h
      cases h
      rfl
  | a :: l, s, t, h => by
      rw [run_cons] at h
      cases hs : step mk s a with
      | none => rw [hs] at h; simp at h
      | some u =>
          rw [hs, Option.bind_some] at h
          rw [frames_cons_some l hs]
          obtain ⟨b, L, hL⟩ : ∃ b L, frames mk u l = b :: L := by
            cases hf : frames mk u l with
            | nil => exact absurd hf (frames_ne_nil mk u l)
            | cons b L => exact ⟨b, L, rfl⟩
          rw [hL, List.getLast?_cons_cons, ← hL]
          exact frames_getLast h

/-- No move can leave the player with negative cash, stock or fuel, so no frame
of a playthrough that started legally is illegal. -/
theorem frames_legal {mk : Market} :
    ∀ {l : List Action} {s : GameState}, s.Legal → ∀ u ∈ frames mk s l, u.Legal
  | [], s, hs, u, hu => by
      rw [frames_nil] at hu
      rw [List.mem_singleton.1 hu]
      exact hs
  | a :: l, s, hs, u, hu => by
      cases hst : step mk s a with
      | none =>
          rw [frames_cons_none l hst, List.mem_singleton] at hu
          rw [hu]; exact hs
      | some t =>
          rw [frames_cons_some l hst, List.mem_cons] at hu
          rcases hu with hu | hu
          · rw [hu]; exact hs
          · exact frames_legal (Build.step_legal hs hst) u hu

/-! ## The playthrough, drawn -/

/-- Every frame of a script as a voxel scene, with the machine parked. -/
def worlds (mk : Market) (s : GameState) (l : List Action) : List World :=
  (frames mk s l).map (fun u => scene u nominal)

theorem worlds_length {mk : Market} {s t : GameState} {l : List Action}
    (h : run mk s l = some t) : (worlds mk s l).length = l.length + 1 := by
  rw [worlds, List.length_map, frames_length h]

/-- The frames of the verified playthrough of `RequestProject/Tycoon.lean`. -/
def campaignFrames : List GameState := frames homestead start firstSeason

/-- The verified playthrough as a sequence of voxel worlds: five scenes, the
opening position and one for each move. -/
def campaignWorlds : List World := worlds homestead start firstSeason

theorem campaignFrames_length : campaignFrames.length = 5 := by
  obtain ⟨t, ht, _⟩ := run_firstSeason
  rw [campaignFrames, frames_length ht]
  rfl

theorem campaignWorlds_length : campaignWorlds.length = 5 := by
  rw [campaignWorlds, worlds, List.length_map]
  exact campaignFrames_length

theorem campaignFrames_head : campaignFrames.head? = some start :=
  frames_head _ _ _

/-- Every position the campaign passes through is legal. -/
theorem campaignFrames_legal : ∀ u ∈ campaignFrames, u.Legal :=
  frames_legal start_legal

/-! ## The last frame, counted -/

/-- Where the verified playthrough ends. -/
def finalState : GameState := (run homestead start firstSeason).getD start

theorem run_firstSeason_final : run homestead start firstSeason = some finalState := by
  obtain ⟨t, ht, _⟩ := run_firstSeason
  rw [finalState, ht]
  rfl

theorem finalState_cash : finalState.cash = 18449 := by
  obtain ⟨t, ht, h, _⟩ := run_firstSeason
  rw [finalState, ht]
  exact h

theorem finalState_fuel : finalState.fuel = 40 := by
  obtain ⟨t, ht, _, _, h, _⟩ := run_firstSeason
  rw [finalState, ht]
  exact h

theorem finalState_hectares : finalState.hectares = 20 := by
  obtain ⟨t, ht, _, _, _, _, h, _⟩ := run_firstSeason
  rw [finalState, ht]
  exact h

theorem finalState_hasMachine : finalState.hasMachine "LifeTrac" = true := by
  obtain ⟨t, ht, _, _, _, _, _, h, _⟩ := run_firstSeason
  rw [finalState, ht]
  exact h

theorem campaignFrames_getLast : campaignFrames.getLast? = some finalState :=
  frames_getLast run_firstSeason_final

/-- The last frame is the last state, drawn. -/
theorem campaignWorlds_getLast : campaignWorlds.getLast? = some (scene finalState nominal) := by
  have h := campaignFrames_getLast
  rw [campaignFrames] at h
  rw [campaignWorlds, worlds, List.getLast?_map, h]
  rfl

/-- The cash column of the last frame is 184 voxels tall. -/
theorem finalState_cashHeight : gaugeHeight cashPerVoxel finalState.cash = 184 := by
  rw [finalState_cash, gaugeHeight, cashPerVoxel]
  norm_num

/-- The fuel gauge of the last frame is 8 voxels tall. -/
theorem finalState_fuelHeight : gaugeHeight fuelPerVoxel finalState.fuel = 8 := by
  rw [finalState_fuel, gaugeHeight, fuelPerVoxel]
  norm_num

/-- The field of the last frame is twenty rows wide. -/
theorem finalState_cropRows : cropRows finalState.hectares = 20 := by
  rw [finalState_hectares, cropRows]
  norm_num

/-- **The last frame of the campaign, counted in the picture.**  A window that
takes in the cash column, the fuel gauge and the field holds exactly 184 coin
voxels, 8 fuel voxels and 160 crop voxels — and somewhere in the scene there is
a shed voxel that reads `LifeTrac`.  Nothing here is read off the game state:
these are counts of voxels in the world the player looks at. -/
theorem campaign_final_view {W : Finset Vox} {c : Config} (hc : c.Valid)
    (hcash : columnWindow cashFoot 184 ⊆ W)
    (hfuel : columnWindow fuelFoot 8 ⊆ W)
    (hcrop : Finset.Icc ((0, fieldY, 0) : Vox) (cropCorner 20) ⊆ W) :
    World.tally W (scene finalState c) .coin = 184 ∧
      World.tally W (scene finalState c) .fuel = 8 ∧
      World.tally W (scene finalState c) (.crop 1) = 160 ∧
      ∃ v, scene finalState c v = .shed "LifeTrac" := by
  refine ⟨?_, ?_, ?_, (scene_shed_iff hc "LifeTrac").1 finalState_hasMachine⟩
  · rw [tally_scene_cash hc (by rwa [finalState_cashHeight]), finalState_cashHeight]
  · rw [tally_scene_fuel hc (by rwa [finalState_fuelHeight]), finalState_fuelHeight]
  · rw [tally_scene_crop hc (by rwa [finalState_hectares]), finalState_cropRows]

end VoxelGame
end LifeTrac
