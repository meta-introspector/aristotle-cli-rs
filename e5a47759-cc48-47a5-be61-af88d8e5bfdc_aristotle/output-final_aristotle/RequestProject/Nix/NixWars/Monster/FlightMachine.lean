import RequestProject.Nix.NixWars.Monster.Flight
import RequestProject.Nix.NixWars.OracleMachine

/-!
# The voxel flight, compiled

`Monster/Flight.lean` flies a ship through the voxel world of
`Monster/World.lean`.  This file puts that flight through the same pipeline
every other door of the board goes through: the rules are compiled, inside
Lean, into the first-order expression language `Expr` of `Machine.lean` over a
flat state vector, and `flightStepIR_correct` proves that evaluating the
compiled table computes exactly what `Monster.step` computes.

The flight is the first door whose state is not a fixed tuple: the ship carries
one coordinate per axis of the level it is flying at, and `DESCEND`/`ASCEND`
change how many axes there are.  It is serialized by padding — the vector always
carries fifteen coordinate slots, and the slots above the current level are
zero.  The three shapes the table needs that no other door has are

* a *dynamic index* — `FLY` moves the coordinate the nose points along, which
  is not known when the table is emitted.  Every coordinate slot gets the same
  program, guarded by `ax = i`, so the table stays a fixed list of expressions;
* a *wrap* — the level-`d` box is a `d`-torus, so a move is a modulo by the
  length of that axis, and that length itself depends on the level
  (`axisLenIR`);
* a *list comparison* — docking is allowed only on the station's cell, which is
  an equality of whole addresses, compiled as a conjunction of fifteen
  coordinate tests, each vacuous above the current level (`atStationIR`).

Everything else is the shape the other doors already use, so the same
WebAssembly compiler takes this table with no new code.
-/

namespace NixWars

namespace Monster

/-! ## List lemmas the padding needs -/

theorem getD_take_of_lt (l : List Nat) {d i : Nat} (hi : i < d) :
    (l.take d).getD i 0 = l.getD i 0 := by
  simp [List.getD_eq_getElem?_getD, hi]

theorem getD_set (l : List Nat) (j w i : Nat) :
    (l.set j w).getD i 0 = if j = i ∧ i < l.length then w else l.getD i 0 := by
  by_cases hj : j = i
  · subst hj
    by_cases hl : j < l.length
    · simp [List.getD_eq_getElem?_getD, hl]
    · simp [List.getD_eq_getElem?_getD, hl]
  · simp [List.getD_eq_getElem?_getD, hj]

theorem getD_append_zero (l : List Nat) (i : Nat) :
    (l ++ [0]).getD i 0 = l.getD i 0 := by
  by_cases hi : i < l.length
  · rw [List.getD_append _ _ _ _ hi]
  · have h1 : (l ++ [0]).getD i 0 = 0 := by
      by_cases he : i = l.length
      · subst he
        simp [List.getD_eq_getElem?_getD]
      · exact List.getD_eq_default _ _ (by simp; omega)
    rw [h1, List.getD_eq_default _ _ (by omega)]

theorem getD_dropLast (l : List Nat) (i : Nat) :
    l.dropLast.getD i 0 = if l.length = i + 1 then 0 else l.getD i 0 := by
  by_cases hi : i < l.length - 1
  · rw [List.dropLast_eq_take, getD_take_of_lt _ hi, if_neg (by omega)]
  · have h0 : l.dropLast.getD i 0 = 0 :=
      List.getD_eq_default _ _ (by simp; omega)
    rw [h0]
    by_cases he : l.length = i + 1
    · rw [if_pos he]
    · rw [if_neg he, List.getD_eq_default _ _ (by omega)]

theorem list_ext_getD {l₁ l₂ : List Nat} (hl : l₁.length = l₂.length)
    (h : ∀ i, i < l₁.length → l₁.getD i 0 = l₂.getD i 0) : l₁ = l₂ := by
  refine List.ext_getElem hl ?_
  intro i h₁ h₂
  have := h i h₁
  rwa [List.getD_eq_getElem _ _ h₁, List.getD_eq_getElem _ _ h₂] at this

/-! ## The commands, as the page names them -/

