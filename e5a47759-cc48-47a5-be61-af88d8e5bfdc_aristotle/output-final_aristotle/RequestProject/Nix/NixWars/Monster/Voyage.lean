import RequestProject.Nix.NixWars.Monster.Moonshine

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# Flying the irrep worlds

`Project.lean` puts everything in the game into a box of cells cut by primes,
and `Moonshine.lean` says how to walk from one such box to another — divide by
`p` to take an axis off, multiply by `p` to put one on.  This file puts a
*player* into that picture: the game is modelled as a ship whose position is an
address in the current irrep, and whose commands are the moves of the model —
one cell along an axis, or a step of a path to the world next door.

* A `Ship` is a world (an `Irrep`) and an address in it.  It is `Aboard` when
  the address is a valid address of that world; `Ship.cell` is the cell of the
  world it occupies (`cell_lt`: always inside the world).
* `Cmd.fwd i` / `Cmd.back i` fly one cell along axis `i`, wrapping: each axis is
  a circle, so the world is a torus (`back_fwd`, `fwd_back`).
* `Cmd.warp p` is `Moonshine.Step.mul p` flown by the player — it drops the ship
  into the finer world with one more axis, at coordinate `0` on the new axis —
  and `Cmd.drop p` is `Step.div p`, lifting it back out.  The two are inverse
  (`drop_warp`).
* Flying a whole path is `travel`; the world it arrives in is exactly the box
  `Moonshine.walk` says (`travel_world`), with as many cells as `runPath` says
  (`travel_size`), and the ship is still aboard (`travel_aboard`).  `ladder` —
  the game's own `÷47 ×41 ×31 ×4` — is flown in `ladder_voyage_*`.
* **The player can fly anywhere.**  `route S T` is an explicit flight plan from
  any ship to any other: strip the axes of the world you are in, build the axes
  of the world you want, then fly out along each of its axes.  `route_flies`
  says it lands exactly on `T`, `route_length` says how long it takes, and
  `route_aboard` that it never leaves the world on the way.
* `shipOfCan` parks the ship on a given can of the world, so `route_to_can`
  flies the player to any can of any irrep, and `can_at_ship` reads back the can
  it is sitting on.
-/

namespace NixWars

namespace Monster

namespace Voyage

open Moonshine

/-! ## Ships -/

/-- A ship in the irrep worlds: which world it is in, and where in it. -/
structure Ship where
  /-- The world (the box of cells) the ship is flying in. -/
  world : Irrep
  /-- The ship's address: one coordinate per axis of `world`. -/
  addr : List Nat
deriving DecidableEq, Repr

namespace Ship

/-- A ship is *aboard* when its address is a genuine address of its world. -/
def Aboard (S : Ship) : Prop := Valid S.world.axes S.addr

/-- The cell of its world the ship occupies. -/
def cell (S : Ship) : Nat := encode S.world.axes S.addr

/-- The dimension of the world the ship is in. -/
def dim (S : Ship) : Nat := S.world.dim

/-- Every axis of the world a ship is aboard of has room in it. -/
theorem axes_pos_of_aboard {S : Ship} (h : S.Aboard) : ∀ p ∈ S.world.axes, 0 < p := by
  have : ∀ {a L : List Nat}, Valid L a → ∀ p ∈ L, 0 < p := by
    intro a L h
    induction h with
    | nil => intro p hp; simp at hp
    | @cons x y xs ys hxy _ ih =>
        intro p hp
        rcases List.mem_cons.1 hp with rfl | hp
        · exact Nat.lt_of_le_of_lt (Nat.zero_le x) hxy
        · exact ih p hp
  exact this h

/-- A ship that is aboard is inside its world. -/
theorem cell_lt {S : Ship} (h : S.Aboard) : S.cell < S.world.size :=
  encode_lt h

/-- The address has one coordinate per axis. -/
theorem addr_length {S : Ship} (h : S.Aboard) : S.addr.length = S.dim :=
  (List.Forall₂.length_eq h)

end Ship

/-! ## Commands -/

/-- What the player can do: fly one cell along an axis either way, or take one
step of a path between the worlds. -/
inductive Cmd where
  /-- Fly one cell forward along axis `i`, wrapping at the end. -/
  | fwd (i : Nat)
  /-- Fly one cell back along axis `i`, wrapping at the start. -/
  | back (i : Nat)
  /-- Multiply in the axis `p`: enter the finer world, at coordinate `0`. -/
  | warp (p : Nat)
  /-- Divide out the axis `p`: leave that axis behind. -/
  | drop (p : Nat)
