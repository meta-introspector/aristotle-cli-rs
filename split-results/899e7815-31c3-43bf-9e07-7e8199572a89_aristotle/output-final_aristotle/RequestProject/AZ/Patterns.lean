import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
import RequestProject.AZ.CliffordK
import RequestProject.AZ.NonHermitian
import RequestProject.AZ.Crystalline

/-!
# Patterns in the Altland–Zirnbauer data

`RequestProject.AZ.TenfoldWay` and its companions build the periodic table
`classify : Class → ℕ → KGroup` of the ten Altland–Zirnbauer (AZ) classes, the
Clifford / K-theory front-end, the non-Hermitian 38-fold classification and the
crystalline / equivariant refinement.

This file *mines that data for patterns* and proves each one outright (every
statement is decidable once Bott periodicity collapses the dimension to `d % 8`).
The headline discovery is that, although the table reshuffles wildly from dimension
to dimension, several **dimension-independent invariants** survive.

## The patterns proved

1. **The K-group census is dimension-independent.**  In *every* spatial dimension the
   ten classes carry exactly the same *multiset* of classifying groups:
   `2 × ℤ`, `2 × ℤ₂`, `1 × 2ℤ`, and `5 × 0`.  See `kgroup_multiset_const` and the
   per-value counts `count_Z`, `count_Z2`, `count_twoZ`, `count_null`.

2. **Five and five.**  The ten classes split evenly into five non-trivial and five
   trivial in every dimension (`count_nontrivial`, `count_trivial`,
   `nontrivial_add_trivial`).

3. **The real / complex split of the census.**  The eight real classes always carry
   `1 × ℤ, 2 × ℤ₂, 1 × 2ℤ, 4 × 0`, and the two complex classes always carry exactly
   one `ℤ` and one `0` (`count_real_*`, `complex_exactly_one_nontrivial`).

4. **Bott diagonal.**  A real class in dimension `d` reads the same entry as the base
   class `AI` shifted: it depends only on `realIndex c - d` on the `ℤ₈` clock
   (`real_value_eq_shift`); likewise the Clifford degree governs everything
   (`value_eq_degree`).

5. **Non-Hermitian shadow.**  Because the non-Hermitian 38-fold table is read off the
   Hermitian one, its per-dimension non-triviality census is *also* dimension-periodic
   (`nh_nontrivial_period8`), and the `38 = 2 · 19` split is exact
   (`nh_family_split`).
-/

namespace AZ
namespace Patterns

open Class

/-! ## 1. The dimension-independent K-group census -/

/-- **The K-group census is dimension-independent.**  Listing the classifying group of
each of the ten classes produces, in *every* spatial dimension `d`, exactly the same
multiset of groups as in dimension `0`. -/
theorem kgroup_multiset_const (d : ℕ) :
    Multiset.map (fun c : Class => classify c d) Finset.univ.val
      = Multiset.map (fun c : Class => classify c 0) Finset.univ.val := by
  have hcong : Multiset.map (fun c : Class => classify c d) Finset.univ.val
      = Multiset.map (fun c : Class => classify c (d % 8)) Finset.univ.val := by
    apply Multiset.map_congr rfl
    intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- In every dimension exactly **two** classes have classifying group `ℤ`. -/
theorem count_Z (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d = KGroup.Z)).card = 2 := by
  have hcong : (Finset.univ.filter (fun c : Class => classify c d = KGroup.Z))
      = (Finset.univ.filter (fun c : Class => classify c (d % 8) = KGroup.Z)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- In every dimension exactly **two** classes have classifying group `ℤ₂`. -/
theorem count_Z2 (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d = KGroup.Z2)).card = 2 := by
  have hcong : (Finset.univ.filter (fun c : Class => classify c d = KGroup.Z2))
      = (Finset.univ.filter (fun c : Class => classify c (d % 8) = KGroup.Z2)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- In every dimension exactly **one** class has classifying group `2ℤ`. -/
theorem count_twoZ (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d = KGroup.twoZ)).card = 1 := by
  have hcong : (Finset.univ.filter (fun c : Class => classify c d = KGroup.twoZ))
      = (Finset.univ.filter (fun c : Class => classify c (d % 8) = KGroup.twoZ)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- In every dimension exactly **five** classes are trivial (`0`). -/
theorem count_null (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d = KGroup.null)).card = 5 := by
  have hcong : (Finset.univ.filter (fun c : Class => classify c d = KGroup.null))
      = (Finset.univ.filter (fun c : Class => classify c (d % 8) = KGroup.null)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-! ## 2. Five and five -/

/-- In every dimension exactly **five** of the ten classes are non-trivial. -/
theorem count_nontrivial (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d ≠ KGroup.null)).card = 5 :=
  five_nontrivial_per_dimension d

