import Mathlib

/-!
# Realm: the rules of the game

`Realm` is the strategy game of this repository: two peoples on an eight by
eight map, gathering wood and gold, raising farms and barracks, training
workers and soldiers and fighting over the ground — a small Civilization, or a
small Warcraft, with the pieces on tiles and the turns taken one after the
other.

Everything here is a *pure, decidable function*.  A `State` is the whole world;
a `Move` is one thing a player may do; `apply` is the only way the world ever
changes, and it returns `none` exactly when the move breaks a rule.  That is
what makes the rest of the development possible: a game is then nothing but a
list of moves, a page can carry that list, and anyone can replay it.

* `terrain` — the map, fixed once and for all, as sixty-four codes.
* `Piece`, `Bldg`, `Purse`, `State` — the world.
* `Move` — march, gather, build, train, strike, end the turn.
* `apply` — the rules; `Legal` — the moves the rules allow.
* `Wf` — the invariant of a sane world (pieces on passable tiles, alive, one to
  a tile; buildings on the board, one to a tile), and `wf_apply`, the theorem
  that no legal move can break it.
* `genesis` — the opening position, which `wf_genesis` shows is sane.
* `winner` — how a game ends.
-/

namespace LifeTrac
namespace Realm

/-! ## The map -/

/-- The width of the map, in tiles. -/
def boardW : Nat := 8

/-- The height of the map, in tiles. -/
def boardH : Nat := 8

/-- How many tiles there are.  A tile is named by its index `p < boardN`; its
column is `p % 8` and its row is `p / 8`. -/
def boardN : Nat := 64

/-- What is on a tile. -/
inductive Terrain
  /-- Open ground: a little gold, and the only place a building may stand. -/
  | plains
  /-- Woodland: wood. -/
  | forest
  /-- Hills: gold. -/
  | hills
  /-- Water: nothing may enter it. -/
  | water
  deriving DecidableEq, Repr, Inhabited

/-- The map, row by row from the top: `0` plains, `1` forest, `2` hills,
`3` water.  A lake in the middle, hills at the four corners of the shore, and
woods scattered over the open ground. -/
def terrainCodes : List Nat :=
  [1, 0, 0, 2, 2, 0, 0, 1,
   0, 0, 1, 0, 0, 1, 0, 0,
   0, 1, 0, 3, 3, 0, 1, 0,
   2, 0, 0, 3, 3, 0, 0, 2,
   2, 0, 0, 3, 3, 0, 0, 2,
   0, 1, 0, 3, 3, 0, 1, 0,
   0, 0, 1, 0, 0, 1, 0, 0,
   1, 0, 0, 2, 2, 0, 0, 1]

/-- A code as a terrain. -/
def terrainOfCode : Nat → Terrain
  | 0 => .plains
  | 1 => .forest
  | 2 => .hills
  | _ => .water

/-- What is on tile `p`. -/
def terrain (p : Nat) : Terrain := terrainOfCode (terrainCodes.getD p 3)

/-- A tile a piece may stand on: on the board, and not water. -/
def passable (p : Nat) : Bool := decide (p < boardN) && decide (terrain p ≠ .water)

/-- The tile one step from `p` in direction `d` (`0` north, `1` east, `2`
south, `3` west), if the step stays on the board. -/
def stepPos (p d : Nat) : Option Nat :=
  if p < boardN then
    match d with
    | 0 => if p / boardW = 0 then none else some (p - boardW)
    | 1 => if p % boardW = boardW - 1 then none else some (p + 1)
    | 2 => if p / boardW = boardH - 1 then none else some (p + boardW)
    | 3 => if p % boardW = 0 then none else some (p - 1)
    | _ => none
  else none

/-! ## The world -/

/-- The two peoples: `false` is the Ash Vale, `true` is the Iron Horde. -/
abbrev Side := Bool

/-- What a piece is. -/
inductive UKind
  /-- A worker: gathers, and raises buildings.  Weak in a fight. -/
  | worker
  /-- A soldier: strong in a fight, and cannot gather or build. -/
  | soldier
  deriving DecidableEq, Repr, Inhabited

/-- What a building is. -/
inductive BKind
  /-- A farm: one gold a turn, and trains workers. -/
  | farm
  /-- Barracks: trains soldiers. -/
  | barracks
  deriving DecidableEq, Repr, Inhabited

