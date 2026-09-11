import Mathlib.Tactic

/-!
# Realm: a small civilisation / warcraft style game, as a pure state machine

The game is played on a fixed 8 × 8 map.  Two players (0 = *Red*, 1 = *Blue*) own
**pieces** (workers and soldiers) and **cities**, and hold a bank of three
resources (food, wood, gold).  A move is one of

* `march i d`  — walk piece `i` one tile in direction `d`;
* `strike i d` — a soldier attacks the enemy piece or city on the next tile;
* `gather i`   — a worker harvests the tile it stands on;
* `found i`    — a worker becomes a city;
* `train c k`  — a city trains a new piece, paid for out of the bank;
* `endTurn`    — collect the cities' income and hand over to the other player.

Everything is deterministic and total: `step : State → Move → Option State` returns
`none` exactly on an illegal move, so a game is a list of moves and nothing else.
That is what makes a game replayable from a page of text, which is what
`RequestProject/RealmChain.lean` and `RequestProject/RealmPage.lean` build on.

Dead pieces and razed cities are **kept in the list with `hp = 0`** rather than
deleted, so that a move's indices mean the same thing in every replay.
-/

namespace Realm

/-! ## §1  The map -/

/-- Board width. -/
def W : Nat := 8
/-- Board height. -/
def H : Nat := 8

/-- The four kinds of tile. -/
inductive Terrain
  | plains | forest | hills | water
  deriving DecidableEq, Repr, Inhabited

/-- The fixed map, one string per row, `p`lains `f`orest `h`ills `w`ater. -/
def mapRows : List String :=
  [ "pphhffpp",
    "ppphfppw",
    "wpppphpp",
    "wwppffpp",
    "ppphhppw",
    "pfpppppw",
    "ppffhppp",
    "pppphhpp" ]

/-- Decode a map character. -/
def charTerrain (c : Char) : Terrain :=
  match c with
  | 'p' => .plains
  | 'f' => .forest
  | 'h' => .hills
  | _   => .water

/-- The terrain of a tile (water outside the board). -/
def terrainAt (x y : Nat) : Terrain :=
  charTerrain ((mapRows.getD y "").toList.getD x 'w')

/-- Can a piece stand here? -/
def passable (x y : Nat) : Bool := terrainAt x y != Terrain.water

/-! ## §2  Resources -/

/-- A bank of resources. -/
structure Res where
  food : Nat
  wood : Nat
  gold : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The empty bank. -/
def Res.zero : Res := ⟨0, 0, 0⟩

/-- Add two banks. -/
def Res.add (a b : Res) : Res := ⟨a.food + b.food, a.wood + b.wood, a.gold + b.gold⟩

/-- Truncated subtraction of banks. -/
def Res.sub (a b : Res) : Res := ⟨a.food - b.food, a.wood - b.wood, a.gold - b.gold⟩

/-- Does `a` cover the cost `b`? -/
def Res.covers (a b : Res) : Bool := b.food ≤ a.food && b.wood ≤ a.wood && b.gold ≤ a.gold

/-- The harvest of a tile. -/
def yieldOf : Terrain → Res
  | .plains => ⟨2, 0, 0⟩
  | .forest => ⟨0, 2, 0⟩
  | .hills  => ⟨0, 0, 2⟩
  | .water  => Res.zero

/-! ## §3  Pieces, cities, state -/

/-- The two unit types. -/
inductive Kind
  | worker | soldier
  deriving DecidableEq, Repr, Inhabited

/-- A unit on the board.  `hp = 0` means it is dead but its slot is kept. -/
structure Piece where
  owner : Nat
  kind  : Kind
  x     : Nat
  y     : Nat
  hp    : Nat
  acted : Bool
  deriving DecidableEq, Repr, Inhabited

/-- A city.  `hp = 0` means razed. -/
structure City where
  owner : Nat
  x     : Nat
  y     : Nat
  hp    : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A whole position. -/
structure State where
  turn   : Nat
  active : Nat
  pieces : List Piece
  cities : List City
  red    : Res
  blue   : Res
  deriving DecidableEq, Repr, Inhabited

/-- The bank of player `p`. -/
def State.bank (st : State) (p : Nat) : Res := if p = 0 then st.red else st.blue

/-- Replace the bank of player `p`. -/
def State.setBank (st : State) (p : Nat) (r : Res) : State :=
  if p = 0 then { st with red := r } else { st with blue := r }

/-- Is a live piece standing on this tile? -/
def occupied (st : State) (x y : Nat) : Bool :=
  st.pieces.any fun u => 0 < u.hp && u.x == x && u.y == y

/-- Is a live city of player `p` on this tile? -/
def cityOfAt (st : State) (p x y : Nat) : Bool :=
  st.cities.any fun c => 0 < c.hp && c.owner == p && c.x == x && c.y == y

/-- Is any live city on this tile? -/
def cityAt (st : State) (x y : Nat) : Bool :=
  st.cities.any fun c => 0 < c.hp && c.x == x && c.y == y

/-- The other player. -/
def other (p : Nat) : Nat := 1 - p

