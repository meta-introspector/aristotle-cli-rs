import RequestProject.Craft.RigSim
import RequestProject.Craft.RigWasmEnc

/-!
# The kernel — the rules of the game, as a WebAssembly module

This is the program that ships to the player's phone.  It holds the design grid and
the state of the test run in linear memory and exports four functions:

| export | what it does |
| --- | --- |
| `setup` | read the 16 × 16 design grid and work out the rig's mass, thrust, lift, fuel and cargo |
| `reset` | put the rig on the start line of the loaded track |
| `tick`  | advance the run one tick under the joystick input |
| `score` | the score of the run so far |

Every one of them is built out of the expression and statement combinators of
`RequestProject/RigVM.lean`, so each carries its meaning with it, and the meaning
is then matched against the rule book in `RequestProject/RigSim.lean`:

* `tick_correct` — one call of `tick` moves the memory image of a run to the memory
  image of `Rig.step`, the very function the theorems about the game are proved
  about;
* `score_correct` — `score` returns `Rig.score`;
* `reset_correct` — `reset` produces the memory image of `Sim.start`;
* `setup_correct` — `setup` computes `Params.of` of the design in the grid.

The kernel contains no loops at all: the one pass it needs over the grid is
unrolled, so nothing it does depends on a fuel bound and no call can fail to
terminate.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM RigWasm Rig

/-! ## Where everything lives in memory -/

/-- The 16 × 16 design grid, one byte per cell. -/
def gridAddr : Nat := 0

/-- The ground height of each of the 128 track columns, one byte each. -/
def trackAddr : Nat := 256

/-- Per-kind constants, indexed by the kind's code. -/
def tblMass : Nat := 384
def tblThrust : Nat := 392
def tblLift : Nat := 400
def tblFuel : Nat := 408
def tblPayload : Nat := 416

/-- The state of the run. -/
def sX : Nat := 512
def sY : Nat := 516
def sVX : Nat := 520
def sVY : Nat := 524
def sFuel : Nat := 528
def sDist : Nat := 532
def sTick : Nat := 536
def sCrash : Nat := 540

/-- The rig's parameters, and the finish line. -/
def pMass : Nat := 560
def pThrust : Nat := 564
def pLift : Nat := 568
def pFuel : Nat := 572
def pPayload : Nat := 576
def pFinish : Nat := 580

/-! ## Little pieces of code -/

/-- A constant. -/
def cst (n : Nat) : List Instr := [.const n]

/-- A local. -/
def lget (i : Nat) : List Instr := [.localGet i]

/-- Assign a local. -/
def lset (i : Nat) (e : List Instr) : List Instr := e ++ [.localSet i]

/-- The word at a fixed address. -/
def wLoad (a : Nat) : List Instr := cst 0 ++ [.load a]

/-- Store to a fixed address. -/
def wStore (a : Nat) (e : List Instr) : List Instr := cst 0 ++ e ++ [.store a]

/-- The byte at a computed address. -/
def bLoad (e : List Instr) : List Instr := e ++ [.load8 0]

/-- A binary operation. -/
def op (o : Bin) (a b : List Instr) : List Instr := a ++ b ++ [.bin o]

/-- `if k ≠ 0 then x else y`. -/
def sel (x y k : List Instr) : List Instr := x ++ y ++ k ++ [.select]

/-- The smaller of two. -/
def eMin (a b : List Instr) : List Instr := sel a b (op .ltu a b)

/-- The larger of two. -/
def eMax (a b : List Instr) : List Instr := sel a b (op .gtu a b)

/-- Subtraction that stops at zero. -/
def eSubSat (a b : List Instr) : List Instr := sel (op .sub a b) (cst 0) (op .geu a b)

/-- The ground height, in sixteenths, under a position. -/
def eFloor (x : List Instr) : List Instr :=
  op .mul (cst unit) (bLoad (op .add (cst trackAddr) (op .shru x (cst 4))))