/-- The commands of the flight, as the page names them. -/
inductive FlyTag
  | aim
  | flip
  | thrust
  | brake
  | fly
  | dock
  | descend
  | ascend
  deriving DecidableEq, Repr, Inhabited

/-- A tag plus the axis named by the player is a command. -/
def FlyTag.cmd : FlyTag → Nat → Cmd
  | .aim, a => .aim a
  | .flip, _ => .flip
  | .thrust, _ => .thrust
  | .brake, _ => .brake
  | .fly, _ => .fly
  | .dock, _ => .dock
  | .descend, _ => .descend
  | .ascend, _ => .ascend

/-- The commands with the names the page uses. -/
def flyTagsWithNames : List (String × FlyTag) :=
  [("aim", .aim), ("flip", .flip), ("thrust", .thrust), ("brake", .brake),
   ("fly", .fly), ("dock", .dock), ("descend", .descend), ("ascend", .ascend)]

/-! ## The state vector -/

/-- The fifteen coordinate slots of the vector. -/
def axisSlots : List Nat := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

theorem lt_of_mem_axisSlots {i : Nat} (h : i ∈ axisSlots) : i < 15 := by
  fin_cases h <;> decide

theorem mem_axisSlots_of_lt {i : Nat} (h : i < 15) : i ∈ axisSlots := by
  interval_cases i <;> decide

/-- The state vector is
`[dim, c0 … c14, ax, fwd, speed, fuel, docked, turn]`: the level, the fifteen
coordinate slots (zero above the level), the heading, the throttle, the tank,
the clamp and the command counter. -/
def flightFieldNames : List String :=
  "dim" :: (axisSlots.map (fun i => "c" ++ toString i) ++
    ["ax", "fwd", "speed", "fuel", "docked", "turn"])

/-- The ship, serialized: coordinates padded with zeros up to the fifteen slots
the finest world has. -/
def flightSerialize (s : Ship) : List Nat :=
  s.dim :: (axisSlots.map (fun i => s.pos.getD i 0) ++
    [s.ax, if s.fwd then 1 else 0, s.speed, s.fuel, if s.docked then 1 else 0, s.turn])

theorem flightSerialize_dim (s : Ship) : (flightSerialize s).getD 0 0 = s.dim := rfl

theorem flightSerialize_coord {i : Nat} (hi : i < 15) (s : Ship) :
    (flightSerialize s).getD (i + 1) 0 = s.pos.getD i 0 := by
  interval_cases i <;> rfl

theorem flightSerialize_ax (s : Ship) : (flightSerialize s).getD 16 0 = s.ax := rfl

theorem flightSerialize_fwd (s : Ship) :
    (flightSerialize s).getD 17 0 = if s.fwd then 1 else 0 := rfl

theorem flightSerialize_speed (s : Ship) : (flightSerialize s).getD 18 0 = s.speed := rfl

theorem flightSerialize_fuel (s : Ship) : (flightSerialize s).getD 19 0 = s.fuel := rfl

theorem flightSerialize_docked (s : Ship) :
    (flightSerialize s).getD 20 0 = if s.docked then 1 else 0 := rfl

theorem flightSerialize_turn (s : Ship) : (flightSerialize s).getD 21 0 = s.turn := rfl

/-! ## The pieces -/

/-- The length of axis `i`, compiled: the axis exists only below the level the
ship is flying at, and above it the world has no room to move. -/
def axisLenIR (i : Nat) : Expr :=
  .cond (ltIR (.lit i) (.fld 0)) (.lit (axisAt i)) (.lit 1)

theorem eval_axisLenIR {s : Ship} (h : Ok s) (v i : Nat) :
    (axisLenIR i).eval (flightSerialize s) v = axisLen s.dim i := by
  simp only [axisLenIR, Expr.eval, eval_ltIR, flightSerialize_dim]
  by_cases hi : i < s.dim
  · simp [hi, axisLen_eq hi]
  · have hlen : (level s.dim).length ≤ i := by
      rw [level_length h.dim_le]; omega
    have hax : axisLen s.dim i = 1 := List.getD_eq_default _ _ hlen
    simp [hi, hax]

