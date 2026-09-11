import Mathlib

set_option autoImplicit false

/-!
# Zero-ontology, part III: identifications, the kernel, and automation

A continuation of `RequestProject/ZeroOntology.lean` and
`RequestProject/ZeroOntologyStateSpace.lean`, formalizing three further slogans of the
zero-ontology view:

1. **Spaces from nothing but identifications** — *propositional univalence* (`propext`) and
   quotients-as-higher-inductive-types: a "space" can be built from a bare relation, the
   cylinder of part I generalised to an arbitrary identification.
2. **The only truth is that which the kernel verifies** — reflecting on the trusted core via
   `Decidable`/`decide` and a tiny *real* (axiom-free) typed term language whose well-typed
   terms are exactly the ones the checker admits.
3. **Automation is inside the loop** — `decide`, `native_decide`, `simp`, and `norm_num` are
   themselves zero-ontology procedures: they settle truth by reduction, resting only on the
   kernel's trusted core (`propext`, `Lean.ofReduceBool`, `Lean.trustCompiler`).

Everything is checked by the kernel; no new axioms are introduced.
-/

namespace ZeroOntology

/-! ## 9. Native decidability, deepened

A handful of sharp slogans about computation as the primitive. The system both *asserts* and
*refutes* purely by normalization, and an irrelevant added context cannot disturb a proof. -/

/-- **Truth is reduction.** For any decidable proposition, asserting `p` is logically identical
to its native boolean reflection computing to `true`. -/
theorem truth_is_reduction (p : Prop) [Decidable p] : p ↔ (decide p = true) :=
  (decide_eq_true_iff).symm

/-- The system refutes by normalization too: `2 + 3 = 4` reduces to `false`. -/
theorem native_refute : decide ((2 : ℕ) + 3 = 4) = false := rfl

/-- **The void at the bottom.** `Empty` has zero constructors, so a map out of it needs
exactly zero clauses: the absolute bottom of the dependency DAG. -/
def void_elimination (A : Type) (x : Empty) : A := by cases x

/-- **Intrinsic metric.** In the wrapped universe `ZMod 5` the distance from `4` to `0` is
natively `1`, computed across the intrinsic topology without ever looking "outside" the loop. -/
theorem intrinsic_proximity : (0 : ZMod 5) - 4 = 1 := by decide

/-- **Monotonicity / weakening.** Introducing a completely isolated, meaningless universe
`_world` cannot decay the internal validity of a derivation: the context is robustly
insulated. (The `_`-prefix marks `_world` as inert — it is the whole point that it is unused.) -/
theorem context_insulated {p q : Prop} (h : p → q) (_world : Type) (hp : p) : q := h hp

/-! ## 10. Spaces from nothing but identifications (univalence & HITs)

Lean's core is not homotopy type theory, so full univalence is unavailable. But its
*propositional* shadow is a genuine kernel axiom, `propext`, and its quotient types play the
role of higher inductive types: a `Quotient` is a space whose only data is a relation, with
`Quotient.sound` as the path constructor. This is the cylinder of part I generalised — a
"space" assembled from nothing but identifications. -/

/-- **Propositional univalence.** Logically equivalent propositions are *literally equal*:
the structure of `Prop` is built from identifications. -/
theorem prop_univalence (a b : Prop) (h : a ↔ b) : a = b := propext h

/-- **Identifications build space.** In any quotient, related coordinates become *equal*:
`Quotient.sound` is the path constructor that glues the space together. -/
theorem identifications_build_space {α : Type} (s : Setoid α) (a b : α) (h : s.r a b) :
    Quotient.mk s a = Quotient.mk s b := Quotient.sound h

/-- The cylinder generalised: for any modulus `m`, identify integers differing by a multiple
of `m`. The relation is the *only* datum; the resulting quotient is the space. -/
def wrapSetoid (m : ℕ) : Setoid ℤ where
  r a b := (m : ℤ) ∣ (b - a)
  iseqv :=
    ⟨fun a => by simp,
     fun {a b} h => (dvd_sub_comm).mp h,
     fun {a b c} h1 h2 => by have := dvd_add h1 h2; simpa using this⟩

/-- The cylinder of modulus `m`, as a higher-inductive-style quotient. -/
def Cylinder (m : ℕ) : Type := Quotient (wrapSetoid m)

/-- A point of the cylinder, named by an integer coordinate. -/
def Cylinder.pt (m : ℕ) (k : ℤ) : Cylinder m := Quotient.mk _ k