deriving DecidableEq, Repr

/-- Change the coordinate at index `i` by `f`, the axis it runs along being
passed to `f` as well.  Off the end of the address nothing happens. -/
def moveAt (f : Nat → Nat → Nat) : List Nat → List Nat → Nat → List Nat
  | p :: _, x :: xs, 0 => f x p :: xs
  | _ :: ps, x :: xs, i + 1 => x :: moveAt f ps xs i
  | _, a, _ => a

/-- One cell forward along an axis of length `p`. -/
def up (x p : Nat) : Nat := (x + 1) % p

/-- One cell back along an axis of length `p`. -/
def down (x p : Nat) : Nat := (x + (p - 1)) % p

/-- Playing one command. -/
def step : Cmd → Ship → Ship
  | Cmd.fwd i, S => ⟨S.world, moveAt up S.world.axes S.addr i⟩
  | Cmd.back i, S => ⟨S.world, moveAt down S.world.axes S.addr i⟩
  | Cmd.warp p, S =>
      if 0 < p then ⟨(Step.mul p).onIrrep S.world, 0 :: S.addr⟩ else S
  | Cmd.drop p, S =>
      if p ∈ S.world.axes then
        ⟨(Step.div p).onIrrep S.world, S.addr.eraseIdx (S.world.axes.idxOf p)⟩
      else S

/-- Playing a list of commands, first to last. -/
def run (cs : List Cmd) (S : Ship) : Ship := cs.foldl (fun T c => step c T) S

@[simp] theorem run_nil (S : Ship) : run [] S = S := rfl

@[simp] theorem run_cons (c : Cmd) (cs : List Cmd) (S : Ship) :
    run (c :: cs) S = run cs (step c S) := rfl

theorem run_append (cs ds : List Cmd) (S : Ship) :
    run (cs ++ ds) S = run ds (run cs S) := by
  induction cs generalizing S with
  | nil => simp
  | cons c cs ih => simp [ih]

/-! ## The ship never leaves the world -/

theorem up_lt {x p : Nat} (hp : 0 < p) : up x p < p := Nat.mod_lt _ hp

theorem down_lt {x p : Nat} (hp : 0 < p) : down x p < p := Nat.mod_lt _ hp

theorem moveAt_valid {f : Nat → Nat → Nat} (hf : ∀ x p, 0 < p → f x p < p) :
    ∀ {L a : List Nat}, Valid L a → ∀ i, Valid L (moveAt f L a i) := by
  intro L a h
  induction h with
  | nil => intro i; cases i <;> simp [moveAt]
  | @cons x p xs ps hxp hrest ih =>
      intro i
      cases i with
      | zero =>
          exact List.Forall₂.cons (hf x p (Nat.lt_of_le_of_lt (Nat.zero_le x) hxp)) hrest
      | succ i => exact List.Forall₂.cons hxp (ih i)

theorem valid_eraseIdx : ∀ {L a : List Nat}, Valid L a → ∀ i,
    Valid (L.eraseIdx i) (a.eraseIdx i) := by
  intro L a h
  induction h with
  | nil => intro i; simp
  | @cons x p xs ps hxp hrest ih =>
      intro i
      cases i with
      | zero => simpa using hrest
      | succ i => exact List.Forall₂.cons hxp (ih i)

/-- `List.erase` removes the coordinate at the index `idxOf` names. -/
theorem erase_eq_eraseIdx_idxOf {p : Nat} : ∀ {L : List Nat},
    L.erase p = L.eraseIdx (L.idxOf p)
  | [] => rfl
  | q :: qs => by
      by_cases h : q = p
      · subst h; simp
      · have hb : (q == p) = false := beq_eq_false_iff_ne.mpr h
        simp [List.idxOf, List.findIdx_cons, hb, erase_eq_eraseIdx_idxOf (L := qs)]

