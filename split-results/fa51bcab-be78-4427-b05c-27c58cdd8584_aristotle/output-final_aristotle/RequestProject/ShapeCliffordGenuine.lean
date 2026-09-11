/-
ShapeCliffordGenuine.lean — a *genuine* (multi-dimensional, anti-commuting) Clifford algebra
of shapes, and a verified "similarity ⇒ structure-preserving renaming" bridge.

This file addresses two honest gaps that were flagged in the interpretation layer of
`RequestProject/ShapeAlgebra.lean`:

1.  **The original "Clifford algebra of shapes" is thin.** There, every size `n` is sent to
    `ι Q (n : ℚ)` for the *one-dimensional* form `Q = QuadraticMap.sq` on `ℚ`. All those
    generators are scalar multiples of the single vector `ι Q 1`, so the algebra is in fact
    **commutative** and collapses to (a quotient of) `ℚ[e]`. We make that defect explicit and
    proven (`ShapeAlgebra.shapeGen_comm`), and then replace it with a genuine construction.

    Here distinct sizes become **orthogonal basis vectors** of a multi-dimensional quadratic
    space `(Fin N → ℚ)` with the diagonal form whose value on the `i`-th axis is `i²`. The
    size-`i` generator `E i` is a real Clifford vector, it squares to the scalar `i²`
    (`E_sq`, matching the original Clifford relation), and — crucially — **distinct generators
    anti-commute** (`E_anticomm`): `E i * E j = -(E j * E i)` for `i ≠ j`. This is the real
    geometric-algebra structure that the one-dimensional version could not express.

2.  **A verified "similarity ⇒ structure-preserving renaming" statement was missing.** We
    prove the naturality of the n-gram construction under relabelling of sizes
    (`ngramsOf_map`): renaming every size by a function `f` carries the n-grams to their
    `f`-images. Consequently arrow / n-gram similarity is *preserved* by any renaming
    (`wordSimilarN_map`) and *reflected* by any injective renaming
    (`wordSimilarN_of_map_injective`). So `n`-similarity is exactly a property of a shape's
    structure modulo renaming of its sizes — the precise sense in which "similar shapes are
    the same up to a structure-preserving renaming".
-/
import Mathlib
import RequestProject.ShapeAlgebra

namespace ShapeAlgebra

open SizeSignature

/-! ## The original 1-dimensional algebra is commutative (the "thin" defect, made explicit) -/

/-
In the original one-dimensional construction (`Q = QuadraticMap.sq` on `ℚ`), the size
generators all **commute**: the algebra is commutative, so it carries none of the
anti-commutation structure of a genuine Clifford/geometric algebra.
-/
theorem shapeGen_comm (m n : Nat) : shapeGen m * shapeGen n = shapeGen n * shapeGen m := by
  unfold shapeGen;
  -- Since the algebra is commutative, we can rearrange the terms.
  have h_comm : (CliffordAlgebra.ι Q (m : ℚ)) = (m : ℚ) • (CliffordAlgebra.ι Q 1) ∧ (CliffordAlgebra.ι Q (n : ℚ)) = (n : ℚ) • (CliffordAlgebra.ι Q 1) := by
    exact ⟨ by rw [ ← map_smul ] ; norm_num, by rw [ ← map_smul ] ; norm_num ⟩;
  simp_all +decide [ mul_comm, smul_smul ]

namespace Genuine

open CliffordAlgebra

/-! ## A genuine multi-dimensional Clifford algebra of shapes

Sizes `0, 1, …, N-1` become the orthogonal axes of `Fin N → ℚ`, with the diagonal quadratic
form whose value on the `i`-th axis is `i²`. -/

variable (N : Nat)

/-- The diagonal quadratic form on `Fin N → ℚ` whose value on the `i`-th coordinate axis is
`i²`. This is the form of our genuine Clifford algebra of shapes. -/
noncomputable def Qm : QuadraticForm ℚ (Fin N → ℚ) :=
  QuadraticMap.weightedSumSquares ℚ (fun i : Fin N => ((i : ℕ) : ℚ) ^ 2)

/-- The vector realising size `i`: the `i`-th coordinate axis `Pi.single i 1`. -/
noncomputable def gen (i : Fin N) : Fin N → ℚ := Pi.single i 1

/-
The form evaluates to `i²` on the size-`i` axis.
-/
theorem Qm_gen (i : Fin N) : Qm N (gen N i) = ((i : ℕ) : ℚ) ^ 2 := by
  simp +decide [ Qm, gen ];
  rw [ Finset.sum_eq_single i ] <;> aesop