/-- The guard on `FLY`: the clamp is off and the tank covers the throttle. -/
def flyOkIR : Expr := andIR (eqIR (.fld 20) (.lit 0)) (.le (.fld 18) (.fld 19))

theorem eval_flyOkIR (s : Ship) (v : Nat) :
    flyOkIR.eval (flightSerialize s) v =
      if s.docked = false ∧ s.speed ≤ s.fuel then 1 else 0 := by
  simp only [flyOkIR, eval_andIR, eval_eqIR, Expr.eval, flightSerialize_docked,
    flightSerialize_speed, flightSerialize_fuel]
  rcases Bool.eq_false_or_eq_true s.docked with hd | hd <;>
    by_cases hf : s.speed ≤ s.fuel <;> simp [hd, hf]

/-- Every coordinate is inside its axis, at every slot: below the level because
the address is valid, above it because there is neither a coordinate nor room
to move. -/
theorem coord_lt_axisLen {s : Ship} (h : Ok s) (i : Nat) :
    s.pos.getD i 0 < axisLen s.dim i := by
  by_cases hi : i < s.dim
  · exact forall₂_lt_getD h.valid i (by rw [h.len]; exact hi)
  · have h0 : s.pos.getD i 0 = 0 := List.getD_eq_default _ _ (by rw [h.len]; omega)
    have h1 : axisLen s.dim i = 1 :=
      List.getD_eq_default _ _ (by rw [level_length h.dim_le]; omega)
    omega

/-- Moving up an axis, once the throttle is reduced into it, is one conditional
subtraction: no second modulo is needed. -/
theorem wrap_arith_fwd {p c k : Nat} (hp : 0 < p) (hc : c < p) :
    (c + k) % p = if c + k % p < p then c + k % p else c + k % p - p := by
  have hk : k % p < p := Nat.mod_lt _ hp
  have h1 : (c + k) % p = (c + k % p) % p := by
    conv_lhs => rw [Nat.add_mod, Nat.mod_eq_of_lt hc]
  rw [h1]
  by_cases hlt : c + k % p < p
  · rw [if_pos hlt, Nat.mod_eq_of_lt hlt]
  · rw [if_neg hlt, Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]

/-- … and so is moving down it. -/
theorem wrap_arith_back {p c k : Nat} (hp : 0 < p) (hc : c < p) :
    (c + (p - k % p)) % p = if k % p ≤ c then c - k % p else c + p - k % p := by
  have hk : k % p < p := Nat.mod_lt _ hp
  by_cases hle : k % p ≤ c
  · rw [if_pos hle, show c + (p - k % p) = (c - k % p) + p by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt (by omega)]
  · rw [if_neg hle, show c + (p - k % p) = c + p - k % p by omega,
      Nat.mod_eq_of_lt (by omega)]

/-- The new value of coordinate `i` when the nose points along axis `i`: the
coordinate moved `speed` cells along the heading, wrapping round the torus.

The throttle is first reduced into the axis — the one modulo the flight needs —
and the move itself is then a conditional subtraction, because the coordinate
is already inside its axis.  Keeping the nesting of modulos out of the table is
what lets the same expressions be compiled to WebAssembly with no risk of a
32-bit overflow. -/
def moveIR (i : Nat) : Expr :=
  .cond (.fld 17)
    (.cond (ltIR (.add (.fld (i + 1)) (modIR (.fld 18) (axisLenIR i))) (axisLenIR i))
      (.add (.fld (i + 1)) (modIR (.fld 18) (axisLenIR i)))
      (.sub (.add (.fld (i + 1)) (modIR (.fld 18) (axisLenIR i))) (axisLenIR i)))
    (.cond (.le (modIR (.fld 18) (axisLenIR i)) (.fld (i + 1)))
      (.sub (.fld (i + 1)) (modIR (.fld 18) (axisLenIR i)))
      (.sub (.add (.fld (i + 1)) (axisLenIR i)) (modIR (.fld 18) (axisLenIR i))))

