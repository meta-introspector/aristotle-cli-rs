import RequestProject.Gvcs.VoxelGame.Scene
import RequestProject.Gvcs.Net.Design

/-!
# Playing in the voxel world

`RequestProject/VoxelGame/Scene.lean` turns a game *state* into a world of
voxels.  This file adds the things a player actually does in that world, and
the elements the build plan (`GAMEPLAN.md`) asks for:

* **the modes** — campaign, sandbox, creative and co-op (`Mode`), and what each
  of them lets a player do (`Mode.allows`);
* **the site** — the ground the players have dug and built, the bricks they
  have placed and where the machine is standing (`Site`);
* **the moves in the world** — dig a voxel, fill one in, place or take away a
  creative-mode brick, drive the machine, work the loader (`SiteAction`), with
  a rule book (`Site.step`) that returns `none` for a move that is not allowed,
  exactly as `Build.step` does for the economy;
* **what the moves do to the world** — digging removes exactly one voxel
  (`dig_removes_one`), filling puts exactly one back (`fill_adds_one`), filling
  a voxel back the way it was undoes a dig (`fill_undoes_dig`), digs in two
  different places commute (`dig_comm`), driving translates the machine
  district and nothing else (`machineWorld_travel`);
* **co-op** — a site is a replicated state machine over `Net.Log`, so two
  players who have seen the same moves see the same world
  (`site_converges`), whatever order the moves arrived in, and a design can
  never be corrupted by replay (`replay_design_valid`);
* **the economy, seen from the world** — buying raises a pile
  (`buy_raises_pile`) and touches no other (`buy_leaves_other_piles`), selling
  lowers one (`sell_lowers_pile`), refuelling raises the gauge
  (`refuel_raises_gauge`), a season lowers it and extends the field
  (`farm_lowers_gauge`, `farm_extends_field`), and fabricating puts a new
  column in the shed (`fabricate_fills_shed`).
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Voxel.Solid
open Build

/-! ## Modes -/

/-- The four ways to play. -/
inductive Mode where
  /-- Buy, build, drive, farm, pay it back. -/
  | campaign : Mode
  /-- The machine and the ground, no economy. -/
  | sandbox : Mode
  /-- The brick editor. -/
  | creative : Mode
  /-- Several players in one world. -/
  | coop : Mode
deriving DecidableEq, Repr, Inhabited

/-! ## The site -/

/-- What the players have made of the world: the ground as they have dug and
built it, the bricks they have placed, and where the machine is standing. -/
structure Site where
  /-- The ground, as dug and built. -/
  ground : World
  /-- The bricks placed in creative mode. -/
  design : Net.Design
  /-- The machine's controls and position. -/
  cfg : Config

/-- A site is legal when its design does not interpenetrate itself and the
loader is within its travel. -/
def Site.Legal (S : Site) : Prop := Net.Design.Valid S.design ∧ S.cfg.Valid

/-- A move in the world. -/
inductive SiteAction where
  /-- Take the voxel at `p` away. -/
  | dig (p : Vox) : SiteAction
  /-- Put a voxel of `c` at `p`. -/
  | fill (p : Vox) (c : Cell) : SiteAction
  /-- Place a creative-mode brick. -/
  | place (b : Net.Brick) : SiteAction
  /-- Take a creative-mode brick away. -/
  | remove (b : Net.Brick) : SiteAction
  /-- Drive the machine `d` voxels along `x`. -/
  | drive (d : ℤ) : SiteAction
  /-- Command the loader to lift `l`. -/
  | lift (l : ℤ) : SiteAction
deriving DecidableEq, Repr

instance (b : Net.Brick) : Decidable b.Proper := by unfold Net.Brick.Proper; infer_instance