/-- Does player `p` still have anything on the board? -/
def alivePlayer (st : State) (p : Nat) : Bool :=
  (st.pieces.any fun u => 0 < u.hp && u.owner == p) ||
  (st.cities.any fun c => 0 < c.hp && c.owner == p)

/-- The winner, if the game is over: the last player left standing. -/
def winner (st : State) : Option Nat :=
  if alivePlayer st 0 && !alivePlayer st 1 then some 0
  else if alivePlayer st 1 && !alivePlayer st 0 then some 1
  else none

/-! ## §4  Moves -/

/-- The four compass directions. -/
inductive Dir
  | north | south | west | east
  deriving DecidableEq, Repr, Inhabited

/-- The neighbour of a tile, if it is on the board.  By construction the result is
always in bounds. -/
def stepDir (d : Dir) (x y : Nat) : Option (Nat × Nat) :=
  match d with
  | .north => if 0 < y then some (x, y - 1) else none
  | .south => if y + 1 < H then some (x, y + 1) else none
  | .west  => if 0 < x then some (x - 1, y) else none
  | .east  => if x + 1 < W then some (x + 1, y) else none

/-- A move of the game. -/
inductive Move
  | march  (i : Nat) (d : Dir)
  | strike (i : Nat) (d : Dir)
  | gather (i : Nat)
  | found  (i : Nat)
  | train  (c : Nat) (k : Kind)
  | endTurn
  deriving DecidableEq, Repr, Inhabited

/-- The piece a move acts through, if any. -/
def Move.pieceIdx : Move → Option Nat
  | .march i _  => some i
  | .strike i _ => some i
  | .gather i   => some i
  | .found i    => some i
  | .train _ _  => none
  | .endTurn    => none

/-- What a new piece costs. -/
def costOf : Kind → Res
  | .worker  => ⟨3, 0, 0⟩
  | .soldier => ⟨2, 2, 0⟩

/-- What founding a city costs. -/
def foundCost : Res := ⟨4, 0, 0⟩

/-- The health a new piece starts with. -/
def startHp : Kind → Nat
  | .worker  => 3
  | .soldier => 6

/-- The health of a new city. -/
def cityHp : Nat := 6

/-- Damage of an attack from `(ax, ay)` against `(dx, dy)`: three, plus one for
attacking downhill, less one for a defender in the forest. -/
def damage (ax ay dx dy : Nat) : Nat :=
  (3 + (if terrainAt ax ay = Terrain.hills then 1 else 0)) -
    (if terrainAt dx dy = Terrain.forest then 1 else 0)

/-- The index of the first live piece on a tile, if any. -/
def pieceIdxAt (st : State) (x y : Nat) : Option Nat :=
  (st.pieces.zipIdx.find? fun p => 0 < p.1.hp && p.1.x == x && p.1.y == y).map (·.2)

/-- The index of the first live city on a tile, if any. -/
def cityIdxAt (st : State) (x y : Nat) : Option Nat :=
  (st.cities.zipIdx.find? fun p => 0 < p.1.hp && p.1.x == x && p.1.y == y).map (·.2)

/-- Is this move legal in this position? -/
def legal (st : State) (mv : Move) : Bool :=
  st.active < 2 && (winner st).isNone &&
  (match mv with
   | .march i d =>
      match st.pieces[i]? with
      | none => false
      | some u =>
        0 < u.hp && u.owner == st.active && !u.acted &&
        (match stepDir d u.x u.y with
         | none => false
         | some (x, y) => passable x y && !occupied st x y && !cityOfAt st (other st.active) x y)
   | .strike i d =>
      match st.pieces[i]? with
      | none => false
      | some u =>
        0 < u.hp && u.owner == st.active && !u.acted && u.kind == Kind.soldier &&
        (match stepDir d u.x u.y with
         | none => false
         | some (x, y) =>
            (match pieceIdxAt st x y with
             | some j => (st.pieces[j]?.map (fun v => v.owner != st.active)).getD false
             | none   => cityOfAt st (other st.active) x y))
   | .gather i =>
      match st.pieces[i]? with
      | none => false
      | some u => 0 < u.hp && u.owner == st.active && !u.acted && u.kind == Kind.worker
   | .found i =>
      match st.pieces[i]? with
      | none => false
      | some u =>
        0 < u.hp && u.owner == st.active && !u.acted && u.kind == Kind.worker &&
        terrainAt u.x u.y == Terrain.plains && !cityAt st u.x u.y &&
        (st.bank st.active).covers foundCost
   | .train c k =>
      match st.cities[c]? with
      | none => false
      | some ct =>
        0 < ct.hp && ct.owner == st.active && (st.bank st.active).covers (costOf k) &&
        !occupied st ct.x ct.y
   | .endTurn => true)

/-- Replace piece `i`. -/
def setPiece (st : State) (i : Nat) (u : Piece) : State :=
  { st with pieces := st.pieces.set i u }

/-- Replace city `i`. -/
def setCity (st : State) (i : Nat) (c : City) : State :=
  { st with cities := st.cities.set i c }

