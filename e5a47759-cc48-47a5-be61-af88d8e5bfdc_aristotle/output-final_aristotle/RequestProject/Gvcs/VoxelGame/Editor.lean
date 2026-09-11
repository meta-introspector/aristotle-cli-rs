import RequestProject.Gvcs.VoxelGame.Frames

/-!
# The brick editor, and a session you can actually draw

`Play.lean` describes a session with a `Net.Design` — a *finite set* of bricks —
because that is what the replicated editor of `RequestProject/Net/Design.lean`
converges to.  A finite set is not something a program can walk, so this file
gives the same worlds over a *list* of bricks, and proves the two agree as soon
as the list holds the design's bricks and the design is legal
(`brickListWorld_eq_brickWorld`).  That is what lets `lake exe game` draw a
creative-mode session with the picture still being the object the theorems are
about.

It also contains a worked creative-mode example — a three-brick bucket tooth
built on the baseplate — and a worked session: a few digs, a puddle, the tooth,
and the machine driven forward with the loader up.  Both are proved legal.
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Build

/-! ## Bricks a program can walk -/

/-- The bricks of a list, as voxels: the first brick of the list that covers a
voxel gives it its colour. -/
def brickListWorld (l : List Net.Brick) : World := fun v =>
  match l.find? (fun b => b.solid v) with
  | some b => .brick b.part
  | none => .air

/-- In a legal design at most one brick covers a voxel. -/
theorem brick_unique {d : Net.Design} (hd : Net.Design.Valid d) {b c : Net.Brick}
    (hb : b ∈ d) (hc : c ∈ d) {v : Vox} (hbv : b.solid v = true) (hcv : c.solid v = true) :
    b = c := by
  by_contra hbc
  rcases hd b hb c hc hbc v with h | h
  · rw [hbv] at h; exact Bool.noConfusion h
  · rw [hcv] at h; exact Bool.noConfusion h

/-- **A list of the design's bricks draws the design.**  The picture a program
builds by walking a list is the world the specification gives the finite set —
so nothing is lost in going from the replicated editor to the renderer. -/
theorem brickListWorld_eq_brickWorld {l : List Net.Brick} {d : Net.Design}
    (hd : Net.Design.Valid d) (hmem : ∀ b, b ∈ l ↔ b ∈ d) :
    brickListWorld l = brickWorld d := by
  funext v
  cases hl : l.find? (fun b => b.solid v) with
  | none =>
      have : d.toList.find? (fun b => b.solid v) = none := by
        refine List.find?_eq_none.2 (fun c hc => ?_)
        have hcl : c ∈ l := (hmem c).2 (Finset.mem_toList.1 hc)
        simpa using List.find?_eq_none.1 hl c hcl
      simp [brickListWorld, brickWorld, hl, this]
  | some b =>
      have hbl : b ∈ l := List.mem_of_find?_eq_some hl
      have hbv : b.solid v = true := by simpa using List.find?_some hl
      have hbd : b ∈ d := (hmem b).1 hbl
      cases hf : d.toList.find? (fun c => c.solid v) with
      | none =>
          have := List.find?_eq_none.1 hf b (Finset.mem_toList.2 hbd)
          simp only at this
          exact absurd hbv this
      | some c =>
          have hcd : c ∈ d := Finset.mem_toList.1 (List.mem_of_find?_eq_some hf)
          have hcv : c.solid v = true := by simpa using List.find?_some hf
          have : b = c := brick_unique hd hbd hcd hbv hcv
          simp [brickListWorld, brickWorld, hl, hf, this]

/-! ## The world of a session -/

/-- The world of a session, over whatever world the placed bricks make. -/
def sessionWorldWith (s : GameState) (ground bricks : World) (c : Config) : World :=
  World.stack [machineWorld c, yard yardY s.stock, shed s.built, fuelGauge s.fuel,
    cashStack s.cash, cropField s.hectares, bricks, ground]

theorem sessionWorld_eq_with (s : GameState) (S : Site) :
    sessionWorld s S = sessionWorldWith s S.ground (brickWorld S.design) S.cfg := rfl

/-- The world of a session, over a list of bricks: what a program can draw. -/
def sessionWorldOf (s : GameState) (ground : World) (l : List Net.Brick) (c : Config) : World :=
  sessionWorldWith s ground (brickListWorld l) c

/-- **What is drawn is what was specified.** -/
theorem sessionWorldOf_eq_sessionWorld {l : List Net.Brick} (s : GameState) (S : Site)
    (hS : S.Legal) (hmem : ∀ b, b ∈ l ↔ b ∈ S.design) :
    sessionWorldOf s S.ground l S.cfg = sessionWorld s S := by
  rw [sessionWorldOf, brickListWorld_eq_brickWorld hS.1 hmem, sessionWorld_eq_with]

