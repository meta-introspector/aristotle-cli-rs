/-
# The bootstrap model: `Tech`, `CardSet`, `BootstrapSeq`

A deliberately small model of a tech tree, in which the *only* thing that is
modelled is dependency structure: which machine needs which resource, at which
tier, and what comes out.  No physics, no materials, no economy.

The point of the model is to be able to state, and mechanically check, the
fixed-point claim:

    running a card set through the tree it describes punches that same
    card set back out.

Everything here is backend agnostic; the reference backend (a brass
Jacquard-style card shop) lives in `RequestProject/Tech/Pantograph.lean`.
-/
import Mathlib

namespace Bootstrap

/-! ## Cards

A **card** is a brass shim with a row of pins on it; each pin is a number (its
height).  A **card set** — a deck — is a list of cards.  Both have decidable
equality, so the fixed point is checkable by `decide`. -/

/-- A punched card: the list of pin heights along the card. -/
abbrev Card := List Nat

/-- A deck of cards. -/
abbrev CardSet := List Card

/-! ## Resources -/

/-- The resources a machine can consume or produce.

* `shim`      — a blank brass shim (stock);
* `pattern c` — the card `c` mounted on a reading barrel, i.e. readable data;
* `card c`    — a finished punched card `c`. -/
inductive Res where
  | shim
  | pattern (c : Card)
  | card (c : Card)
  deriving DecidableEq, Repr

/-- The finished card carried by a resource, if it is one. -/
def Res.asCard : Res → Option Card
  | .card c => some c
  | _ => none

/-- What a machine asks for at a given input port.  A port asks for a *kind* of
resource, never for a specific one — this is what lets a machine be universal
(the loom below reads whatever pattern is mounted). -/
inductive Req where
  | shim
  | pattern
  deriving DecidableEq, Repr

/-- Does a resource satisfy a port's request? -/
def Req.accepts : Req → Res → Bool
  | .shim, .shim => true
  | .pattern, .pattern _ => true
  | _, _ => false

/-! ## Nodes and trees -/

/-- A node of the tech tree: a machine.  `fire` says what comes out when
exactly the listed input ports are filled; it is a function, so a machine that
transforms data is one node, not one node per datum. -/
structure Node where
  name : String
  tier : Nat
  inputs : List Req
  fire : List Res → List Res

/-- A tech tree is a list of machines. -/
structure Tech where
  nodes : List Node

/-! ## Bootstrap sequences -/

/-- One firing of one machine: which machine, what went in, what came out. -/
structure Step where
  node : Node
  used : List Res
  made : List Res

/-- A build sequence: machines fired in order. -/
abbrev BootstrapSeq := List Step

/-- The cards a run punches, in order.  This is the run's *output deck*. -/
def emit (seq : BootstrapSeq) : CardSet :=
  seq.flatMap (fun s => s.made.filterMap Res.asCard)

/-- **The bootstrap exceptions**: what an entry is allowed to assume it already
has, rather than building it.  Here: blank brass shims, and nothing else.
Everything with structure in it — every pattern, every punched card — must be
produced by a machine of the tree. -/
def BootstrapExceptions : List Res := [Res.shim]

/-- A single legal firing, against the resources available so far (each tagged
with the tier of the machine that made it) and the tier of the previous step.

The conditions are:
* the machine is in the tree;
* what was fed in matches the input ports, one for one;
* every input is either a declared bootstrap exception, or was made earlier by
  a machine of *strictly lower* tier;
* the outputs are exactly what the machine's `fire` produces;
* no tier skipping: each step stays at the previous tier or climbs by one. -/
def StepOk (t : Tech) (avail : List (Nat × Res)) (prevTier : Nat) (s : Step) : Prop :=
  s.node ∈ t.nodes ∧
  List.Forall₂ (fun (q : Req) (r : Res) => q.accepts r = true) s.node.inputs s.used ∧
  (∀ r ∈ s.used, r ∈ BootstrapExceptions ∨ ∃ k, (k, r) ∈ avail ∧ k < s.node.tier) ∧
  s.made = s.node.fire s.used ∧
  (s.node.tier = prevTier ∨ s.node.tier = prevTier + 1)

/-- A whole sequence is legal, threading the available resources and the tier
through the steps. -/
def Valid (t : Tech) : List (Nat × Res) → Nat → BootstrapSeq → Prop
  | _, _, [] => True
  | avail, prevTier, s :: rest =>
      StepOk t avail prevTier s ∧
      Valid t (avail ++ s.made.map (fun r => (s.node.tier, r))) s.node.tier rest

/-- A bootstrap sequence is valid for a tree when it starts from nothing but
the bootstrap exceptions, at tier zero. -/
def ValidSequence (seq : BootstrapSeq) (t : Tech) : Prop :=
  Valid t [] 0 seq

/-- The tiers of a sequence never decrease and never skip. -/
def TierMonotone : Nat → BootstrapSeq → Prop
  | _, [] => True
  | prev, s :: rest => (s.node.tier = prev ∨ s.node.tier = prev + 1) ∧ TierMonotone s.node.tier rest

/-! ## The loom's instruction set

A pattern card read as a *program* drives the punch.  Each pin is one
instruction; two of them carry an operand in the following pin.  The machine
also holds a second pattern card, the *data* card `d`, on its second barrel.

| pin | name     | effect                                        |
|-----|----------|-----------------------------------------------|
| `0` | `STAMP`  | punch a copy of the data card                 |
| `1` | `FOLD`   | punch the data card fed tail first (reversed) |
| `2` | `SHIM n` | punch a fresh card carrying the single pin `n`|
| `3` | `WEAVE`  | punch the data card twice onto one card       |
| `4` | `LEAD n` | punch pin `n`, then the data card behind it   |

Any other pin height is a tooth the barrel does not catch: it is skipped. -/
def exec : Card → Card → List Card
  | [], _ => []
  | 0 :: rest, d => d :: exec rest d
  | 1 :: rest, d => d.reverse :: exec rest d
  | 2 :: n :: rest, d => [n] :: exec rest d
  | 3 :: rest, d => (d ++ d) :: exec rest d
  | 4 :: n :: rest, d => (n :: d) :: exec rest d
  | _ :: rest, d => exec rest d

/-! ## The two machines -/

/-- **The spindle** (tier 0): the deck itself, mounted.  It needs nothing and
makes the deck's cards readable as patterns.  This is the only node that
depends on the deck; it *is* the deck. -/
def spindle (cs : CardSet) : Node :=
  { name := "Spindle", tier := 0, inputs := [], fire := fun _ => cs.map Res.pattern }

/-- **The loom** (tier 1): a universal reader/punch.  Given a blank shim and
two mounted patterns it reads the first as a program, the second as data, and
punches whatever that program says.  Its definition mentions no deck at all. -/
def loom : Node :=
  { name := "Loom", tier := 1, inputs := [Req.shim, Req.pattern, Req.pattern],
    fire := fun rs => match rs with
      | [Res.shim, Res.pattern p, Res.pattern d] => (exec p d).map Res.card
      | _ => [] }

/-- The tech tree a deck describes: the deck on its spindle, and the loom that
reads it.  Two nodes. -/
def interpret (cs : CardSet) : Tech := { nodes := [spindle cs, loom] }

/-- **The fixed point.**  A deck is *self-copying* when some legal run of the
tree it describes punches out exactly that deck again. -/
def SelfCopying (cs : CardSet) : Prop :=
  ∃ seq : BootstrapSeq, ValidSequence seq (interpret cs) ∧ emit seq = cs

end Bootstrap
