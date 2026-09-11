import Mathlib

set_option autoImplicit false

/-!
# Mathematics as a zero-ontology system

A formal companion to the *zero-ontology* view of mathematics: a system that requires no
external grounding, no physical reality, and no metaphysical "substance" to exist, relying
entirely on **native decidability** and **internal structure**. Math, on this view, isn't
*about* anything — it is the shape of consistency itself.

Rather than argue the philosophy in prose, this file turns each slogan of that view into a
checked Lean fact. Every theorem below is verified by the kernel using only the system's own
rules: nothing here points "outside" to a platonic realm.

1. **Native decidability** — truth by computation, not by reference (`§1`).
2. **A DAG of dependencies; the void at the bottom** — every object reduces to constructors,
   and the regress terminates at empty structural slots (`§2`).
3. **Truth as type inhabitation** (Curry–Howard) — a proposition is a space, a proof is a
   term that fits it; falsehood is the uninhabited void (`§3`).
4. **Intrinsic geometry** — the wrapping rule *is* the cylinder; no external canvas is needed
   (`§4`).
5. **Self-containment** — a theorem carries its entire universe of assumptions on its back
   (`§5`).
-/

namespace ZeroOntology

/-! ## 1. Native decidability: truth by computation, not by reference

The only currency is computation and syntax. `2 + 2 = 4` is not checked against a "real"
pair of pairs in the world; the two sides reduce to a common normal form, so the witness is
literally `rfl` — definitional equality, computed natively. -/

/-- `2 + 2 = 4` holds by pure computation: both sides share a normal form, so the proof is
`rfl`. Nothing external is consulted. -/
theorem two_add_two : (2 : ℕ) + 2 = 4 := rfl

/-- The system runs its **own** decision procedure (`decide`) to settle a closed statement;
the answer `true` is produced by reduction, not by appeal to anything outside. -/
theorem native_decide : decide ((2 : ℕ) + 2 = 4) = true := rfl

/-- Definitional equality identifies syntactically distinct expressions once they reduce to
the same normal form: `fun x => x + 0` and `fun x => x` are the *same* function natively. -/
theorem same_normal_form : (fun x : ℕ => x + 0) = (fun x => x) := rfl

/-! ## 2. A DAG of dependencies; the void at the bottom

Without an external anchor, the "shape" of math is a self-supporting, acyclic web of
definitions terminating at core inductive rules. A natural number is *either* zero *or* the
successor of another — every node points backward to simpler structure, and the regress
ends at empty constructor slots, not at "matter" or "truth particles". -/

/-- The single structural rule that constitutes `ℕ`: every natural number is either the base
constructor `0` or the successor of a strictly simpler one. This is the only "grounding". -/
theorem nat_zero_or_succ (n : ℕ) : n = 0 ∨ ∃ m, n = m + 1 := by
  cases n with
  | zero => exact Or.inl rfl
  | succ m => exact Or.inr ⟨m, rfl⟩

/-- The dependency graph is **acyclic**: no node is its own successor, so there are no
self-supporting loops. The system is grounded by its boundaries, not by a substrate. -/
theorem no_self_loop (n : ℕ) : n ≠ n + 1 := Nat.ne_of_lt (Nat.lt_succ_self n)