/-- A piece on the map. -/
structure Piece where
  /-- Whose piece it is. -/
  owner : Side
  /-- What it is. -/
  kind : UKind
  /-- The tile it stands on. -/
  pos : Nat
  /-- What is left of it. -/
  hp : Nat
  /-- Has it already done something this turn? -/
  acted : Bool
  deriving DecidableEq, Repr, Inhabited

/-- A building on the map. -/
structure Bldg where
  /-- Whose building it is. -/
  owner : Side
  /-- What it is. -/
  kind : BKind
  /-- The tile it stands on. -/
  pos : Nat
  deriving DecidableEq, Repr, Inhabited

/-- What a player holds. -/
structure Purse where
  /-- Gold. -/
  gold : Nat
  /-- Wood. -/
  wood : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The whole world. -/
structure State where
  /-- Whose turn it is. -/
  turn : Side
  /-- How many full rounds have been played. -/
  round : Nat
  /-- What the Ash Vale holds. -/
  p0 : Purse
  /-- What the Iron Horde holds. -/
  p1 : Purse
  /-- The pieces, in no particular order. -/
  pieces : List Piece
  /-- The buildings, in no particular order. -/
  bldgs : List Bldg
  deriving DecidableEq, Repr, Inhabited

/-! ## Prices and figures -/

/-- What a building costs. -/
def bldgCost : BKind → Purse
  | .farm => ⟨0, 3⟩
  | .barracks => ⟨2, 5⟩

/-- What a piece costs to train. -/
def unitCost : UKind → Purse
  | .worker => ⟨2, 0⟩
  | .soldier => ⟨3, 2⟩

/-- What a piece is trained in. -/
def trainer : UKind → BKind
  | .worker => .farm
  | .soldier => .barracks

/-- What a piece is worth when it is trained. -/
def unitHp : UKind → Nat
  | .worker => 5
  | .soldier => 10

/-- What a piece takes off another in a strike. -/
def unitDmg : UKind → Nat
  | .worker => 1
  | .soldier => 4

/-- What one turn of gathering a tile brings in. -/
def tileYield : Terrain → Purse
  | .plains => ⟨1, 0⟩
  | .forest => ⟨0, 2⟩
  | .hills => ⟨2, 0⟩
  | .water => ⟨0, 0⟩

/-- Can a purse pay a price? -/
def canPay (q c : Purse) : Bool := decide (c.gold ≤ q.gold) && decide (c.wood ≤ q.wood)

/-- A purse after paying. -/
def payFrom (q c : Purse) : Purse := ⟨q.gold - c.gold, q.wood - c.wood⟩

/-- A purse after being paid. -/
def addTo (q c : Purse) : Purse := ⟨q.gold + c.gold, q.wood + c.wood⟩

/-- What a side holds. -/
def purseOf (s : State) (b : Side) : Purse := if b then s.p1 else s.p0

/-- Hand the player to move some goods. -/
def credit (s : State) (c : Purse) : State :=
  if s.turn then { s with p1 := addTo s.p1 c } else { s with p0 := addTo s.p0 c }

/-- Take the price out of the purse of the player to move. -/
def spend (s : State) (c : Purse) : State :=
  if s.turn then { s with p1 := payFrom s.p1 c } else { s with p0 := payFrom s.p0 c }

/-! ## Looking at the map -/

/-- The piece on a tile, if any. -/
def pieceAt (s : State) (p : Nat) : Option Piece := s.pieces.find? (fun u => u.pos == p)

/-- The building on a tile, if any. -/
def bldgAt (s : State) (p : Nat) : Option Bldg := s.bldgs.find? (fun b => b.pos == p)

theorem pieceAt_some {s : State} {p : Nat} {u : Piece} (h : pieceAt s p = some u) :
    u ∈ s.pieces ∧ u.pos = p := by
  have h1 := List.mem_of_find?_eq_some h
  have h2 := List.find?_some h
  exact ⟨h1, by simpa using h2⟩

theorem pieceAt_none {s : State} {p : Nat} (h : pieceAt s p = none) :
    ∀ u ∈ s.pieces, u.pos ≠ p := by
  intro u hu hp
  have := List.find?_eq_none.mp h u hu
  simp [hp] at this


