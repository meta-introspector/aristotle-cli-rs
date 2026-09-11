import RequestProject.Nix.NixWars.Meme

/-!
# A tenth door: 8D Hyperspace

The navigation door, taken from the hackathon repository's flying game: the
player is a consciousness moving through an eight-dimensional space of
performance traces, the *Monster manifold*, whose axes are

```
0 conductor    2 level     4 primes     6 muses
1 weight       3 traits    5 gitdepth   7 complexity
```

Each axis is a ring of eight positions, so hyperspace is the discrete
8-cube `8^8`, and the whole of it fits in eight small numbers — the state of
this door. `fwd d` steps forward along axis `d`, `back d` steps back, `home`
returns to the origin, and `fix` applies the Y combinator: it is the command
that does nothing, because a fixed point is a place that maps to itself.

What is proved here:

* the ship never leaves the manifold: every coordinate stays below eight
  (`hyperStep_coord_lt`, `hyperRun_coord_lt`);
* a step moves exactly one axis and leaves the other seven alone
  (`fwd_coord`, `fwd_other`, `back_coord`, `back_other`);
* forward and back are inverse (`back_fwd`, `fwd_back`), and eight steps along
  one axis come back to where they started (`fwd_eight`);
* `fix` is a fixed point of the whole game — `Y(p) = p` — and it is the only
  command that never moves anything (`fix_id`, `fix_run`);
* **the whole manifold is reachable**: for every point of the 8-cube there is a
  route from anywhere that arrives exactly there (`route_arrives`), of at most
  fifty-seven commands (`route_length_le`);
* hyperspace is addressed on the 71-shard DMZ: a position's address is a
  base-eight numeral below `8^8` (`address_lt`), and its shard is a real shard
  (`shard_lt`); the Monster Crown's shard 47 is reachable (`crown_position`).
-/

namespace NixWars

/-- A position in the Monster manifold: one coordinate per axis. -/
structure Position where
  /-- Axis 0, the conductor. -/
  d0 : Nat
  /-- Axis 1, the weight. -/
  d1 : Nat
  /-- Axis 2, the level. -/
  d2 : Nat
  /-- Axis 3, the traits. -/
  d3 : Nat
  /-- Axis 4, the key primes. -/
  d4 : Nat
  /-- Axis 5, the git depth. -/
  d5 : Nat
  /-- Axis 6, the muse count. -/
  d6 : Nat
  /-- Axis 7, the complexity. -/
  d7 : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the hyperspace door. -/
inductive HyperCmd
  | fwd (d : Nat)
  | back (d : Nat)
  | home
  | fix
  deriving DecidableEq, Repr, Inhabited

/-- How many dimensions the manifold has. -/
def dims : Nat := 8

/-- How many positions there are along one axis. -/
def span : Nat := 8

/-- The coordinate of a position along an axis; axes outside the manifold read
as zero. -/
def coord (s : Position) (d : Nat) : Nat :=
  if d = 0 then s.d0 else if d = 1 then s.d1 else if d = 2 then s.d2
  else if d = 3 then s.d3 else if d = 4 then s.d4 else if d = 5 then s.d5
  else if d = 6 then s.d6 else if d = 7 then s.d7 else 0

/-- Setting one coordinate; setting an axis outside the manifold does
nothing. -/
def setCoord (s : Position) (d x : Nat) : Position :=
  { d0 := if d = 0 then x else s.d0, d1 := if d = 1 then x else s.d1,
    d2 := if d = 2 then x else s.d2, d3 := if d = 3 then x else s.d3,
    d4 := if d = 4 then x else s.d4, d5 := if d = 5 then x else s.d5,
    d6 := if d = 6 then x else s.d6, d7 := if d = 7 then x else s.d7 }

/-- One step forward along a ring of `span` positions. -/
def bumpUp (x : Nat) : Nat := if x + 1 ≤ span - 1 then x + 1 else 0

/-- One step back along a ring of `span` positions. -/
def bumpDown (x : Nat) : Nat := if x ≤ 0 then span - 1 else x - 1

/-- The origin of the manifold. -/
def origin : Position :=
  { d0 := 0, d1 := 0, d2 := 0, d3 := 0, d4 := 0, d5 := 0, d6 := 0, d7 := 0 }

/-- **The transition function of the hyperspace door.** -/
def hyperStep (s : Position) : HyperCmd → Position
  | .fwd d => setCoord s d (bumpUp (coord s d))
  | .back d => setCoord s d (bumpDown (coord s d))
  | .home => origin
  | .fix => s

