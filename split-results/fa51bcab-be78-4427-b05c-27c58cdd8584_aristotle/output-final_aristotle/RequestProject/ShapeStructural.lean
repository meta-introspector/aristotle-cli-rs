/-
ShapeStructural.lean — exploiting the genuine multidimensional Clifford layer and the
similarity / renaming bridge of `RequestProject/ShapeCliffordGenuine.lean`.

This file carries the geometric and structural program one step further:

1.  **Geometric operations on the anti-commuting axes.** Using the genuine generators
    `Genuine.E i` (real Clifford vectors on orthogonal size axes), we package the *outer
    product* (`Genuine.wedge`) of two distinct size axes, prove its antisymmetry
    (`Genuine.wedge_antisymm`, an immediate consequence of `Genuine.E_anticomm`), and prove
    that such a **bivector squares to a negative scalar** (`Genuine.E_bivector_sq`):
    `(E i * E j)² = -(i² · j²)`. This is the hallmark geometric-algebra fact that the original
    one-dimensional ("thin", commutative) construction could never exhibit.

2.  **A coordinate-free "Structural Shape" type.** Building on the renaming bridge
    (`wordSimilarN_map`, `wordSimilarN_of_map_injective`), we introduce a *canonical form*
    `canon` of a size word — relabelling its sizes by a fixed deterministic scheme — that is
    invariant under every injective renaming (`canon_map_injective`). Two size words are
    *renaming-equivalent* (`RenEquiv`) exactly when they share this canonical form; this is an
    equivalence relation, and the quotient `StructuralShape` is a pure, coordinate-free type of
    shapes modulo renaming of their sizes. Genuinely structural quantities — the number of
    arrows (`StructuralShape.length`) and the number of distinct sizes used
    (`StructuralShape.distinctSizes`) — descend to it, and an injective renaming of a shape's
    sizes leaves its structural shape unchanged (`structuralOf_map_injective`).
-/
import Mathlib
import RequestProject.ShapeCliffordGenuine

namespace ShapeAlgebra

open SizeSignature

/-! ## Geometric operations on the genuine anti-commuting axes -/

namespace Genuine

open CliffordAlgebra

variable (N : Nat)

/-- The **outer product** (wedge) of two size axes. For *distinct* sizes the axes are
orthogonal, so their geometric product `E i * E j` already *is* the wedge `E i ∧ E j`: a pure
grade-2 **bivector**. -/
noncomputable def wedge (i j : Fin N) : CliffordAlgebra (Qm N) := E N i * E N j

/-- The outer product of distinct size axes is **antisymmetric**: `E i ∧ E j = -(E j ∧ E i)`.
This is exactly the anti-commutation of distinct generators. -/
theorem wedge_antisymm {i j : Fin N} (h : i ≠ j) : wedge N i j = -(wedge N j i) := by
  unfold wedge
  exact E_anticomm N h

/-
A **bivector squares to a negative scalar**: for distinct sizes `i ≠ j`,
`(E i * E j)² = -(i² · j²)`. This is the signature geometric-algebra phenomenon — impossible in
the original commutative one-dimensional construction.
-/
theorem E_bivector_sq {i j : Fin N} (h : i ≠ j) :
    (E N i * E N j) * (E N i * E N j)
      = algebraMap ℚ (CliffordAlgebra (Qm N)) (-(((i : ℕ) : ℚ) ^ 2 * ((j : ℕ) : ℚ) ^ 2)) := by
  convert congr_arg ( fun x : CliffordAlgebra ( Qm N ) => -x ) ( mul_assoc ( E N i ) ( E N i ) ( E N j * E N j ) ) using 1;
  · have hba : E N j * E N i = -(E N i * E N j) := E_anticomm N (Ne.symm h)
    simp +decide only [mul_assoc];
    simp +decide only [← mul_assoc, hba];
    simp +decide [ mul_assoc, mul_neg ];
  · simp +decide [ ← mul_assoc, E_sq ]

end Genuine

/-! ## A canonical form for size words, invariant under renaming -/

open List

/-- The **canonical form** of a size word: each size is relabelled by a fixed deterministic
scheme (its index among the distinct sizes). Distinct *values* are forgotten; only the
*pattern* of equalities and the order are retained. Two words have the same canonical form iff
one is an injective renaming of the other. -/
def canon (l : List Nat) : List Nat := l.map (fun x => l.dedup.idxOf x)

