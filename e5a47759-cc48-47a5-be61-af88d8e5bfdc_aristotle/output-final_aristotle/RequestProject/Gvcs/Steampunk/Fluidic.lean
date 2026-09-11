import Mathlib.Data.Fin.Tuple.Basic
import Mathlib.Tactic

/-!
# Fluidic logic: a controller with no semiconductors in it

The rest of this project drives its 3D printer (`RequestProject/Printer/`) with
an abstract instruction interpreter and says nothing about what *implements*
the interpreter.  This file supplies one implementation that contains no
silicon at all: **fluidic logic**, the pressure-operated switching elements of
the 1960s, which are spool valves — brass, bronze, leather and steam.

The model is deliberately austere.  A signal is a pressure: `true` is supply
pressure, `false` is vent.  The one primitive element is a *pilot-operated
double valve* whose output is connected to supply unless both of its two pilot
lines are pressurised, in which case the spool shifts and the output is vented.
That is exactly the NAND function, and it is the whole gate library:

* `FCirc n` — a network of such valves fed by `n` input lines, plus hard
  connections to supply and to vent;
* `FCirc.eval` — its steady-state pressure semantics;
* `fluidic_complete` — **every** Boolean function of `n` lines is the
  steady state of some such network.  So no control law needed by the machine
  is out of reach of a plumbing diagram.

The last section makes the silicon-free claim checkable rather than rhetorical:
the parts of one valve are listed with the material each is made of, and
`valveParts_semiconductor_free` says none of them is a semiconductor.
-/

namespace LifeTrac
namespace Steampunk

/-! ## Networks of pilot valves -/

/-- A fluidic network with `n` input lines.

`inp i` is input line `i`, `supply` is a line teed straight off the boiler,
`vent` is a line open to atmosphere, and `nand a b` is the output of a
pilot-operated double valve whose two pilot lines are fed by `a` and `b`. -/
inductive FCirc (n : ℕ) where
  /-- Input line `i`. -/
  | inp (i : Fin n)
  /-- A line teed off the supply header: always pressurised. -/
  | supply
  /-- A line open to atmosphere: never pressurised. -/
  | vent
  /-- The output port of a pilot-operated double valve piloted by `a` and `b`. -/
  | nand (a b : FCirc n)
  deriving DecidableEq, Repr

namespace FCirc

/-- Steady-state pressure at the output of a network, given the pressures on
the input lines. -/
def eval {n : ℕ} : FCirc n → (Fin n → Bool) → Bool
  | inp i, x => x i
  | supply, _ => true
  | vent, _ => false
  | nand a b, x => !(a.eval x && b.eval x)

/-- Number of valves in a network: the physical part count. -/
def valves {n : ℕ} : FCirc n → ℕ
  | inp _ => 0
  | supply => 0
  | vent => 0
  | nand a b => a.valves + b.valves + 1

/-- Re-plumb the input lines of a network along `σ`. -/
def relabel {n m : ℕ} (σ : Fin n → Fin m) : FCirc n → FCirc m
  | inp i => inp (σ i)
  | supply => supply
  | vent => vent
  | nand a b => nand (a.relabel σ) (b.relabel σ)

@[simp] theorem valves_relabel {n m : ℕ} (σ : Fin n → Fin m) (c : FCirc n) :
    (c.relabel σ).valves = c.valves := by
  induction c with
  | inp i => rfl
  | supply => rfl
  | vent => rfl
  | nand a b ha hb => simp [relabel, valves, ha, hb]

@[simp] theorem eval_relabel {n m : ℕ} (σ : Fin n → Fin m) (c : FCirc n)
    (x : Fin m → Bool) : (c.relabel σ).eval x = c.eval (x ∘ σ) := by
  induction c with
  | inp i => rfl
  | supply => rfl
  | vent => rfl
  | nand a b ha hb => simp [relabel, eval, ha, hb]

/-! ## The derived gates -/

/-- Negation: one valve with both pilots on the same line. -/
def notC {n : ℕ} (a : FCirc n) : FCirc n := nand a a

/-- Conjunction. -/
def andC {n : ℕ} (a b : FCirc n) : FCirc n := notC (nand a b)

/-- Disjunction. -/
def orC {n : ℕ} (a b : FCirc n) : FCirc n := nand (notC a) (notC b)

/-- A pressure-operated selector: passes `a` when `s` is pressurised and `b`
when it is not.  This is the element a punched card acts on. -/
def muxC {n : ℕ} (s a b : FCirc n) : FCirc n := nand (nand s a) (nand (notC s) b)

@[simp] theorem eval_notC {n : ℕ} (a : FCirc n) (x : Fin n → Bool) :
    (notC a).eval x = !a.eval x := by
  simp [notC, eval]

@[simp] theorem eval_andC {n : ℕ} (a b : FCirc n) (x : Fin n → Bool) :
    (andC a b).eval x = (a.eval x && b.eval x) := by
  simp [andC, eval]

@[simp] theorem eval_orC {n : ℕ} (a b : FCirc n) (x : Fin n → Bool) :
    (orC a b).eval x = (a.eval x || b.eval x) := by
  simp [orC, eval]

@[simp] theorem valves_muxC {n : ℕ} (s a b : FCirc n) :
    (muxC s a b).valves = s.valves * 3 + a.valves + b.valves + 4 := by
  simp only [muxC, notC, valves]
  ring

