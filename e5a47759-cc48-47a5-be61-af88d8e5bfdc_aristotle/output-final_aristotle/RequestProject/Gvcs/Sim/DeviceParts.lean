import RequestProject.Gvcs.Sim.Device

/-!
# Parts, player-built devices, and the bridge back to the fixed interface

`Sim/Device.lean` says what a device *is*: a list of axes, a list of flags, and
a declared peak coil draw, with the range and draw guarantees proved for every
shape at once.  This file is what a player does with that.

* **Parts.**  A `Part` is smaller than a whole device — a handful of axes and a
  handful of flags, the thing a kid drags onto the build plate.  Parts combine
  with `Part.compose`, which is proved associative (`Part.compose_assoc`) and
  unital, so a half-finished assembly can be checked now and finished later:
  `Part.Ok_compose` says the check of a composite is exactly the checks of its
  pieces, and `Part.impliedDraw_compose` says the current draw is exactly the
  sum of the pieces' draws.  That is what makes the build plate able to show a
  running total that is not a guess.

* **A device the engine will accept.**  `Part.toSpec` turns a finished assembly
  into a `DeviceSpec` by naming a coil budget, and `Part.specSafe_toSpec` says
  a budget that clears the running total makes a spec the engine accepts —
  once, at build time.

* **A worked six-axis machine.**  `craneSpec` is a concrete player-shaped
  device: six axes with different ranges and different coil costs, three
  flags.  It is `SpecSafe` by `decide`; a sample command round-trips through
  the wire; its draw is bounded by the general theorem, not by a special case.

* **Games inside games.**  `nestedSpec` bolts a winch onto the crane and keeps
  the crane's budget.  The inner machine is safe and the outer one is not
  (`nestedSpec_not_safe`), and `nestedOverload_exceeds_crane_budget` exhibits a
  perfectly valid outer command that draws more than the inner budget.  An
  inner proof does not stand in for the outer one; each device carries its own.

* **Nothing regresses.**  `lifetracSpec` is the fixed 4-axis interface of
  `Sim/Interface.lean` written as a `DeviceSpec`, and `ofCommand`/`toCommand`
  are proved mutually inverse (`toCommand_ofCommand`, `ofCommand_toCommand`)
  and to carry validity both ways (`valid_ofCommand_iff`).  So the skid-steer
  mixer of `Controls.lean` is untouched: the old `Command` is a special case of
  the new one, not a thing the new one replaces.

  One honest caveat: `Device.totalCoilDraw` is a *linear* measure — coils per
  unit of demand, summed — while `Interface.Command.coils` counts energised
  valve coils, at most one per axis.  They are different measures of different
  things, and `Interface.lean` keeps its own.  The bridge here is about the
  command shape and its validity, not about identifying the two draw figures.

* **The bundle.**  `PlayerDevice` packages a spec with its safety proof and with a
  player-written behaviour function, and `PlayerDevice.accepted_draw_le` says that
  *any* frame the device accepts, run through *any* behaviour the player wrote,
  ends inside the declared budget.  Player logic can be as silly as it likes;
  it cannot make the machine draw more current than it declared.
-/

namespace LifeTrac
namespace Device

/-! ## Parts -/

/-- A piece of a machine: some axes and some flags, no budget yet. -/
structure Part where
  axes : List AxisSpec
  flags : List String
deriving DecidableEq, Repr, Inhabited

namespace Part

/-- The empty assembly. -/
def empty : Part := ⟨[], []⟩

/-- Bolting one part onto another. -/
def compose (p q : Part) : Part := ⟨p.axes ++ q.axes, p.flags ++ q.flags⟩

/-- **Composition is associative**, so an assembly may be checked in any
grouping and the build plate never has to commit to an order of assembly. -/
theorem compose_assoc (p q r : Part) :
    (p.compose q).compose r = p.compose (q.compose r) := by
  simp [compose, List.append_assoc]

@[simp] theorem empty_compose (p : Part) : empty.compose p = p := by
  cases p; simp [compose, empty]

@[simp] theorem compose_empty (p : Part) : p.compose empty = p := by
  cases p; simp [compose, empty]

/-- Every axis of the assembly is well formed. -/
def Ok (p : Part) : Prop := ∀ a ∈ p.axes, a.Ok

instance (p : Part) : Decidable p.Ok := inferInstanceAs (Decidable (∀ _ ∈ _, _))