/-- **Every command keeps the ship in its world.** -/
theorem step_aboard {S : Ship} (h : S.Aboard) (c : Cmd) : (step c S).Aboard := by
  cases c with
  | fwd i => exact moveAt_valid (fun _ _ hp => up_lt hp) h i
  | back i => exact moveAt_valid (fun _ _ hp => down_lt hp) h i
  | warp p =>
      by_cases hp : 0 < p
      · simpa [step, hp, Ship.Aboard, Step.onIrrep] using List.Forall₂.cons hp h
      · simpa [step, hp] using h
  | drop p =>
      by_cases hp : p ∈ S.world.axes
      · have hv := valid_eraseIdx h (S.world.axes.idxOf p)
        show Valid ((step (Cmd.drop p) S).world.axes) ((step (Cmd.drop p) S).addr)
        rw [step, if_pos hp]
        show Valid (S.world.axes.erase p) (S.addr.eraseIdx (S.world.axes.idxOf p))
        rw [erase_eq_eraseIdx_idxOf]
        exact hv
      · simpa [step, hp] using h

/-- **A whole flight keeps the ship in its world.** -/
theorem run_aboard {S : Ship} (h : S.Aboard) (cs : List Cmd) : (run cs S).Aboard := by
  induction cs generalizing S with
  | nil => simpa using h
  | cons c cs ih => exact ih (step_aboard h c)

/-- A ship that is flying is always inside the box it is flying in. -/
theorem run_cell_lt {S : Ship} (h : S.Aboard) (cs : List Cmd) :
    (run cs S).cell < (run cs S).world.size :=
  Ship.cell_lt (run_aboard h cs)

/-! ## The axes are circles -/

theorem down_up {x p : Nat} (hx : x < p) : down (up x p) p = x := by
  have hp : 0 < p := Nat.lt_of_le_of_lt (Nat.zero_le x) hx
  rcases Nat.lt_or_ge (x + 1) p with h | h
  · have : up x p = x + 1 := by simp [up, Nat.mod_eq_of_lt h]
    rw [this]
    have : x + 1 + (p - 1) = x + p := by omega
    simp [down, this, Nat.add_mod_right, Nat.mod_eq_of_lt hx]
  · have hxp : x + 1 = p := by omega
    have : up x p = 0 := by simp [up, hxp]
    rw [this]
    have : 0 + (p - 1) = x := by omega
    simp [down, this, Nat.mod_eq_of_lt hx]

theorem up_down {x p : Nat} (hx : x < p) : up (down x p) p = x := by
  have hp : 0 < p := Nat.lt_of_le_of_lt (Nat.zero_le x) hx
  rcases Nat.eq_zero_or_pos x with rfl | hx0
  · have h1 : down 0 p = p - 1 := by
      simp [down, Nat.mod_eq_of_lt (show p - 1 < p by omega)]
    rw [h1]
    have : p - 1 + 1 = p := by omega
    simp [up, this]
  · have h1 : down x p = x - 1 := by
      have : x + (p - 1) = (x - 1) + p := by omega
      simp [down, this, Nat.add_mod_right, Nat.mod_eq_of_lt (show x - 1 < p by omega)]
    rw [h1]
    have : x - 1 + 1 = x := by omega
    simp [up, this, Nat.mod_eq_of_lt hx]

theorem moveAt_inv {f g : Nat → Nat → Nat} (hg : ∀ {x p}, x < p → g (f x p) p = x) :
    ∀ {L a : List Nat}, Valid L a → ∀ i,
      moveAt g L (moveAt f L a i) i = a := by
  intro L a h
  induction h with
  | nil => intro i; cases i <;> simp [moveAt]
  | @cons x p xs ps hxp hrest ih =>
      intro i
      cases i with
      | zero => simp [moveAt, hg hxp]
      | succ i => simp [moveAt, ih i]

/-- **The axes are circles**: flying one cell forward and one cell back returns
the ship to where it was. -/
theorem back_fwd {S : Ship} (h : S.Aboard) (i : Nat) :
    step (Cmd.back i) (step (Cmd.fwd i) S) = S := by
  have := moveAt_inv (f := up) (g := down) (fun hx => down_up hx) h i
  simp [step, this]

/-- And the other way round. -/
theorem fwd_back {S : Ship} (h : S.Aboard) (i : Nat) :
    step (Cmd.fwd i) (step (Cmd.back i) S) = S := by
  have := moveAt_inv (f := down) (g := up) (fun hx => up_down hx) h i
  simp [step, this]

/-! ## Warping between worlds -/

/-- **Dropping into a finer world and lifting back out returns the ship.** -/
theorem drop_warp {S : Ship} {p : Nat} (hp : 0 < p) :
    step (Cmd.drop p) (step (Cmd.warp p) S) = S := by
  simp [step, hp, Step.onIrrep]

