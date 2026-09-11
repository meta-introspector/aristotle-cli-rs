import RequestProject.Gvcs.Runtime
import RequestProject.Gvcs.Wasm.Encode

/-!
# Compiling the runtime to WebAssembly

This is the code generator.  It turns the integer rule book of
`RequestProject/Runtime.lean` into a WebAssembly module: a memory holding the
constant tables of the game and the position of play, and functions

* `enabled (kind, idx, arg)` — is that button live?
* `apply (kind, idx, arg)` — play the move, if it is legal;
* `commit (kind, idx, arg)` — play it if it is legal *and* the screen showing
  offers it, which is what `UI.handle` does with a mouse click;
* `nav (screen)`, `back ()` — the screen graph;
* `netWorth ()` — the figure on the head-up display.

A move is named by a `kind` (0 buy, 1 order, 2 sell, 3 fabricate, 4 refuel,
5 farm), an `idx` (which material, which assembly, which crop) and an `arg`
(a whole number of units, litres or hectares).

`Rep s mem` says that a memory holds the position `s`: the constant tables are
in place and every cell of the state region agrees with `s`.  The correctness
theorems (`enabled_correct`, `apply_correct`, …) say that the generated code
computes exactly `Runtime.rstep`, which by `Runtime.rstep_refines` is exactly
the rule book of `Game.lean`.
-/

namespace LifeTrac
namespace Wasm

open Build Material Runtime

/-! ## Where things live in memory -/

/-- Address of the cash cell. -/
def CASH : Int := 0
/-- Address of the fuel cell. -/
def FUEL : Int := 8
/-- Address of the calendar cell. -/
def DAY : Int := 16
/-- Address of the hectares cell. -/
def HECT : Int := 24
/-- Address of the current screen. -/
def SCREEN : Int := 32
/-- Base of the stock array (24 cells). -/
def STOCK : Int := 64
/-- Base of the built-parts counters (7 cells). -/
def BUILT : Int := 256
/-- Base of the material price table. -/
def COST : Int := 1024
/-- Base of the salvage price table. -/
def SALV : Int := 1280
/-- Base of the bill-of-materials table (7 assemblies × 24 materials). -/
def REQ : Int := 1536
/-- Base of the assembly material-cost table. -/
def PCOST : Int := 3072
/-- Base of the assembly wage-bill table. -/
def PLAB : Int := 3136
/-- Base of the assembly build-time table. -/
def PDAY : Int := 3200
/-- Base of the crop seed-cost table. -/
def CSEED : Int := 3264
/-- Base of the crop revenue table. -/
def CREV : Int := 3328
/-- Base of the crop fuel table. -/
def CFUEL : Int := 3392
/-- Base of the crop working-time table. -/
def CDAY : Int := 3456
/-- Base of the parent-screen table. -/
def PARENT : Int := 3520
/-- Base of the table saying which screen offers which kind of move. -/
def HOME : Int := 3648

/-! ## Numbering the enumerations -/

/-- The position of a material in the tables. -/
def idxM : Material → Int
  | steelTube4 => 0 | steelTube3 => 1 | steelTube2 => 2 | steelPlate6 => 3
  | steelPlate12 => 4 | roundBar50 => 5 | boltM12 => 6 | nutM12 => 7
  | weldWire => 8 | hose => 9 | fitting => 10 | fluid => 11
  | gearPump => 12 | wheelMotor => 13 | cylinder => 14 | controlValve => 15
  | engine => 16 | fuelTank => 17 | hydraulicTank => 18 | wheelHub => 19
  | tire => 20 | seat => 21 | paint => 22 | electricalKit => 23

/-- The materials in table order. -/
def allM : List Material :=
  [steelTube4, steelTube3, steelTube2, steelPlate6, steelPlate12, roundBar50,
   boltM12, nutM12, weldWire, hose, fitting, fluid, gearPump, wheelMotor,
   cylinder, controlValve, engine, fuelTank, hydraulicTank, wheelHub, tire,
   seat, paint, electricalKit]