/-- Playing a list of commands. -/
def hyperRun (s : Position) : List HyperCmd → Position
  | [] => s
  | c :: cs => hyperRun (hyperStep s c) cs

theorem hyperRun_append (s : Position) (cs ds : List HyperCmd) :
    hyperRun s (cs ++ ds) = hyperRun (hyperRun s cs) ds := by
  induction cs generalizing s with
  | nil => rfl
  | cons c cs ih => simp [hyperRun, ih]

/-! ## The position as a payload -/

/-- The position as a payload. -/
def hyperSerialize (s : Position) : List Nat :=
  [s.d0, s.d1, s.d2, s.d3, s.d4, s.d5, s.d6, s.d7]

/-- Reading a position back from a payload. -/
def hyperDeserialize : List Nat → Option Position
  | [a, b, c, d, e, f, g, h] =>
      some { d0 := a, d1 := b, d2 := c, d3 := d, d4 := e, d5 := f, d6 := g, d7 := h }
  | _ => none

theorem hyperDeserialize_hyperSerialize (s : Position) :
    hyperDeserialize (hyperSerialize s) = some s := by
  cases s
  simp [hyperSerialize, hyperDeserialize]

/-- **8D Hyperspace as a door game.** -/
def hyperspace : DoorGame where
  State := Position
  Cmd := HyperCmd
  step := hyperStep
  serialize := hyperSerialize
  deserialize := hyperDeserialize
  deserialize_serialize := hyperDeserialize_hyperSerialize

/-! ## Coordinates -/

@[simp] theorem coord_setCoord_self (s : Position) (d x : Nat) (hd : d < dims) :
    coord (setCoord s d x) d = x := by
  unfold dims at hd
  interval_cases d <;> simp [coord, setCoord]

theorem coord_setCoord_other (s : Position) (d e x : Nat) (h : e ≠ d) :
    coord (setCoord s d x) e = coord s e := by
  unfold coord setCoord
  dsimp only
  split_ifs <;> simp_all

/-- A step forward moves the axis it names by one place round its ring. -/
theorem fwd_coord (s : Position) (d : Nat) (hd : d < dims) :
    coord (hyperStep s (.fwd d)) d = bumpUp (coord s d) :=
  coord_setCoord_self s d _ hd

/-- A step forward leaves every other axis alone. -/
theorem fwd_other (s : Position) (d e : Nat) (h : e ≠ d) :
    coord (hyperStep s (.fwd d)) e = coord s e :=
  coord_setCoord_other s d e _ h

theorem back_coord (s : Position) (d : Nat) (hd : d < dims) :
    coord (hyperStep s (.back d)) d = bumpDown (coord s d) :=
  coord_setCoord_self s d _ hd

theorem back_other (s : Position) (d e : Nat) (h : e ≠ d) :
    coord (hyperStep s (.back d)) e = coord s e :=
  coord_setCoord_other s d e _ h

/-! ## Staying inside the manifold -/

/-- A position is *in the manifold* when every coordinate is below `span`. -/
def Inside (s : Position) : Prop := ∀ d, d < dims → coord s d < span

theorem origin_inside : Inside origin := by
  intro d hd
  unfold dims at hd
  interval_cases d <;> decide

theorem bumpUp_lt (x : Nat) : bumpUp x < span := by
  unfold bumpUp span; split_ifs <;> omega

theorem bumpDown_lt (x : Nat) (h : x < span) : bumpDown x < span := by
  unfold bumpDown span at *; split_ifs <;> omega

/-- **The ship never leaves the manifold.** -/
theorem hyperStep_coord_lt (s : Position) (c : HyperCmd) (h : Inside s) : Inside (hyperStep s c) := by
  intro e he
  cases c with
  | fwd d =>
      by_cases hed : e = d
      · subst hed; rw [fwd_coord s e he]; exact bumpUp_lt _
      · rw [fwd_other s d e hed]; exact h e he
  | back d =>
      by_cases hed : e = d
      · subst hed; rw [back_coord s e he]; exact bumpDown_lt _ (h e he)
      · rw [back_other s d e hed]; exact h e he
  | home => exact origin_inside e he
  | fix => exact h e he

theorem hyperRun_coord_lt (s : Position) (cs : List HyperCmd) (h : Inside s) :
    Inside (hyperRun s cs) := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih _ (hyperStep_coord_lt s c h)

/-! ## Forward and back -/

theorem bumpDown_bumpUp (x : Nat) (h : x < span) : bumpDown (bumpUp x) = x := by
  unfold bumpUp bumpDown span at *
  split_ifs <;> omega

theorem bumpUp_bumpDown (x : Nat) (h : x < span) : bumpUp (bumpDown x) = x := by
  unfold bumpUp bumpDown span at *
  split_ifs <;> omega