/-- The rule book of the world: `none` exactly when the move is not allowed —
you cannot dig air, you cannot build where there is already something, you
cannot place a brick that clashes with one already there, and you cannot
command the loader past its stops. -/
def Site.step (S : Site) : SiteAction → Option Site
  | .dig p => if S.ground p = .air then none else some { S with ground := S.ground.set p .air }
  | .fill p c =>
      if c = .air ∨ S.ground p ≠ .air then none
      else some { S with ground := S.ground.set p c }
  | .place b =>
      if Net.Design.Fits S.design b ∧ b.Proper then some { S with design := insert b S.design }
      else none
  | .remove b => some { S with design := S.design.erase b }
  | .drive d => some { S with cfg := ⟨S.cfg.lift, S.cfg.travel + d⟩ }
  | .lift l => if 0 ≤ l ∧ l ≤ liftMax then some { S with cfg := ⟨l, S.cfg.travel⟩ } else none

/-- What a mode lets a player do: bricks are the creative mode's business, and
the campaign is played with the machine, not with a magic wand. -/
def Mode.allows : Mode → SiteAction → Bool
  | .campaign, .place _ => false
  | .campaign, .remove _ => false
  | _, _ => true

theorem creative_allows (a : SiteAction) : Mode.creative.allows a = true := by
  cases a <;> rfl

theorem campaign_forbids_bricks (b : Net.Brick) :
    Mode.campaign.allows (.place b) = false ∧ Mode.campaign.allows (.remove b) = false :=
  ⟨rfl, rfl⟩

/-- Playing a move in a mode. -/
def Site.stepIn (m : Mode) (S : Site) (a : SiteAction) : Option Site :=
  if m.allows a then S.step a else none

/-- A mode can only forbid moves, never invent them. -/
theorem stepIn_eq_step {m : Mode} {S T : Site} {a : SiteAction} (h : S.stepIn m a = some T) :
    S.step a = some T := by
  unfold Site.stepIn at h
  split at h
  · exact h
  · exact absurd h (by simp)

/-! ## What the moves do -/

theorem step_dig {S : Site} {p : Vox} (h : S.ground p ≠ .air) :
    S.step (.dig p) = some { S with ground := S.ground.set p .air } := by
  simp [Site.step, h]

theorem step_dig_none {S : Site} {p : Vox} (h : S.ground p = .air) :
    S.step (.dig p) = none := by simp [Site.step, h]

theorem step_fill {S : Site} {p : Vox} {c : Cell} (hc : c ≠ .air) (h : S.ground p = .air) :
    S.step (.fill p c) = some { S with ground := S.ground.set p c } := by
  simp [Site.step, hc, h]

/-- **Digging takes exactly one voxel out of the world.** -/
theorem dig_removes_one {W : Finset Vox} {S T : Site} {p : Vox} (hp : p ∈ W)
    (h : S.step (.dig p) = some T) :
    Solid.count W (World.solid T.ground) + 1 = Solid.count W (World.solid S.ground) := by
  by_cases hg : S.ground p = .air
  · rw [step_dig_none hg] at h; exact absurd h (by simp)
  · rw [step_dig hg] at h
    cases h
    exact World.count_solid_set_air hp hg

/-- **Filling puts exactly one back.** -/
theorem fill_adds_one {W : Finset Vox} {S T : Site} {p : Vox} {c : Cell} (hp : p ∈ W)
    (hc : c ≠ .air) (hg : S.ground p = .air) (h : S.step (.fill p c) = some T) :
    Solid.count W (World.solid T.ground) = Solid.count W (World.solid S.ground) + 1 := by
  rw [step_fill hc hg] at h
  cases h
  exact World.count_solid_set_cell hp hg hc

/-- **Putting a voxel back the way it was undoes a dig.** -/
theorem fill_undoes_dig (S : Site) (p : Vox) :
    (S.ground.set p .air).set p (S.ground p) = S.ground := by
  rw [World.set_set, World.set_get]