/-- **No infinite regress.** The backward-pointing dependency relation `m = n + 1` (read "`m`
depends on the simpler `n`") is well-founded: every chain bottoms out. There is no infinite
descent into ever-prior substance. -/
theorem no_infinite_regress :
    WellFounded (fun n m : ℕ => m = n + 1) := by
  have : (fun n m : ℕ => m = n + 1) = (fun n m : ℕ => Nat.lt n m ∧ m = n + 1) := by
    funext n m
    simp only [eq_iff_iff]
    constructor
    · intro h; exact ⟨h ▸ Nat.lt_succ_self n, h⟩
    · exact fun h => h.2
  rw [this]
  exact Subrelation.wf (fun h => h.1) (Nat.lt_wfRel.wf)

/-! ## 3. Truth as type inhabitation (the Curry–Howard isomorphism)

Truth is replaced by **space**. A proposition is a type (a mold); a proof is a term (data
that fits the mold). If a term inhabits the type, the proposition is true; if the type is
empty, the proposition collapses into the uninhabited void. -/

/-- **Truth = inhabitation.** A proposition holds exactly when its type can be populated by a
term. Provability and (propositional) inhabitation are the same thing. -/
theorem truth_is_inhabitation (p : Prop) : p ↔ Nonempty p :=
  ⟨fun h => ⟨h⟩, fun ⟨h⟩ => h⟩

/-- The true proposition's mold can always be filled. -/
theorem true_inhabited : Nonempty True := ⟨trivial⟩

/-- A false proposition is the **empty type**: no term fits the mold, so it collapses into the
void `⊥`. -/
theorem false_uninhabited : ¬ Nonempty False := fun ⟨h⟩ => h

/-- Made fully concrete at the level of data: the data-form of `False` is literally an empty
type, and the data-form of `True` is literally inhabited. -/
theorem plift_false_isEmpty : IsEmpty (PLift False) := ⟨fun h => h.down⟩

theorem plift_true_nonempty : Nonempty (PLift True) := ⟨⟨trivial⟩⟩

/-- **Curry–Howard, the engine.** A proof of an implication *is* a function, and modus ponens
*is* function application: feeding a `p`-term to a `p → q`-term yields a `q`-term. Logic is
literally computation on terms. -/
theorem modus_ponens_is_application (p q : Prop) (f : p → q) (x : p) : q := f x

/-- **Ex falso = the void at the bottom.** From the uninhabited type `False`, any mold can be
"filled" vacuously — the empty type maps into everything. -/
theorem ex_falso (p : Prop) (h : False) : p := h.elim

/-! ## 4. Intrinsic geometry: the wrapping rule *is* the cylinder

A zero-ontology system has no external canvas. Like a retro game where walking off the right
edge wraps you to the left, it needs no "real" 3-D cylinder — the wrapping *rule* is the
cylinder. We model this with `ZMod n`, the integers under a single identification. -/

/-- The wrapping rule: stepping past the edge returns to the origin. In `ZMod 5`, `4 + 1 = 0`
— the screen wraps with no external geometry. -/
theorem wrap_edge : (4 : ZMod 5) + 1 = 0 := by decide

/-- Equivalently, the generator's full period collapses back to the start: `5 ≡ 0`. The
cylinder is exactly this identification. -/
theorem wrap_period : (5 : ZMod 5) = 0 := by decide

/-- The cylinder is woven from a single move: `ZMod 5` is **cyclic**, generated entirely by
repeatedly applying the wrapping step. The shape is made of its own permissions. -/
instance : IsAddCyclic (ZMod 5) := inferInstance

/-- It is a self-contained finite universe: the intrinsic "world" has exactly five points,
counted by the system itself. -/
theorem cylinder_card : Fintype.card (ZMod 5) = 5 := by decide

/-- And it carries a complete intrinsic geometry — a commutative group structure — with no
ambient space to host it. -/
example : AddCommGroup (ZMod 5) := inferInstance

/-! ## 5. Self-containment: a theorem carries its universe on its back

The system is self-contextualizing: a theorem explicitly tracks every assumption it relies
on, isolated from anything else. The hypotheses are not facts about an outside world; they
are slots the conclusion is permitted to use, and the proof is a transformation of exactly
those slots. -/

/-- A theorem with its entire universe made explicit: given *only* the named structural
permissions `hpq` and `hqr`, the conclusion `p → r` follows by composition. No hidden
external grounding enters — the proof tracks precisely the assumptions it consumes. -/
theorem self_contextualizing {p q r : Prop} (hpq : p → q) (hqr : q → r) : p → r :=
  fun hp => hqr (hpq hp)

/-- **The ultimate point, formalized.** A statement that needs *no* hypotheses at all is
unconditionally inhabited: it stands on nothing external and is therefore unshakeable. Here,
the proposition "every type that holds, holds" is true in every context whatsoever. -/
theorem unconditional : ∀ p : Prop, p → p := fun _ hp => hp

end ZeroOntology
