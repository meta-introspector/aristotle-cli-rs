import RequestProject.Nix.NixWars.Monster.Place
import RequestProject.Nix.NixWars.Frontier

/-!
# Flying the voxel world

`World.lean` builds the map — a stack of grids over one universe, level `d`
being the box whose axes are the `d` largest primes dividing the order of the
Monster — and `Place.lean` puts the 194 irreducibles into it.  This file puts a
*ship* into it.

The ship is a voxel address plus a heading: which axis the nose points along,
whether it points up or down that axis, a throttle, a tank and a docking clamp.
It is exactly the Frontier Run of `Frontier.lean` with the `16 × 16 × 16` cube
replaced by the level-`d` box, and with two new commands that the cube does not
have: `descend` drops the ship into the next finer grid (one more axis, one more
coordinate) and `ascend` lifts it back out.  So the same ship flies the 3D world
`71 × 59 × 47` and the 15D world of all fifteen primes.

What is proved:

* the ship never leaves the world (`step_ok`, `run_ok`, `index_lt`): every
  command preserves the invariant that the address is a valid address of the
  level it is flying at, so its cell index always lies inside the level;
* the axes wrap — the level-`d` box is a `d`-torus (`wrapFwd_lt`,
  `wrapBack_lt`), and on an axis of length `16` the wrap is literally the
  Frontier Run's (`wrapFwd_eq_frontierUp`, `wrapBack_eq_frontierDown`), so this
  is the same flight model the fourteenth door already ships;
* fuel is only ever gained at the station, the station being the Monster's own
  voxel (`fuel_le_of_ne_dock`, `dock_only_at_station`), and a ship with an empty
  tank does not move (`fly_dry`);
* the two new commands are inverse: dropping into the finer grid and lifting
  back out returns the same ship, two turns later (`ascend_descend`);
* the levels really are one map seen at two resolutions: flying along the newest
  axis never leaves the coarse cell (`fly_fine_keeps_parent`), and flying along
  any older axis is the same flight seen coarsely (`fly_coarse_projects`);
* the runs are flyable: `flight3_docks` flies a fresh ship from the origin of
  the `71 × 59 × 47` world to the station and docks it, and `flight15_docks`
  does the same in the fifteen-dimensional world, on one tank.
-/

set_option maxRecDepth 10000

namespace NixWars

namespace Monster

/-! ## Axes of a level -/

/-- The length of the axis a coordinate at index `i` runs along, at level `d`.
Off the end of the level the axis has length `1`: a world with no room to move.
-/
def axisLen (d i : Nat) : Nat := (level d).getD i 1

theorem axisLen_pos (d i : Nat) : 0 < axisLen d i :=
  getD_pos (fun x hx => worldAxes_pos x (List.mem_of_mem_take hx)) i (by decide)

theorem axisLen_eq {d i : Nat} (hi : i < d) : axisLen d i = axisAt i := by
  simp [axisLen, axisAt, level, List.getD_eq_getElem?_getD, hi]

/-- Below the top level the axes of the finer world are the axes of the coarser
one, so a coordinate that exists at both levels runs along the same axis. -/
theorem axisLen_succ {d i : Nat} (hi : i < d) : axisLen (d + 1) i = axisLen d i := by
  rw [axisLen_eq hi, axisLen_eq (Nat.lt_succ_of_lt hi)]

/-! ## Valid addresses, coordinate by coordinate -/

/-- An address is valid as soon as it has the right length and every coordinate
lies inside its axis.  The converse is `forall₂_lt_getD`. -/
theorem valid_of_getD : ∀ {L a : List Nat}, a.length = L.length →
    (∀ i, i < L.length → a.getD i 0 < L.getD i 1) → Valid L a := by
  intro L
  induction L with
  | nil =>
    intro a h _
    cases a with
    | nil => exact List.Forall₂.nil
    | cons _ _ => simp at h
  | cons p ps ih =>
    intro a h hall
    cases a with
    | nil => simp at h
    | cons c cs =>
      refine List.Forall₂.cons ?_ (ih (by simpa using h) ?_)
      · simpa using hall 0 (by simp)
      · intro i hi; simpa using hall (i + 1) (by simpa using hi)

