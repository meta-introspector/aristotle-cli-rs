/-
ShapeHarmonic.lean — a harmonic map of the code, mined from Bott periodicity.

The companion analysers (`SizeFinder`, `ShapeFinder`, `SplitDecls`) turn a Lean environment
into *shape data*: every declaration becomes a tree (`SizeSignature.Shape`), whose pre-order
`sizeWord` lists the sizes seen along the structure, and whose consecutive entries are the
*arrows* (`ShapeAlgebra.arrows`). `SizeSignature` groups objects by a single number (`size`);
`ShapeAlgebra` refines this to bags of `n`-grams.

Here we add a third lens, **mined from the Altland–Zirnbauer "tenfold way" / Bott-periodicity
construction**. The decisive idea there is the *Bott clock*: a topological invariant is read
not as an integer but as a residue on a periodic clock `ZMod p` — period `2` for the complex
("KU") series and period `8` for the real ("KO") series — and the real clock *refines* the
complex one because `2 ∣ 8`. Periodicity is exactly the statement that adding a whole period
of structure changes nothing.

We transport that idea onto the project's *own* code-shape data: the **harmonic** of a shape
at period `p` is the bag of its sizes read on the Bott clock `ZMod p`.

* `harmonic p s` — the multiset of `(size mod p)` along the size word; the projection of a
  shape onto the period-`p` clock.
* **It is a homomorphism / "harmonic map".** `harmonic_append` (and `harmonic_node`) say the
  harmonic of a composite shape is the sum of the harmonics of its parts — the map respects
  the additive structure of the size word, which is what makes it *harmonic*.
* **Periodicity (the Bott idea).** `bottClock_periodic` / `harmonic_shift_period`: a full
  period of size adds nothing on the clock.
* **The two Bott clocks.** `complexHarmonic = harmonic 2`, `realHarmonic = harmonic 8`, and
  `realHarmonic_refines_complexHarmonic`: the real clock refines the complex one via the ring
  map `ZMod 8 → ZMod 2`, exactly as `KO` refines `KU`.
* **Compatibility with the earlier lenses.** The harmonic factors through the `1`-gram bag,
  so `similarN`-equal shapes are harmonically equal (`harmonic_of_similarN_one`).
-/
import Mathlib
import RequestProject.SizeSignature
import RequestProject.ShapeAlgebra

namespace ShapeHarmonic

open SizeSignature ShapeAlgebra

/-! ## The harmonic projection onto a Bott clock -/

/-- The **harmonic** of a *word* at period `p`: the bag of its entries read on the Bott clock
`ZMod p`. -/
def listHarmonic (p : ℕ) (l : List Nat) : Multiset (ZMod p) :=
  (l : Multiset Nat).map (fun n => (n : ZMod p))

/-- The **harmonic** of a *shape* at period `p`: the bag of subtree sizes, each projected onto
the period-`p` Bott clock `ZMod p`. This is the shape's spectrum on the clock. -/
def harmonic (p : ℕ) (s : Shape) : Multiset (ZMod p) :=
  listHarmonic p (sizeWord s)

@[simp] theorem harmonic_leaf (p : ℕ) : harmonic p .leaf = {(1 : ZMod p)} := by
  simp [harmonic, listHarmonic]

/-- The harmonic only depends on the size word, so it is computed by `listHarmonic`. -/
theorem harmonic_eq_listHarmonic (p : ℕ) (s : Shape) :
    harmonic p s = listHarmonic p (sizeWord s) := rfl

/-- The number of harmonics equals the length of the size word (one residue per subtree). -/
theorem card_harmonic (p : ℕ) (s : Shape) :
    Multiset.card (harmonic p s) = (sizeWord s).length := by
  simp [harmonic, listHarmonic]

/-! ## The harmonic map is a homomorphism -/

/-- **The harmonic of a word is additive in concatenation.** Reading two words on the clock
and adding the bags is the same as reading the concatenation: `listHarmonic` is a monoid
homomorphism from words (under `++`) into multisets (under `+`). -/
theorem listHarmonic_append (p : ℕ) (l₁ l₂ : List Nat) :
    listHarmonic p (l₁ ++ l₂) = listHarmonic p l₁ + listHarmonic p l₂ := by
  simp [listHarmonic]