theorem bldgAt_some {s : State} {p : Nat} {b : Bldg} (h : bldgAt s p = some b) :
    b ∈ s.bldgs ∧ b.pos = p := by
  have h1 := List.mem_of_find?_eq_some h
  have h2 := List.find?_some h
  exact ⟨h1, by simpa using h2⟩

theorem bldgAt_none {s : State} {p : Nat} (h : bldgAt s p = none) :
    ∀ b ∈ s.bldgs, b.pos ≠ p := by
  intro b hb hp
  have := List.find?_eq_none.mp h b hb
  simp [hp] at this


/-! ## Moves -/

/-- One thing a player may do. -/
inductive Move
  /-- Walk the piece on a tile one step in a direction. -/
  | march (source dir : Nat)
  /-- Have the worker on a tile work it. -/
  | gather (tile : Nat)
  /-- Have the worker on a tile raise a building. -/
  | build (tile : Nat) (b : BKind)
  /-- Have the building on a tile train a piece. -/
  | train (tile : Nat) (u : UKind)
  /-- Have the piece on a tile strike the piece one step away. -/
  | strike (source dir : Nat)
  /-- Hand the turn over. -/
  | endTurn
  deriving DecidableEq, Repr, Inhabited

/-- The moves that can be written down: tiles on the board, directions of the
four.  `apply` rejects everything else anyway, but this is the range the move
codes of `RequestProject/Realm/Hash.lean` cover. -/
def Move.Ok : Move → Prop
  | .march p d => p < boardN ∧ d < 4
  | .gather p => p < boardN
  | .build p _ => p < boardN
  | .train p _ => p < boardN
  | .strike p d => p < boardN ∧ d < 4
  | .endTurn => True

instance (m : Move) : Decidable m.Ok := by
  cases m <;> unfold Move.Ok <;> infer_instance

/-- Mark the piece on a tile as having acted. -/
def markActed (l : List Piece) (p : Nat) : List Piece :=
  l.map (fun v => if v.pos = p then { v with acted := true } else v)

/-- Walk the piece on tile `p` to tile `q`, and mark it as having acted. -/
def walkTo (l : List Piece) (p q : Nat) : List Piece :=
  l.map (fun v => if v.pos = p then { v with pos := q, acted := true } else v)

/-- Take `dmg` off the piece on tile `q`, removing it if that finishes it. -/
def hurtAt (l : List Piece) (q dmg : Nat) : List Piece :=
  (l.map (fun w => if w.pos = q then { w with hp := w.hp - dmg } else w)).filter
    (fun w => decide (0 < w.hp))

/-- Every piece rested, for the start of a turn. -/
def restAll (l : List Piece) : List Piece := l.map (fun u => { u with acted := false })

/-- The rules.  `apply s m` is the world after the move, or `none` if the move
breaks a rule. -/
def apply (s : State) : Move → Option State
  | .march p d =>
    match pieceAt s p with
    | none => none
    | some u =>
      if u.owner ≠ s.turn ∨ u.acted then none else
      match stepPos p d with
      | none => none
      | some q =>
        if passable q = false then none else
        if (pieceAt s q).isSome then none else
        some { s with pieces := walkTo s.pieces p q }
  | .gather p =>
    match pieceAt s p with
    | none => none
    | some u =>
      if u.owner ≠ s.turn ∨ u.acted ∨ u.kind ≠ UKind.worker then none else
      some (credit { s with pieces := markActed s.pieces p } (tileYield (terrain p)))
  | .build p b =>
    match pieceAt s p with
    | none => none
    | some u =>
      if u.owner ≠ s.turn ∨ u.acted ∨ u.kind ≠ UKind.worker then none else
      if (bldgAt s p).isSome then none else
      if terrain p ≠ Terrain.plains then none else
      if canPay (purseOf s s.turn) (bldgCost b) = false then none else
      some (spend { s with pieces := markActed s.pieces p,
                           bldgs := ⟨s.turn, b, p⟩ :: s.bldgs } (bldgCost b))
  | .train p k =>
    match bldgAt s p with
    | none => none
    | some b =>
      if b.owner ≠ s.turn ∨ b.kind ≠ trainer k then none else
      if (pieceAt s p).isSome then none else
      if canPay (purseOf s s.turn) (unitCost k) = false then none else
      some (spend { s with pieces := ⟨s.turn, k, p, unitHp k, true⟩ :: s.pieces } (unitCost k))
  | .strike p d =>
    match pieceAt s p with
    | none => none
    | some u =>
      if u.owner ≠ s.turn ∨ u.acted then none else
      match stepPos p d with
      | none => none
      | some q =>
        match pieceAt s q with
        | none => none
        | some v =>
          if v.owner = s.turn then none else
          some { s with pieces := hurtAt (markActed s.pieces p) q (unitDmg u.kind) }
  | .endTurn =>
    let inc : Purse :=
      ⟨(s.bldgs.filter (fun b => b.owner == s.turn && b.kind == BKind.farm)).length, 0⟩
    let t := credit s inc
    some { t with turn := !s.turn,
                  round := if s.turn then s.round + 1 else s.round,
                  pieces := restAll t.pieces }