/-- Overwriting one coordinate with a value inside its axis keeps the address
valid. -/
theorem valid_set : ∀ {L a : List Nat}, Valid L a → ∀ (i v : Nat), v < L.getD i 1 →
    Valid L (a.set i v) := by
  intro L a h
  induction h with
  | nil => intro i v _; simp
  | @cons x y xs ys hxy _ ih =>
    intro i v hv
    cases i with
    | zero => exact List.Forall₂.cons (by simpa using hv) (by assumption)
    | succ j => exact List.Forall₂.cons hxy (ih j v (by simpa using hv))

/-- Appending a coordinate to the address and its axis to the level. -/
theorem valid_append_zero : ∀ {L a : List Nat}, Valid L a → ∀ q : Nat, 0 < q →
    Valid (L ++ [q]) (a ++ [0]) := by
  intro L a h
  induction h with
  | nil => intro q hq; exact List.Forall₂.cons hq List.Forall₂.nil
  | @cons x y xs ys hxy _ ih => intro q hq; exact List.Forall₂.cons hxy (ih q hq)

/-- Dropping the last coordinate and the last axis. -/
theorem valid_dropLast : ∀ {L a : List Nat}, Valid L a → Valid L.dropLast a.dropLast := by
  intro L a h
  induction h with
  | nil => simp
  | @cons x y xs ys hxy hrest ih =>
    cases hrest with
    | nil => simp
    | @cons x' y' xs' ys' hxy' hrest' => simpa using List.Forall₂.cons hxy ih

theorem level_dropLast {d : Nat} (h : d < 15) : (level (d + 1)).dropLast = level d := by
  rw [level_succ h]
  simp

/-! ## The ship -/

/-- The top throttle notch, as on the Frontier Run. -/
def maxThrottle : Nat := frontierMaxSpeed

/-- A full tank, as on the Frontier Run. -/
def shipTank : Nat := frontierTank

/-- A ship in the voxel world. -/
structure Ship where
  /-- The level it is flying at: the number of axes of its world. -/
  dim : Nat
  /-- Its address, one coordinate per axis, coarsest axis first. -/
  pos : List Nat
  /-- The axis the nose points along. -/
  ax : Nat
  /-- Whether the nose points up that axis or down it. -/
  fwd : Bool
  /-- The throttle notch. -/
  speed : Nat
  /-- Fuel in the tank. -/
  fuel : Nat
  /-- Whether the ship is clamped to the station. -/
  docked : Bool
  /-- Command counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the flight. -/
inductive Cmd
  | /-- Point the nose along axis `a`, if the world has one. -/ aim (a : Nat)
  | /-- Reverse the nose along the current axis. -/ flip
  | /-- One more throttle notch. -/ thrust
  | /-- One less throttle notch. -/ brake
  | /-- Move `speed` cells along the heading, burning `speed` fuel. -/ fly
  | /-- Clamp to the station, or release. -/ dock
  | /-- Drop into the next finer grid: one more axis. -/ descend
  | /-- Lift into the next coarser grid: one axis fewer. -/ ascend
  deriving DecidableEq, Repr, Inhabited

/-! ## The torus -/

/-- One coordinate, moved `k` cells up an axis of length `p`, wrapping. -/
def wrapFwd (p c k : Nat) : Nat := (c + k) % p

/-- One coordinate, moved `k` cells down an axis of length `p`, wrapping. -/
def wrapBack (p c k : Nat) : Nat := (c + (p - k % p)) % p

theorem wrapFwd_lt {p : Nat} (hp : 0 < p) (c k : Nat) : wrapFwd p c k < p :=
  Nat.mod_lt _ hp

theorem wrapBack_lt {p : Nat} (hp : 0 < p) (c k : Nat) : wrapBack p c k < p :=
  Nat.mod_lt _ hp

/-- On an axis of length `16` the wrap is the Frontier Run's own. -/
theorem wrapFwd_eq_frontierUp {c k : Nat} (hc : c < 16) (hk : k < 16) :
    wrapFwd 16 c k = frontierUp c k := by
  unfold wrapFwd frontierUp
  by_cases h : c + k ≤ 15
  · rw [if_pos h, Nat.mod_eq_of_lt (by omega)]
  · rw [if_neg h, Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]

