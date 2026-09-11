import RequestProject.Gvcs.TechTree.Ir
import RequestProject.Gvcs.Steampunk.Fluidic

/-!
# Two physical backends, each proved separately

The card set of `RequestProject/TechTree/Ir.lean` is compiled here to two
physical substrates, and each compiler is proved to compute the same logical
function as the reference semantics `evalCards`:

* **Pipes.**  `toPipeSystem` builds a network of pilot-operated spool valves —
  the `FCirc` of `RequestProject/Steampunk/Fluidic.lean` — and `pipe_correct`
  says its steady-state pressure is the value of the deck.
* **Relays.**  `toElectricSystem` builds a ladder: a list of rungs, each a
  contact network over the input lines and the coils already latched, and
  `electric_correct` says the last coil is the value of the deck.  A NAND
  becomes two break contacts in parallel, which is what a relay logician would
  draw.

These are two separate theorems about two specific realizations.  Neither is,
and neither should be read as, a claim that a deck "becomes any physical
system": `pipe_correct` is about pipes and `electric_correct` is about relay
contacts, and each had to be proved on its own terms.  Adding a third backend
later — cams and levers, say — touches nothing in this file but the new
compiler and its own theorem, which is the practical reason for structuring it
this way.

The third backend asked for in §2b, the physical encoding onto clay, is a
different kind of claim — a round trip rather than an equivalence — and lives
in `RequestProject/TechTree/Tablet.lean`.
-/

namespace LifeTrac
namespace TechTree

open Steampunk

/-! ## A small list lemma both compilers need -/

theorem getD_map {α β : Type*} (f : α → β) (d : α) :
    ∀ (l : List α) (i : ℕ), (l.map f).getD i (f d) = f (l.getD i d)
  | [], i => by simp
  | a :: rest, 0 => by simp
  | a :: rest, i + 1 => by
      simp

/-! ## Backend one: pipes -/

/-- Compile one card to a fluidic network, given the networks already built. -/
def pipeCard {n : ℕ} (acc : List (FCirc n)) : Card n → FCirc n
  | .inp i => .inp i
  | .const true => .supply
  | .const false => .vent
  | .nand a b => .nand (acc.getD a .vent) (acc.getD b .vent)

/-- Compile the deck, left to right. -/
def pipeList {n : ℕ} (acc : List (FCirc n)) : CardSet n → List (FCirc n)
  | [] => acc
  | c :: rest => pipeList (acc ++ [pipeCard acc c]) rest

/-- **The pipe backend.**  The network whose steady state is the value of the
deck. -/
def toPipeSystem {n : ℕ} (cs : CardSet n) : FCirc n :=
  ((pipeList [] cs).getLast?).getD .vent

/-- Simulating a plumbing network is evaluating its steady-state pressure. -/
def simulatePipeSpec {n : ℕ} (c : FCirc n) (x : Fin n → Bool) : Bool := c.eval x

theorem pipeList_eval {n : ℕ} (x : Fin n → Bool) :
    ∀ (cs : CardSet n) (acc : List (FCirc n)),
      (pipeList acc cs).map (fun c => c.eval x) =
        runFrom x (acc.map (fun c => c.eval x)) cs
  | [], acc => rfl
  | c :: rest, acc => by
      have hcard : (pipeCard acc c).eval x =
          cardVal x (acc.map (fun d => d.eval x)) c := by
        cases c with
        | inp i => rfl
        | const b => cases b <;> rfl
        | nand a b =>
            simp only [pipeCard, cardVal, FCirc.eval]
            rw [show (false : Bool) = (FCirc.vent : FCirc n).eval x from rfl,
              getD_map (fun d : FCirc n => d.eval x) (FCirc.vent) acc a,
              getD_map (fun d : FCirc n => d.eval x) (FCirc.vent) acc b]
      simp only [pipeList, runFrom, pipeList_eval x rest, List.map_append, List.map_cons,
        List.map_nil, hcard]

/-- **`pipe_correct`.**  The plumbing computes the deck. -/
theorem pipe_correct {n : ℕ} (cs : CardSet n) (x : Fin n → Bool) :
    simulatePipeSpec (toPipeSystem cs) x = evalCards cs x := by
  unfold simulatePipeSpec toPipeSystem evalCards
  have h := pipeList_eval x cs []
  simp only [List.map_nil] at h
  cases hl : (pipeList [] cs).getLast? with
  | none =>
      have : pipeList [] cs = [] := List.getLast?_eq_none_iff.1 hl
      rw [this] at h
      simp only [List.map_nil] at h
      simp [← h, FCirc.eval]
  | some c =>
      have hmap : ((pipeList [] cs).map (fun d => d.eval x)).getLast? = some (c.eval x) := by
        rw [List.getLast?_map, hl]
        rfl
      rw [h] at hmap
      simp [hmap]

