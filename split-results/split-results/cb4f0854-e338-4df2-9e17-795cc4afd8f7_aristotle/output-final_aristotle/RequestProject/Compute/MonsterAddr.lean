/-
# MonsterAddr — Literals as addresses in the Monster structure

## What this is

This module formalizes the **de-duplication pass** described in the project's
design notes: every integer literal appearing in the sources (Lean, or the RDFa
sheaf-section metadata) is no longer treated as a bare constant.  Instead each
occurrence is *lifted* into a canonical coordinate inside a rooted, typed
"Monster" address space, and two occurrences are considered the *same object*
only when they resolve to the *same* `MonsterAddr` — not merely when their raw
decimal values happen to coincide.

The pipeline modelled here is

```
  Source files
      │  extract  (dumb /([0-9]+)/ scan + role classification)
      ▼
  Literal           -- a typed occurrence:  value + role + source span
      │  resolve    (the context-sensitive functor  F : Literals → 𝓜)
      ▼
  MonsterAddr       -- a canonical node in the Monster tree
```

The integers `{62,53,25, 71,59,47, 11, 3, 1, 0}` of the running RDFa example

```html
<div typeof="erdfa:SheafSection dasl:Type3" about="#bafkda51309071503ae6">
  <meta property="erdfa:shard"   content="62,53,25" />
  <meta property="dasl:type"     content="3" />
  <meta property="dasl:bott"     content="0 (R)" />
  <meta property="dasl:hecke"    content="T_11" />
  <meta property="erdfa:prime"   content="1" />
  <meta property="sheaf:orbifold" content="(62 mod 71, 53 mod 59, 25 mod 47)" />
</div>
```

are classified into

  * **moduli**   71, 59, 47        (the CRT die-plate axes; `MonsterConstants.crt_moduli`)
  * **residues** 62 mod 71, 53 mod 59, 25 mod 47   (orbifold coordinates)
  * **hecke**    11                (the Hecke operator `T₁₁`)
  * **type**     3                 (the sheaf typology code)
  * **bott**     0                 (the stable / real zone of the Bott spectrum)
  * **prime tag** 1                (the trivial / unit prime flag)

## The point of the construction

The central invariant is `resolve_eq_iff`:

  `resolve ℓ₁ = resolve ℓ₂  ↔  (ℓ₁.value = ℓ₂.value ∧ ℓ₁.role = ℓ₂.role)`

from which the three design-note proof goals follow directly:

  * `canonicalize_preserves_role`  — the address remembers the role it came from;
  * `same_semantic_object_same_addr` — equal `(value, role)` ⇒ equal address
    (this is *de-duplication*: many spans collapse to one node);
  * `addr_unique_on_normal_form`   — equal address ⇒ equal `(value, role)`
    (distinct semantic objects keep distinct addresses).

In particular `distinct_role_distinct_addr` makes the headline slogan precise:
a `11` used as a Hecke prime and a `11` used as a plain length are *different*
coordinates even though the decimal `11` is the same.
-/

import Mathlib
import RequestProject.MonsterConstants

namespace MonsterDedup

/-! ## §1. Pass 0 — typed literal occurrences -/

/-- The source location of a scanned literal (file, line, column).
    Spans are *forgotten* by `resolve`: they identify an occurrence but never
    its mathematical meaning. -/
structure Span where
  file : String
  line : Nat
  col  : Nat
  deriving Repr, DecidableEq, Inhabited

/-- The semantic role a literal plays at its occurrence site.  This is the
    output of the (heuristic) classifier in the extraction pass.

    `residue` carries the modulus it is reduced against, because an orbifold
    coordinate `r mod m` is only meaningful relative to its axis `m`. -/
inductive LiteralRole
  | modulus              -- a CRT / orbifold axis modulus, e.g. 71, 59, 47
  | residue (mod : Nat)  -- an orbifold coordinate `value mod` , e.g. 62 mod 71
  | heckePrime           -- the index of a Hecke operator `T_p`, e.g. 11
  | bottIndex            -- a Bott-periodicity index, e.g. 0
  | typeCode             -- a sheaf / vertex-operator typology code, e.g. 3
  | primeTag             -- the trivial unit-prime flag, e.g. 1
  | other                -- unclassified coefficient / index
  deriving Repr, DecidableEq, Inhabited

/-- A single typed literal occurrence produced by the scanner. -/
structure Literal where
  value : Nat
  role  : LiteralRole
  span  : Span
  deriving Repr, DecidableEq, Inhabited

/-! ## §2. The Monster address space 𝓜 -/

/-- A canonical node in the Monster tree.  These are the *coordinates* that
    literals resolve to.  Two textual occurrences with the same coordinate are,
    by definition, the same mathematical object. -/