@[simp] theorem eval_muxC {n : ℕ} (s a b : FCirc n) (x : Fin n → Bool) :
    (muxC s a b).eval x = if s.eval x then a.eval x else b.eval x := by
  cases h : s.eval x <;> simp [muxC, eval, h]

end FCirc

/-! ## Completeness

Every control law is a plumbing diagram. -/

open FCirc in
/-- **And it does not take much plumbing.**  The network of `fluidic_complete`
can be built from fewer than `4·2ⁿ` valves: the Shannon construction doubles
and adds four selector valves at each input line. -/
theorem fluidic_complete_valves : ∀ (n : ℕ) (f : (Fin n → Bool) → Bool),
    ∃ c : FCirc n, (∀ x, c.eval x = f x) ∧ c.valves + 4 ≤ 4 * 2 ^ n := by
  intro n
  induction n with
  | zero =>
      intro f
      refine ⟨if f (fun i => i.elim0) then supply else vent, fun x => ?_, ?_⟩
      · have hx : x = fun i => i.elim0 := funext fun i => i.elim0
        subst hx
        by_cases h : f (fun i => i.elim0) = true <;> simp [h, eval]
      · by_cases h : f (fun i => i.elim0) = true <;> simp [h, valves]
  | succ n ih =>
      intro f
      obtain ⟨c1, hc1, hs1⟩ := ih (fun g => f (Fin.cons true g))
      obtain ⟨c0, hc0, hs0⟩ := ih (fun g => f (Fin.cons false g))
      refine ⟨muxC (inp 0) (c1.relabel Fin.succ) (c0.relabel Fin.succ), fun x => ?_, ?_⟩
      · have hcons : Fin.cons (x 0) (fun i : Fin n => x i.succ) = x := by
          funext i
          refine Fin.cases ?_ ?_ i
          · simp
          · intro j; simp
        cases hx : x 0 with
        | false =>
            simp only [eval_muxC, eval_relabel, eval, hx, if_false, Bool.false_eq_true]
            rw [hc0]
            simp only [Function.comp_def]
            rw [← hx, hcons]
        | true =>
            simp only [eval_muxC, eval_relabel, eval, hx, if_true]
            rw [hc1]
            simp only [Function.comp_def]
            rw [← hx, hcons]
      · simp only [valves_muxC, valves_relabel, valves, Nat.zero_mul]
        have : 2 ^ (n + 1) = 2 ^ n * 2 := by ring
        omega

/-- **Functional completeness of fluidic logic.**  For every Boolean function
`f` of `n` pressure lines there is a network of pilot valves whose steady-state
output is `f`.  So no control law needed by the machine is out of reach of a
plumbing diagram. -/
theorem fluidic_complete : ∀ (n : ℕ) (f : (Fin n → Bool) → Bool),
    ∃ c : FCirc n, ∀ x, c.eval x = f x := by
  intro n f
  obtain ⟨c, hc, _⟩ := fluidic_complete_valves n f
  exact ⟨c, hc⟩

/-! ## What the valve is made of -/

/-- Materials available to a village foundry and workshop. -/
inductive Material where
  /-- Cast or machined brass. -/
  | brass
  /-- Cast bronze. -/
  | bronze
  /-- Mild steel. -/
  | steel
  /-- Cast iron. -/
  | castIron
  /-- Leather (diaphragms, packings). -/
  | leather
  /-- Seasoned hardwood. -/
  | hardwood
  /-- Graphite / carbon. -/
  | graphite
  /-- Dressed stone. -/
  | stone
  /-- Pasteboard, for punched cards. -/
  | pasteboard
  /-- Silvered glass, for mirrors. -/
  | glass
  /-- Doped semiconductor crystal. -/
  | siliconWafer
  deriving DecidableEq, Repr

/-- The only material on the list that has to come out of a semiconductor
fab. -/
def Material.semiconductor : Material → Bool
  | .siliconWafer => true
  | _ => false

/-- A part of the controller: a name, a material and how many are used. -/
structure Part where
  /-- What the part is called. -/
  name : String
  /-- What it is made of. -/
  mat : Material
  /-- How many are needed per valve. -/
  qty : ℕ
  deriving DecidableEq, Repr

/-- The parts of one pilot-operated double valve — one NAND gate. -/
def valveParts : List Part :=
  [ ⟨"body", .brass, 1⟩
  , ⟨"spool", .bronze, 1⟩
  , ⟨"return spring", .steel, 1⟩
  , ⟨"pilot diaphragm", .leather, 2⟩
  , ⟨"end cap", .brass, 2⟩
  , ⟨"seat", .graphite, 2⟩
  , ⟨"mounting block", .hardwood, 1⟩ ]

/-- **No silicon in the gate.**  Not one part of a fluidic NAND is made of
semiconductor. -/
theorem valveParts_semiconductor_free :
    ∀ p ∈ valveParts, p.mat.semiconductor = false := by
  decide

/-- A fluidic NAND is ten pieces of metal, leather and wood. -/
theorem valveParts_qty : (valveParts.map Part.qty).sum = 10 := by decide

/-- Parts in a whole network, valve by valve. -/
def partCount {n : ℕ} (c : FCirc n) : ℕ :=
  c.valves * (valveParts.map Part.qty).sum

end Steampunk
end LifeTrac