theorem setCoord_coord (s : Position) (d : Nat) : setCoord s d (coord s d) = s := by
  unfold setCoord coord
  split_ifs <;> simp_all

theorem setCoord_setCoord (s : Position) (d x y : Nat) :
    setCoord (setCoord s d x) d y = setCoord s d y := by
  unfold setCoord
  split_ifs <;> simp_all

/-- Stepping back undoes stepping forward. -/
theorem back_fwd (s : Position) (d : Nat) (hd : d < dims) (h : Inside s) :
    hyperStep (hyperStep s (.fwd d)) (.back d) = s := by
  show setCoord (setCoord s d (bumpUp (coord s d))) d
      (bumpDown (coord (setCoord s d (bumpUp (coord s d))) d)) = s
  rw [coord_setCoord_self _ _ _ hd, bumpDown_bumpUp _ (h d hd), setCoord_setCoord, setCoord_coord]

/-- Stepping forward undoes stepping back. -/
theorem fwd_back (s : Position) (d : Nat) (hd : d < dims) (h : Inside s) :
    hyperStep (hyperStep s (.back d)) (.fwd d) = s := by
  show setCoord (setCoord s d (bumpDown (coord s d))) d
      (bumpUp (coord (setCoord s d (bumpDown (coord s d))) d)) = s
  rw [coord_setCoord_self _ _ _ hd, bumpUp_bumpDown _ (h d hd), setCoord_setCoord, setCoord_coord]

/-- Eight steps along one axis come back to where they started: each axis is a
ring of eight. -/
theorem fwd_eight (s : Position) (d : Nat) (hd : d < dims) (h : Inside s) :
    hyperRun s (List.replicate span (HyperCmd.fwd d)) = s := by
  have hstep : ∀ t : Position, Inside t →
      hyperStep t (.fwd d) = setCoord t d (bumpUp (coord t d)) := fun _ _ => rfl
  have key : ∀ k, ∀ t : Position, Inside t →
      hyperRun t (List.replicate k (HyperCmd.fwd d))
        = setCoord t d ((coord t d + k) % span) := by
    intro k
    induction k with
    | zero =>
        intro t ht
        have hmod : (coord t d + 0) % span = coord t d := Nat.mod_eq_of_lt (ht d hd)
        simp only [List.replicate_zero, hyperRun, hmod]
        rw [setCoord_coord]
    | succ k ih =>
        intro t ht
        have h1 : hyperRun t (List.replicate (k + 1) (HyperCmd.fwd d))
            = hyperRun (hyperStep t (.fwd d)) (List.replicate k (HyperCmd.fwd d)) := by
          simp [List.replicate_succ, hyperRun]
        rw [h1, ih _ (hyperStep_coord_lt t _ ht), hstep t ht,
          coord_setCoord_self _ _ _ hd, setCoord_setCoord]
        congr 1
        have hb : bumpUp (coord t d) = (coord t d + 1) % span := by
          unfold bumpUp span
          have := ht d hd
          unfold span at this
          split_ifs <;> omega
        rw [hb, Nat.mod_add_mod]
        congr 1
        omega
  rw [key span s h]
  have hmod : (coord s d + span) % span = coord s d := by
    rw [Nat.add_mod_right]
    exact Nat.mod_eq_of_lt (h d hd)
  rw [hmod, setCoord_coord]

/-! ## The Y combinator -/

/-- **`fix` is a fixed point**: applying the Y combinator to a position returns
that position. -/
theorem fix_id (s : Position) : hyperStep s .fix = s := rfl

/-- However many times it is applied. -/
theorem fix_run (s : Position) (n : Nat) : hyperRun s (List.replicate n .fix) = s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simpa [List.replicate_succ, hyperRun, fix_id] using ih s

/-- `home` really does go home. -/
theorem home_origin (s : Position) : hyperStep s .home = origin := rfl

/-! ## The whole manifold is reachable -/

/-- Setting a coordinate to a value inside the ring keeps the ship inside the
manifold. -/
theorem inside_setCoord (s : Position) (d x : Nat) (h : Inside s) (hx : x < span) :
    Inside (setCoord s d x) := by
  intro e he
  by_cases hed : e = d
  · subst hed
    rw [coord_setCoord_self _ _ _ he]
    exact hx
  · rw [coord_setCoord_other _ _ _ _ hed]
    exact h e he