inductive MonsterAddr
  | modulusAxis  (p : Nat)             -- /moduli/M_p
  | orbifoldCoord (res : Nat) (mod : Nat) -- /orbifold/(res mod mod)
  | heckeOp      (p : Nat)             -- /hecke/T_p
  | bottZone     (i : Nat)             -- /bott/i
  | typeNode     (t : Nat)             -- /type/t
  | unitFlag     (v : Nat)             -- /prime/unit   (the distinguished unit prime class)
  | generic      (v : Nat)             -- /generic/v    (fallback by raw value)
  deriving Repr, DecidableEq, Inhabited

/-! ## §3. The resolver  F : Literals → 𝓜  and its left inverses -/

/-- The context-sensitive resolution functor `F`.  It maps a typed literal
    occurrence to its canonical Monster coordinate, *discarding the span*. -/
def resolve (l : Literal) : MonsterAddr :=
  match l.role with
  | .modulus      => .modulusAxis l.value
  | .residue m    => .orbifoldCoord l.value m
  | .heckePrime   => .heckeOp l.value
  | .bottIndex    => .bottZone l.value
  | .typeCode     => .typeNode l.value
  | .primeTag     => .unitFlag l.value
  | .other        => .generic l.value

/-- Recover the role from an address (left inverse of `resolve` on roles). -/
def roleOf : MonsterAddr → LiteralRole
  | .modulusAxis _      => .modulus
  | .orbifoldCoord _ m  => .residue m
  | .heckeOp _          => .heckePrime
  | .bottZone _         => .bottIndex
  | .typeNode _         => .typeCode
  | .unitFlag _         => .primeTag
  | .generic _          => .other

/-- Recover the underlying value from an address (left inverse of `resolve`
    on values). -/
def valueOf : MonsterAddr → Nat
  | .modulusAxis p      => p
  | .orbifoldCoord r _  => r
  | .heckeOp p          => p
  | .bottZone i         => i
  | .typeNode t         => t
  | .unitFlag v         => v
  | .generic v          => v

@[simp] theorem roleOf_resolve (l : Literal) : roleOf (resolve l) = l.role := by
  cases l with | mk v r s => cases r <;> rfl

@[simp] theorem valueOf_resolve (l : Literal) : valueOf (resolve l) = l.value := by
  cases l with | mk v r s => cases r <;> rfl

/-! ## §4. The de-duplication theorems -/

/-- **Master invariant.**  Two occurrences resolve to the *same* Monster
    coordinate exactly when they share both value and role.  The span is
    irrelevant — that is precisely what makes this a de-duplication. -/
theorem resolve_eq_iff (l₁ l₂ : Literal) :
    resolve l₁ = resolve l₂ ↔ (l₁.value = l₂.value ∧ l₁.role = l₂.role) := by
  constructor
  · intro h
    refine ⟨?_, ?_⟩
    · have := congrArg valueOf h; simpa using this
    · have := congrArg roleOf h; simpa using this
  · rintro ⟨hv, hr⟩
    cases l₁ with | mk v₁ r₁ s₁ =>
    cases l₂ with | mk v₂ r₂ s₂ =>
    simp only at hv hr
    subst hv; subst hr; rfl

/-- **Goal 1 — `canonicalize_preserves_role`.**  Canonicalization never loses
    the role: the address always reports the role it was built from. -/
theorem canonicalize_preserves_role (l : Literal) :
    roleOf (resolve l) = l.role := roleOf_resolve l

/-- **Goal 2 — `same_semantic_object_same_addr`.**  Occurrences denoting the
    same semantic object (same value and role, any spans) collapse to a single
    address.  This is the unification half of de-duplication. -/
theorem same_semantic_object_same_addr {l₁ l₂ : Literal}
    (hv : l₁.value = l₂.value) (hr : l₁.role = l₂.role) :
    resolve l₁ = resolve l₂ := (resolve_eq_iff l₁ l₂).mpr ⟨hv, hr⟩

/-- **Goal 3 — `addr_unique_on_normal_form`.**  Conversely, a shared address
    forces a shared `(value, role)`: distinct semantic objects never alias. -/
theorem addr_unique_on_normal_form {l₁ l₂ : Literal}
    (h : resolve l₁ = resolve l₂) : l₁.value = l₂.value ∧ l₁.role = l₂.role :=
  (resolve_eq_iff l₁ l₂).mp h

/-- **The headline slogan, made precise.**  Two literals with *different roles*
    never share an address — even if their raw decimal values are identical.
    So `11` as a Hecke prime and `11` as a plain length are different
    coordinates in the Monster. -/
theorem distinct_role_distinct_addr {l₁ l₂ : Literal}
    (hr : l₁.role ≠ l₂.role) : resolve l₁ ≠ resolve l₂ := by
  intro h
  exact hr ((resolve_eq_iff l₁ l₂).mp h).2

/-! ## §5. The running RDFa sheaf-section example -/