/-- **Checking is incremental**: a composite is well formed exactly when its
pieces are, so a part that has already passed never needs re-checking. -/
theorem Ok_compose {p q : Part} : (p.compose q).Ok ↔ p.Ok ∧ q.Ok := by
  constructor
  · intro h
    exact ⟨fun a ha => h a (by simp [compose, ha]), fun a ha => h a (by simp [compose, ha])⟩
  · rintro ⟨h1, h2⟩ a ha
    simp only [compose, List.mem_append] at ha
    exact ha.elim (h1 a) (h2 a)

/-- The peak draw the part's own axes imply. -/
def impliedDraw (p : Part) : ℤ := (p.axes.map axisMaxDraw).sum

/-- **The running total is a sum**: the draw of an assembly is the draw of its
pieces added up, which is what lets the build plate keep score as you build. -/
theorem impliedDraw_compose (p q : Part) :
    (p.compose q).impliedDraw = p.impliedDraw + q.impliedDraw := by
  simp [impliedDraw, compose]

@[simp] theorem impliedDraw_empty : empty.impliedDraw = 0 := rfl

/-- Finishing an assembly: name a coil budget and you have a device shape. -/
def toSpec (p : Part) (budget : ℤ) : DeviceSpec :=
  { axes := p.axes, flags := p.flags, maxCoilDraw := budget }

@[simp] theorem impliedMaxDraw_toSpec (p : Part) (budget : ℤ) :
    (p.toSpec budget).impliedMaxDraw = p.impliedDraw := by
  rw [impliedMaxDraw_eq]; rfl

/-- **A budget that clears the running total makes an acceptable device.** -/
theorem specSafe_toSpec {p : Part} {budget : ℤ} (hok : p.Ok)
    (ha : p.axes.length < 256) (hf : p.flags.length < 256)
    (hb : p.impliedDraw ≤ budget) : SpecSafe (p.toSpec budget) := by
  refine ⟨hok, ha, hf, ?_⟩
  rw [impliedMaxDraw_toSpec]
  exact hb

/-- Assembling a whole list of parts, left to right. -/
def assemble (ps : List Part) : Part := ps.foldl compose empty

theorem assemble_cons (p : Part) (ps : List Part) :
    assemble (p :: ps) = p.compose (assemble ps) := by
  have aux : ∀ (ps : List Part) (acc : Part),
      ps.foldl compose acc = acc.compose (ps.foldl compose empty) := by
    intro ps
    induction ps with
    | nil => intro acc; simp
    | cons q qs ih =>
        intro acc
        rw [List.foldl_cons, ih (acc.compose q), List.foldl_cons, empty_compose, ih q,
          compose_assoc]
  show (p :: ps).foldl compose empty = p.compose (ps.foldl compose empty)
  rw [List.foldl_cons, empty_compose, aux ps p]

/-- Checking a whole assembly is checking each part. -/
theorem Ok_assemble {ps : List Part} : (assemble ps).Ok ↔ ∀ p ∈ ps, p.Ok := by
  induction ps with
  | nil => simp [assemble, Ok, empty]
  | cons q qs ih => rw [assemble_cons, Ok_compose, ih]; simp

/-- And the total draw of an assembly is the sum of its parts' draws. -/
theorem impliedDraw_assemble (ps : List Part) :
    (assemble ps).impliedDraw = (ps.map impliedDraw).sum := by
  induction ps with
  | nil => simp [assemble]
  | cons q qs ih => rw [assemble_cons, impliedDraw_compose, ih]; simp

end Part

/-! ## A worked six-axis machine -/

/-- The mast of a toy crane: slew and boom. -/
def cranePartMast : Part :=
  { axes := [{ name := "slew", range := (-180, 180), coilsPerUnit := 2 },
             { name := "boom", range := (0, 90), coilsPerUnit := 3 }]
    flags := ["power"] }

/-- The arm: stick and hoist. -/
def cranePartArm : Part :=
  { axes := [{ name := "stick", range := (-45, 120), coilsPerUnit := 3 },
             { name := "hoist", range := (-500, 500), coilsPerUnit := 1 }]
    flags := ["beacon"] }

/-- The head: gripper and tilt. -/
def cranePartHead : Part :=
  { axes := [{ name := "grip", range := (0, 100), coilsPerUnit := 4 },
             { name := "tilt", range := (-30, 30), coilsPerUnit := 2 }]
    flags := ["magnet"] }

/-- The whole crane, assembled from its three parts. -/
def cranePart : Part := Part.assemble [cranePartMast, cranePartArm, cranePartHead]

/-- Its running total, added up piece by piece. -/
theorem cranePart_impliedDraw : cranePart.impliedDraw = 1950 := by decide