/-! ## A creative-mode design -/

/-- The root of a bucket tooth: a plate on the baseplate. -/
def toothRoot : Net.Brick := ⟨60, 0, 0, 6, 4, 2, 0⟩
/-- The shank of the tooth, resting on the root. -/
def toothShank : Net.Brick := ⟨61, 1, 2, 4, 2, 2, 1⟩
/-- The point of the tooth, resting on the shank. -/
def toothPoint : Net.Brick := ⟨62, 1, 4, 2, 2, 3, 2⟩

/-- A bucket tooth, designed out of three bricks. -/
def toothDesign : Net.Design :=
  insert toothPoint (insert toothShank (insert toothRoot (∅ : Net.Design)))

/-- The tooth does not interpenetrate itself, so the editor would have accepted
it brick by brick. -/
theorem toothDesign_valid : Net.Design.Valid toothDesign :=
  Net.Design.valid_insert
    (Net.Design.valid_insert
      (Net.Design.valid_insert Net.Design.valid_empty (by decide))
      (by decide))
    (by decide)

/-- The tooth obeys the plastic-brick rule: the root is on the baseplate, the
shank rests on the root and the point rests on the shank. -/
theorem toothDesign_grounded : Net.Design.Grounded toothDesign :=
  Net.Design.grounded_insert
    (Net.Design.grounded_insert
      (Net.Design.grounded_insert Net.Design.grounded_empty (Or.inl rfl))
      (Or.inr ⟨toothRoot, by decide, by decide⟩))
    (Or.inr ⟨toothShank, by decide, by decide⟩)

/-! ## A worked session -/

/-- Untouched ground, no bricks, the machine parked. -/
def fresh : Site := ⟨terrain, ∅, nominal⟩

theorem fresh_legal : fresh.Legal := ⟨Net.Design.valid_empty, nominal_valid⟩

/-- A list of moves, played one after another, keeps the site legal. -/
theorem foldl_apply_legal :
    ∀ (l : List SiteAction) {S : Site}, S.Legal → (l.foldl Site.apply S).Legal
  | [], _, hS => hS
  | _ :: l, _, hS => foldl_apply_legal l (apply_legal hS _)

/-- A session: dig a pond, fill one of the holes with water, build the tooth,
drive four voxels forward and raise the loader. -/
def demoMoves : List SiteAction :=
  [ .dig (2, 0, -1), .dig (3, 0, -1), .dig (4, 0, -1)
  , .fill (3, 0, -1) .water
  , .place toothRoot, .place toothShank, .place toothPoint
  , .drive 4, .lift liftMax ]

/-- The site those moves leave behind. -/
def demoSite : Site := demoMoves.foldl Site.apply fresh

theorem demoSite_legal : demoSite.Legal := foldl_apply_legal demoMoves fresh_legal

/-- Every brick of the demo was accepted: the session ends holding the tooth. -/
theorem demoSite_design : demoSite.design = toothDesign := by decide

/-- The machine ended four voxels forward with the loader all the way up. -/
theorem demoSite_cfg : demoSite.cfg = ⟨liftMax, 4⟩ := rfl

/-- The bricks of the demo, as a list. -/
def demoBricks : List Net.Brick := [toothPoint, toothShank, toothRoot]

theorem mem_demoBricks (b : Net.Brick) : b ∈ demoBricks ↔ b ∈ demoSite.design := by
  rw [demoSite_design]
  constructor
  · intro h
    rcases List.mem_cons.1 h with rfl | h
    · simp [toothDesign]
    · rcases List.mem_cons.1 h with rfl | h
      · simp [toothDesign]
      · rcases List.mem_singleton.1 h with rfl
        simp [toothDesign]
  · intro h
    simp only [toothDesign, Finset.mem_insert, Finset.notMem_empty, or_false] at h
    rcases h with rfl | rfl | rfl <;> simp [demoBricks]

/-- The session world of the demo, drawn with the campaign's closing accounts:
the machine, the yard, the shed, the gauges, the field, the player's bricks and
the ground they have dug. -/
def demoWorld : World :=
  sessionWorldOf finalState demoSite.ground demoBricks demoSite.cfg

/-- The picture the emitter draws is the session world of the specification. -/
theorem demoWorld_eq : demoWorld = sessionWorld finalState demoSite :=
  sessionWorldOf_eq_sessionWorld finalState demoSite demoSite_legal mem_demoBricks

end VoxelGame
end LifeTrac