/-- The position of an assembly in the tables. -/
def idxP : RPart → Int
  | .frame => 0 | .wheelModule => 1 | .powerUnit => 2 | .controlStation => 3
  | .loader => 4 | .finishing => 5 | .lifeTrac => 6

/-- The assemblies in table order. -/
def allP : List RPart :=
  [.frame, .wheelModule, .powerUnit, .controlStation, .loader, .finishing, .lifeTrac]

/-- The position of a crop in the tables. -/
def idxC : RCrop → Int
  | .wheat => 0

/-- The crops in table order. -/
def allC : List RCrop := [.wheat]

theorem idxM_mem (m : Material) : m ∈ allM := by cases m <;> decide

theorem idxM_inj {m n : Material} (h : idxM m = idxM n) : m = n := by
  cases m <;> cases n <;> simp_all [idxM]

theorem idxM_bounds (m : Material) : 0 ≤ idxM m ∧ idxM m ≤ 23 := by
  cases m <;> exact ⟨by decide, by decide⟩

theorem idxP_inj {a b : RPart} (h : idxP a = idxP b) : a = b := by
  cases a <;> cases b <;> simp_all [idxP]

theorem idxP_bounds (a : RPart) : 0 ≤ idxP a ∧ idxP a ≤ 6 := by
  cases a <;> exact ⟨by decide, by decide⟩

/-- The material at a given position in the tables: the inverse of `idxM`. -/
def matOf : Nat → Material
  | 0 => steelTube4 | 1 => steelTube3 | 2 => steelTube2 | 3 => steelPlate6
  | 4 => steelPlate12 | 5 => roundBar50 | 6 => boltM12 | 7 => nutM12
  | 8 => weldWire | 9 => hose | 10 => fitting | 11 => fluid
  | 12 => gearPump | 13 => wheelMotor | 14 => cylinder | 15 => controlValve
  | 16 => engine | 17 => fuelTank | 18 => hydraulicTank | 19 => wheelHub
  | 20 => tire | 21 => seat | 22 => paint | _ => electricalKit

theorem idxM_matOf {i : Nat} (h : i ≤ 23) : idxM (matOf i) = (i : Int) := by
  interval_cases i <;> rfl

theorem matOf_idxM (m : Material) : matOf (idxM m).toNat = m := by
  cases m <;> rfl

theorem idxC_bounds (c : RCrop) : idxC c = 0 := by cases c; rfl

/-! ## The initial memory image -/

/-- The constant tables of the game, as a memory image. -/
def constantImage : List (Nat × Int) :=
  (allM.map (fun m => ((COST + 8 * idxM m).toNat, costM m))) ++
  (allM.map (fun m => ((SALV + 8 * idxM m).toNat, salvageM m))) ++
  (allP.flatMap (fun a => allM.map (fun m =>
      ((REQ + 192 * idxP a + 8 * idxM m).toNat, a.req m)))) ++
  (allP.map (fun a => ((PCOST + 8 * idxP a).toNat, a.cost))) ++
  (allP.map (fun a => ((PLAB + 8 * idxP a).toNat, a.laborCost))) ++
  (allP.map (fun a => ((PDAY + 8 * idxP a).toNat, a.days))) ++
  (allC.map (fun c => ((CSEED + 8 * idxC c).toNat, c.seed))) ++
  (allC.map (fun c => ((CREV + 8 * idxC c).toNat, c.revenue))) ++
  (allC.map (fun c => ((CFUEL + 8 * idxC c).toNat, c.fuelHa))) ++
  (allC.map (fun c => ((CDAY + 8 * idxC c).toNat, c.daysHa))) ++
  -- the screen graph: title 0, yard 1, market 2, workbench 3, field 4,
  -- ledger 5, help 6; `-1` means "no parent".
  [ (PARENT.toNat, -1), ((PARENT + 8).toNat, 0), ((PARENT + 16).toNat, 1),
    ((PARENT + 24).toNat, 1), ((PARENT + 32).toNat, 1), ((PARENT + 40).toNat, 1),
    ((PARENT + 48).toNat, 0) ] ++
  -- which screen offers which kind of move
  [ (HOME.toNat, 2), ((HOME + 8).toNat, 2), ((HOME + 16).toNat, 2),
    ((HOME + 24).toNat, 3), ((HOME + 32).toNat, 2), ((HOME + 40).toNat, 4) ]

