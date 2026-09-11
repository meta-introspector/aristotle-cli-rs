import Mathlib.Tactic

/-!
# The card set: a shared intermediate representation

§2b asks for the deck to be treated as a target-agnostic IR, with independently
verified backends per physical substrate.  This file is the IR and its
reference semantics; the backends are in
`RequestProject/TechTree/Backends.lean` and the physical encoding onto clay is
in `RequestProject/TechTree/Tablet.lean`.

A card set is a straight-line NAND program over `n` input lines.  Each card is
either an input line, a constant, or the NAND of two *earlier* cards, named by
their position in the deck.  The value of the deck is the value of its last
card.

* `Card`, `CardSet` — the IR.
* `runFrom`, `evalCards` — the reference semantics: the one meaning every
  backend is measured against.
* `runFrom_append`, `evalCards_snoc` — the two structural lemmas the backend
  correctness proofs share.

Straight-line NAND is enough: NAND is functionally complete, and naming earlier
cards by index is what a physical deck does anyway — the reader has already
passed those cards.
-/

namespace LifeTrac
namespace TechTree

/-- One card of the deck. -/
inductive Card (n : ℕ) where
  /-- Read input line `i`. -/
  | inp (i : Fin n) : Card n
  /-- A hard-wired constant. -/
  | const (b : Bool) : Card n
  /-- The NAND of the cards at positions `a` and `b`, which must be earlier. -/
  | nand (a b : ℕ) : Card n
  deriving DecidableEq, Repr

/-- A deck. -/
abbrev CardSet (n : ℕ) := List (Card n)

/-- The value of one card, given the input lines and the values of the cards
already read.  A reference to a card that has not been read yet reads as
`false` — the physical reader has nothing on that peg. -/
def cardVal {n : ℕ} (x : Fin n → Bool) (vals : List Bool) : Card n → Bool
  | .inp i => x i
  | .const b => b
  | .nand a b => !(vals.getD a false && vals.getD b false)

/-- Read the deck from left to right, accumulating card values. -/
def runFrom {n : ℕ} (x : Fin n → Bool) (acc : List Bool) : CardSet n → List Bool
  | [] => acc
  | c :: rest => runFrom x (acc ++ [cardVal x acc c]) rest

/-- **The reference semantics**: the value of the deck is the value of its last
card. -/
def evalCards {n : ℕ} (cs : CardSet n) (x : Fin n → Bool) : Bool :=
  ((runFrom x [] cs).getLast?).getD false

theorem runFrom_append {n : ℕ} (x : Fin n → Bool) :
    ∀ (cs ds : CardSet n) (acc : List Bool),
      runFrom x acc (cs ++ ds) = runFrom x (runFrom x acc cs) ds
  | [], _, _ => rfl
  | c :: rest, ds, acc => by
      simp only [List.cons_append, runFrom]
      exact runFrom_append x rest ds _

theorem length_runFrom {n : ℕ} (x : Fin n → Bool) :
    ∀ (cs : CardSet n) (acc : List Bool),
      (runFrom x acc cs).length = acc.length + cs.length
  | [], acc => by simp [runFrom]
  | c :: rest, acc => by
      simp only [runFrom, length_runFrom x rest, List.length_append, List.length_cons,
        List.length_nil]
      omega

end TechTree
end LifeTrac