/-- In every dimension exactly **five** of the ten classes are trivial. -/
theorem count_trivial (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d = KGroup.null)).card = 5 :=
  count_null d

/-- The non-trivial and trivial classes partition the ten: `5 + 5 = 10`. -/
theorem nontrivial_add_trivial (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d ≠ KGroup.null)).card
      + (Finset.univ.filter (fun c : Class => classify c d = KGroup.null)).card
      = Fintype.card Class := by
  rw [count_nontrivial, count_null, card_classes]

/-! ## 3. The real / complex split of the census -/

/-- Among the eight **real** classes, exactly one has classifying group `ℤ` in every
dimension. -/
theorem count_real_Z (d : ℕ) :
    (Finset.univ.filter
      (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.Z)).card = 1 := by
  have hcong : (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.Z))
      = (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c (d % 8) = KGroup.Z)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- Among the eight **real** classes, exactly two have classifying group `ℤ₂` in every
dimension. -/
theorem count_real_Z2 (d : ℕ) :
    (Finset.univ.filter
      (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.Z2)).card = 2 := by
  have hcong : (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.Z2))
      = (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c (d % 8) = KGroup.Z2)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- Among the eight **real** classes, exactly one has classifying group `2ℤ` in every
dimension. -/
theorem count_real_twoZ (d : ℕ) :
    (Finset.univ.filter
      (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.twoZ)).card = 1 := by
  have hcong : (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c d = KGroup.twoZ))
      = (Finset.univ.filter
        (fun c : Class => c.isComplex = false ∧ classify c (d % 8) = KGroup.twoZ)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-- Among the two **complex** classes (`A`, `AIII`), exactly one is non-trivial (`ℤ`)
in every dimension — they alternate on the period-`2` clock. -/
theorem complex_exactly_one_nontrivial (d : ℕ) :
    (Finset.univ.filter
      (fun c : Class => c.isComplex = true ∧ classify c d ≠ KGroup.null)).card = 1 := by
  have hcong : (Finset.univ.filter
        (fun c : Class => c.isComplex = true ∧ classify c d ≠ KGroup.null))
      = (Finset.univ.filter
        (fun c : Class => c.isComplex = true ∧ classify c (d % 8) ≠ KGroup.null)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

/-! ## 4. The Bott diagonal -/

/-- **Bott diagonal (real series).**  A real class `c` in dimension `d` reads the
periodic-table entry determined solely by the difference `realIndex c - d` on the
`ℤ₈` Bott clock — i.e. it equals `realPattern` at that single combined index. -/
theorem real_value_eq_shift (c : Class) (hc : c.isComplex = false) (d : ℕ) :
    classify c d = realPattern (c.realIndex - (d : ZMod 8)) := by
  unfold classify; rw [if_neg (by simp [hc])]

/-- **Everything is a Clifford degree.**  The classifying group of any class in any
dimension is a function of its Clifford degree minus the dimension — the single
homotopy-theoretic invariant behind the whole table. -/
theorem value_eq_degree (c : Class) (d : ℕ) :
    classify c d = KGroupOf (spectrumOfClass c) ((clIndexOfClass c).degree - (d : ℤ)) := by
  rw [classify_eq_classifyViaClifford]; rfl

/-! ## 5. The non-Hermitian shadow -/

open NonHermitian in
/-- **The non-Hermitian census is dimension-periodic too.**  The number of non-trivial
non-Hermitian classes in dimension `d` equals the number in dimension `d + 8`: the
38-fold table inherits Bott periodicity from the Hermitian one. -/
theorem nh_nontrivial_period8 (d : ℕ) :
    (classes.filter (fun x => x.isNontrivial (d + 8))).card
      = (classes.filter (fun x => x.isNontrivial d)).card := by
  apply congrArg
  apply Finset.filter_congr
  intro x _
  simp only [NHClass.isNontrivial, nhClassify_periodic8 x d]

open NonHermitian in
/-- **The `38 = 20 + 18` family split** of the non-Hermitian classes is exact: the AZ
family contributes `20`, the AZ† family `18`, and they partition all `38`. -/
theorem nh_family_split :
    (classes.filter (fun x => x.family = Family.az)).card
      + (classes.filter (fun x => x.family = Family.azdag)).card
      = classes.card := by
  rw [card_az, card_azdag, NonHermitian.card_classes]

end Patterns
end AZ