/-- A move the rules allow. -/
def Legal (s : State) (m : Move) : Bool := (apply s m).isSome

theorem legal_iff {s : State} {m : Move} : Legal s m = true ↔ ∃ s', apply s m = some s' := by
  unfold Legal; cases apply s m <;> simp

/-! ## The invariant -/

/-- A sane world: every piece stands on a passable tile and is alive, no two
pieces share a tile, every building is on the board, and no two buildings share
a tile. -/
def Wf (s : State) : Prop :=
  (∀ u ∈ s.pieces, passable u.pos = true ∧ 0 < u.hp) ∧
  (s.pieces.map (·.pos)).Nodup ∧
  (∀ b ∈ s.bldgs, terrain b.pos = Terrain.plains) ∧
  (s.bldgs.map (·.pos)).Nodup

/-! ## Small facts about the map -/

theorem terrain_water_of_ge {p : Nat} (h : boardN ≤ p) : terrain p = Terrain.water := by
  have h2 : terrainCodes.getD p 3 = 3 := by
    apply List.getD_eq_default
    simpa [terrainCodes, boardN] using h
  unfold terrain
  rw [h2]
  rfl

theorem lt_of_terrain_ne_water {p : Nat} (h : terrain p ≠ Terrain.water) : p < boardN := by
  by_contra hc
  exact h (terrain_water_of_ge (by omega))

theorem passable_iff {p : Nat} : passable p = true ↔ terrain p ≠ Terrain.water := by
  simp only [passable, Bool.and_eq_true, decide_eq_true_eq]
  exact ⟨fun h => h.2, fun h => ⟨lt_of_terrain_ne_water h, h⟩⟩

theorem passable_of_plains {p : Nat} (h : terrain p = Terrain.plains) : passable p = true :=
  passable_iff.mpr (by simp [h])

theorem lt_of_passable {p : Nat} (h : passable p = true) : p < boardN := by
  simp only [passable, Bool.and_eq_true, decide_eq_true_eq] at h; exact h.1

theorem stepPos_lt {p d q : Nat} (h : stepPos p d = some q) : q < boardN := by
  unfold stepPos at h
  split at h
  · rename_i hp
    match d with
    | 0 =>
      simp only at h; split at h
      · simp at h
      · simp only [Option.some.injEq] at h; omega
    | 1 =>
      simp only at h; split at h
      · simp at h
      · simp only [Option.some.injEq] at h
        subst h; simp only [boardN, boardW] at *; omega
    | 2 =>
      simp only at h; split at h
      · simp at h
      · simp only [Option.some.injEq] at h
        subst h; simp only [boardN, boardW, boardH] at *; omega
    | 3 =>
      simp only at h; split at h
      · simp at h
      · simp only [Option.some.injEq] at h; omega
    | (_ + 4) => simp at h
  · simp at h

/-! ## The invariant survives every legal move -/

theorem map_pos_markActed (l : List Piece) (p : Nat) :
    (markActed l p).map (·.pos) = l.map (·.pos) := by
  simp only [markActed, List.map_map]
  apply List.map_congr_left
  intro v _; by_cases h : v.pos = p <;> simp [Function.comp, h]