theorem eval_moveIR {s : Ship} (h : Ok s) (v : Nat) {i : Nat} (hi : i < 15) (hax : s.ax = i) :
    (moveIR i).eval (flightSerialize s) v = wrapDir s := by
  have hp : 0 < axisLen s.dim i := axisLen_pos _ _
  have hc : s.pos.getD i 0 < axisLen s.dim i := coord_lt_axisLen h i
  simp only [moveIR, Expr.eval, eval_modIR, eval_ltIR, eval_axisLenIR h, flightSerialize_fwd,
    flightSerialize_speed, flightSerialize_coord hi]
  simp only [wrapDir, hax]
  rcases Bool.eq_false_or_eq_true s.fwd with hd | hd
  · simp only [hd, wrapFwd, wrap_arith_fwd hp hc]
    simp
  · simp only [hd, wrapBack, wrap_arith_back hp hc]
    simp

/-- Standing on the station's cell, compiled: every coordinate below the level
agrees with the station's, and the slots above the level are vacuous. -/
def atStationIR : Expr :=
  axisSlots.foldr
    (fun i acc =>
      andIR (.cond (ltIR (.lit i) (.fld 0))
        (eqIR (.fld (i + 1)) (.lit (stationCoords.getD i 0))) (.lit 1)) acc)
    (.lit 1)

theorem eval_foldr_and (st : List Nat) (v : Nat) (P : Nat → Prop) [DecidablePred P]
    (f : Nat → Expr) (hf : ∀ i, (f i).eval st v = if P i then 1 else 0) :
    ∀ l : List Nat,
      ((l.foldr (fun i acc => andIR (f i) acc) (.lit 1)).eval st v) =
        if ∀ i ∈ l, P i then 1 else 0
  | [] => by simp [Expr.eval]
  | a :: t => by
    have ih := eval_foldr_and st v P f hf t
    simp only [List.foldr_cons, eval_andIR, hf a, ih]
    by_cases ha : P a
    · by_cases ht : ∀ i ∈ t, P i <;> simp [ha, ht]
    · simp [ha]

/-- The address is the station's exactly when every coordinate of the level
agrees with the station's. -/
theorem atStation_iff {s : Ship} (h : Ok s) :
    atStation s = true ↔ ∀ i, i < s.dim → s.pos.getD i 0 = stationCoords.getD i 0 := by
  have hsc : stationCoords.length = 15 := by rw [stationCoords_eq]; rfl
  have hlen : (stationPos s.dim).length = s.dim := by
    have hd := h.dim_le
    simp only [stationPos, List.length_take, hsc]
    omega
  constructor
  · intro hs i hi
    have hp : s.pos = stationPos s.dim := by
      simpa [atStation] using hs
    rw [hp, stationPos, getD_take_of_lt _ hi]
  · intro hall
    have hp : s.pos = stationPos s.dim := by
      refine list_ext_getD (by rw [h.len, hlen]) ?_
      intro i hi
      rw [h.len] at hi
      rw [hall i hi, stationPos, getD_take_of_lt _ hi]
    simp [atStation, hp]

theorem eval_atStationIR {s : Ship} (h : Ok s) (v : Nat) :
    atStationIR.eval (flightSerialize s) v = if atStation s then 1 else 0 := by
  have key : ∀ i : Nat,
      (Expr.cond (ltIR (.lit i) (.fld 0))
          (eqIR (.fld (i + 1)) (.lit (stationCoords.getD i 0))) (.lit 1)).eval
        (flightSerialize s) v =
        if (i < s.dim → s.pos.getD i 0 = stationCoords.getD i 0) then 1 else 0 := by
    intro i
    by_cases hi : i < s.dim
    · have hi15 : i < 15 := lt_of_lt_of_le hi h.dim_le
      simp only [Expr.eval, eval_ltIR, eval_eqIR, flightSerialize_dim,
        flightSerialize_coord hi15, hi, if_pos]
      simp
    · simp only [Expr.eval, eval_ltIR, flightSerialize_dim]
      simp [hi]
  rw [atStationIR, eval_foldr_and (flightSerialize s) v
    (fun i => i < s.dim → s.pos.getD i 0 = stationCoords.getD i 0) _ key axisSlots]
  by_cases hst : atStation s
  · have hall := (atStation_iff h).mp hst
    rw [if_pos hst]
    exact if_pos (fun i _ hi => hall i hi)
  · rw [if_neg hst]
    refine if_neg ?_
    intro hall
    exact hst ((atStation_iff h).mpr (fun i hi =>
      hall i (mem_axisSlots_of_lt (lt_of_lt_of_le hi h.dim_le)) hi))