/-- … and so is the wrap the other way. -/
theorem wrapBack_eq_frontierDown {c k : Nat} (hc : c < 16) (hk : k < 16) :
    wrapBack 16 c k = frontierDown c k := by
  unfold wrapBack frontierDown
  rw [Nat.mod_eq_of_lt hk]
  by_cases h : k ≤ c
  · rw [if_pos h, show c + (16 - k) = (c - k) + 16 by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt (by omega)]
  · rw [if_neg h, show c + (16 - k) = c + 16 - k by omega, Nat.mod_eq_of_lt (by omega)]

/-! ## The station -/

/-- The station: the Monster's own voxel.  Its coordinates are the `p`-adic
exponents of the order of the Monster, read from the largest prime down and
reduced into their axes — the same reading that places the 194 rows. -/
def stationCoords : List Nat := monsterExps.reverse.zipWith (fun e p => e % p) worldAxes

/-- The station, as an address of the level-`d` world. -/
def stationPos (d : Nat) : List Nat := stationCoords.take d

theorem stationCoords_eq :
    stationCoords = [1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 6, 4, 2, 0] := by decide

/-- In the three-dimensional world the station stands on the corner
`(1, 1, 1)`. -/
theorem stationPos_three : stationPos 3 = [1, 1, 1] := by decide

/-- The station is a cell of every level. -/
theorem stationPos_valid (d : Nat) : Valid (level d) (stationPos d) :=
  valid_take (zipWith_mod_valid _ _ (by decide) (fun p hp => worldAxes_pos p hp)) d

/-! ## The transition function -/

/-- The new value of the coordinate the ship's nose points along. -/
def wrapDir (s : Ship) : Nat :=
  if s.fwd then wrapFwd (axisLen s.dim s.ax) (s.pos.getD s.ax 0) s.speed
  else wrapBack (axisLen s.dim s.ax) (s.pos.getD s.ax 0) s.speed

/-- The address the ship moves to. -/
def slide (s : Ship) : List Nat := s.pos.set s.ax (wrapDir s)

/-- Whether the ship is standing on the station's cell. -/
def atStation (s : Ship) : Bool := s.pos == stationPos s.dim

/-- The transition function of the flight. -/
def step (s : Ship) : Cmd → Ship
  | .aim a => { s with ax := (if a < s.dim then a else s.ax), turn := s.turn + 1 }
  | .flip => { s with fwd := !s.fwd, turn := s.turn + 1 }
  | .thrust =>
      { s with
        speed := (if s.docked = false ∧ s.speed < maxThrottle then s.speed + 1 else s.speed),
        turn := s.turn + 1 }
  | .brake => { s with speed := s.speed - 1, turn := s.turn + 1 }
  | .fly =>
      if s.docked = false ∧ s.speed ≤ s.fuel then
        { s with pos := slide s, fuel := s.fuel - s.speed, turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }
  | .dock =>
      if s.docked then { s with docked := false, turn := s.turn + 1 }
      else if atStation s then
        { s with docked := true, speed := 0, fuel := shipTank, turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }
  | .descend =>
      if s.dim < 15 then
        { s with dim := s.dim + 1, pos := s.pos ++ [0], turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }
  | .ascend =>
      if 0 < s.dim then
        { s with dim := s.dim - 1
                 pos := s.pos.dropLast
                 ax := (if s.ax + 1 < s.dim then s.ax else 0)
                 turn := s.turn + 1 }
      else { s with turn := s.turn + 1 }

/-- A whole flight plan. -/
def run (s : Ship) (cs : List Cmd) : Ship := cs.foldl step s

/-- A fresh ship at the origin of the level-`d` world, on a full tank. -/
def freshShip (d : Nat) : Ship :=
  { dim := d, pos := List.replicate d 0, ax := 0, fwd := true, speed := 0,
    fuel := shipTank, docked := false, turn := 0 }

/-- The cell of the world the ship is in. -/
def index (s : Ship) : Nat := encode (level s.dim) s.pos

/-! ## The ship never leaves the world -/

/-- The flight invariant: the ship is flying a real level of the world, its
address is a valid address of that level, its nose points along an axis the
world has, and the throttle is inside its range. -/
structure Ok (s : Ship) : Prop where
  /-- The level exists. -/
  dim_le : s.dim ≤ 15
  /-- One coordinate per axis. -/
  len : s.pos.length = s.dim
  /-- Every coordinate is inside its axis. -/
  valid : Valid (level s.dim) s.pos
  /-- The nose points along an axis of the world, or lies parked at the first
  one. -/
  ax_ok : s.ax < s.dim ∨ s.ax = 0
  /-- The throttle is inside its range. -/
  speed_le : s.speed ≤ maxThrottle