theorem map_pos_restAll (l : List Piece) : (restAll l).map (·.pos) = l.map (·.pos) := by
  simp [restAll, List.map_map, Function.comp]

theorem mem_markActed {l : List Piece} {p : Nat} {u : Piece} (h : u ∈ markActed l p) :
    ∃ v ∈ l, v.pos = u.pos ∧ v.hp = u.hp := by
  simp only [markActed, List.mem_map] at h
  obtain ⟨v, hv, rfl⟩ := h
  refine ⟨v, hv, ?_, ?_⟩ <;> by_cases hc : v.pos = p <;> simp [hc]

theorem mem_restAll {l : List Piece} {u : Piece} (h : u ∈ restAll l) :
    ∃ v ∈ l, v.pos = u.pos ∧ v.hp = u.hp := by
  simp only [restAll, List.mem_map] at h
  obtain ⟨v, hv, rfl⟩ := h
  exact ⟨v, hv, rfl, rfl⟩

theorem map_pos_walkTo (l : List Piece) (p q : Nat) :
    (walkTo l p q).map (·.pos) = (l.map (·.pos)).map (fun x => if x = p then q else x) := by
  simp only [walkTo, List.map_map]
  apply List.map_congr_left
  intro v _; by_cases h : v.pos = p <;> simp [Function.comp, h]

theorem nodup_walkTo {l : List Piece} {p q : Nat} (hn : (l.map (·.pos)).Nodup)
    (hq : ∀ v ∈ l, v.pos ≠ q) : ((walkTo l p q).map (·.pos)).Nodup := by
  rw [map_pos_walkTo]
  refine hn.map_on ?_
  intro x hx y hy hxy
  simp only [List.mem_map] at hx hy
  obtain ⟨v, hv, rfl⟩ := hx
  obtain ⟨w, hw, rfl⟩ := hy
  by_cases h1 : v.pos = p <;> by_cases h2 : w.pos = p <;>
    simp only [h1, h2, ite_true, ite_false] at hxy
  · rw [h1, h2]
  · exact absurd hxy.symm (hq w hw)
  · exact absurd hxy (hq v hv)
  · exact hxy

theorem mem_walkTo {l : List Piece} {p q : Nat} {u : Piece} (h : u ∈ walkTo l p q) :
    (u.pos = q ∨ ∃ v ∈ l, v.pos = u.pos) ∧ ∃ v ∈ l, v.hp = u.hp := by
  simp only [walkTo, List.mem_map] at h
  obtain ⟨v, hv, rfl⟩ := h
  by_cases hc : v.pos = p
  · exact ⟨Or.inl (by simp [hc]), ⟨v, hv, by simp [hc]⟩⟩
  · exact ⟨Or.inr ⟨v, hv, by simp [hc]⟩, ⟨v, hv, by simp [hc]⟩⟩

theorem map_pos_hurtAt_sublist (l : List Piece) (q dmg : Nat) :
    ((hurtAt l q dmg).map (·.pos)).Sublist (l.map (·.pos)) := by
  have h1 : ((l.map (fun w => if w.pos = q then { w with hp := w.hp - dmg } else w)).map
      (·.pos)) = l.map (·.pos) := by
    simp only [List.map_map]
    apply List.map_congr_left
    intro v _; by_cases h : v.pos = q <;> simp [Function.comp, h]
  have h2 := (List.filter_sublist
    (l := l.map (fun w => if w.pos = q then { w with hp := w.hp - dmg } else w))
    (p := fun w => decide (0 < w.hp))).map (f := fun (w : Piece) => w.pos)
  rw [h1] at h2
  exact h2

theorem mem_hurtAt {l : List Piece} {q dmg : Nat} {u : Piece} (h : u ∈ hurtAt l q dmg) :
    (∃ v ∈ l, v.pos = u.pos) ∧ 0 < u.hp := by
  simp only [hurtAt, List.mem_filter, List.mem_map] at h
  obtain ⟨⟨v, hv, rfl⟩, hpos⟩ := h
  refine ⟨⟨v, hv, ?_⟩, by simpa using hpos⟩
  by_cases hc : v.pos = q <;> simp [hc]

@[simp] theorem credit_pieces (t : State) (c : Purse) : (credit t c).pieces = t.pieces := by
  unfold credit; split <;> rfl