/-! ## The compiled table -/

/-- The level after the command. -/
def dimIR : FlyTag → Expr
  | .descend => .cond (ltIR (.fld 0) (.lit 15)) (.add (.fld 0) (.lit 1)) (.fld 0)
  | .ascend => .sub (.fld 0) (.lit 1)
  | _ => .fld 0

/-- Coordinate slot `i` after the command. -/
def coordIR : FlyTag → Nat → Expr
  | .fly, i => .cond (andIR flyOkIR (eqIR (.fld 16) (.lit i))) (moveIR i) (.fld (i + 1))
  | .ascend, i => .cond (eqIR (.fld 0) (.lit (i + 1))) (.lit 0) (.fld (i + 1))
  | _, i => .fld (i + 1)

/-- The axis the nose points along after the command. -/
def axIR : FlyTag → Expr
  | .aim => .cond (ltIR .arg (.fld 0)) .arg (.fld 16)
  | .ascend => .cond (ltIR (.add (.fld 16) (.lit 1)) (.fld 0)) (.fld 16) (.lit 0)
  | _ => .fld 16

/-- The direction along that axis after the command. -/
def fwdIR : FlyTag → Expr
  | .flip => .sub (.lit 1) (.fld 17)
  | _ => .fld 17

/-- The throttle after the command. -/
def speedIR : FlyTag → Expr
  | .thrust =>
      .cond (andIR (eqIR (.fld 20) (.lit 0)) (ltIR (.fld 18) (.lit maxThrottle)))
        (.add (.fld 18) (.lit 1)) (.fld 18)
  | .brake => .sub (.fld 18) (.lit 1)
  | .dock => .cond (.fld 20) (.fld 18) (.cond atStationIR (.lit 0) (.fld 18))
  | _ => .fld 18

/-- The tank after the command. -/
def fuelIR : FlyTag → Expr
  | .fly => .cond flyOkIR (.sub (.fld 19) (.fld 18)) (.fld 19)
  | .dock => .cond (.fld 20) (.fld 19) (.cond atStationIR (.lit shipTank) (.fld 19))
  | _ => .fld 19

/-- The clamp after the command. -/
def dockedIR : FlyTag → Expr
  | .dock => .cond (.fld 20) (.lit 0) atStationIR
  | _ => .fld 20

/-- The compiled transition table of the voxel flight: one program per command,
each program one expression per field of the state vector. -/
def flightStepIR (tag : FlyTag) : List Expr :=
  dimIR tag :: (axisSlots.map (coordIR tag) ++
    [axIR tag, fwdIR tag, speedIR tag, fuelIR tag, dockedIR tag,
      .add (.fld 21) (.lit 1)])

/-! ## The table is the flight -/

/-- A `cond` whose guard is a zero-or-one test is an `if`. -/
theorem eval_cond_guard (st : List Nat) (v : Nat) (c a b : Expr) (P : Prop) [Decidable P]
    (hc : c.eval st v = if P then 1 else 0) :
    (Expr.cond c a b).eval st v = if P then a.eval st v else b.eval st v := by
  simp only [Expr.eval, hc]
  by_cases hp : P <;> simp [hp]

/-- A conjunction of two zero-or-one guards is the conjunction of what they
test. -/
theorem eval_andIR_guard (st : List Nat) (v : Nat) (a b : Expr) (P Q : Prop)
    [Decidable P] [Decidable Q] (ha : a.eval st v = if P then 1 else 0)
    (hb : b.eval st v = if Q then 1 else 0) :
    (andIR a b).eval st v = if P ∧ Q then 1 else 0 := by
  simp only [eval_andIR, ha, hb]
  by_cases hp : P <;> by_cases hq : Q <;> simp [hp, hq]

