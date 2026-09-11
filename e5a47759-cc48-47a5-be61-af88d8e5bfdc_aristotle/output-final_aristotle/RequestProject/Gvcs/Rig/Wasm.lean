import RequestProject.Gvcs.Rig.Drive
import RequestProject.Gvcs.Wasm.Encode

/-!
# The rig game, compiled to WebAssembly

`RequestProject/Rig/Blocks.lean` and `RequestProject/Rig/Drive.lean` are the
rule book; this file is the code generator that turns them into a module the
browser runs, in the loop-free `i64` fragment of `RequestProject/Wasm/Ir.lean`.

The module keeps everything in its linear memory:

```
    0    the state of the run     pos, lane, vel, fuel, load, score, ticks
   64    the machine's figures    mass, power, grip, cap, cost, fuel, wheels,
                                  engines, tanks
  192    scratch                  the intermediate values of one tick
  256    the grid                 sixty-four cells, one block each
 1024    the block tables         nine tables of seven entries
```

and exports six functions:

* `reset()` — put the machine back on the line with a full tank;
* `place(i, k)` — put block `k` in cell `i`, keeping the nine figures up to
  date *incrementally* (`statOf_place` is why that is legal);
* `stat(j)` — the `j`th figure of the machine;
* `get(j)` — the `j`th field of the run;
* `valid()` — may this machine be taken to the course?
* `tick(throttle, steer, scoop, brake)` — one tenth of a second of driving.

There are no loops in any of them: the grid is written a cell at a time from
the page, and every figure is a running total, so the whole game is
straight-line integer arithmetic.  `i64.div_s` — added to the target language
for this game — is `Int.tdiv`, which is what the rule book is written with.
-/

namespace LifeTrac
namespace Rig

open Wasm

/-! ## Where things live -/

/-- Address of the position cell. -/
def aPOS : Int := 0
/-- Address of the line cell. -/
def aLANE : Int := 8
/-- Address of the speed cell. -/
def aVEL : Int := 16
/-- Address of the fuel cell. -/
def aFUEL : Int := 24
/-- Address of the load cell. -/
def aLOAD : Int := 32
/-- Address of the score cell. -/
def aSCORE : Int := 40
/-- Address of the tick counter. -/
def aTICKS : Int := 48
/-- Base of the nine figures of the machine. -/
def aACC : Int := 64
/-- Base of the scratch cells one tick uses. -/
def aSCR : Int := 192
/-- Base of the build grid. -/
def aGRID : Int := 256
/-- Base of the block tables. -/
def aTBL : Int := 1024

/-- The address of the `j`th figure. -/
def accAddr (j : Nat) : Int := aACC + 8 * (j : Int)
/-- The address of cell `i` of the grid. -/
def gridAddr (i : Nat) : Int := aGRID + 8 * (i : Int)
/-- The address of entry `k` of table `j`. -/
def tblAddr (j k : Nat) : Int := aTBL + 64 * (j : Int) + 8 * (k : Int)
/-- The address of the `t`th scratch cell. -/
def scrAddr (t : Nat) : Int := aSCR + 8 * (t : Int)

/-- Scratch: the new speed. -/
def sVEL : Int := scrAddr 0
/-- Scratch: the position before the lap is taken off. -/
def sRAW : Int := scrAddr 1
/-- Scratch: one if the line was crossed. -/
def sLAP : Int := scrAddr 2
/-- Scratch: the new position. -/
def sPOS : Int := scrAddr 3
/-- Scratch: the load before the lap empties it. -/
def sLOAD : Int := scrAddr 4

/-! ## Little pieces of code -/