/-- Rolling friction. -/
def eDrag (v : List Instr) : List Instr :=
  sel (op .sub v (cst 1)) (sel (op .add v (cst 1)) v (op .ltu v (cst vBias)))
    (op .ltu (cst vBias) v)

/-- Keep a biased velocity inside the cap. -/
def eClampV (v : List Instr) : List Instr :=
  eMax (cst (vBias - vCap)) (eMin (cst (vBias + vCap)) v)

/-! ## The four functions -/

/-! ### `setup` -/

/-- Locals of `setup`: five running totals and the kind of the cell being read. -/
def setupCell (c : Nat) : List Instr :=
  lset 5 (bLoad (cst (gridAddr + c))) ++
  lset 0 (op .add (lget 0) (bLoad (op .add (cst tblMass) (lget 5)))) ++
  lset 1 (op .add (lget 1) (bLoad (op .add (cst tblThrust) (lget 5)))) ++
  lset 2 (op .add (lget 2) (bLoad (op .add (cst tblLift) (lget 5)))) ++
  lset 3 (op .add (lget 3) (bLoad (op .add (cst tblFuel) (lget 5)))) ++
  lset 4 (op .add (lget 4) (bLoad (op .add (cst tblPayload) (lget 5))))

/-- The first `n` cells of the grid, in order. -/
def setupCells : Nat → List Instr
  | 0 => []
  | n + 1 => setupCells n ++ setupCell n

/-- `setup`: total up the grid and write the rig's parameters. -/
def setupBody : List Instr :=
  setupCells 256 ++
  wStore pMass (eMax (cst 1) (lget 0)) ++
  wStore pThrust (lget 1) ++
  wStore pLift (lget 2) ++
  wStore pFuel (lget 3) ++
  wStore pPayload (lget 4)

/-! ### `reset` -/

/-- `reset`: the rig on the start line. -/
def resetBody : List Instr :=
  wStore sX (cst 0) ++
  wStore sY (eFloor (cst 0)) ++
  wStore sVX (cst vBias) ++
  wStore sVY (cst vBias) ++
  wStore sFuel (wLoad pFuel) ++
  wStore sDist (cst 0) ++
  wStore sTick (cst 0) ++
  wStore sCrash (cst 0)

/-! ### `tick` -/

/-- Local `0` is the joystick input. -/
def lInp : Nat := 0
/-- The wheels' push this tick. -/
def lA : Nat := 1
/-- The new horizontal velocity. -/
def lVX : Nat := 2
/-- The new vertical velocity. -/
def lVY : Nat := 3
/-- Where the rig would get to. -/
def lX1 : Nat := 4
/-- How high the rig would get. -/
def lY1 : Nat := 5
/-- Did it run into a wall? -/
def lHit : Nat := 6
/-- Where it actually gets to. -/
def lX2 : Nat := 7
/-- The ground under it. -/
def lFloor : Nat := 8
/-- Is it standing on the ground? -/
def lDown : Nat := 9
/-- Were the wheels on the ground when the tick started? -/
def lGrnd : Nat := 10

