import RequestProject.Nix.NixWars.Nested.Space
import RequestProject.Nix.NixWars.Nested.Arcade

/-!
# A worked nest: the arcade inside the arcade

Three worlds, one inside the other.  Level `0` is the world you stand in, with
two callers and a market of twenty shards.  Standing in cabinet `2` of its floor
is a whole miniature world of its own, level `1`, with its own market; standing
in cabinet `7` of *that* floor is a third, level `2`.

The session played here is the one the page replays: the player walks into the
cabinet, buys four shards **in the miniature world's own database** at the
prices its clock quotes (47, 59, 71, 47), walks into the cabinet inside that
world and buys one there too, and then cashes four of the little world's shards
out into one shard of the world outside.  Every number below is computed by the
kernel from the definitions, not asserted.
-/

set_option maxRecDepth 8000

namespace NixWars

namespace Nested

namespace Demo

open Scene3D

/-! ## The three worlds -/

/-- The world you stand in. -/
def world0 : Db :=
  { accounts := [⟨1, 200, 3⟩, ⟨2, 150, 5⟩], float := 20, house := 5000, clock := 0,
    journal := [] }

/-- The miniature world inside cabinet 2. -/
def world1 : Db :=
  { accounts := [⟨1, 300, 0⟩], float := 8, house := 4000, clock := 0, journal := [] }

/-- The miniature world inside cabinet 7 of the miniature world. -/
def world2 : Db :=
  { accounts := [⟨1, 60, 0⟩], float := 4, house := 3000, clock := 0, journal := [] }

/-- The nest: three worlds, each inside a cabinet of the one before. -/
def nest : Tower := ⟨[⟨world0, 0⟩, ⟨world1, 2⟩, ⟨world2, 7⟩]⟩

theorem nest_wf : TowerWF nest := by
  intro l hl
  simp only [nest, List.mem_cons, List.not_mem_nil, or_false] at hl
  rcases hl with rfl | rfl | rfl <;> simp [WF, world0, world1, world2]

theorem nest_depth : nest.depth = 3 := rfl

/-- Every world of the nest stands in a cabinet of the one above it. -/
theorem nest_slots : ∀ j, slotAt nest j < arena := by
  intro j
  match j with
  | 0 => decide
  | 1 => decide
  | 2 => decide
  | (n + 3) =>
      have hlen : nest.levels.length = 3 := rfl
      have h : nest.levels[n + 3]? = none := List.getElem?_eq_none (by omega)
      simp [slotAt, h, arena]

/-- **The miniature world stands in the arcade's trading cabinet**: the world
inside the game is inside the very cabinet the trading game is played at. -/
theorem demo_mini_in_the_trading_cabinet : slotAt nest 1 = marketCabinet := rfl

/-! ## The session -/

/-- Four buys at the cabinet inside cabinet 2. -/
def session : List MarketCmd := [.buy, .buy, .buy, .buy]

/-- The nest after the session in the miniature world. -/
def afterPlay : Tower :=
  (session.map (txOf 1)).foldl (fun t tx => playAt t 1 tx) nest

/-- And after one buy in the world inside *that* one. -/
def afterDeep : Tower := playAt afterPlay 2 (txOf 1 .buy)

/-- And after cashing four of the little world's shards out into one shard of
the world outside. -/
def afterCash : Tower := cashOut afterDeep 0 1 1

/-- **The session really traded in the miniature world's database**: four
shards bought, paid for at the prices its own clock quoted. -/
theorem demo_inner_account : findAcct (world1) 1 = some ⟨1, 300, 0⟩ ∧
    (dbAt afterPlay 1).bind (fun db => findAcct db 1) = some ⟨1, 76, 4⟩ := by decide

/-- Its journal has one line per settled trade, at the prices the clock
quoted. -/
theorem demo_journal :
    (dbAt afterPlay 1).map (·.journal) =
      some [⟨1, 0, 47, 0⟩, ⟨1, 0, 59, 1⟩, ⟨1, 0, 71, 2⟩, ⟨1, 0, 47, 3⟩] := by decide

/-- **Playing in the world inside the cabinet did not touch the world
outside.** -/
theorem demo_outer_untouched : dbAt afterPlay 0 = dbAt nest 0 := by decide

/-- Nor did the game inside the game touch the world that holds it. -/
theorem demo_middle_untouched : dbAt afterDeep 1 = dbAt afterPlay 1 := by decide

/-- The deepest world traded too. -/
theorem demo_deep_account :
    (dbAt afterDeep 2).bind (fun db => findAcct db 1) = some ⟨1, 13, 1⟩ := by decide

/-! ## Cashing out -/

theorem demo_can_cash : canCash afterDeep 0 1 1 = true := by decide

/-- Four shards in the little world buy one shard in the big one, off its own
shelf. -/
theorem demo_cash :
    heldAt afterCash 0 1 = 4 ∧ heldAt afterCash 1 1 = 0 ∧
      (dbAt afterCash 0).map (·.float) = some 19 ∧
      (dbAt afterCash 1).map (·.float) = some 8 := by decide

/-- **And the player is worth exactly what they were worth before**: 65, in the
innermost world's unit, on both sides of the counter. -/
theorem demo_worth :
    playerWorth nest 1 = 48 ∧ playerWorth afterDeep 1 = 65 ∧ playerWorth afterCash 1 = 65 := by
  decide

/-! ## The nest on the screen -/

/-- Where the three worlds stand in the picture: the whole nest is 256 fine
units across, the miniature world starts a third of the way along the floor of
the big one, and the world inside that starts inside *its* cabinet 7. -/
theorem demo_origins :
    unit nest 0 = 16 ∧ unit nest 1 = 4 ∧ unit nest 2 = 1 ∧
      originX nest 1 = 128 ∧ originZ nest 1 = 0 ∧
      originX nest 2 = 176 ∧ originZ nest 2 = 16 := by decide

theorem demo_voxels : (nestVoxels nest).length = 36 ∧ (nestVoxels afterCash).length = 37 := by
  decide

theorem afterCash_slots : ∀ j, slotAt afterCash j < arena := by
  intro j
  match j with
  | 0 => decide
  | 1 => decide
  | 2 => decide
  | (n + 3) =>
      have hlen : afterCash.levels.length = 3 := by decide
      have h : afterCash.levels[n + 3]? = none := List.getElem?_eq_none (by omega)
      simp [slotAt, h, arena]

/-- **The whole worked nest is one picture**: every cube of all three worlds
stands inside the outermost world's box. -/
theorem demo_in_picture : ∀ v ∈ nestVoxels afterCash, InBox afterCash 0 v :=
  nestVoxels_in_picture afterCash afterCash_slots

end Demo

end Nested

end NixWars