/-- **Digs in two different places commute**, so two players may dig at once
without agreeing on an order. -/
theorem dig_comm {S : Site} {p q : Vox} (h : p ≠ q) :
    ((S.step (.dig p)).bind (fun T => T.step (.dig q))) =
      ((S.step (.dig q)).bind (fun T => T.step (.dig p))) := by
  by_cases hp : S.ground p = .air <;> by_cases hq : S.ground q = .air
  · simp [Site.step, hp, hq]
  · simp [Site.step, hp, hq, World.set, h]
  · simp [Site.step, hp, hq, World.set, Ne.symm h]
  · rw [step_dig hp, step_dig hq]
    simp only [Option.bind_some]
    rw [step_dig (by simpa [World.set, Ne.symm h] using hq),
      step_dig (by simpa [World.set, h] using hp)]
    simp only [Option.some.injEq]
    exact congrArg (fun g => ({ S with ground := g } : Site)) (World.set_comm h _ _ _)

/-- A move of the world keeps the site legal: a brick can never be placed so as
to interpenetrate another, and the loader can never be commanded past its
stops. -/
theorem step_legal {S T : Site} {a : SiteAction} (hS : S.Legal) (h : S.step a = some T) :
    T.Legal := by
  obtain ⟨hd, hc⟩ := hS
  cases a with
  | dig p =>
      by_cases hg : S.ground p = .air
      · rw [step_dig_none hg] at h; exact absurd h (by simp)
      · rw [step_dig hg] at h; cases h; exact ⟨hd, hc⟩
  | fill p c =>
      by_cases hg : c = .air ∨ S.ground p ≠ .air
      · simp only [Site.step, if_pos hg] at h; exact absurd h (by simp)
      · push_neg at hg
        rw [step_fill hg.1 hg.2] at h; cases h; exact ⟨hd, hc⟩
  | place b =>
      by_cases hb : Net.Design.Fits S.design b ∧ b.Proper
      · simp only [Site.step, if_pos hb] at h
        cases h
        exact ⟨Net.Design.valid_insert hd hb.1, hc⟩
      · simp only [Site.step, if_neg hb] at h; exact absurd h (by simp)
  | remove b =>
      simp only [Site.step] at h; cases h
      exact ⟨hd.erase b, hc⟩
  | drive d =>
      simp only [Site.step] at h; cases h
      exact ⟨hd, hc⟩
  | lift l =>
      by_cases hl : 0 ≤ l ∧ l ≤ liftMax
      · simp only [Site.step, if_pos hl] at h; cases h
        exact ⟨hd, hl⟩
      · simp only [Site.step, if_neg hl] at h; exact absurd h (by simp)

/-! ## The world of a session -/

/-- The bricks of a design, as voxels. -/
noncomputable def brickWorld (d : Net.Design) : World := fun v =>
  match d.toList.find? (fun b => b.solid v) with
  | some b => .brick b.part
  | none => .air

@[simp] theorem brickWorld_empty : brickWorld ∅ = World.empty := by
  funext v; simp [brickWorld, World.empty]

/-- The bricks fill exactly the region the design says they do. -/
theorem solid_brickWorld (d : Net.Design) : World.solid (brickWorld d) = Net.Design.solid d := by
  funext v
  simp only [World.solid_apply, Net.Design.solid]
  cases hf : d.toList.find? (fun b => b.solid v) with
  | none =>
      have : ¬ ∃ b ∈ d, b.solid v = true := by
        rintro ⟨b, hb, hbv⟩
        have := List.find?_eq_none.1 hf b (Finset.mem_toList.2 hb)
        simp only at this
        exact this hbv
      simp [brickWorld, hf, this]
  | some b =>
      have hb : b ∈ d := Finset.mem_toList.1 (List.mem_of_find?_eq_some hf)
      have hbv : b.solid v = true := by simpa using List.find?_some hf
      have hex : ∃ b ∈ d, b.solid v = true := ⟨b, hb, hbv⟩
      simp [brickWorld, hf, hex]

