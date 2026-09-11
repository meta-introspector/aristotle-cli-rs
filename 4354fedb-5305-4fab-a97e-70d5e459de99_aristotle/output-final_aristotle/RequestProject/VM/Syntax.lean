/-
# A certified-complexity VM: syntax and semantics

This is the little machine language the whole development is aimed at. A
program is a **cascade of layers**, which is exactly the shape of a
Krohn-Rhodes decomposition:

* `Prog.nil` — the empty machine (one state);
* `Prog.reset R p act` — adds a *reset layer* with state set `R` on top of the
  sub-program `p`. On each input letter the layer either does nothing
  (`act a q = none`) or jumps to a fixed state (`act a q = some r`). Both the
  letter and the state `q` of the layers *below* may be inspected; the layer's
  own state never influences its successor except by being kept. This is the
  flip-flop `U₂` component of Krohn-Rhodes;
* `Prog.group G p act` — adds a *group layer* with state set a finite group
  `G`, whose state is multiplied on the right by a group element chosen from
  the letter and the state below. This is the group component.

Because a layer's next state never depends on the states of layers *above* it,
a program denotes a genuine wreath-product cascade, and its complexity class can
be read off the syntax:

* `Prog.groupDepth` — the number of group layers, i.e. the declared
  Krohn-Rhodes group-complexity level;
* `Prog.groupCapacity` — the product of the orders of the groups used, i.e. the
  declared group budget.

`RequestProject/VM/Certification.lean` proves that these syntactic numbers are
honest: a program with `groupDepth = 0` provably has an aperiodic transition
monoid, hence (by `RequestProject/KrohnRhodes/Aperiodic.lean`) no nontrivial
group divisor whatsoever.
-/
import RequestProject.KrohnRhodes.Cascade

namespace VM

open KrohnRhodes

/-- Programs of the VM, indexed by their state type. Instances are carried as
explicit data fields so that programs can be manipulated as ordinary terms. -/
inductive Prog (A : Type) : Type → Type 1
  | nil : Prog A Unit
  | reset {Q : Type} (R : Type) (hR : Fintype R) (p : Prog A Q) (act : A → Q → Option R) :
      Prog A (R × Q)
  | group {Q : Type} (G : Type) (hG : Group G) (hF : Fintype G) (p : Prog A Q)
      (act : A → Q → G) : Prog A (G × Q)

namespace Prog

variable {A : Type} {Q : Type}

/-- One step of the machine on a letter. -/
def step : {Q : Type} → Prog A Q → A → Q → Q
  | _, nil, _, q => q
  | _, reset _ _ p act, a, (r, q) => ((act a q).getD r, p.step a q)
  | _, group _ hG _ p act, a, (g, q) =>
      (letI := hG; g * act a q, p.step a q)

/-- Every program has a finite state set. -/
theorem finite_state : {Q : Type} → (p : Prog A Q) → Finite Q
  | _, nil => inferInstanceAs (Finite Unit)
  | _, reset _ hR p _ => by
      haveI := hR
      haveI := finite_state p
      exact inferInstanceAs (Finite (_ × _))
  | _, group _ _ hF p _ => by
      haveI := hF
      haveI := finite_state p
      exact inferInstanceAs (Finite (_ × _))

/-- The **declared complexity level** of a program: how many group layers it
uses. `groupDepth = 0` is the certified "reset-only" class. -/
def groupDepth : {Q : Type} → Prog A Q → ℕ
  | _, nil => 0
  | _, reset _ _ p _ => p.groupDepth
  | _, group _ _ _ p _ => p.groupDepth + 1

/-- The **declared group budget** of a program: the product of the orders of the
groups it uses (an empty product, i.e. `1`, for reset-only programs). -/
def groupCapacity : {Q : Type} → Prog A Q → ℕ
  | _, nil => 1
  | _, reset _ _ p _ => p.groupCapacity
  | _, group G _ hF p _ => (@Fintype.card G hF) * p.groupCapacity

/-- The state maps realized by single letters. -/
def letterEnd (p : Prog A Q) (a : A) : Function.End Q := fun q => p.step a q

/-- The **transition monoid of a program**: all state maps realized by input
words. It does not depend on the choice of start state or accepting set. -/
def monoid (p : Prog A Q) : Submonoid (Function.End Q) :=
  Submonoid.closure (Set.range p.letterEnd)

/-- A program together with a start state and an accepting set denotes a DFA. -/
def toDFA (p : Prog A Q) (start : Q) (accept : Set Q) : DFA A Q where
  step q a := p.step a q
  start := start
  accept := accept

@[simp] lemma toDFA_step (p : Prog A Q) (start : Q) (accept : Set Q) (q : Q) (a : A) :
    (p.toDFA start accept).step q a = p.step a q := rfl

lemma letterMap_toDFA (p : Prog A Q) (start : Q) (accept : Set Q) (a : A) :
    letterMap (p.toDFA start accept) a = p.letterEnd a := rfl

/-- The program's transition monoid is the transition monoid of the automaton it
denotes, for any start state and accepting set. -/
lemma monoid_eq_transitionMonoid (p : Prog A Q) (start : Q) (accept : Set Q) :
    p.monoid = transitionMonoid (p.toDFA start accept) := rfl

/-- The language recognized by a program with a given start state and accepting
set. -/
def accepts (p : Prog A Q) (start : Q) (accept : Set Q) : Language A :=
  (p.toDFA start accept).accepts

end Prog

end VM