/-
**The harmonic map respects structure (it is "harmonic").** The harmonic of a node is the
clock-residue of its total size, together with the sum of the harmonics of its children.
-/
theorem harmonic_node (p : ℕ) (cs : List Shape) :
    harmonic p (.node cs) =
      (size (.node cs) : ZMod p) ::ₘ (cs.map (harmonic p)).sum := by
  have h_harmonic_node : ∀ (cs : List Shape), (List.map (harmonic p) cs).sum = (List.flatMap sizeWord cs : Multiset Nat).map (fun n => (n : ZMod p)) := by
    intro cs; induction cs <;> simp_all +decide [ List.flatMap ] ;
    simp +decide [ harmonic, listHarmonic ];
  -- By definition of harmonic, we know that harmonic p (node cs) is the size of the node plus the sum of the harmonics of the children. Therefore, we can rewrite the goal using this definition.
  simp [harmonic, h_harmonic_node];
  simp +decide [ listHarmonic ]

/-! ## Periodicity — the Bott-clock idea -/

/-- **The Bott clock is periodic.** A full period `p` of size is invisible on the clock:
size `n` and size `n + p` have the same residue. -/
theorem bottClock_periodic (p n : ℕ) : ((n + p : ℕ) : ZMod p) = (n : ZMod p) := by
  push_cast; simp

/-- More generally, any whole number of periods is invisible on the clock. -/
theorem bottClock_periodic_mul (p n k : ℕ) : ((n + k * p : ℕ) : ZMod p) = (n : ZMod p) := by
  push_cast; simp

/-- A single leaf contributes the residue of `1` regardless of how large the period is. -/
theorem harmonic_leaf_const (p q : ℕ) :
    (harmonic p .leaf).map (fun _ => (0 : ℕ)) = (harmonic q .leaf).map (fun _ => (0 : ℕ)) := by
  simp [harmonic, listHarmonic]

/-! ## The two Bott clocks: complex (period 2) and real (period 8) -/

/-- The **complex Bott clock** harmonic (period `2`, the `KU` series). -/
def complexHarmonic (s : Shape) : Multiset (ZMod 2) := harmonic 2 s

/-- The **real Bott clock** harmonic (period `8`, the `KO` series). -/
def realHarmonic (s : Shape) : Multiset (ZMod 8) := harmonic 8 s

/-
**The real clock refines the complex clock.** Pushing the period-`8` real harmonic through
the ring map `ZMod 8 → ZMod 2` (which exists because `2 ∣ 8`) recovers the period-`2` complex
harmonic — exactly the way real `KO` refines complex `KU` in the tenfold way.
-/
theorem realHarmonic_refines_complexHarmonic (s : Shape) :
    (realHarmonic s).map (ZMod.castHom (show (2 : ℕ) ∣ 8 by norm_num) (ZMod 2)) =
      complexHarmonic s := by
  unfold realHarmonic complexHarmonic;
  unfold harmonic listHarmonic;
  induction ( sizeWord s ) <;> aesop

/-! ## Compatibility with the size / arrow lenses -/

/-- The harmonic at period `p` factors through the multiset of subtree sizes: it is the
`1`-gram bag, read on the clock. -/
theorem harmonic_eq_map_sizeWord (p : ℕ) (s : Shape) :
    harmonic p s = (sizeWord s : Multiset Nat).map (fun n => (n : ZMod p)) := rfl

/-- **Compatibility.** Shapes that are `1`-similar (same multiset of sizes) have the same
harmonic on every Bott clock: the harmonic lens is a coarsening of the size lens. -/
theorem harmonic_of_similarN_one {a b : Shape} (h : similarN 1 a b) (p : ℕ) :
    harmonic p a = harmonic p b := by
  have hw : (sizeWord a : Multiset Nat) = (sizeWord b : Multiset Nat) :=
    (similarN_one_iff a b).1 h
  simp only [harmonic_eq_map_sizeWord, hw]

/-! ## A Bott profile: sweeping the periods that divide 8 -/

/-- The **Bott profile** of a shape: its harmonic on each clock whose period divides `8`
(`1, 2, 4, 8`) — the chain of clocks through which the real series factors. Two shapes with
the same total size multiset share the whole profile. -/
def bottProfile (s : Shape) : List (Σ p : ℕ, Multiset (ZMod p)) :=
  [⟨1, harmonic 1 s⟩, ⟨2, harmonic 2 s⟩, ⟨4, harmonic 4 s⟩, ⟨8, harmonic 8 s⟩]

/-- `1`-similar shapes have identical Bott profiles. -/
theorem bottProfile_of_similarN_one {a b : Shape} (h : similarN 1 a b) :
    bottProfile a = bottProfile b := by
  simp only [bottProfile, harmonic_of_similarN_one h]

end ShapeHarmonic