/-- Apply a move.  Only meaningful when the move is legal; `step` is the gate. -/
def apply (st : State) (mv : Move) : State :=
  match mv with
  | .march i d =>
    match st.pieces[i]? with
    | none => st
    | some u =>
      match stepDir d u.x u.y with
      | none => st
      | some (x, y) => setPiece st i { u with x := x, y := y, acted := true }
  | .strike i d =>
    match st.pieces[i]? with
    | none => st
    | some u =>
      match stepDir d u.x u.y with
      | none => st
      | some (x, y) =>
        let st1 := setPiece st i { u with acted := true }
        match pieceIdxAt st x y with
        | some j =>
          match st.pieces[j]? with
          | none => st1
          | some v => setPiece st1 j { v with hp := v.hp - damage u.x u.y x y }
        | none =>
          match cityIdxAt st x y with
          | some j =>
            match st.cities[j]? with
            | none => st1
            | some ct => setCity st1 j { ct with hp := ct.hp - damage u.x u.y x y }
          | none => st1
  | .gather i =>
    match st.pieces[i]? with
    | none => st
    | some u =>
      let st1 := setPiece st i { u with acted := true }
      st1.setBank st.active ((st.bank st.active).add (yieldOf (terrainAt u.x u.y)))
  | .found i =>
    match st.pieces[i]? with
    | none => st
    | some u =>
      let st1 := setPiece st i { u with hp := 0 }
      let st2 : State :=
        { st1 with cities := st1.cities ++ [(⟨st.active, u.x, u.y, cityHp⟩ : City)] }
      st2.setBank st.active ((st.bank st.active).sub foundCost)
  | .train c k =>
    match st.cities[c]? with
    | none => st
    | some ct =>
      let st1 : State :=
        { st with pieces := st.pieces ++ [⟨st.active, k, ct.x, ct.y, startHp k, true⟩] }
      st1.setBank st.active ((st.bank st.active).sub (costOf k))
  | .endTurn =>
    let income : Res :=
      st.cities.foldl (fun r c => if 0 < c.hp && c.owner == st.active then r.add (⟨2, 0, 1⟩ : Res) else r)
        Res.zero
    let st1 := st.setBank st.active ((st.bank st.active).add income)
    let nxt := other st.active
    { st1 with
        turn := st.turn + 1
      , active := nxt
      , pieces := st1.pieces.map fun u => if u.owner = nxt then { u with acted := false } else u }

/-- One move of the game: `none` exactly when the move is illegal. -/
def step (st : State) (mv : Move) : Option State :=
  if legal st mv then some (apply st mv) else none

/-- Play a list of moves; `none` as soon as one is illegal. -/
def play (st : State) : List Move → Option State
  | [] => some st
  | m :: ms => (step st m).bind fun st' => play st' ms

/-- The list of states visited, starting with `st`, as far as the moves are legal. -/
def trace (st : State) : List Move → List State
  | [] => [st]
  | m :: ms => match step st m with
    | none => [st]
    | some st' => st :: trace st' ms

/-! ## §5  The opening position -/

/-- The opening position: Red has a worker and two soldiers on the western hills,
Blue a worker and a soldier in the east, four food each in the bank. -/
def initial : State where
  turn := 0
  active := 0
  pieces :=
    [ ⟨0, .worker,  1, 2, startHp .worker,  false⟩
    , ⟨0, .soldier, 3, 4, startHp .soldier, false⟩
    , ⟨0, .soldier, 2, 4, startHp .soldier, false⟩
    , ⟨1, .worker,  5, 5, startHp .worker,  false⟩
    , ⟨1, .soldier, 5, 4, startHp .soldier, false⟩ ]
  cities := []
  red := ⟨4, 0, 0⟩
  blue := ⟨4, 0, 0⟩

/-! ## §6  Well-formedness -/

/-- A position is well formed: both players are numbered 0 or 1, everything on the
board is inside the board and out of the water, and no two live pieces (or two
live cities) share a tile. -/
structure WF (st : State) : Prop where
  active : st.active < 2
  piece_ok : ∀ u ∈ st.pieces, u.owner < 2 ∧ u.x < W ∧ u.y < H ∧ (0 < u.hp → passable u.x u.y)
  city_ok  : ∀ c ∈ st.cities, c.owner < 2 ∧ c.x < W ∧ c.y < H ∧ (0 < c.hp → passable c.x c.y)
  piece_uniq : ∀ i j, ∀ hi : i < st.pieces.length, ∀ hj : j < st.pieces.length, i ≠ j →
      0 < st.pieces[i].hp → 0 < st.pieces[j].hp →
      ¬(st.pieces[i].x = st.pieces[j].x ∧ st.pieces[i].y = st.pieces[j].y)
  city_uniq : ∀ i j, ∀ hi : i < st.cities.length, ∀ hj : j < st.cities.length, i ≠ j →
      0 < st.cities[i].hp → 0 < st.cities[j].hp →
      ¬(st.cities[i].x = st.cities[j].x ∧ st.cities[i].y = st.cities[j].y)

end Realm