/-- Dropping the leading axis peels the head off both lists. -/
theorem step_drop_head (p x : Nat) (ps xs : List Nat) :
    step (Cmd.drop p) ⟨⟨p :: ps⟩, x :: xs⟩ = ⟨⟨ps⟩, xs⟩ := by
  simp [step, Step.onIrrep]

/-- Warping puts an axis on and starts you at its origin. -/
theorem step_warp (p : Nat) (hp : 0 < p) (I : Irrep) (a : List Nat) :
    step (Cmd.warp p) ⟨I, a⟩ = ⟨⟨p :: I.axes⟩, 0 :: a⟩ := by
  simp [step, hp, Step.onIrrep]

/-! ## Flying a path of `Moonshine.lean` -/

/-- The command that flies one step of a path. -/
def cmdOfStep : Step → Cmd
  | Step.mul p => Cmd.warp p
  | Step.div p => Cmd.drop p

/-- The flight plan of a path. -/
def plan (P : Path) : List Cmd := P.map cmdOfStep

/-- Flying a whole path. -/
def travel (P : Path) (S : Ship) : Ship := run (plan P) S

@[simp] theorem travel_nil (S : Ship) : travel [] S = S := rfl

@[simp] theorem travel_cons (s : Step) (P : Path) (S : Ship) :
    travel (s :: P) S = travel P (step (cmdOfStep s) S) := rfl

/-- **The world the player arrives in is the box the path says.** -/
theorem travel_world : ∀ (P : Path) {S : Ship}, axesOk P S.world →
    (travel P S).world = walk P S.world := by
  intro P
  induction P with
  | nil => intro S _; simp
  | cons s P ih =>
      intro S h
      cases s with
      | mul p =>
          obtain ⟨hp, hrest⟩ := h
          have hstep : (step (cmdOfStep (Step.mul p)) S).world = (Step.mul p).onIrrep S.world := by
            simp [cmdOfStep, step, hp]
          rw [travel_cons, walk_cons, ih (by rw [hstep]; exact hrest), hstep]
      | div p =>
          obtain ⟨_, hmem, hrest⟩ := h
          have hstep : (step (cmdOfStep (Step.div p)) S).world = (Step.div p).onIrrep S.world := by
            simp [cmdOfStep, step, hmem]
          rw [travel_cons, walk_cons, ih (by rw [hstep]; exact hrest), hstep]

/-- **And it has as many cells as the path says.** -/
theorem travel_size {P : Path} {S : Ship} (h : axesOk P S.world) :
    (travel P S).world.size = runPath P S.world.size := by
  rw [travel_world P h, walk_size P h]

/-- Flying a path keeps the ship aboard. -/
theorem travel_aboard {S : Ship} (h : S.Aboard) (P : Path) : (travel P S).Aboard :=
  run_aboard h (plan P)

/-! ## Flying anywhere: the explicit flight plan -/

/-- Strip the world you are in, axis by axis, down to the single-celled world. -/
def strip : List Nat → List Cmd
  | [] => []
  | p :: ps => Cmd.drop p :: strip ps

/-- Build a world and an address in it out of the single-celled world: the tail
first, then the leading axis, then fly out along it. -/
def build : List Nat → List Nat → List Cmd
  | [], _ => []
  | p :: ps, xs =>
      build ps xs.tail ++ (Cmd.warp p :: List.replicate (xs.headD 0) (Cmd.fwd 0))

/-- The flight plan from one ship to any other. -/
def route (S T : Ship) : List Cmd := strip S.world.axes ++ build T.world.axes T.addr

/-- The empty world: one cell, no axes.  Every flight passes through it. -/
def home : Ship := ⟨⟨[]⟩, []⟩

theorem home_aboard : home.Aboard := List.Forall₂.nil

/-- Stripping a world, axis by axis, leaves the ship at `home`. -/
theorem strip_flies_aux : ∀ {L a : List Nat}, Valid L a →
    run (strip L) ⟨⟨L⟩, a⟩ = home := by
  intro L a h
  induction h with
  | nil => rfl
  | @cons x p xs ps _ _ ih =>
      simp only [strip, run_cons, step_drop_head]
      exact ih