/-- The finished device: six axes, three flags, a 2000-coil budget. -/
def craneSpec : DeviceSpec := cranePart.toSpec 2000

theorem craneSpec_axes_length : craneSpec.axes.length = 6 := by decide

/-- **The engine accepts the crane** — one decidable check, at build time. -/
theorem craneSpec_safe : SpecSafe craneSpec := by decide

/-- A command a player might send it. -/
def craneSample : GenericCommand craneSpec :=
  { axisValues := [90, 45, 60, 250, 50, -10]
    flagValues := [true, false, true]
    hLen := by decide
    hFlagLen := by decide }

theorem craneSample_valid : craneSample.Valid := by
  rw [valid_iff_axesInRange]; decide

/-- **The sample survives the wire exactly** — by the general theorem, with no
special pleading for this shape. -/
theorem craneSample_roundtrip : decodeG craneSpec (encodeG craneSample) = some craneSample :=
  decodeG_encodeG craneSpec_safe.1 craneSample_valid

theorem craneSample_draw : totalCoilDraw craneSpec craneSample = 925 := by decide

/-- **And the general bound covers it**, as it covers every valid command the
crane can receive. -/
theorem craneSample_draw_le : totalCoilDraw craneSpec craneSample ≤ craneSpec.maxCoilDraw :=
  maxCoilDraw_sound_of_safe craneSpec_safe _ craneSample_valid

/-! ## A game inside the game -/

/-- A winch part, bolted onto the crane by a player building a machine that
contains a machine. -/
def winchPart : Part :=
  { axes := [{ name := "winch", range := (-300, 300), coilsPerUnit := 4 }]
    flags := ["clutch"] }

/-- The outer machine: the crane plus the winch, keeping the crane's budget.
This is the mistake the engine has to catch. -/
def nestedSpec : DeviceSpec := (cranePart.compose winchPart).toSpec 2000

/-- The inner machine is fine. -/
theorem nestedSpec_inner_safe : SpecSafe craneSpec := craneSpec_safe

/-- **The outer machine is not.**  The inner device's proof does not carry over
to the device that contains it: the composite draws more than the budget it
inherited, and the engine rejects it. -/
theorem nestedSpec_not_safe : ¬ SpecSafe nestedSpec := by decide

/-- A command the outer machine would happily accept as valid. -/
def nestedOverload : GenericCommand nestedSpec :=
  { axisValues := [180, 90, 120, 500, 100, 30, 300]
    flagValues := [true, true, true, true]
    hLen := by decide
    hFlagLen := by decide }

theorem nestedOverload_valid : nestedOverload.Valid := by
  rw [valid_iff_axesInRange]; decide

/-- …and it really does exceed the inherited budget.  So the rejection above is
not pedantry: without it a valid frame would overload the machine. -/
theorem nestedOverload_exceeds_crane_budget :
    craneSpec.maxCoilDraw < totalCoilDraw nestedSpec nestedOverload := by decide

/-- Naming a big enough budget fixes it, and then the same general theorem
applies to the outer machine on its own account. -/
def nestedSpecFixed : DeviceSpec := (cranePart.compose winchPart).toSpec 3200

theorem nestedSpecFixed_safe : SpecSafe nestedSpecFixed := by decide

theorem nestedFixed_draw_le (c : GenericCommand nestedSpecFixed) (h : c.Valid) :
    totalCoilDraw nestedSpecFixed c ≤ 3200 :=
  maxCoilDraw_sound_of_safe nestedSpecFixed_safe c h

/-! ## The fixed interface as a special case -/

/-- The four-axis LifeTrac interface of `Sim/Interface.lean`, written as a
device spec. -/
def lifetracSpec : DeviceSpec :=
  { axes := [{ name := "throttle", range := (-1000, 1000), coilsPerUnit := 1 },
             { name := "steer", range := (-1000, 1000), coilsPerUnit := 1 },
             { name := "lift", range := (-1000, 1000), coilsPerUnit := 1 },
             { name := "tilt", range := (-1000, 1000), coilsPerUnit := 1 }]
    flags := ["ignition", "lights"]
    maxCoilDraw := 4000 }

theorem lifetracSpec_safe : SpecSafe lifetracSpec := by decide

/-- An old command, read as a generic one. -/
def ofCommand (c : Interface.Command) : GenericCommand lifetracSpec :=
  { axisValues := [c.throttle, c.steer, c.lift, c.tilt]
    flagValues := [c.ignition, c.lights]
    hLen := rfl
    hFlagLen := rfl }