theorem valid_replicate_zero {d : Nat} (h : d ≤ 15) : Valid (level d) (List.replicate d 0) := by
  refine valid_of_getD (by simp [level_length h]) ?_
  intro i hi
  rw [level_length h] at hi
  rw [List.getD_replicate _ hi]
  exact axisLen_pos d i

theorem freshShip_ok {d : Nat} (h : d ≤ 15) : Ok (freshShip d) where
  dim_le := h
  len := by simp [freshShip]
  valid := valid_replicate_zero h
  ax_ok := Or.inr rfl
  speed_le := by simp [freshShip]

theorem slide_valid {s : Ship} (h : Ok s) : Valid (level s.dim) (slide s) := by
  refine valid_set h.valid _ _ ?_
  have hp : 0 < axisLen s.dim s.ax := axisLen_pos _ _
  show wrapDir s < (level s.dim).getD s.ax 1
  rw [← axisLen]
  unfold wrapDir
  split
  · exact wrapFwd_lt hp _ _
  · exact wrapBack_lt hp _ _

theorem slide_length (s : Ship) : (slide s).length = s.pos.length := by
  simp [slide]

/-- **Every command keeps the ship inside the world.** -/
theorem step_ok {s : Ship} (h : Ok s) (c : Cmd) : Ok (step s c) := by
  cases c with
  | aim a =>
    simp only [step]
    refine { h with ax_ok := ?_ }
    split
    · exact Or.inl (by assumption)
    · exact h.ax_ok
  | flip => exact { h with }
  | thrust =>
    simp only [step]
    refine { h with speed_le := ?_ }
    split
    · rename_i hc
      have hs := hc.2
      show s.speed + 1 ≤ maxThrottle
      omega
    · exact h.speed_le
  | brake => exact { h with speed_le := le_trans (Nat.sub_le _ _) h.speed_le }
  | fly =>
    simp only [step]
    split
    · exact { h with len := (by rw [slide_length]; exact h.len)
                     valid := slide_valid h }
    · exact { h with }
  | dock =>
    simp only [step]
    split
    · exact { h with }
    · split
      · exact { h with speed_le := Nat.zero_le _ }
      · exact { h with }
  | descend =>
    simp only [step]
    split
    · rename_i hd
      refine { dim_le := (show s.dim + 1 ≤ 15 by omega)
               len := (by simp [h.len])
               valid := ?_
               ax_ok := ?_
               speed_le := h.speed_le }
      · rw [level_succ hd]
        exact valid_append_zero h.valid _ (axisAt_pos _)
      · rcases h.ax_ok with hax | hax
        · exact Or.inl (show s.ax < s.dim + 1 by omega)
        · exact Or.inr hax
    · exact { h with }
  | ascend =>
    simp only [step]
    split
    · rename_i hd
      obtain ⟨e, he⟩ : ∃ e, s.dim = e + 1 := ⟨s.dim - 1, by omega⟩
      have hdle := h.dim_le
      have he15 : e < 15 := by omega
      refine { dim_le := (show s.dim - 1 ≤ 15 by omega)
               len := (by simp [h.len])
               valid := ?_
               ax_ok := ?_
               speed_le := h.speed_le }
      · have hv := valid_dropLast h.valid
        show Valid (level (s.dim - 1)) s.pos.dropLast
        rw [he] at hv ⊢
        simpa [level_dropLast he15] using hv
      · show (if s.ax + 1 < s.dim then s.ax else 0) < s.dim - 1 ∨
            (if s.ax + 1 < s.dim then s.ax else 0) = 0
        split
        · exact Or.inl (by omega)
        · exact Or.inr rfl
    · exact { h with }

/-- **A whole flight keeps the ship inside the world.** -/
theorem run_ok {s : Ship} (h : Ok s) (cs : List Cmd) : Ok (run s cs) := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih (step_ok h c)

/-- The ship is always in a cell of the level it is flying at. -/
theorem index_lt {s : Ship} (h : Ok s) : index s < cells s.dim :=
  encode_lt h.valid