/-- Stripping a ship's world leaves it at `home`. -/
theorem strip_flies {S : Ship} (h : S.Aboard) : run (strip S.world.axes) S = home :=
  strip_flies_aux h

/-- Flying forward along the leading axis, one cell at a time. -/
theorem run_fwd_replicate (p : Nat) (ps xs : List Nat) :
    ∀ (k y : Nat), y < p → run (List.replicate k (Cmd.fwd 0)) ⟨⟨p :: ps⟩, y :: xs⟩
      = ⟨⟨p :: ps⟩, (y + k) % p :: xs⟩ := by
  intro k
  induction k with
  | zero => intro y hy; simp [Nat.mod_eq_of_lt hy]
  | succ k ih =>
      intro y hy
      have hp : 0 < p := Nat.lt_of_le_of_lt (Nat.zero_le y) hy
      rw [List.replicate_succ, run_cons]
      have hstep : step (Cmd.fwd 0) (Ship.mk ⟨p :: ps⟩ (y :: xs))
          = ⟨⟨p :: ps⟩, (y + 1) % p :: xs⟩ := by simp [step, moveAt, up]
      rw [hstep, ih ((y + 1) % p) (Nat.mod_lt _ hp)]
      have : ((y + 1) % p + k) % p = (y + (k + 1)) % p := by
        rw [Nat.mod_add_mod]
        congr 1
        omega
      rw [this]

/-- Building a world out of `home` lands exactly on the ship you asked for. -/
theorem build_flies_aux : ∀ {L a : List Nat}, Valid L a →
    run (build L a) home = ⟨⟨L⟩, a⟩ := by
  intro L a h
  induction h with
  | nil => rfl
  | @cons x p xs ps hx _ ih =>
      have hp : 0 < p := Nat.lt_of_le_of_lt (Nat.zero_le x) hx
      simp only [build, List.tail_cons, List.headD_cons, run_append, ih, run_cons]
      rw [step_warp p hp, run_fwd_replicate p ps xs x 0 hp]
      simp [Nat.mod_eq_of_lt hx]

/-- Building a world out of `home` lands exactly on the ship you asked for. -/
theorem build_flies {S : Ship} (h : S.Aboard) : run (build S.world.axes S.addr) home = S :=
  build_flies_aux h

/-- **The player can fly anywhere.**  `route S T` is an explicit flight plan
carrying any ship to any other ship, however far apart their worlds are. -/
theorem route_flies {S T : Ship} (hS : S.Aboard) (hT : T.Aboard) :
    run (route S T) S = T := by
  rw [route, run_append, strip_flies hS, build_flies hT]

/-- Nowhere on the flight does the ship leave the world it is in. -/
theorem route_aboard {S T : Ship} (hS : S.Aboard) (k : Nat) :
    (run ((route S T).take k) S).Aboard := run_aboard hS _

theorem strip_length (L : List Nat) : (strip L).length = L.length := by
  induction L with
  | nil => rfl
  | cons p ps ih => simp [strip, ih]

theorem build_length : ∀ (L a : List Nat), a.length = L.length →
    (build L a).length = L.length + a.sum := by
  intro L
  induction L with
  | nil => intro a ha; simp [build, List.eq_nil_of_length_eq_zero (by simpa using ha)]
  | cons p ps ih =>
      intro a ha
      cases a with
      | nil => simp at ha
      | cons x xs =>
          have hxs : xs.length = ps.length := by simpa using ha
          simp only [build, List.tail_cons, List.headD_cons, List.length_append,
            List.length_cons, List.length_replicate, ih xs hxs, List.sum_cons]
          omega

/-- **How long the flight takes**: one command to take off each axis of the
world you are leaving, one to put on each axis of the world you want, and one
cell of flying for each unit of the address you are heading for. -/
theorem route_length {S T : Ship} (hT : T.Aboard) :
    (route S T).length = S.dim + T.dim + T.addr.sum := by
  rw [route, List.length_append, strip_length, build_length _ _ (Ship.addr_length hT)]
  simp [Ship.dim, Irrep.dim]
  omega

/-! ## The cans of the world -/

/-- The ship parked on the can numbered `n` of the world `I`. -/
def shipOfCan (I : Irrep) (n : Nat) : Ship := ⟨I, I.coords n⟩

theorem shipOfCan_aboard {I : Irrep} (h : ∀ p ∈ I.axes, 0 < p) (n : Nat) :
    (shipOfCan I n).Aboard := Irrep.coords_valid h n