/-- Above the level it is flying at the ship has no room to move, so a move
along an axis the world does not have leaves it at the origin of that axis. -/
theorem wrapDir_of_dim_le {s : Ship} (h : Ok s) (hax : s.dim ≤ s.ax) : wrapDir s = 0 := by
  have hlen : (level s.dim).length ≤ s.ax := by
    rw [level_length h.dim_le]; omega
  have hax1 : axisLen s.dim s.ax = 1 := List.getD_eq_default _ _ hlen
  simp [wrapDir, wrapFwd, wrapBack, hax1, Nat.mod_one]

theorem eval_dimIR (tag : FlyTag) (s : Ship) (v : Nat) :
    (dimIR tag).eval (flightSerialize s) v = (step s (tag.cmd v)).dim := by
  cases tag <;>
    simp only [dimIR, Expr.eval, eval_ltIR, flightSerialize_dim, FlyTag.cmd, step,
      apply_ite Ship.dim, ite_self]
  · -- descend
    by_cases hd : s.dim < 15 <;> simp [hd]
  · -- ascend
    rcases Nat.eq_zero_or_pos s.dim with hd | hd <;> simp [hd]

theorem eval_coordIR (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) {i : Nat} (hi : i < 15) :
    (coordIR tag i).eval (flightSerialize s) v = (step s (tag.cmd v)).pos.getD i 0 := by
  cases tag
  · simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step]
  · simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step]
  · simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step]
  · simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step]
  · -- fly
    have hguard : (andIR flyOkIR (eqIR (.fld 16) (.lit i))).eval (flightSerialize s) v =
        if (s.docked = false ∧ s.speed ≤ s.fuel) ∧ s.ax = i then 1 else 0 :=
      eval_andIR_guard _ _ _ _ _ _ (eval_flyOkIR s v)
        (by simp only [eval_eqIR, Expr.eval, flightSerialize_ax])
    simp only [coordIR, eval_cond_guard _ _ _ _ _ _ hguard, Expr.eval,
      flightSerialize_coord hi, FlyTag.cmd, step, apply_ite Ship.pos]
    by_cases hok : s.docked = false ∧ s.speed ≤ s.fuel
    · rw [if_pos hok]
      by_cases hax : s.ax = i
      · rw [if_pos ⟨hok, hax⟩, eval_moveIR h v hi hax, slide, getD_set]
        by_cases hl : i < s.pos.length
        · rw [if_pos ⟨hax, hl⟩]
        · rw [if_neg (by tauto), List.getD_eq_default _ _ (by omega)]
          refine wrapDir_of_dim_le h ?_
          rw [hax, ← h.len]
          omega
      · rw [if_neg (by tauto), slide, getD_set, if_neg (by tauto)]
    · rw [if_neg hok, if_neg (by tauto)]
  · -- dock
    simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step,
      apply_ite Ship.pos, ite_self]
  · -- descend
    simp only [coordIR, Expr.eval, flightSerialize_coord hi, FlyTag.cmd, step,
      apply_ite Ship.pos]
    by_cases hd : s.dim < 15
    · rw [if_pos hd, getD_append_zero]
    · rw [if_neg hd]
  · -- ascend
    simp only [coordIR, Expr.eval, eval_eqIR, flightSerialize_dim,
      flightSerialize_coord hi, FlyTag.cmd, step, apply_ite Ship.pos]
    by_cases hd : 0 < s.dim
    · rw [if_pos hd, getD_dropLast, h.len]
      by_cases he : s.dim = i + 1 <;> simp [he]
    · have he : ¬ s.dim = i + 1 := by omega
      rw [if_neg hd]
      simp [he]

theorem eval_axIR (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) :
    (axIR tag).eval (flightSerialize s) v = (step s (tag.cmd v)).ax := by
  cases tag <;>
    simp only [axIR, Expr.eval, eval_ltIR, flightSerialize_dim, flightSerialize_ax,
      FlyTag.cmd, step, apply_ite Ship.ax, ite_self]
  · -- aim
    by_cases hv : v < s.dim <;> simp [hv]
  · -- ascend
    by_cases hd : 0 < s.dim
    · rw [if_pos hd]
      by_cases ha : s.ax + 1 < s.dim <;> simp [ha]
    · have hd0 : s.dim = 0 := by omega
      have hax : s.ax = 0 := by
        rcases h.ax_ok with hax | hax
        · omega
        · exact hax
      simp [hax, hd0]