/-! ## Fuel and the station -/

/-- Fuel is never gained except by docking. -/
theorem fuel_le_of_ne_dock {s : Ship} {c : Cmd} (h : c ≠ Cmd.dock) :
    (step s c).fuel ≤ s.fuel := by
  cases c with
  | dock => exact absurd rfl h
  | fly =>
    simp only [step]
    split
    · exact Nat.sub_le _ _
    · exact Nat.le_refl _
  | aim a => simp [step]
  | flip => simp [step]
  | thrust => simp [step]
  | brake => simp [step]
  | descend => simp only [step]; split <;> exact Nat.le_refl _
  | ascend => simp only [step]; split <;> exact Nat.le_refl _

/-- The clamp only closes on the station's own cell. -/
theorem dock_only_at_station {s : Ship} (h : s.docked = false)
    (hs : atStation s = false) : (step s Cmd.dock).docked = false := by
  simp [step, h, hs]

/-- A ship whose tank cannot pay for the throttle does not move. -/
theorem fly_dry {s : Ship} (h : s.fuel < s.speed) : (step s Cmd.fly).pos = s.pos := by
  have hno : ¬ (s.docked = false ∧ s.speed ≤ s.fuel) := by
    rintro ⟨-, h2⟩; omega
  simp [step, hno]

/-- A docked ship does not move. -/
theorem fly_docked {s : Ship} (h : s.docked = true) : (step s Cmd.fly).pos = s.pos := by
  simp [step, h]

/-! ## The two new commands are inverse -/

/-- Dropping into the finer grid and lifting straight back out returns the same
ship, two turns later. -/
theorem ascend_descend {s : Ship} (h : Ok s) (hd : s.dim < 15) :
    step (step s Cmd.descend) Cmd.ascend = { s with turn := s.turn + 2 } := by
  have hax : (if s.ax + 1 < s.dim + 1 then s.ax else 0) = s.ax := by
    rcases h.ax_ok with hlt | h0
    · rw [if_pos (by omega)]
    · split <;> simp [h0]
  simp only [step, if_pos hd, if_pos (Nat.succ_pos s.dim), hax]
  cases s
  simp [Nat.add_assoc]

/-! ## One map, two resolutions -/

/-- The ship as seen at the next coarser level: the last coordinate is dropped.
-/
def proj (s : Ship) : Ship :=
  { s with dim := s.dim - 1, pos := s.pos.dropLast }

theorem dropLast_set : ∀ (l : List Nat) (i v : Nat), i + 1 < l.length →
    (l.set i v).dropLast = l.dropLast.set i v := by
  intro l
  induction l with
  | nil => intro i v h; simp at h
  | cons a t ih =>
    intro i v h
    cases i with
    | zero =>
      cases t with
      | nil => simp at h
      | cons b u => simp
    | succ j =>
      cases t with
      | nil => simp at h
      | cons b u =>
        have h' : j + 1 < (b :: u).length := by simpa using h
        have hne : ((b :: u).set j v) ≠ [] := by simp
        rw [List.set_cons_succ, List.dropLast_cons_of_ne_nil hne, ih j v h',
          List.dropLast_cons_of_ne_nil (by simp : (b :: u) ≠ []), List.set_cons_succ]

theorem getD_append_singleton {a : List Nat} {c e : Nat} (h : a.length = e) :
    (a ++ [c]).getD e 0 = c := by
  subst h; simp [List.getD_eq_getElem?_getD]

theorem set_append_singleton {a : List Nat} {c v e : Nat} (h : a.length = e) :
    (a ++ [c]).set e v = a ++ [v] := by
  subst h; simp