/-
Renaming the indices of `idxOf` by an injective `f` does not change the resulting index.
-/
theorem idxOf_map_inj (f : Nat → Nat) (hf : Function.Injective f) (l : List Nat) (x : Nat) :
    (l.map f).idxOf (f x) = l.idxOf x := by
  unfold List.idxOf
  rw [List.findIdx_map]
  congr 1; ext a; simp [Function.comp, hf.eq_iff]

/-
**The canonical form is invariant under every injective renaming** of the sizes:
`canon (l.map f) = canon l`. This is the heart of the renaming bridge.
-/
theorem canon_map_injective (f : Nat → Nat) (hf : Function.Injective f) (l : List Nat) :
    canon (l.map f) = canon l := by
  unfold canon
  rw [List.dedup_map_of_injective hf, List.map_map]
  apply List.map_congr_left
  intro x _
  simp only [Function.comp_apply]
  rw [idxOf_map_inj f hf]

/-- The canonical form has the same length as the original word (no arrows are lost). -/
@[simp] theorem canon_length (l : List Nat) : (canon l).length = l.length := by
  unfold canon; simp

/-
The canonical form uses exactly as many distinct sizes as the original word.
-/
theorem canon_dedup_length (l : List Nat) : (canon l).dedup.length = l.dedup.length := by
  convert congr_arg Finset.card ( show ( l.dedup.map ( fun x => l.dedup.idxOf x ) ).toFinset = Finset.range ( l.dedup.length ) from ?_ ) using 1;
  · convert congr_arg Finset.card ( show ( l.map ( fun x => l.dedup.idxOf x ) ).toFinset = ( l.dedup.map ( fun x => l.dedup.idxOf x ) ).toFinset from ?_ ) using 1;
    ext; simp [List.mem_toFinset, List.mem_map];
  · norm_num;
  · ext x;
    constructor <;> intro h <;> simp_all +decide [ List.mem_map ];
    · obtain ⟨ a, ha₁, rfl ⟩ := h; exact List.idxOf_lt_length_iff.mpr ( by aesop ) ;
    · use l.dedup[x]!;
      grind +suggestions

/-
The canonical form is **idempotent** — it is a genuine canonical representative.
-/
theorem canon_idem (l : List Nat) : canon (canon l) = canon l := by
  -- By definition of `canon`, we know that `canon l` is a list of indices of `l` in `l.dedup`.
  set g := fun x => l.dedup.idxOf x with hg_def
  have h_g : ∀ x ∈ l, g x < l.dedup.length ∧ List.Nodup (l.dedup.map g) ∧ l.dedup.map g = List.range (l.dedup.length) := by
    intro x hx; have := idxOf_lt_length_iff.mpr ( show x ∈ l.dedup from by simpa using hx ) ; simp_all +decide [ List.Nodup ] ;
    refine' ⟨ _, _ ⟩;
    · rw [ List.pairwise_map, List.pairwise_iff_get ];
      grind +suggestions;
    · refine' List.ext_get _ _ <;> simp +decide;
      grind +suggestions;
  have h_canon_idempotent : ∀ (l : List Nat) (g : Nat → Nat), (∀ x ∈ l, g x < l.dedup.length ∧ List.Nodup (l.dedup.map g) ∧ l.dedup.map g = List.range (l.dedup.length)) → List.map (fun x => List.idxOf x (List.dedup (List.map g l))) (List.map g l) = List.map g l := by
    intros l g hg
    have h_dedup : List.dedup (List.map g l) = List.range (l.dedup.length) := by
      have h_dedup : List.dedup (List.map g l) = List.dedup (List.map g (List.dedup l)) := by
        have h_map_dedup : ∀ (l : List ℕ) (g : ℕ → ℕ), List.dedup (List.map g l) = List.dedup (List.map g (List.dedup l)) := by
          intros l g; induction' l with hd tl ih <;> simp +decide [ * ] ;
          by_cases h : hd ∈ tl <;> simp +decide [ h ];
          · rw [ ← ih, List.dedup_cons_of_mem ] ; aesop;
          · by_cases h' : g hd ∈ List.map g tl <;> simp_all +decide [ List.dedup_cons_of_mem ];
        apply h_map_dedup;
      by_cases h : l.dedup = [] <;> simp_all +decide;
      rw [ hg _ ( Classical.choose_spec ( List.length_pos_iff_exists_mem.mp ( List.length_pos_iff.mpr h ) ) ) |>.2.2, List.dedup_eq_self.mpr ( List.nodup_range ) ];
    simp +decide [ h_dedup, List.idxOf ];
    intro x hx; have := hg x hx; simp_all +decide [ List.findIdx_eq ] ;
    exact fun j hj => ne_of_lt hj;
  convert h_canon_idempotent l g h_g using 1