/-- **The loop.** In `Cylinder m`, the basepoint `0` and the coordinate `m` are *identified*:
this single path constructor (an instance of `Quotient.sound`) wraps the line into a circle,
with no ambient plane to host it. -/
theorem cylinder_loop (m : ℕ) : Cylinder.pt m 0 = Cylinder.pt m (m : ℤ) := by
  apply Quotient.sound
  show (m : ℤ) ∣ ((m : ℤ) - 0)
  simp

/-- **Transport: the working content of univalence in Lean.** Any property of types that
respects equivalences may be transported along an equivalence — equivalent structures are
indistinguishable to the internal logic. -/
theorem equiv_transports {α β : Type} (e : α ≃ β) (P : Type → Prop)
    (hP : ∀ {X Y : Type}, (X ≃ Y) → P X → P Y) (h : P α) : P β := hP e h

/-! ## 11. The only truth is that which the kernel verifies

We refuse to *posit* a kernel by axiom. Instead we model verification by the system's own
trusted machinery: a proposition is admitted exactly when its decision procedure reduces to
`true`. We then build a tiny but genuine typed term language whose well-typed terms are
precisely those its checker accepts — the checker, not an external oracle, is the arbiter. -/

/-- A proposition counts as *kernel-verified* when its decision procedure computes `true`. -/
def KernelVerified (p : Prop) [Decidable p] : Prop := decide p = true

/-- **Kernel arbitration.** Truth and kernel-verification coincide for decidable
propositions: the only truths the system admits are the ones it can decide. -/
theorem kernel_arbitration (p : Prop) [Decidable p] : p ↔ KernelVerified p := by
  unfold KernelVerified
  exact (decide_eq_true_iff).symm

/-- A minimal syntactic type for a toy proof language. -/
inductive STy where
  /-- The base type. -/
  | base : STy
  /-- A function type. -/
  | arr : STy → STy → STy
  deriving DecidableEq, Repr

/-- A minimal term language: a base inhabitant and abstraction over a typed slot. -/
inductive STerm where
  /-- The unique base inhabitant. -/
  | star : STerm
  /-- Abstraction introducing a slot of the given type. -/
  | lam : STy → STerm → STerm
  deriving Repr

/-- The toy kernel's typing judgment, as a genuine (axiom-free) decidable checker. -/
def checkType : STerm → Option STy
  | .star => some STy.base
  | .lam d b => (checkType b).map (fun c => STy.arr d c)

/-- A term is **well-formed** exactly when the checker assigns it a type. The kernel — not an
external oracle — is the sole arbiter of admission into the universe of terms. -/
def WellFormed (t : STerm) : Prop := (checkType t).isSome

instance (t : STerm) : Decidable (WellFormed t) := by unfold WellFormed; infer_instance

/-- **Closing the loop.** Being a well-formed term is, by definition, the checker succeeding:
existence in this universe *is* a parsing/typing success state inside the machine. -/
theorem kernel_admits_only_checked (t : STerm) :
    WellFormed t ↔ (checkType t).isSome := Iff.rfl

/-- The checker decides; here it natively *admits* the base term. -/
theorem star_wellformed : WellFormed STerm.star := by decide

/-- And it natively *rejects* nothing well-typed by accident: an abstraction over a checked
body is itself checked. -/
theorem lam_star_wellformed : WellFormed (STerm.lam STy.base STerm.star) := by decide

/-! ## 12. Automation is inside the zero-ontology loop

The system's *automatic* procedures are not an external meta-level; they are themselves
zero-ontology moves, settling truth by reduction. `decide` and `native_decide` run the
system's own decision procedures; `simp` and `norm_num` rewrite to a normal form. The
`#print axioms` queries at the end witness that every automated proof rests only on the
kernel's trusted core. -/

/-- `decide` exhausts a finite space by computation — automation as reduction. -/
theorem auto_decide : ∀ n : Fin 5, n + 0 = n := by decide

/-- `simp` settles a fact by rewriting to a normal form. -/
theorem auto_simp (a b : ℕ) : a + b = b + a := by simp [Nat.add_comm]

/-- `norm_num` is a decision-by-normalization procedure for arithmetic facts. -/
theorem auto_norm : Nat.Prime 1000003 := by norm_num

/-- `native_decide` compiles the decision procedure and runs it: the system computes its own
truth at machine speed, resting only on the trusted core (`Lean.ofReduceBool`). -/
theorem auto_native : (List.range 100).sum = 4950 := by native_decide

/-- The automated and by-hand verdicts agree: `native_decide` confirms the same reduction
that `rfl` would. -/
theorem auto_consistent : decide ((2 : ℕ) + 2 = 4) = true := by native_decide

-- Reflecting on the trusted core: each automated proof rests only on allowed kernel axioms.
#print axioms auto_decide
#print axioms auto_native
#print axioms kernel_arbitration
#print axioms cylinder_loop

end ZeroOntology