/-- The body of `tick`, for a run that has not crashed. -/
def tickLive : List Instr :=
  lset lGrnd (op .leu (wLoad sY) (eFloor (wLoad sX))) ++
  lset lA
    (sel (cst 0)
      (sel (eMin (cst 12) (op .divu (op .mul (cst 4) (wLoad pThrust)) (wLoad pMass)))
           (eMin (cst 6) (op .divu (op .mul (cst 2) (wLoad pThrust)) (wLoad pMass)))
           (lget lGrnd))
      (op .eq (wLoad sFuel) (cst 0))) ++
  lset lVX
    (eClampV
      (sel (op .add (wLoad sVX) (lget lA))
        (sel (eSubSat (eDrag (wLoad sVX)) (lget lA)) (eDrag (wLoad sVX))
          (op .and (op .shru (lget lInp) (cst 1)) (cst 1)))
        (op .and (lget lInp) (cst 1)))) ++
  lset lVY
    (eClampV
      (eSubSat
        (op .add (wLoad sVY)
          (sel
            (eMin (cst 6) (op .divu (op .mul (cst 4) (wLoad pLift)) (wLoad pMass)))
            (cst 0)
            (op .and (op .and (op .shru (lget lInp) (cst 2)) (cst 1))
              (op .ltu (cst 0) (wLoad sFuel)))))
        (cst gravity))) ++
  lset lX1
    (sel (eMin (cst maxX) (op .add (wLoad sX) (op .sub (lget lVX) (cst vBias))))
      (eSubSat (wLoad sX) (op .sub (cst vBias) (lget lVX)))
      (op .leu (cst vBias) (lget lVX))) ++
  lset lY1
    (sel (eMin (cst maxY) (op .add (wLoad sY) (op .sub (lget lVY) (cst vBias))))
      (eSubSat (wLoad sY) (op .sub (cst vBias) (lget lVY)))
      (op .leu (cst vBias) (lget lVY))) ++
  lset lHit
    (op .and (op .gtu (eFloor (lget lX1)) (op .add (wLoad sY) (cst unit)))
      (op .ltu (cst vBias) (lget lVX))) ++
  lset lX2 (sel (wLoad sX) (lget lX1) (lget lHit)) ++
  lset lFloor (eFloor (lget lX2)) ++
  lset lDown (op .ltu (lget lY1) (lget lFloor)) ++
  wStore sX (lget lX2) ++
  wStore sY (sel (lget lFloor) (lget lY1) (lget lDown)) ++
  wStore sVX (sel (cst vBias) (lget lVX) (lget lHit)) ++
  wStore sVY (sel (cst vBias) (lget lVY) (lget lDown)) ++
  wStore sFuel (eSubSat (wLoad sFuel) (sel (cst 1) (cst 0) (lget lInp))) ++
  wStore sDist (eMax (wLoad sDist) (lget lX2)) ++
  wStore sTick (op .add (wLoad sTick) (cst 1)) ++
  wStore sCrash
    (op .and (lget lHit) (op .geu (lget lVX) (cst (vBias + smashSpeed))))

/-- `tick`: nothing at all once the rig is wrecked. -/
def tickBody : List Instr :=
  op .eq (wLoad sCrash) (cst 1) ++ [.ifElse [] tickLive]

/-! ### `score` -/

/-- `score`: what the run is worth. -/
def scoreBody : List Instr :=
  eSubSat
    (op .add
      (op .add (op .divu (wLoad sDist) (cst unit))
        (sel (wLoad pPayload) (cst 0) (op .leu (wLoad pFinish) (wLoad sDist))))
      (op .divu (wLoad sFuel) (cst 8)))
    (sel (cst crashPenalty) (cst 0) (op .eq (wLoad sCrash) (cst 1)))

/-! ## The module -/

/-- The per-kind constant tables, as a data segment. -/
def tableSeg (base : Nat) (f : Kind → Nat) : Seg :=
  ⟨base, 0 :: Kind.all.map f⟩

/-- The four functions of the kernel. -/
def kernelFuncs : List Func :=
  [ ⟨0, "setup", 6, setupBody⟩
  , ⟨0, "reset", 0, resetBody⟩
  , ⟨1, "tick", 10, tickBody⟩
  , ⟨2, "score", 0, scoreBody⟩ ]

/-- The kernel module. -/
def kernelModule : Bytes :=
  module kernelFuncs 1
    [ tableSeg tblMass Kind.mass
    , tableSeg tblThrust Kind.thrust
    , tableSeg tblLift Kind.lift
    , tableSeg tblFuel Kind.fuelUnits
    , tableSeg tblPayload Kind.payload ]

/-- The kernel, base-64 encoded for the page. -/
def kernelBase64 : String := base64 kernelModule

end RigKernel