/-- **The world a player sees**: the machine, the yard, the shed, the gauges
and the field of `Scene.lean`, then the bricks, then the ground. -/
noncomputable def sessionWorld (s : GameState) (S : Site) : World :=
  World.stack [machineWorld S.cfg, yard yardY s.stock, shed s.built, fuelGauge s.fuel,
    cashStack s.cash, cropField s.hectares, brickWorld S.design, S.ground]

/-- **On untouched ground, with no bricks placed, the session is the campaign
scene**: `Play` extends `Scene` rather than replacing it. -/
theorem sessionWorld_eq_scene (s : GameState) (c : Config) :
    sessionWorld s ⟨terrain, ∅, c⟩ = scene s c := by
  simp [sessionWorld, scene, World.stack]

/-! ## Driving translates the view -/

/-- **Driving the machine translates its district and nothing else.**  This is
the voxel form of `machine_travel`. -/
theorem machineWorld_travel (lift t : ℤ) (v : Vox) :
    machineWorld ⟨lift, t⟩ v = machineWorld ⟨lift, 0⟩ (v - (t, 0, 0)) := by
  simp only [machineWorld]
  have hb : ∀ b : Body, (b.at ⟨lift, t⟩ v) = (b.at ⟨lift, 0⟩ (v - (t, 0, 0))) := by
    intro b
    rw [Body.at_travel b lift t]
    rfl
  have : (fun b : Body => b.at ⟨lift, t⟩ v) = (fun b : Body => b.at ⟨lift, 0⟩ (v - (t, 0, 0))) := by
    funext b; exact hb b
  rw [this]

/-! ## Co-op: a site is a replicated state machine -/

/-- A move that is not allowed is ignored, so that any stream of moves from any
peer can be replayed. -/
def Site.apply (S : Site) (a : SiteAction) : Site := (S.step a).getD S

theorem apply_legal {S : Site} (hS : S.Legal) (a : SiteAction) : (S.apply a).Legal := by
  unfold Site.apply
  cases h : S.step a with
  | none => simpa using hS
  | some T => simpa using step_legal hS h

/-- Replaying a log of world moves. -/
noncomputable def replaySite (S₀ : Site) (L : Net.Log SiteAction) : Site :=
  Net.replay Site.apply S₀ L

/-- **Two players who have seen the same moves see the same world.**  Nothing
else is needed: no locks, no ticks, no server. -/
theorem site_converges (S₀ : Site) {L M : Net.Log SiteAction}
    (h : ∀ o : Net.Op SiteAction, o ∈ L ↔ o ∈ M) : replaySite S₀ L = replaySite S₀ M :=
  Net.eventual_consistency Site.apply S₀ h

theorem foldl_legal (l : List (Net.Op SiteAction)) {S : Site} (hS : S.Legal) :
    (l.foldl (fun S o => Site.apply S o.payload) S).Legal := by
  induction l generalizing S with
  | nil => exact hS
  | cons o l ih => exact ih (apply_legal hS o.payload)

/-- **However the moves arrive, the world stays legal**: no replay of any log
can make two bricks interpenetrate or drive the loader past its stops. -/
theorem replay_legal {S₀ : Site} (hS : S₀.Legal) (L : Net.Log SiteAction) :
    (replaySite S₀ L).Legal :=
  foldl_legal _ hS

/-! ## The economy, seen from the world -/

/-- Buying material raises its pile. -/
theorem buy_raises_pile {mk : Market} {s t : GameState} {m : Material} {q : ℚ}
    (h : step mk s (.buy m q) = some t) :
    pileHeight s.stock m ≤ pileHeight t.stock m := by
  by_cases hg : 0 ≤ q ∧ q * Material.unitCost m ≤ s.cash
  · rw [step_buy hg.1 hg.2] at h
    cases h
    refine pileHeight_mono ?_
    have hval : (s.stock.add (Inventory.single m q)) m = s.stock m + q := by
      simp [Inventory.add, Inventory.single]
    simp only
    rw [hval]
    linarith [hg.1]
  · simp [step, hg] at h