/-- A generic command over `lifetracSpec`, read as an old one. -/
def toCommand (g : GenericCommand lifetracSpec) : Interface.Command :=
  { throttle := g.axisValues.getD 0 0
    steer := g.axisValues.getD 1 0
    lift := g.axisValues.getD 2 0
    tilt := g.axisValues.getD 3 0
    ignition := g.flagValues.getD 0 false
    lights := g.flagValues.getD 1 false }

@[simp] theorem toCommand_ofCommand (c : Interface.Command) : toCommand (ofCommand c) = c := by
  cases c; rfl

theorem ofCommand_toCommand (g : GenericCommand lifetracSpec) : ofCommand (toCommand g) = g := by
  obtain ⟨xs, bs, h1, h2⟩ := g
  have hx : xs.length = 4 := h1
  have hb : bs.length = 2 := h2
  match xs, hx with
  | [_, _, _, _], _ =>
    match bs, hb with
    | [_, _], _ => rfl

/-- **The two command types are the same thing.**  Nothing in `Controls.lean`
needs to change: the fixed shape is a device spec like any other. -/
theorem command_equiv : Function.Bijective ofCommand :=
  ⟨fun c₁ c₂ h => by
      have := congrArg toCommand h
      simpa using this,
   fun g => ⟨toCommand g, ofCommand_toCommand g⟩⟩

/-- And validity means the same on both sides. -/
theorem valid_ofCommand_iff (c : Interface.Command) : (ofCommand c).Valid ↔ c.Valid := by
  rw [valid_iff_axesInRange]
  constructor
  · rintro ⟨⟨a1, a2⟩, ⟨b1, b2⟩, ⟨c1, c2⟩, ⟨d1, d2⟩, -⟩
    exact ⟨⟨a1, a2⟩, ⟨b1, b2⟩, ⟨c1, c2⟩, ⟨d1, d2⟩⟩
  · rintro ⟨⟨a1, a2⟩, ⟨b1, b2⟩, ⟨c1, c2⟩, ⟨d1, d2⟩⟩
    exact ⟨⟨a1, a2⟩, ⟨b1, b2⟩, ⟨c1, c2⟩, ⟨d1, d2⟩, trivial⟩

/-! ## A device, bundled -/

/-- What a player hands the engine: a shape, the proof the engine demanded, and
whatever logic they wrote to drive it. -/
structure PlayerDevice where
  /-- The interface the device presents. -/
  spec : DeviceSpec
  /-- The build-time check, carried with the device. -/
  hSafe : SpecSafe spec
  /-- The player's own logic.  Arbitrary — it is not trusted for anything. -/
  behave : GenericCommand spec → GenericCommand spec

/-- Running a device on a frame: read it, run the player's logic, sanitise. -/
def PlayerDevice.run (d : PlayerDevice) (bs : List UInt8) : Option (GenericCommand d.spec) :=
  (decodeG d.spec bs).map fun c => (d.behave c).sanitize

/-- **The guarantee.**  Whatever bytes arrive and whatever logic the player
wrote, a frame this device accepts leaves it inside the coil budget it
declared.  Safety is a property of the interface, not of the player's code. -/
theorem PlayerDevice.accepted_draw_le (d : PlayerDevice) {bs : List UInt8} {c : GenericCommand d.spec}
    (h : d.run bs = some c) : totalCoilDraw d.spec c ≤ d.spec.maxCoilDraw := by
  rw [PlayerDevice.run, Option.map_eq_some_iff] at h
  obtain ⟨c₀, -, rfl⟩ := h
  exact sanitize_draw_le d.hSafe _

/-- …and the command it produces is in range on every axis. -/
theorem PlayerDevice.accepted_valid (d : PlayerDevice) {bs : List UInt8} {c : GenericCommand d.spec}
    (h : d.run bs = some c) : c.Valid := by
  rw [PlayerDevice.run, Option.map_eq_some_iff] at h
  obtain ⟨c₀, -, rfl⟩ := h
  exact GenericCommand.sanitize_valid d.hSafe.1 _

/-- The crane, bundled, with a piece of deliberately silly player logic: it
doubles every axis demand.  The guarantee holds anyway. -/
def craneDevice : PlayerDevice :=
  { spec := craneSpec
    hSafe := craneSpec_safe
    behave := fun c => { c with axisValues := c.axisValues.map (2 * ·),
                                hLen := by rw [List.length_map]; exact c.hLen } }

theorem craneDevice_safe {bs : List UInt8} {c : GenericCommand craneSpec}
    (h : craneDevice.run bs = some c) : totalCoilDraw craneSpec c ≤ 2000 :=
  craneDevice.accepted_draw_le h

end Device
end LifeTrac