/-- A constant. -/
def cst (n : Int) : List Instr := [.const n]
/-- The word at a fixed address. -/
def ld (a : Int) : List Instr := [.const a, .load]
/-- The word at a computed address. -/
def ldE (e : List Instr) : List Instr := e ++ [.load]
/-- Addition. -/
def addE (a b : List Instr) : List Instr := a ++ b ++ [.add]
/-- Subtraction. -/
def subE (a b : List Instr) : List Instr := a ++ b ++ [.sub]
/-- Multiplication. -/
def mulE (a b : List Instr) : List Instr := a ++ b ++ [.mul]
/-- Signed division, truncating towards zero. -/
def divE (a b : List Instr) : List Instr := a ++ b ++ [.divs]
/-- Signed `<`. -/
def ltE (a b : List Instr) : List Instr := a ++ b ++ [.lt]
/-- Signed `≤`. -/
def leE (a b : List Instr) : List Instr := a ++ b ++ [.le]
/-- Conjunction of two `0`/`1` values. -/
def andE (a b : List Instr) : List Instr := a ++ b ++ [.and]
/-- A conditional expression. -/
def ifE (c t e : List Instr) : List Instr := c ++ [.ifte t e]
/-- Store at a fixed address. -/
def putE (a : Int) (v : List Instr) : List Instr := (Instr.const a) :: v ++ [.store]
/-- Store at a computed address. -/
def putAtE (a v : List Instr) : List Instr := a ++ v ++ [.store]
/-- Negation. -/
def negE (a : List Instr) : List Instr := subE (cst 0) a
/-- Absolute value. -/
def absE (a : List Instr) : List Instr := ifE (ltE a (cst 0)) (negE a) a
/-- The smaller of two values. -/
def minE (a b : List Instr) : List Instr := ifE (ltE a b) a b
/-- Nothing below zero. -/
def max0E (a : List Instr) : List Instr := ifE (ltE a (cst 0)) (cst 0) a
/-- Hold a value inside `±b`, with `b` a constant. -/
def clampCE (b : Int) (x : List Instr) : List Instr :=
  ifE (ltE x (cst (-b))) (cst (-b)) (ifE (ltE (cst b) x) (cst b) x)
/-- Hold a value inside `±b`, with `b` computed. -/
def clampE (b x : List Instr) : List Instr :=
  ifE (ltE x (negE b)) (negE b) (ifE (ltE b x) b x)

/-! ## The parameters, as the page passes them -/

/-- `tick`'s throttle parameter. -/
def pTH : List Instr := [.localGet 0]
/-- `tick`'s steering parameter. -/
def pST : List Instr := [.localGet 1]
/-- `tick`'s scoop button. -/
def pSCOOP : List Instr := [.localGet 2]
/-- `tick`'s brake button. -/
def pBRAKE : List Instr := [.localGet 3]
/-- The first parameter of the one- and two-argument entry points. -/
def p0 : List Instr := [.localGet 0]
/-- The second parameter of `place`. -/
def p1 : List Instr := [.localGet 1]

/-! ## `place` -/

/-- The address of the cell `place` is writing. -/
def cellAddrE : List Instr := addE (cst aGRID) (mulE (cst 8) p0)

/-- The block that is in that cell now. -/
def oldKindE : List Instr := ldE cellAddrE

/-- The address of entry `k` of table `j`, with `k` computed. -/
def tblAddrE (j : Nat) (k : List Instr) : List Instr :=
  addE (cst (aTBL + 64 * (j : Int))) (mulE (cst 8) k)

/-- The new value of the `j`th figure: take the old block's entry off and put
the new block's entry on. -/
def accUpdE (j : Nat) : List Instr :=
  addE (subE (ld (accAddr j)) (ldE (tblAddrE j oldKindE))) (ldE (tblAddrE j p1))

/-- The nine accumulator updates, then the cell itself. -/
def placeBody : List Instr :=
  ((List.range 9).flatMap (fun j => putE (accAddr j) (accUpdE j))) ++
    putAtE cellAddrE p1

/-- `place` is a legal move when the cell and the block are both in range. -/
def placeGuard : List Instr :=
  andE (andE (leE (cst 0) p0) (ltE p0 (cst 64)))
    (andE (leE (cst 0) p1) (ltE p1 (cst 7)))

/-- The whole of `place`. -/
def placeFun : List Instr := placeGuard ++ [.ifte (placeBody ++ [.const 1]) [.const 0]]

/-! ## `reset`, `stat`, `get` and `valid` -/

/-- Back to the line with a full tank. -/
def resetFun : List Instr :=
  putE aPOS (cst 0) ++ putE aLANE (cst 0) ++ putE aVEL (cst 0) ++
    putE aFUEL (ld (accAddr 5)) ++ putE aLOAD (cst 0) ++ putE aSCORE (cst 0) ++
    putE aTICKS (cst 0) ++ cst 1

/-- The `j`th figure of the machine. -/
def statFun : List Instr :=
  ifE (andE (leE (cst 0) p0) (ltE p0 (cst 9)))
    (ldE (addE (cst aACC) (mulE (cst 8) p0))) (cst 0)

/-- The `j`th field of the run. -/
def getFun : List Instr :=
  ifE (andE (leE (cst 0) p0) (ltE p0 (cst 7)))
    (ldE (mulE (cst 8) p0)) (cst 0)