theorem shipOfCan_cell (I : Irrep) (n : Nat) : (shipOfCan I n).cell = I.cell n := rfl

/-- The can the ship is sitting on. -/
def canAt (S : Ship) : Nat := S.world.lift S.cell

/-- **Reading the can back off the cell**: a ship parked on can `n` of a legit
world is sitting on can `n`. -/
theorem can_at_ship {I : Irrep} (hI : I.Legit) {n : Nat} (hn : n < I.size) :
    canAt (shipOfCan I n) = n := by
  have := Irrep.lift_cell hI n
  simpa [canAt, shipOfCan, Ship.cell, Irrep.cell, Nat.mod_eq_of_lt hn] using this

/-- **The player can fly to any can of any world**: an explicit flight plan from
wherever the ship is to the cell holding the can numbered `n`. -/
theorem route_to_can {S : Ship} (hS : S.Aboard) {I : Irrep} (hI : ∀ p ∈ I.axes, 0 < p)
    (n : Nat) : run (route S (shipOfCan I n)) S = shipOfCan I n :=
  route_flies hS (shipOfCan_aboard hI n)

/-! ## Worked flights -/

/-- A ship whose coordinates are all inside their axes is aboard; `ltAll` is the
decidable check of `Place.lean`, so the worked flights below can be checked by
the kernel. -/
theorem aboard_of_ltAll {S : Ship} (h : ltAll S.addr S.world.axes = true) : S.Aboard :=
  valid_of_ltAll h

/-- The ship the worked flights start from: the origin of `71 × 59 × 47`. -/
def start3 : Ship := ⟨Irrep.irrep3, [0, 0, 0]⟩

theorem start3_aboard : start3.Aboard := aboard_of_ltAll (by decide)

/-- A worked flight inside the first world: three cells along the `71` axis, two
along the `59` axis, one back along the `47` axis. -/
def tour3 : List Cmd :=
  [Cmd.fwd 0, Cmd.fwd 0, Cmd.fwd 0, Cmd.fwd 1, Cmd.fwd 1, Cmd.back 2]

theorem tour3_lands : run tour3 start3 = ⟨Irrep.irrep3, [3, 2, 46]⟩ := by decide

theorem tour3_cell : (run tour3 start3).cell = 3 * (59 * 47) + 2 * 47 + 46 := by decide

/-- Flying the tour and flying it backwards returns the ship to the origin. -/
theorem tour3_round_trip :
    run (tour3 ++ [Cmd.fwd 2, Cmd.back 1, Cmd.back 1, Cmd.back 0, Cmd.back 0, Cmd.back 0])
      start3 = start3 := by decide

/-- A ship somewhere in the first world, about to fly the game's own path. -/
def voyager : Ship := ⟨Irrep.irrep3, [3, 4, 5]⟩

theorem voyager_aboard : voyager.Aboard := aboard_of_ltAll (by decide)

/-- **Flying `÷47 ×41 ×31 ×4`**: the ship leaves the `47` axis behind and
arrives in `4 × 31 × 41 × 71 × 59`, at the origin of each new axis. -/
theorem ladder_voyage : travel ladder voyager = ⟨irrepNext, [0, 0, 0, 3, 4]⟩ := by decide

theorem ladder_voyage_world : (travel ladder voyager).world = irrepNext := by decide

theorem ladder_voyage_aboard : (travel ladder voyager).Aboard :=
  travel_aboard voyager_aboard ladder

theorem ladder_voyage_size : (travel ladder voyager).world.size = 21296876 := by decide

/-- The ship comes back: flying the path and then its inverse returns the ship
to the world it set out from, at the address it set out from — except for the
axis it dropped, which it re-enters at its origin. -/
theorem ladder_voyage_back :
    travel (invPath ladder) (travel ladder voyager) = ⟨⟨[47, 71, 59]⟩, [0, 3, 4]⟩ := by decide

/-- A worked route: from the origin of the first world to a cell of the world
next door, computed by `route` and checked by the kernel. -/
def hop : List Cmd := route start3 ⟨irrepNext, [1, 2, 0, 0, 1]⟩

theorem hop_flies : run hop start3 = ⟨irrepNext, [1, 2, 0, 0, 1]⟩ := by decide

theorem hop_length : hop.length = 3 + 5 + 4 := by decide

end Voyage

end Monster

end NixWars