/-- The opening position of the homestead game, as a memory image: 15 000 in
cash, an empty shelf, and the title screen. -/
def startImage : List (Nat × Int) :=
  [ (CASH.toNat, 15000 * SCALE), (FUEL.toNat, 0), (DAY.toNat, 0),
    (HECT.toNat, 0), (SCREEN.toNat, 0) ] ++
  allM.map (fun m => ((STOCK + 8 * idxM m).toNat, 0)) ++
  allP.map (fun a => ((BUILT + 8 * idxP a).toNat, 0))

/-- The memory a module image describes: the word at an address named in the
image, and zero everywhere else.  This is what `Wasm/Encode.lean` lays down as
the data segment. -/
def memOfImage (img : List (Nat × Int)) : Int → Int :=
  fun x => (img.find? (fun p => (p.1 : Int) == x)).elim 0 (fun p => p.2)

/-- The memory the generated module starts from. -/
def startMem : Int → Int := memOfImage (constantImage ++ startImage)

/-! ## Code generation

The generated code is built from combinators (`addE`, `leE`, `put`, …) rather
than written as flat instruction lists, so that the correctness proofs can be
assembled from the `Computes`/`Effects` lemmas of `Wasm/Ir.lean` one combinator
at a time.  Each combinator is exactly the concatenation of its arguments and
the opcode, so the bytes are what they would have been. -/

/-- The kind of a move: 0 buy, 1 order, 2 sell, 3 fabricate, 4 refuel, 5 farm. -/
def kindOf : RAction → Nat
  | .buy _ _ => 0
  | .order _ => 1
  | .sell _ _ => 2
  | .fabricate _ => 3
  | .refuel _ => 4
  | .farm _ _ => 5

/-- The three arguments the shell passes for a move: kind, index, quantity. -/
def argsOf : RAction → List Int
  | .buy m q => [0, idxM m, q]
  | .order a => [1, idxP a, 0]
  | .sell m q => [2, idxM m, q]
  | .fabricate a => [3, idxP a, 0]
  | .refuel l => [4, 0, l]
  | .farm c a => [5, idxC c, a]

/-- Local 0 of every entry point: the kind of move. -/
def KIND : Nat := 0
/-- Local 1: which material, assembly or crop. -/
def IDX : Nat := 1
/-- Local 2: the quantity. -/
def ARG : Nat := 2

/-- A literal. -/
def constE (n : Int) : List Instr := [.const n]
/-- Addition. -/
def addE (a b : List Instr) : List Instr := a ++ b ++ [.add]
/-- Subtraction. -/
def subE (a b : List Instr) : List Instr := a ++ b ++ [.sub]
/-- Multiplication. -/
def mulE (a b : List Instr) : List Instr := a ++ b ++ [.mul]
/-- Signed `≤`. -/
def leE (a b : List Instr) : List Instr := a ++ b ++ [.le]
/-- Equality. -/
def eqE (a b : List Instr) : List Instr := a ++ b ++ [.eq]
/-- Conjunction of two `0`/`1` values. -/
def andE (a b : List Instr) : List Instr := a ++ b ++ [.and]

/-- The word at a fixed address. -/
def get (a : Int) : List Instr := constE a ++ [.load]

/-- The address `base + 8·i`. -/
def cellAddr (base : Int) (i : List Instr) : List Instr :=
  addE (constE base) (mulE i (constE 8))