/-- Flying along the newest axis stays inside the same coarse cell: the finest
axis is exactly the resolution the coarse grid cannot see. -/
theorem fly_fine_keeps_parent {s : Ship} (h : Ok s) {e : Nat} (hdim : s.dim = e + 1)
    (hax : s.ax = e) (he : e < 15) :
    parent e (index (step s Cmd.fly)) = parent e (index s) := by
  have hlen : s.pos.length = e + 1 := by rw [h.len, hdim]
  obtain ⟨a, c, hpos⟩ : ∃ a c, s.pos = a ++ [c] :=
    ⟨s.pos.dropLast, s.pos.getLast (by intro hnil; rw [hnil] at hlen; simp at hlen),
      (List.dropLast_append_getLast _).symm⟩
  have halen : a.length = e := by
    rw [hpos] at hlen; simpa using hlen
  have hcs : c < axisAt e := by
    have hv := forall₂_lt_getD h.valid e (by omega)
    rw [hdim] at hv
    rw [hpos, getD_append_singleton halen] at hv
    rwa [← axisLen, axisLen_eq (Nat.lt_succ_self e)] at hv
  have hslide : slide s = a ++ [wrapDir s] := by
    simp only [slide, hax, hpos]
    exact set_append_singleton halen
  have hwlt : wrapDir s < axisAt e := by
    have hp : 0 < axisLen s.dim s.ax := axisLen_pos _ _
    have : wrapDir s < axisLen s.dim s.ax := by
      unfold wrapDir
      split
      · exact wrapFwd_lt hp _ _
      · exact wrapBack_lt hp _ _
    rwa [hdim, hax, axisLen_eq (Nat.lt_succ_self e)] at this
  simp only [step]
  split
  · simp only [index, hdim, hslide, hpos, encode_child he halen, parent_child _ _ hwlt,
      parent_child _ _ hcs]
  · simp only [index, hdim]

/-- Flying along any older axis is the same flight, seen at the coarser
resolution: the projection of the flown ship is the flight of the projection. -/
theorem fly_coarse_projects {s : Ship} (h : Ok s) {e : Nat} (hdim : s.dim = e + 1)
    (hax : s.ax < e) :
    (proj (step s Cmd.fly)).pos = (step (proj s) Cmd.fly).pos := by
  have hlen : s.pos.length = e + 1 := by rw [h.len, hdim]
  have hax' : s.ax + 1 < s.pos.length := by omega
  have haxlen : axisLen (s.dim - 1) s.ax = axisLen s.dim s.ax := by
    rw [hdim, Nat.add_sub_cancel]
    exact (axisLen_succ hax).symm
  have hgd : s.pos.dropLast.getD s.ax 0 = s.pos.getD s.ax 0 := by
    rw [List.getD_eq_getElem?_getD, List.getD_eq_getElem?_getD, List.getElem?_dropLast,
      if_pos (by omega : s.ax < s.pos.length - 1)]
  simp only [step, proj]
  split
  · simp only [slide, wrapDir, haxlen, hgd]
    exact dropLast_set s.pos s.ax _ hax'
  · rfl

/-! ## The runs are flyable -/

/-- Fly `n` cells up the current axis, one cell at a time. -/
def hop (n : Nat) : List Cmd := List.replicate n Cmd.fly

/-- Point along axis `i` and hop to coordinate `c`, at throttle one. -/
def leg (i c : Nat) : List Cmd := Cmd.aim i :: hop c

/-- A course to the station of the level-`d` world: aim down each axis in turn
and hop to the station's coordinate on it. -/
def courseToStation (d : Nat) : List Cmd :=
  Cmd.thrust :: ((List.range d).flatMap (fun i => leg i ((stationPos d).getD i 0))) ++ [Cmd.dock]

/-- **The three-dimensional world is flyable**: a fresh ship at the origin of
the `71 × 59 × 47` box reaches the station and docks. -/
theorem flight3_docks : (run (freshShip 3) (courseToStation 3)).docked = true := by decide

/-- … it arrives at the station's cell. -/
theorem flight3_at_station : (run (freshShip 3) (courseToStation 3)).pos = stationPos 3 := by
  decide

/-- **The fifteen-dimensional world is flyable too**, on one tank. -/
theorem flight15_docks : (run (freshShip 15) (courseToStation 15)).docked = true := by decide

/-- … at the station's cell, the course having burned 26 of the 71 units of
fuel before the clamp refilled the tank. -/
theorem flight15_at_station : (run (freshShip 15) (courseToStation 15)).pos = stationPos 15 := by
  decide

/-- The fifteen-dimensional course is 43 commands long. -/
theorem courseToStation_15_length : (courseToStation 15).length = 43 := by decide

/-- The ship that flew it is still a legal ship. -/
theorem flight15_ok : Ok (run (freshShip 15) (courseToStation 15)) :=
  run_ok (freshShip_ok (by norm_num)) _

end Monster

end NixWars