@[simp] theorem credit_bldgs (t : State) (c : Purse) : (credit t c).bldgs = t.bldgs := by
  unfold credit; split <;> rfl

@[simp] theorem spend_pieces (t : State) (c : Purse) : (spend t c).pieces = t.pieces := by
  unfold spend; split <;> rfl

@[simp] theorem spend_bldgs (t : State) (c : Purse) : (spend t c).bldgs = t.bldgs := by
  unfold spend; split <;> rfl

theorem wf_credit {t : State} {c : Purse} (h : Wf t) : Wf (credit t c) := by
  simpa [Wf] using h

theorem wf_spend {t : State} {c : Purse} (h : Wf t) : Wf (spend t c) := by
  simpa [Wf] using h

/-- **No legal move can break the world.**  If the position is sane and the
move is allowed, the position after it is sane: pieces stand on passable tiles,
are alive, and no two share a tile; buildings stand on plains, no two to a
tile. -/
theorem wf_apply {s s' : State} {m : Move} (hw : Wf s) (h : apply s m = some s') : Wf s' := by
  obtain ⟨hpp, hn, hb, hbn⟩ := hw
  cases m with
  | march p d =>
    simp only [apply] at h
    split at h
    · simp at h
    rename_i u hu
    split at h
    · simp at h
    rename_i hown
    split at h
    · simp at h
    rename_i q hq
    split at h
    · simp at h
    rename_i hpass
    split at h
    · simp at h
    rename_i hocc
    have hpass' : passable q = true := by
      cases hz : passable q
      · exact absurd hz hpass
      · rfl
    have hnone : pieceAt s q = none := by
      cases hz : pieceAt s q with
      | none => rfl
      | some w => rw [hz] at hocc; simp at hocc
    have hq' : ∀ v ∈ s.pieces, v.pos ≠ q := pieceAt_none hnone
    simp only [Option.some.injEq] at h
    subst h
    refine ⟨?_, nodup_walkTo hn hq', hb, hbn⟩
    intro u' hu'
    obtain ⟨hpos, v, hv, hvh⟩ := mem_walkTo hu'
    refine ⟨?_, ?_⟩
    · rcases hpos with h1 | ⟨w, hw2, hw3⟩
      · rw [h1]; exact hpass'
      · rw [← hw3]; exact (hpp w hw2).1
    · rw [← hvh]; exact (hpp v hv).2
  | gather p =>
    simp only [apply] at h
    split at h
    · simp at h
    rename_i u hu
    split at h
    · simp at h
    rename_i hown
    simp only [Option.some.injEq] at h
    subst h
    refine wf_credit ⟨?_, ?_, hb, hbn⟩
    · intro u' hu'
      obtain ⟨v, hv, e1, e2⟩ := mem_markActed hu'
      rw [← e1, ← e2]; exact hpp v hv
    · rw [map_pos_markActed]; exact hn
  | build p b =>
    simp only [apply] at h
    split at h
    · simp at h
    rename_i u hu
    split at h
    · simp at h
    rename_i hown
    split at h
    · simp at h
    rename_i hbld
    split at h
    · simp at h
    rename_i hter
    split at h
    · simp at h
    rename_i hpay
    have hplains : terrain p = Terrain.plains := not_not.mp hter
    have hnone : bldgAt s p = none := by
      cases hz : bldgAt s p with
      | none => rfl
      | some w => rw [hz] at hbld; simp at hbld
    have hfree : ∀ x ∈ s.bldgs, x.pos ≠ p := bldgAt_none hnone
    simp only [Option.some.injEq] at h
    subst h
    refine wf_spend ⟨?_, ?_, ?_, ?_⟩
    · intro u' hu'
      obtain ⟨v, hv, e1, e2⟩ := mem_markActed hu'
      rw [← e1, ← e2]; exact hpp v hv
    · rw [map_pos_markActed]; exact hn
    · intro x hx
      rcases List.mem_cons.mp hx with rfl | hx'
      · exact hplains
      · exact hb x hx'
    · simp only [List.map_cons, List.nodup_cons]
      refine ⟨?_, hbn⟩
      simp only [List.mem_map, not_exists]
      rintro x ⟨hx, hxp⟩
      exact hfree x hx hxp
  | train p k =>
    simp only [apply] at h
    split at h
    · simp at h
    rename_i bl hbb
    split at h
    · simp at h
    rename_i hown
    split at h
    · simp at h
    rename_i hocc
    split at h
    · simp at h
    rename_i hpay
    have hnone : pieceAt s p = none := by
      cases hz : pieceAt s p with
      | none => rfl
      | some w => rw [hz] at hocc; simp at hocc
    have hfree : ∀ v ∈ s.pieces, v.pos ≠ p := pieceAt_none hnone
    obtain ⟨hmem, hpos⟩ := bldgAt_some hbb
    have hplains : terrain p = Terrain.plains := by rw [← hpos]; exact hb bl hmem
    simp only [Option.some.injEq] at h
    subst h
    refine wf_spend ⟨?_, ?_, hb, hbn⟩
    · intro u' hu'
      rcases List.mem_cons.mp hu' with rfl | hu''
      · exact ⟨passable_of_plains hplains, by cases k <;> simp [unitHp]⟩
      · exact hpp u' hu''
    · simp only [List.map_cons, List.nodup_cons]
      refine ⟨?_, hn⟩
      simp only [List.mem_map, not_exists]
      rintro v ⟨hv, hvp⟩
      exact hfree v hv hvp
  | strike p d =>
    simp only [apply] at h
    split at h
    · simp at h
    rename_i u hu
    split at h
    · simp at h
    rename_i hown
    split at h
    · simp at h
    rename_i q hq
    split at h
    · simp at h
    rename_i v hv
    split at h
    · simp at h
    rename_i hside
    simp only [Option.some.injEq] at h
    subst h
    refine ⟨?_, ?_, hb, hbn⟩
    · intro u' hu'
      obtain ⟨⟨w, hw1, hw2⟩, hhp⟩ := mem_hurtAt hu'
      refine ⟨?_, hhp⟩
      obtain ⟨v0, hv0, e1, _⟩ := mem_markActed hw1
      rw [← hw2, ← e1]
      exact (hpp v0 hv0).1
    · refine List.Nodup.sublist (map_pos_hurtAt_sublist _ _ _) ?_
      rw [map_pos_markActed]; exact hn
  | endTurn =>
    simp only [apply, Option.some.injEq] at h
    subst h
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro u' hu'
      simp only [credit_pieces] at hu'
      obtain ⟨v, hv, e1, e2⟩ := mem_restAll hu'
      rw [← e1, ← e2]; exact hpp v hv
    · simp only [credit_pieces, map_pos_restAll]
      exact hn
    · simpa using hb
    · simpa using hbn