theorem eval_fwdIR (tag : FlyTag) (s : Ship) (v : Nat) :
    (fwdIR tag).eval (flightSerialize s) v =
      if (step s (tag.cmd v)).fwd then 1 else 0 := by
  cases tag <;>
    simp only [fwdIR, Expr.eval, flightSerialize_fwd, FlyTag.cmd, step,
      apply_ite Ship.fwd, ite_self]
  -- flip
  rcases Bool.eq_false_or_eq_true s.fwd with hd | hd <;> simp [hd]

theorem eval_speedIR (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) :
    (speedIR tag).eval (flightSerialize s) v = (step s (tag.cmd v)).speed := by
  cases tag <;>
    simp only [speedIR, Expr.eval, eval_andIR, eval_eqIR, eval_ltIR, eval_atStationIR h,
      flightSerialize_docked, flightSerialize_speed, FlyTag.cmd, step,
      apply_ite Ship.speed, ite_self]
  · -- thrust
    rcases Bool.eq_false_or_eq_true s.docked with hd | hd <;>
      by_cases hs : s.speed < maxThrottle <;> simp [hd, hs]
  · -- dock
    rcases Bool.eq_false_or_eq_true s.docked with hd | hd <;>
      by_cases hst : atStation s <;> simp [hd, hst]

theorem eval_fuelIR (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) :
    (fuelIR tag).eval (flightSerialize s) v = (step s (tag.cmd v)).fuel := by
  cases tag <;>
    simp only [fuelIR, Expr.eval, eval_flyOkIR, eval_atStationIR h, flightSerialize_docked,
      flightSerialize_fuel, flightSerialize_speed, FlyTag.cmd, step,
      apply_ite Ship.fuel, ite_self]
  · -- fly
    by_cases hok : s.docked = false ∧ s.speed ≤ s.fuel <;> simp [hok]
  · -- dock
    rcases Bool.eq_false_or_eq_true s.docked with hd | hd <;>
      by_cases hst : atStation s <;> simp [hd, hst]

theorem eval_dockedIR (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) :
    (dockedIR tag).eval (flightSerialize s) v =
      if (step s (tag.cmd v)).docked then 1 else 0 := by
  cases tag <;>
    simp only [dockedIR, Expr.eval, eval_atStationIR h, flightSerialize_docked,
      FlyTag.cmd, step, apply_ite Ship.docked, ite_self]
  -- dock
  rcases Bool.eq_false_or_eq_true s.docked with hd | hd <;>
    by_cases hst : atStation s <;> simp [hd, hst]

theorem eval_turnIR (tag : FlyTag) (s : Ship) (v : Nat) :
    (Expr.add (.fld 21) (.lit 1)).eval (flightSerialize s) v = (step s (tag.cmd v)).turn := by
  cases tag <;>
    simp only [Expr.eval, flightSerialize_turn, FlyTag.cmd, step,
      apply_ite Ship.turn, ite_self]

/-- **The compiled table is the flight.**  Evaluating the emitted expressions on
the serialized ship computes exactly the serialized ship the flight's own
transition function returns, so the page and the Lean model cannot disagree. -/
theorem flightStepIR_correct (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat) :
    runIR (flightStepIR tag) (flightSerialize s) v =
      flightSerialize (step s (tag.cmd v)) := by
  simp only [runIR, flightStepIR, List.map_cons, List.map_append, List.map_map,
    List.map_nil, Function.comp_def]
  rw [List.map_congr_left (fun i hi => eval_coordIR tag h v (lt_of_mem_axisSlots hi)),
    eval_dimIR tag s v, eval_axIR tag h v, eval_fwdIR tag s v, eval_speedIR tag h v,
    eval_fuelIR tag h v, eval_dockedIR tag h v, eval_turnIR tag s v]
  rfl

/-! ## Reading the vector back -/