/-- The word at `base + 8·i`. -/
def loadCell (base : Int) (i : List Instr) : List Instr := cellAddr base i ++ [.load]

/-- Store the value of `v` at a fixed address. -/
def put (a : Int) (v : List Instr) : List Instr := Instr.const a :: v ++ [.store]

/-- Store the value of `v` at `base + 8·i`. -/
def putCell (base : Int) (i v : List Instr) : List Instr := cellAddr base i ++ v ++ [.store]

/-- The index held in local `IDX`. -/
def theIdx : List Instr := [.localGet IDX]

/-- The quantity held in local `ARG`. -/
def theArg : List Instr := [.localGet ARG]

/-- The entry of the bill-of-materials table for the assembly in `IDX` and the
`i`-th material. -/
def reqCell (i : Nat) : List Instr :=
  addE (cellAddr REQ (mulE theIdx (constE 24))) (constE (8 * (i : Int))) ++ [.load]

/-- The stock cell of the `i`-th material. -/
def stockCell (i : Nat) : List Instr := get (STOCK + 8 * (i : Int))

/-- The guard of a move: the code that decides whether the button is live. -/
def guardOf : Nat → List Instr
  -- buy: `0 ≤ arg` and the stock is affordable
  | 0 => andE (leE (constE 0) theArg)
              (leE (mulE theArg (loadCell COST theIdx)) (get CASH))
  -- order: the bill of materials is affordable
  | 1 => leE (loadCell PCOST theIdx) (get CASH)
  -- sell: `0 ≤ arg` and the stock is on the shelf
  | 2 => andE (leE (constE 0) theArg)
              (leE (mulE theArg (constE SCALE)) (loadCell STOCK theIdx))
  -- fabricate: every material is on the shelf, and the wage bill can be met
  | 3 => (List.range 24).foldl
            (fun (acc : List Instr) (i : Nat) => andE acc (leE (reqCell i) (stockCell i)))
            (leE (loadCell PLAB theIdx) (get CASH))
  -- refuel: `0 ≤ arg` and the fuel can be paid for
  | 4 => andE (leE (constE 0) theArg)
              (leE (mulE theArg (constE fuelPriceM)) (get CASH))
  -- farm: a machine, fuel for the season, money for the seed
  | 5 => andE (andE (andE (leE (constE 1) (get (BUILT + 8 * idxP RPart.lifeTrac)))
                          (leE (constE 0) theArg))
                    (leE (mulE theArg (loadCell CFUEL theIdx)) (get FUEL)))
              (leE (mulE theArg (loadCell CSEED theIdx)) (get CASH))
  | _ => constE 0

/-- The effect of a move on the shelf: `op` applied cell by cell to the bill of
materials of the assembly in `IDX`. -/
def stockPass (op : Instr) (l : List Nat) : List Instr :=
  l.flatMap (fun (i : Nat) => put (STOCK + 8 * (i : Int)) (stockCell i ++ reqCell i ++ [op]))

/-- The effect of a move: the code that changes the position. -/
def effectOf : Nat → List Instr
  | 0 => put CASH (subE (get CASH) (mulE theArg (loadCell COST theIdx))) ++
         putCell STOCK theIdx (addE (loadCell STOCK theIdx) (mulE theArg (constE SCALE)))
  | 1 => put CASH (subE (get CASH) (loadCell PCOST theIdx)) ++
         stockPass .add (List.range 24)
  | 2 => put CASH (addE (get CASH) (mulE theArg (loadCell SALV theIdx))) ++
         putCell STOCK theIdx (subE (loadCell STOCK theIdx) (mulE theArg (constE SCALE)))
  | 3 => put CASH (subE (get CASH) (loadCell PLAB theIdx)) ++
         stockPass .sub (List.range 24) ++
         putCell BUILT theIdx (addE (loadCell BUILT theIdx) (constE 1)) ++
         put DAY (addE (get DAY) (loadCell PDAY theIdx))
  | 4 => put CASH (subE (get CASH) (mulE theArg (constE fuelPriceM))) ++
         put FUEL (addE (get FUEL) (mulE theArg (constE SCALE)))
  | 5 => put CASH (subE (addE (get CASH) (mulE theArg (loadCell CREV theIdx)))
                        (mulE theArg (loadCell CSEED theIdx))) ++
         put FUEL (subE (get FUEL) (mulE theArg (loadCell CFUEL theIdx))) ++
         put DAY (addE (get DAY) (mulE theArg (loadCell CDAY theIdx))) ++
         put HECT (addE (get HECT) (mulE theArg (constE SCALE)))
  | _ => []