/-! ## Backend two: relay contacts -/

/-- A contact network.  References below `n` are input lines; reference `n + j`
is the coil of rung `j`. -/
inductive Contact where
  /-- A contact that closes when its reference is live. -/
  | make (r : ℕ) : Contact
  /-- A contact that opens when its reference is live. -/
  | brk (r : ℕ) : Contact
  /-- Two networks in series. -/
  | series (a b : Contact) : Contact
  /-- Two networks in parallel. -/
  | parallel (a b : Contact) : Contact
  /-- A plain wire. -/
  | short : Contact
  /-- A gap. -/
  | opened : Contact
  deriving DecidableEq, Repr

/-- Does the network conduct? -/
def Contact.conducts (env : ℕ → Bool) : Contact → Bool
  | .make r => env r
  | .brk r => !env r
  | .series a b => a.conducts env && b.conducts env
  | .parallel a b => a.conducts env || b.conducts env
  | .short => true
  | .opened => false

/-- A ladder: rung `k`'s coil is driven by the contact network at position
`k`. -/
abbrev Ladder := List Contact

/-- The reference environment: input lines below `n`, coils above. -/
def ladderEnv {n : ℕ} (x : Fin n → Bool) (coils : List Bool) (r : ℕ) : Bool :=
  if h : r < n then x ⟨r, h⟩ else coils.getD (r - n) false

/-- Energise the rungs in order. -/
def runLadderFrom {n : ℕ} (x : Fin n → Bool) (coils : List Bool) : Ladder → List Bool
  | [] => coils
  | c :: rest => runLadderFrom x (coils ++ [c.conducts (ladderEnv x coils)]) rest

/-- Simulating a relay circuit is reading its last coil. -/
def simulateCircuit {n : ℕ} (l : Ladder) (x : Fin n → Bool) : Bool :=
  ((runLadderFrom x [] l).getLast?).getD false

/-- Compile one card to a rung. -/
def relayCard (n : ℕ) : Card n → Contact
  | .inp i => .make i.val
  | .const true => .short
  | .const false => .opened
  | .nand a b => .parallel (.brk (n + a)) (.brk (n + b))

/-- **The relay backend.** -/
def toElectricSystem {n : ℕ} (cs : CardSet n) : Ladder := cs.map (relayCard n)

theorem runLadder_eq {n : ℕ} (x : Fin n → Bool) :
    ∀ (cs : CardSet n) (acc : List Bool),
      runLadderFrom x acc (cs.map (relayCard n)) = runFrom x acc cs
  | [], acc => rfl
  | c :: rest, acc => by
      have hrung : (relayCard n c).conducts (ladderEnv x acc) = cardVal x acc c := by
        cases c with
        | inp i => simp [relayCard, Contact.conducts, ladderEnv, i.isLt, cardVal]
        | const b => cases b <;> rfl
        | nand a b =>
            simp [relayCard, Contact.conducts, ladderEnv, cardVal, Nat.not_lt.2 (Nat.le_add_right n a),
              Nat.not_lt.2 (Nat.le_add_right n b), Bool.not_and]
      simp only [List.map_cons, runLadderFrom, runFrom, hrung]
      exact runLadder_eq x rest _

/-- **`electric_correct`.**  The ladder computes the deck. -/
theorem electric_correct {n : ℕ} (cs : CardSet n) (x : Fin n → Bool) :
    simulateCircuit (toElectricSystem cs) x = evalCards cs x := by
  unfold simulateCircuit toElectricSystem evalCards
  rw [runLadder_eq]

/-- The two backends therefore agree with each other — but only *because* each
was proved against the reference semantics, which is the point of having a
reference semantics. -/
theorem pipe_electric_agree {n : ℕ} (cs : CardSet n) (x : Fin n → Bool) :
    simulatePipeSpec (toPipeSystem cs) x = simulateCircuit (toElectricSystem cs) x := by
  rw [pipe_correct, electric_correct]

end TechTree
end LifeTrac