/-
Distinct size axes are orthogonal for the diagonal form.
-/
theorem gen_isOrtho {i j : Fin N} (h : i ≠ j) : (Qm N).IsOrtho (gen N i) (gen N j) := by
  unfold Qm; simp +decide [ *, QuadraticMap.IsOrtho ] ;
  simp +decide [ gen, Finset.sum_add_distrib, mul_add, mul_comm ];
  simp +decide [ Pi.single_apply ];
  grind

/-- The genuine Clifford **generator** of size `i`: the size-`i` axis as a Clifford vector. -/
noncomputable def E (i : Fin N) : CliffordAlgebra (Qm N) := CliffordAlgebra.ι (Qm N) (gen N i)

/-
The genuine Clifford relation: the size-`i` generator squares to the scalar `i²` — the
same relation as the original `shapeGen_sq`, now for a real multi-dimensional vector.
-/
theorem E_sq (i : Fin N) :
    E N i * E N i = algebraMap ℚ (CliffordAlgebra (Qm N)) (((i : ℕ) : ℚ) ^ 2) := by
  convert CliffordAlgebra.ι_sq_scalar ( Qm N ) ( gen N i ) using 1;
  rw [ Qm_gen ]

/-
**Anti-commutation of distinct generators** — the genuine geometric-algebra structure
absent from the one-dimensional version: for `i ≠ j`, `E i * E j = -(E j * E i)`.
-/
theorem E_anticomm {i j : Fin N} (h : i ≠ j) : E N i * E N j = -(E N j * E N i) := by
  apply CliffordAlgebra.ι_mul_ι_comm_of_isOrtho
  exact gen_isOrtho N h

/-
A symmetric restatement: distinct generators **add-swap to zero** (`E i E j + E j E i = 0`),
the Clifford anti-commutator vanishing off the diagonal.
-/
theorem E_add_swap {i j : Fin N} (h : i ≠ j) : E N i * E N j + E N j * E N i = 0 := by
  rw [ E_anticomm N h, neg_add_cancel ]

end Genuine

/-! ## Similarity is a property of structure modulo renaming of sizes

The "arrows" picture compares shapes by the bag of n-grams of their size word. We now show
that this is invariant under, and only under, relabelling of the sizes. -/

/-
**Naturality of n-grams under renaming.** Renaming every size in a word by `f` carries the
list of n-grams to the list of their `f`-images.
-/
theorem ngramsOf_map (n : Nat) (f : Nat → Nat) (l : List Nat) :
    ngramsOf n (l.map f) = (ngramsOf n l).map (fun g => g.map f) := by
  unfold ngramsOf;
  aesop

/-- **Word-level n-gram similarity**: two size words carry the same bag of n-grams. This is
`similarN n` read off the size words. -/
def wordSimilarN (n : Nat) (u v : List Nat) : Prop :=
  (ngramsOf n u : Multiset (List Nat)) = (ngramsOf n v : Multiset (List Nat))

/-
`similarN n a b` is exactly word-level similarity of the two size words.
-/
theorem similarN_iff_wordSimilarN (n : Nat) (a b : Shape) :
    similarN n a b ↔ wordSimilarN n (sizeWord a) (sizeWord b) := by
  rfl

/-
**Similarity is preserved by any renaming.** If two words are n-gram-similar, then so are
their relabellings by any `f` — relabelling sizes is structure-preserving.
-/
theorem wordSimilarN_map (n : Nat) (f : Nat → Nat) {u v : List Nat}
    (h : wordSimilarN n u v) : wordSimilarN n (u.map f) (v.map f) := by
  convert congr_arg ( Multiset.map ( fun g => List.map f g ) ) h using 1;
  simp +decide [ wordSimilarN, ngramsOf_map ]

/-
**Similarity is reflected by an injective renaming.** If the relabellings by an injective
`f` are similar, the originals were already similar — an injective renaming neither creates nor
destroys similarity. Together with `wordSimilarN_map`, this says n-gram similarity is precisely
a property of structure modulo renaming of sizes.
-/
theorem wordSimilarN_of_map_injective (n : Nat) {f : Nat → Nat} (hf : Function.Injective f)
    {u v : List Nat} (h : wordSimilarN n (u.map f) (v.map f)) : wordSimilarN n u v := by
  convert Multiset.map_injective ( show Function.Injective ( fun g : List ℕ => g.map f ) from ?_ ) _;
  · exact fun a b hab => by simpa [ hf.eq_iff ] using List.map_injective_iff.mpr hf hab;
  · convert h using 1;
    convert Iff.rfl using 2 ; simp +decide [ wordSimilarN, ngramsOf_map ]

end ShapeAlgebra