/-- May this machine be taken to the course? -/
def validFun : List Instr :=
  andE (andE (leE (cst 2) (ld (accAddr 6))) (leE (cst 1) (ld (accAddr 7))))
    (andE (leE (cst 1) (ld (accAddr 8))) (leE (ld (accAddr 4)) (cst budget)))

/-! ## `tick` -/

/-- The throttle, clamped. -/
def thE : List Instr := clampCE 1000 pTH
/-- The steering, clamped. -/
def stE : List Instr := clampCE 1000 pST
/-- One while there is fuel in the tank. -/
def liveE : List Instr := ifE (ltE (cst 0) (ld aFUEL)) (cst 1) (cst 0)
/-- The thrust. -/
def driveE : List Instr := mulE liveE (divE (mulE (ld (accAddr 1)) thE) (cst 1000))
/-- Drag, and the brake. -/
def resistE : List Instr :=
  addE (mulE (cst dragK) (ld aVEL)) (ifE pBRAKE (mulE (cst brakeK) (ld aVEL)) (cst 0))
/-- The mass the thrust has to shift. -/
def mtotE : List Instr := addE (addE (ld (accAddr 0)) (mulE (cst 10) (ld aLOAD))) (cst 1)
/-- The new speed. -/
def velE : List Instr := clampCE vmax (addE (ld aVEL) (divE (subE driveE resistE) mtotE))
/-- The new line across the track. -/
def laneE : List Instr :=
  clampCE laneMax
    (addE (ld aLANE) (clampE (ld (accAddr 2)) (divE (mulE stE (ld sVEL)) (cst 20000))))
/-- How far round the lap, before the lap is taken off. -/
def rawE : List Instr := addE (ld aPOS) (divE (ld sVEL) (cst tickHz))
/-- One if the line was crossed. -/
def lapE : List Instr := leE (cst track) (ld sRAW)
/-- The new position. -/
def posE : List Instr :=
  ifE (ld sLAP) (subE (ld sRAW) (cst track))
    (ifE (ltE (ld sRAW) (cst 0)) (addE (ld sRAW) (cst track)) (ld sRAW))
/-- The fuel burnt this tick. -/
def burnE : List Instr := mulE liveE (divE (addE (absE thE) (cst 200)) (cst 200))
/-- The fuel left. -/
def fuelE : List Instr := max0E (subE (ld aFUEL) burnE)
/-- Is the scoop taking a bale? -/
def pickE : List Instr :=
  andE (andE pSCOOP (leE (cst zoneLo) (ld sPOS)))
    (andE (leE (ld sPOS) (cst zoneHi)) (leE (absE (ld aLANE)) (cst zoneLane)))
/-- The load, before the line empties the scoop. -/
def load1E : List Instr :=
  ifE pickE (minE (ld (accAddr 3)) (addE (ld aLOAD) (cst bite))) (ld aLOAD)
/-- The score. -/
def scoreE : List Instr :=
  ifE (ld sLAP) (addE (ld aSCORE) (mulE (cst 10) (ld sLOAD))) (ld aSCORE)
/-- The load. -/
def loadE : List Instr := ifE (ld sLAP) (cst 0) (ld sLOAD)

/-- **One tick**, as twelve stores. -/
def tickFun : List Instr :=
  putE sVEL velE ++
  putE aLANE laneE ++
  putE sRAW rawE ++
  putE sLAP lapE ++
  putE sPOS posE ++
  putE aFUEL fuelE ++
  putE sLOAD load1E ++
  putE aSCORE scoreE ++
  putE aLOAD loadE ++
  putE aPOS (ld sPOS) ++
  putE aVEL (ld sVEL) ++
  putE aTICKS (addE (ld aTICKS) (cst 1)) ++
  cst 1

/-! ## The module -/

/-- The block tables, as an initial memory image. -/
def tableImage : List (Nat × Int) :=
  (List.range 9).flatMap fun j =>
    (List.range 7).map fun k => ((tblAddr j k).toNat, (tables.getD j massTbl) k)

/-- The module the page runs. -/
def rigMod : Mod where
  memPages := 1
  image := tableImage
  funcs :=
    [ { name := "reset", params := 0, locals := 0, returns := true, body := resetFun },
      { name := "place", params := 2, locals := 0, returns := true, body := placeFun },
      { name := "stat", params := 1, locals := 0, returns := true, body := statFun },
      { name := "get", params := 1, locals := 0, returns := true, body := getFun },
      { name := "valid", params := 0, locals := 0, returns := true, body := validFun },
      { name := "tick", params := 4, locals := 0, returns := true, body := tickFun } ]

end Rig
end LifeTrac