/-! ## The opening position -/

/-- The opening position: two workers and a soldier a side, on the near and far
edges of the map, and a small purse each. -/
def genesis : State :=
  { turn := false
    round := 0
    p0 := ⟨2, 2⟩
    p1 := ⟨2, 2⟩
    pieces :=
      [⟨false, .worker, 49, unitHp .worker, false⟩,
       ⟨false, .worker, 54, unitHp .worker, false⟩,
       ⟨false, .soldier, 57, unitHp .soldier, false⟩,
       ⟨true, .worker, 9, unitHp .worker, false⟩,
       ⟨true, .worker, 14, unitHp .worker, false⟩,
       ⟨true, .soldier, 6, unitHp .soldier, false⟩]
    bldgs := [] }

theorem wf_genesis : Wf genesis := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> decide

/-! ## Winning -/

/-- What a side still has on the map. -/
def alive (s : State) (b : Side) : Nat :=
  (s.pieces.filter (fun u => u.owner == b)).length +
  (s.bldgs.filter (fun x => x.owner == b)).length

/-- The gold a side needs for a victory by wealth. -/
def wealthGoal : Nat := 25

/-- Who has won, if anyone: a side that has swept the other off the map, or one
that has piled up `wealthGoal` gold. -/
def winner (s : State) : Option Side :=
  if alive s true = 0 then some false
  else if alive s false = 0 then some true
  else if wealthGoal ≤ s.p0.gold then some false
  else if wealthGoal ≤ s.p1.gold then some true
  else none

end Realm
end LifeTrac