/-- Dispatch on the kind of move: `f k` is the code for kind `k`. -/
def dispatch (f : Nat → List Instr) : List Instr :=
  let arm (k : Nat) (rest : List Instr) : List Instr :=
    eqE [.localGet KIND] (constE (k : Int)) ++ [.ifte (f k) rest]
  arm 0 (arm 1 (arm 2 (arm 3 (arm 4 (arm 5 (constE 0))))))

/-- `enabled (kind, idx, arg)`: is the button live? -/
def enabledBody : List Instr := dispatch guardOf

/-- `apply (kind, idx, arg)`: play the move if the rule book allows it,
answering `1` if it was played and `0` if the button was dead. -/
def applyBody : List Instr :=
  dispatch (fun k => guardOf k ++ [.ifte (effectOf k ++ [.const 1]) [.const 0]])

/-- `commit (kind, idx, arg)`: a mouse click — the move is played only if the
screen on show is the one that offers it. -/
def commitBody : List Instr :=
  eqE (loadCell HOME [.localGet KIND]) (get SCREEN) ++ [.ifte applyBody [.const 0]]

/-- `nav (screen)`: open a submenu of the screen on show. -/
def navBody : List Instr :=
  eqE (loadCell PARENT [.localGet 0]) (get SCREEN) ++
    [.ifte (put SCREEN [.localGet 0] ++ [.const 1]) [.const 0]]

/-- `back ()`: go up one screen, unless we are at the title. -/
def backBody : List Instr :=
  leE (constE 1) (get SCREEN) ++
    [.ifte (put SCREEN (loadCell PARENT (get SCREEN)) ++ [.const 1]) [.const 0]]

/-- `netWorth ()`: cash, plus the shelf at catalogue prices, plus the fuel in
the tank, plus the material value of everything built.  Prices and quantities
are both held in millionths, so their products carry two factors of the scale:
the answer is the net worth in units of `10^-12`, and the shell divides. -/
def netWorthBody : List Instr :=
  (List.range 7).foldl
    (fun (acc : List Instr) (i : Nat) =>
      addE acc (mulE (mulE (get (BUILT + 8 * (i : Int))) (get (PCOST + 8 * (i : Int))))
        (constE SCALE)))
    (addE
      ((List.range 24).foldl
        (fun (acc : List Instr) (i : Nat) =>
          addE acc (mulE (get (STOCK + 8 * (i : Int))) (get (COST + 8 * (i : Int)))))
        (mulE (get CASH) (constE SCALE)))
      (mulE (get FUEL) (constE fuelPriceM)))

/-- The whole module. -/
def gameMod : Mod where
  memPages := 1
  image := constantImage ++ startImage
  funcs :=
    [ { name := "enabled", params := 3, locals := 0, returns := true, body := enabledBody }
    , { name := "apply", params := 3, locals := 0, returns := true, body := applyBody }
    , { name := "commit", params := 3, locals := 0, returns := true, body := commitBody }
    , { name := "nav", params := 1, locals := 0, returns := true, body := navBody }
    , { name := "back", params := 0, locals := 0, returns := true, body := backBody }
    , { name := "netWorth", params := 0, locals := 0, returns := true,
        body := netWorthBody } ]

end Wasm
end LifeTrac