/-- A scanned sheaf section: the structured result of running the extractor on
    one `<div typeof="erdfa:SheafSection …">` block.  Field order is irrelevant
    to the resulting address tree. -/
structure SheafSection where
  /-- the orbifold triple `(r₁ mod m₁, r₂ mod m₂, r₃ mod m₃)` -/
  shard   : (Nat × Nat) × (Nat × Nat) × (Nat × Nat)
  hecke   : Nat
  typeCd  : Nat
  bott    : Nat
  primeTg : Nat
  deriving Repr, DecidableEq

/-- The running example from the design notes. -/
def exampleSection : SheafSection where
  shard   := ((62, 71), (53, 59), (25, 47))
  hecke   := 11
  typeCd  := 3
  bott    := 0
  primeTg := 1

/-- Flatten a scanned section into the list of typed literal occurrences the
    scanner emits (spans are schematic here). -/
def SheafSection.literals (s : SheafSection) : List Literal :=
  let sp := fun (n : Nat) => (⟨"rdfa", n, 0⟩ : Span)
  let (a, b, c) := s.shard
  [ ⟨a.1, .residue a.2, sp 1⟩, ⟨a.2, .modulus, sp 1⟩,
    ⟨b.1, .residue b.2, sp 2⟩, ⟨b.2, .modulus, sp 2⟩,
    ⟨c.1, .residue c.2, sp 3⟩, ⟨c.2, .modulus, sp 3⟩,
    ⟨s.hecke,   .heckePrime, sp 4⟩,
    ⟨s.typeCd,  .typeCode,   sp 5⟩,
    ⟨s.bott,    .bottIndex,  sp 6⟩,
    ⟨s.primeTg, .primeTag,   sp 7⟩ ]

/-- The canonical address tree of a section: resolve every literal. -/
def SheafSection.addrs (s : SheafSection) : List MonsterAddr :=
  s.literals.map resolve

/-- The example resolves to exactly the expected Monster coordinates. -/
theorem exampleSection_addrs :
    exampleSection.addrs =
      [ .orbifoldCoord 62 71, .modulusAxis 71,
        .orbifoldCoord 53 59, .modulusAxis 59,
        .orbifoldCoord 25 47, .modulusAxis 47,
        .heckeOp 11, .typeNode 3, .bottZone 0, .unitFlag 1 ] := by
  decide

/-! ## §6. De-duplication facts about the example -/

/-- **Unification across spans.**  Two scans of the same Hecke operator `T₁₁`
    at different source locations collapse to one address. -/
theorem hecke_dedup (s₁ s₂ : Span) :
    resolve ⟨11, .heckePrime, s₁⟩ = resolve ⟨11, .heckePrime, s₂⟩ :=
  same_semantic_object_same_addr rfl rfl

/-- **Role separation.**  A `11` read as a Hecke prime and a `11` read as a
    plain coefficient are *not* unified. -/
theorem hecke_vs_other_not_dedup (s₁ s₂ : Span) :
    resolve ⟨11, .heckePrime, s₁⟩ ≠ resolve ⟨11, .other, s₂⟩ :=
  distinct_role_distinct_addr (by
    show LiteralRole.heckePrime ≠ LiteralRole.other; decide)

/-- **Residues separate by axis.**  The same residue value reduced against two
    different moduli lands on two different orbifold coordinates. -/
theorem residue_axis_separates (s₁ s₂ : Span) :
    resolve ⟨25, .residue 47, s₁⟩ ≠ resolve ⟨25, .residue 59, s₂⟩ :=
  distinct_role_distinct_addr (by
    show LiteralRole.residue 47 ≠ LiteralRole.residue 59; decide)

/-! ## §7. Tie-in with the real Monster constants -/

/-- The three orbifold moduli of the example are exactly the CRT die-plate axes
    `MonsterConstants.crt_moduli = (47, 59, 71)`. -/
theorem example_moduli_are_crt :
    (exampleSection.shard.2.2.2, exampleSection.shard.2.1.2,
      exampleSection.shard.1.2) = MonsterConstants.crt_moduli := by
  decide

/-- All four "prime-flavoured" literals of the example (the three moduli and the
    Hecke index) are genuine supersingular primes of the Monster. -/
theorem example_primes_are_supersingular :
    71 ∈ MonsterConstants.supersingularPrimes ∧
    59 ∈ MonsterConstants.supersingularPrimes ∧
    47 ∈ MonsterConstants.supersingularPrimes ∧
    11 ∈ MonsterConstants.supersingularPrimes := by
  decide

/-- The product of the three orbifold moduli is `196883`, the CRT factorization
    that underlies the Monster's smallest faithful representation. -/
theorem example_moduli_product :
    exampleSection.shard.1.2 * exampleSection.shard.2.1.2 *
      exampleSection.shard.2.2.2 = MonsterConstants.crt_product := by
  decide

end MonsterDedup