/-! ## The coordinate-free Structural Shape type -/

/-- Two size words are **renaming-equivalent** when they share a canonical form, i.e. one is an
injective renaming of the other. -/
def RenEquiv (u v : List Nat) : Prop := canon u = canon v

/-- Renaming-equivalence is an equivalence relation. -/
theorem renEquiv_equivalence : Equivalence RenEquiv := by
  constructor
  · intro x; rfl
  · intro x y h; exact h.symm
  · intro x y z h1 h2; exact h1.trans h2

/-- Renaming-equivalence as a `Setoid` on size words. -/
def renSetoid : Setoid (List Nat) := ⟨RenEquiv, renEquiv_equivalence⟩

/-- The **Structural Shape** type: size words modulo injective renaming of their sizes — a
pure, coordinate-free notion of shape structure. -/
def StructuralShape : Type := Quotient renSetoid

/-- The structural shape of a size word. -/
def StructuralShape.of (l : List Nat) : StructuralShape := Quotient.mk renSetoid l

/-
An **injective renaming of the sizes leaves the structural shape unchanged**.
-/
theorem renEquiv_map_injective (f : Nat → Nat) (hf : Function.Injective f) (l : List Nat) :
    RenEquiv (l.map f) l :=
  canon_map_injective f hf l

theorem StructuralShape.of_map_injective (f : Nat → Nat) (hf : Function.Injective f)
    (l : List Nat) : StructuralShape.of (l.map f) = StructuralShape.of l :=
  Quotient.sound (renEquiv_map_injective f hf l)

/-- The **number of arrows** (length of the size word) is a structural invariant: it descends
to the Structural Shape quotient. -/
def StructuralShape.length : StructuralShape → Nat :=
  Quotient.lift List.length (by
    intro u v h
    have : canon u = canon v := h
    have := congrArg List.length this
    simpa [canon_length] using this)

@[simp] theorem StructuralShape.length_of (l : List Nat) :
    StructuralShape.length (StructuralShape.of l) = l.length := rfl

/-- The **number of distinct sizes** used is a structural invariant: it descends to the
Structural Shape quotient. -/
def StructuralShape.distinctSizes : StructuralShape → Nat :=
  Quotient.lift (fun l => l.dedup.length) (by
    intro u v h
    have huv : canon u = canon v := h
    have := congrArg (fun w => w.dedup.length) huv
    simpa [canon_dedup_length] using this)

@[simp] theorem StructuralShape.distinctSizes_of (l : List Nat) :
    StructuralShape.distinctSizes (StructuralShape.of l) = l.dedup.length := rfl

/-! ## Structural shapes of actual shapes -/

/-- The structural shape of a `Shape`: the structural class of its size word. -/
def structuralOf (s : Shape) : StructuralShape := StructuralShape.of (sizeWord s)

/-- Two shapes are **structurally equal** when they have the same structural shape, i.e. their
size words are the same up to injective renaming of sizes. -/
def StructEqShape (a b : Shape) : Prop := structuralOf a = structuralOf b

/-- Structural equality of shapes is an equivalence relation. -/
theorem structEqShape_equivalence : Equivalence StructEqShape := by
  constructor
  · intro x; rfl
  · intro x y h; exact h.symm
  · intro x y z h1 h2; exact h1.trans h2

/-
The number of arrows of a shape is a structural invariant.
-/
@[simp] theorem structuralOf_length (s : Shape) :
    StructuralShape.length (structuralOf s) = (sizeWord s).length := rfl

end ShapeAlgebra