/-- …and leaves every other pile exactly as it was. -/
theorem buy_leaves_other_piles {mk : Market} {s t : GameState} {m m' : Material} {q : ℚ}
    (hm : m' ≠ m) (h : step mk s (.buy m q) = some t) :
    pileHeight t.stock m' = pileHeight s.stock m' := by
  by_cases hg : 0 ≤ q ∧ q * Material.unitCost m ≤ s.cash
  · rw [step_buy hg.1 hg.2] at h
    cases h
    simp [pileHeight, Inventory.add, Inventory.single, hm]
  · simp [step, hg] at h

/-- Selling material back lowers its pile. -/
theorem sell_lowers_pile {mk : Market} {s t : GameState} {m : Material} {q : ℚ}
    (hq : 0 ≤ q) (h : step mk s (.sell m q) = some t) :
    pileHeight t.stock m ≤ pileHeight s.stock m := by
  by_cases hg : 0 ≤ q ∧ q ≤ s.stock m
  · rw [step_sell hg.1 hg.2] at h
    cases h
    refine pileHeight_mono ?_
    have hval : (s.stock.sub (Inventory.single m q)) m = s.stock m - q := by
      simp [Inventory.sub, Inventory.single]
    simp only
    rw [hval]
    linarith
  · simp [step, hg] at h

/-- Refuelling raises the fuel gauge. -/
theorem refuel_raises_gauge {mk : Market} {s t : GameState} {l : ℚ}
    (h : step mk s (.refuel l) = some t) :
    gaugeHeight fuelPerVoxel s.fuel ≤ gaugeHeight fuelPerVoxel t.fuel := by
  by_cases hg : 0 ≤ l ∧ mk.fuelPrice * l ≤ s.cash
  · rw [step_refuel hg.1 hg.2] at h
    cases h
    exact gaugeHeight_mono fuelPerVoxel_pos (by simpa using hg.1)
  · simp [step, hg] at h

/-- A season of work lowers it. -/
theorem farm_lowers_gauge {mk : Market} {s t : GameState} {nm : String} {c : Crop} {area : ℚ}
    (hm : s.hasMachine nm = true) (ha : 0 ≤ area) (hf : seasonFuel c area ≤ s.fuel)
    (hcash : area * c.seedCostPerHa ≤ s.cash) (h : step mk s (.farm nm c area) = some t) :
    gaugeHeight fuelPerVoxel t.fuel ≤ gaugeHeight fuelPerVoxel s.fuel := by
  rw [step_farm hm ha hf hcash] at h
  cases h
  refine gaugeHeight_mono fuelPerVoxel_pos ?_
  have : 0 ≤ seasonFuel c area := seasonFuel_nonneg c ha
  simp only
  linarith

/-- …and extends the field. -/
theorem farm_extends_field {mk : Market} {s t : GameState} {nm : String} {c : Crop} {area : ℚ}
    (hm : s.hasMachine nm = true) (ha : 0 ≤ area) (hf : seasonFuel c area ≤ s.fuel)
    (hcash : area * c.seedCostPerHa ≤ s.cash) (h : step mk s (.farm nm c area) = some t) :
    cropRows s.hectares ≤ cropRows t.hectares := by
  rw [step_farm hm ha hf hcash] at h
  cases h
  exact Nat.floor_mono (by simp only; linarith)

/-- Fabricating a subassembly puts a new column in the shed, with its name
on it. -/
theorem fabricate_fills_shed {mk : Market} {s t : GameState} {a : Assembly} {cfg : Config}
    (hcfg : cfg.Valid) (hw : a.WellFormed = true)
    (hs : Inventory.Covers s.stock a.requirements)
    (hc : mk.laborRate * a.laborHours ≤ s.cash) (h : step mk s (.fabricate a) = some t) :
    ∃ v, scene t cfg v = .shed a.name :=
  (scene_shed_iff hcfg a.name).1 (built_fabricate hw hs hc h)

end VoxelGame
end LifeTrac