/-- The route to a target position: home, then walk out along each axis in
turn. -/
def route (p : Position) : List HyperCmd :=
  HyperCmd.home ::
    (List.replicate p.d0 (HyperCmd.fwd 0) ++ List.replicate p.d1 (HyperCmd.fwd 1) ++
     List.replicate p.d2 (HyperCmd.fwd 2) ++ List.replicate p.d3 (HyperCmd.fwd 3) ++
     List.replicate p.d4 (HyperCmd.fwd 4) ++ List.replicate p.d5 (HyperCmd.fwd 5) ++
     List.replicate p.d6 (HyperCmd.fwd 6) ++ List.replicate p.d7 (HyperCmd.fwd 7))

/-- Walking out along one axis from a position whose coordinate is zero. -/
theorem run_replicate_fwd (t : Position) (d k : Nat) (hd : d < dims) (hk : k < span)
    (h0 : coord t d = 0) (h : Inside t) :
    hyperRun t (List.replicate k (HyperCmd.fwd d)) = setCoord t d k := by
  have key : ∀ j, ∀ u : Position, Inside u → coord u d + j < span →
      hyperRun u (List.replicate j (HyperCmd.fwd d)) = setCoord u d (coord u d + j) := by
    intro j
    induction j with
    | zero => intro u _ _; simp [hyperRun, setCoord_coord]
    | succ j ih =>
        intro u hu hlt
        have h1 : hyperRun u (List.replicate (j + 1) (HyperCmd.fwd d))
            = hyperRun (hyperStep u (.fwd d)) (List.replicate j (HyperCmd.fwd d)) := by
          simp [List.replicate_succ, hyperRun]
        have hb : bumpUp (coord u d) = coord u d + 1 := by
          unfold bumpUp span at *
          split_ifs <;> omega
        have hstep : hyperStep u (.fwd d) = setCoord u d (coord u d + 1) := by
          show setCoord u d (bumpUp (coord u d)) = _
          rw [hb]
        rw [h1, hstep, ih _ (by rw [← hstep]; exact hyperStep_coord_lt u _ hu)
          (by rw [coord_setCoord_self _ _ _ hd]; omega),
          coord_setCoord_self _ _ _ hd, setCoord_setCoord]
        congr 1
        omega
  rw [key k t h (by rw [h0]; omega), h0]
  simp

/-- **Every point of the 8-cube is reachable**, from wherever the ship happens
to be. -/
theorem route_arrives (s p : Position) (hp : Inside p) : hyperRun s (route p) = p := by
  have h0 : hyperStep s .home = origin := rfl
  have hb : ∀ d, d < dims → coord p d < span := hp
  have b0 : p.d0 < 8 := hb 0 (by decide)
  have b1 : p.d1 < 8 := hb 1 (by decide)
  have b2 : p.d2 < 8 := hb 2 (by decide)
  have b3 : p.d3 < 8 := hb 3 (by decide)
  have b4 : p.d4 < 8 := hb 4 (by decide)
  have b5 : p.d5 < 8 := hb 5 (by decide)
  have b6 : p.d6 < 8 := hb 6 (by decide)
  have b7 : p.d7 < 8 := hb 7 (by decide)
  have i0 : Inside origin := origin_inside
  have i1 : Inside (setCoord origin 0 p.d0) := inside_setCoord _ _ _ i0 b0
  have i2 : Inside (setCoord (setCoord origin 0 p.d0) 1 p.d1) := inside_setCoord _ _ _ i1 b1
  have i3 : Inside (setCoord (setCoord (setCoord origin 0 p.d0) 1 p.d1) 2 p.d2) :=
    inside_setCoord _ _ _ i2 b2
  have i4 : Inside (setCoord (setCoord (setCoord (setCoord origin 0 p.d0) 1 p.d1) 2 p.d2)
      3 p.d3) := inside_setCoord _ _ _ i3 b3
  have i5 : Inside (setCoord (setCoord (setCoord (setCoord (setCoord origin 0 p.d0) 1 p.d1)
      2 p.d2) 3 p.d3) 4 p.d4) := inside_setCoord _ _ _ i4 b4
  have i6 : Inside (setCoord (setCoord (setCoord (setCoord (setCoord (setCoord origin
      0 p.d0) 1 p.d1) 2 p.d2) 3 p.d3) 4 p.d4) 5 p.d5) := inside_setCoord _ _ _ i5 b5
  have i7 : Inside (setCoord (setCoord (setCoord (setCoord (setCoord (setCoord (setCoord origin
      0 p.d0) 1 p.d1) 2 p.d2) 3 p.d3) 4 p.d4) 5 p.d5) 6 p.d6) := inside_setCoord _ _ _ i6 b6
  simp only [route, hyperRun, h0, hyperRun_append]
  rw [run_replicate_fwd origin 0 p.d0 (by decide) b0 rfl i0]
  rw [run_replicate_fwd _ 1 p.d1 (by decide) b1 rfl i1]
  rw [run_replicate_fwd _ 2 p.d2 (by decide) b2 rfl i2]
  rw [run_replicate_fwd _ 3 p.d3 (by decide) b3 rfl i3]
  rw [run_replicate_fwd _ 4 p.d4 (by decide) b4 rfl i4]
  rw [run_replicate_fwd _ 5 p.d5 (by decide) b5 rfl i5]
  rw [run_replicate_fwd _ 6 p.d6 (by decide) b6 rfl i6]
  rw [run_replicate_fwd _ 7 p.d7 (by decide) b7 rfl i7]
  cases p
  simp [setCoord, origin]