/-- The ship a state vector denotes: the level says how many of the fifteen
coordinate slots are coordinates, and the rest of the vector is read off. -/
def flightDeserialize (st : List Nat) : Ship :=
  { dim := st.getD 0 0
    pos := (List.range (st.getD 0 0)).map (fun i => st.getD (i + 1) 0)
    ax := st.getD 16 0
    fwd := st.getD 17 0 != 0
    speed := st.getD 18 0
    fuel := st.getD 19 0
    docked := st.getD 20 0 != 0
    turn := st.getD 21 0 }

/-- **Padding loses nothing.**  Reading the vector back gives the ship it was
made from, so a page that serializes a ship, runs the table and deserializes
the result has run the flight's own transition function on that ship. -/
theorem flightDeserialize_flightSerialize {s : Ship} (h : Ok s) :
    flightDeserialize (flightSerialize s) = s := by
  have hpos : (List.range s.dim).map (fun i => (flightSerialize s).getD (i + 1) 0) = s.pos := by
    refine list_ext_getD (by simp [h.len]) ?_
    intro i hi
    simp only [List.length_map, List.length_range] at hi
    have hi15 : i < 15 := lt_of_lt_of_le hi h.dim_le
    rw [List.getD_eq_getElem _ _ (by simpa using hi), List.getElem_map, List.getElem_range,
      flightSerialize_coord hi15]
  rcases s with ⟨dim, pos, ax, fwd, speed, fuel, docked, turn⟩
  simp only at hpos
  simp only [flightDeserialize, flightSerialize_dim, flightSerialize_ax, flightSerialize_fwd,
    flightSerialize_speed, flightSerialize_fuel, flightSerialize_docked, flightSerialize_turn,
    Ship.mk.injEq, hpos, true_and, and_true]
  refine ⟨?_, ?_⟩
  · cases fwd <;> simp
  · cases docked <;> simp

/-! ## Whole flights -/

/-- Every command of the flight is a tag and a numeric argument. -/
def Cmd.tagged : Cmd → FlyTag × Nat
  | .aim a => (.aim, a)
  | .flip => (.flip, 0)
  | .thrust => (.thrust, 0)
  | .brake => (.brake, 0)
  | .fly => (.fly, 0)
  | .dock => (.dock, 0)
  | .descend => (.descend, 0)
  | .ascend => (.ascend, 0)

theorem cmd_tagged (c : Cmd) : c.tagged.1.cmd c.tagged.2 = c := by
  cases c <;> rfl

/-- A whole flight plan, run on the compiled table. -/
def flightRunIR (st : List Nat) (cs : List (FlyTag × Nat)) : List Nat :=
  cs.foldl (fun st tv => runIR (flightStepIR tv.1) st tv.2) st

/-- **The compiled table flies the whole plan.**  Running the table command by
command on the serialized ship gives the serialization of the ship the flight
itself arrives at. -/
theorem flightRunIR_correct : ∀ (cs : List (FlyTag × Nat)) {s : Ship}, Ok s →
    flightRunIR (flightSerialize s) cs =
      flightSerialize (run s (cs.map (fun tv => tv.1.cmd tv.2)))
  | [], _, _ => rfl
  | (t, v) :: cs, s, h => by
      have ih := flightRunIR_correct cs (step_ok h (t.cmd v))
      simp only [flightRunIR, List.foldl_cons, flightStepIR_correct t h v] at *
      simp only [run, List.map_cons, List.foldl_cons]
      exact ih

/-- The course to the station of the three-dimensional world, flown by the
table alone: the clamp field of the vector it computes is set, so the emitted
table docks the ship exactly as the model does. -/
theorem flightRunIR_docks :
    (flightRunIR (flightSerialize (freshShip 3))
      ((courseToStation 3).map Cmd.tagged)).getD 20 0 = 1 := by
  rw [flightRunIR_correct _ (freshShip_ok (by decide))]
  have hmap : ((courseToStation 3).map Cmd.tagged).map (fun tv => tv.1.cmd tv.2) =
      courseToStation 3 := by
    rw [List.map_map]
    simpa using List.map_congr_left (fun c _ => cmd_tagged c)
  rw [hmap, flightSerialize_docked, flight3_docks]
  rfl

end Monster

end NixWars
