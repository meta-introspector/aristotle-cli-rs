/-
# CliffordBladeEmbedding — `bladeOfAddr` lands in a genuine Mathlib `CliffordAlgebra`

The module `RequestProject.Compute.ScaleCategory` attaches to every addressed
arrow a *combinatorial* Clifford blade label `bladeOfAddr a : Finset ℕ` — the set
of generators `eᵢ` indexed by the binary support of the address.  That label was
only a `Finset`; here we complete the roadmap item of **realizing it as an honest
element of a full Mathlib `CliffordAlgebra`**.

## What is built here

1. `cliffordBlade Q b S` — for a quadratic form `Q : QuadraticForm R M`, a family
   of vectors `b : ι → M` (a "basis") and a finite set `S : Finset ι` of indices,
   the **ordered Clifford product** `∏_{i ∈ S, increasing} ι_Q (b i)` living in
   `CliffordAlgebra Q`.  This is the genuine algebra element the combinatorial
   blade names.

2. `bladeElement Q b a` — the Clifford element of an *arrow* `a`, obtained by
   feeding `bladeOfAddr a` into `cliffordBlade`.  This is the embedding
   `bladeOfAddr ↪ CliffordAlgebra Q`.

3. **Compatibility with the existing invariants.**  `bladeElement_eq_of_addr_eq`
   shows the Clifford element only depends on the address — so it descends through
   the weight-preserving conformal embeddings exactly as the combinatorial blade
   did (`eraseDeclDetail_preserves_bladeElement`, …).

4. **Genuine Clifford relations.**  `cliffordBlade_empty` ( = `1`),
   `cliffordBlade_singleton` ( = `ι_Q (b i)`) and the Clifford square
   `cliffordBlade_singleton_mul_self` ( = `algebraMap` of `Q (b i)`) verify that
   the embedding really uses the Clifford structure, not just the underlying
   module.
-/

import Mathlib
import RequestProject.Compute.ScaleCategory

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ

/-! ## §1. The Clifford blade of a finite set of basis indices -/

section CliffordBlade

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
variable {ι : Type*} [LinearOrder ι]

/-- The **ordered Clifford product** of the basis vectors `b i` for `i` ranging
    over `S` in increasing order: this is the genuine `CliffordAlgebra` element
    named by the combinatorial blade `S`. -/
noncomputable def cliffordBlade (Q : QuadraticForm R M) (b : ι → M) (S : Finset ι) :
    CliffordAlgebra Q :=
  ((S.sort (· ≤ ·)).map (fun i => CliffordAlgebra.ι Q (b i))).prod

/-- The empty blade is the algebra unit. -/
@[simp] theorem cliffordBlade_empty (Q : QuadraticForm R M) (b : ι → M) :
    cliffordBlade Q b (∅ : Finset ι) = 1 := by
  simp [cliffordBlade]

/-- A singleton blade is the image of the single basis vector under `ι_Q`. -/
@[simp] theorem cliffordBlade_singleton (Q : QuadraticForm R M) (b : ι → M) (i : ι) :
    cliffordBlade Q b ({i} : Finset ι) = CliffordAlgebra.ι Q (b i) := by
  simp [cliffordBlade]

/-- The Clifford square of a singleton blade is the scalar `Q (b i)` — the
    defining quadratic relation of the algebra. -/
theorem cliffordBlade_singleton_mul_self (Q : QuadraticForm R M) (b : ι → M) (i : ι) :
    cliffordBlade Q b ({i} : Finset ι) * cliffordBlade Q b ({i} : Finset ι)
      = (algebraMap R (CliffordAlgebra Q)) (Q (b i)) := by
  rw [cliffordBlade_singleton]
  exact CliffordAlgebra.ι_sq_scalar Q (b i)

end CliffordBlade

/-! ## §2. The Clifford element of an addressed arrow -/

section BladeElement

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- The **Clifford element of an arrow**: the combinatorial blade `bladeOfAddr a`
    realized as an honest element of `CliffordAlgebra Q`, with respect to a chosen
    family of generators `b : ℕ → M`. -/
noncomputable def bladeElement (Q : QuadraticForm R M) (b : ℕ → M)
    {α : Type*} [CFTArrow α] (a : α) : CliffordAlgebra Q :=
  cliffordBlade Q b (bladeOfAddr a)

/-- The Clifford element depends only on the address — equal addresses (across any
    two types) give the same algebra element.  This is the Clifford-level refinement
    of `bladeOfAddr_eq_of_addr_eq`. -/
theorem bladeElement_eq_of_addr_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {α β : Type*} [CFTArrow α] [CFTArrow β] (a : α) (c : β) (h : addr a = addr c) :
    bladeElement Q b a = bladeElement Q b c := by
  unfold bladeElement
  rw [bladeOfAddr_eq_of_addr_eq a c h]

/-- Erasing declaration detail keeps the entire Clifford element. -/
theorem eraseDeclDetail_preserves_bladeElement (Q : QuadraticForm R M) (b : ℕ → M)
    (d : DeclArrow) : bladeElement Q b (eraseDeclDetail d) = bladeElement Q b d :=
  bladeElement_eq_of_addr_eq Q b _ _ rfl

/-- Coarsening n-grams keeps the Clifford element. -/
theorem coarsenNgram_preserves_bladeElement (Q : QuadraticForm R M) (b : ℕ → M)
    (l : List ℕ) : bladeElement Q b (coarsenNgram l) = bladeElement Q b l :=
  bladeElement_eq_of_addr_eq Q b _ _ rfl

end BladeElement

/-! ## §3. A concrete Euclidean instantiation

We instantiate the embedding in the concrete Clifford algebra of the finitely
supported real sequences `ℕ →₀ ℝ` with the canonical generators `eᵢ = single i 1`,
showing the construction is non-vacuous and lands in a genuine algebra. -/

section Concrete

/-- The canonical generators of `ℕ →₀ ℝ`: `stdGen i = single i 1`. -/
noncomputable def stdGen (i : ℕ) : ℕ →₀ ℝ := Finsupp.single i (1 : ℝ)

/-- The Clifford element of an arrow in the Clifford algebra of `(ℕ →₀ ℝ, Q)`. -/
noncomputable def bladeElementStd (Q : QuadraticForm ℝ (ℕ →₀ ℝ))
    {α : Type*} [CFTArrow α] (a : α) : CliffordAlgebra Q :=
  bladeElement Q stdGen a

/-- Even in the concrete algebra the element is address-determined. -/
theorem bladeElementStd_eq_of_addr_eq (Q : QuadraticForm ℝ (ℕ →₀ ℝ))
    {α β : Type*} [CFTArrow α] [CFTArrow β] (a : α) (c : β) (h : addr a = addr c) :
    bladeElementStd Q a = bladeElementStd Q c :=
  bladeElement_eq_of_addr_eq Q stdGen a c h

end Concrete

end RequestProject.Compute.CFT