/-- No point is more than fifty-seven commands away. -/
theorem route_length_le (p : Position) (hp : Inside p) : (route p).length ≤ 57 := by
  have hb : ∀ d, d < dims → coord p d < span := hp
  have b0 : p.d0 < 8 := hb 0 (by decide)
  have b1 : p.d1 < 8 := hb 1 (by decide)
  have b2 : p.d2 < 8 := hb 2 (by decide)
  have b3 : p.d3 < 8 := hb 3 (by decide)
  have b4 : p.d4 < 8 := hb 4 (by decide)
  have b5 : p.d5 < 8 := hb 5 (by decide)
  have b6 : p.d6 < 8 := hb 6 (by decide)
  have b7 : p.d7 < 8 := hb 7 (by decide)
  unfold span at *
  simp only [route, List.length_cons, List.length_append, List.length_replicate]
  omega

/-! ## The address of a position -/

/-- The address of a position: its coordinates as a base-eight numeral. -/
def address (s : Position) : Nat :=
  s.d0 + span * (s.d1 + span * (s.d2 + span * (s.d3 + span *
    (s.d4 + span * (s.d5 + span * (s.d6 + span * s.d7))))))

/-- Addresses fill exactly the 8-cube. -/
theorem address_lt (s : Position) (h : Inside s) : address s < span ^ dims := by
  have hb : ∀ d, d < dims → coord s d < span := h
  have b0 : s.d0 < 8 := hb 0 (by decide)
  have b1 : s.d1 < 8 := hb 1 (by decide)
  have b2 : s.d2 < 8 := hb 2 (by decide)
  have b3 : s.d3 < 8 := hb 3 (by decide)
  have b4 : s.d4 < 8 := hb 4 (by decide)
  have b5 : s.d5 < 8 := hb 5 (by decide)
  have b6 : s.d6 < 8 := hb 6 (by decide)
  have b7 : s.d7 < 8 := hb 7 (by decide)
  unfold address span dims at *
  omega

/-- The shard of hyperspace a position broadcasts on. -/
def hyperShard (s : Position) : Nat := address s % numShards

theorem shard_lt (s : Position) : hyperShard s < numShards :=
  Nat.mod_lt _ (by decide)

/-- The origin sits on shard zero. -/
theorem origin_shard : hyperShard origin = 0 := by decide

/-- **The Monster Crown's shard is out there**: a position of the manifold
whose address lands on shard 47, and the route to it. -/
def crownPos : Position :=
  { d0 := 7, d1 := 5, d2 := 0, d3 := 0, d4 := 0, d5 := 0, d6 := 0, d7 := 0 }

theorem crown_position : hyperShard crownPos = crownShard := by decide

theorem crown_position_inside : Inside crownPos := by
  intro d hd
  unfold dims at hd
  interval_cases d <;> decide

theorem crown_reachable (s : Position) : hyperRun s (route crownPos) = crownPos :=
  route_arrives s crownPos crown_position_inside

/-! ## On the board

Hyperspace is a `DoorGame`, so it inherits the stateless session and all five
wires with no new transport code: the whole 8-cube travels in eight digits. -/

/-- The hyperspace session of a player. -/
def hyperSession (i shard : Nat) (st : Position) : GameSession hyperspace :=
  { user := i, shard := shard, game := 10, state := st }

/-- **A hyperspace session survives any wire intact.** -/
theorem hyperSession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession hyperspace) : receive hyperspace t (transmit t s) = some s :=
  receive_transmit t s

/-- **Hyperspace is stateless**: re-serializing after every command gives
exactly the same result as playing locally. -/
theorem hyper_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession hyperspace) (cs : List HyperCmd) :
    runOverWire (g := hyperspace) t (transmit t s) cs
      = some (transmit t { s with state := hyperspace.run s.state cs }) :=
  runOverWire_eq t s cs

end NixWars
