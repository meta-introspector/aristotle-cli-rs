/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.Field1951
import RequestProject.Imported.OutputFinal3.Reduction
import RequestProject.Imported.OutputFinal3.GroupA5
import RequestProject.Imported.OutputFinal3.Discriminant
import RequestProject.Imported.OutputFinal3.Discr1951

/-!
# The Galois group of the Doud–Moore quintic `f₁₉₅₁` is `A₅`

This file proves that the Galois group of

  `f₁₉₅₁ = X^5 - X^4 - 780 X^3 - 1795 X^2 + 3106 X + 344`

over `ℚ` is isomorphic to the alternating group `A₅`
(`ArtinA5Even.gal1951_equiv_alternating`).  Nothing is assumed.

## The argument

* `ArtinA5Even.five_dvd_card_gal` : `5 ∣ |Gal|`, from the fact that `f₁₉₅₁` stays irreducible
  modulo `3`;
* `ArtinA5Even.three_dvd_card_gal` : `3 ∣ |Gal|`, from the factorisation
  `f₁₉₅₁ ≡ (X² + 6X + 12)(X³ + 6X² + 4X + 7) (mod 13)` whose cubic factor is irreducible over
  `𝔽₁₃`;
* `ArtinA5Even.fifteen_dvd_card_gal` : `15 ∣ |Gal|`.

Both divisibility statements come from `ArtinA5Even.natDegree_dvd_card_gal`, the "easy half" of
Dedekind's theorem proved in `ArtinA5Even.Reduction`: an irreducible factor of degree `d` of the
reduction of `f` mod `q` forces `d ∣ |Gal|` (it produces a residue field of degree divisible by
`d`, and residue degrees divide the order of the Galois group).

* `ArtinA5Even.even_action_of_discr` : the Galois group acts on the five roots by **even**
  permutations, because `discr f₁₉₅₁` is a square.  The discriminant is *computed* in
  `ArtinA5Even.Discr1951` (`poly1951.discr = disc1951`), and the link between `Polynomial.discr`
  and the differences of the roots is proved in `ArtinA5Even.Discriminant`; neither is assumed.
* `ArtinA5Even.subgroup_eq_top_of_fifteen_dvd` : a subgroup of `A₅` of order divisible by `15`
  is all of `A₅` (from the simplicity of `A₅`).

Putting these together, the image of `Gal` in `S₅` is a subgroup of `A₅` of order divisible by
`15`, hence is `A₅`; and the permutation representation is faithful.

The conditional form `ArtinA5Even.gal_eq_A5_of_disc`, which takes
`hdisc : poly1951.discr = disc1951` as a hypothesis, is also recorded, together with the
unconditional weaker statement `ArtinA5Even.alternating_le_range_permRep1951` (`Gal` is `A₅` or
`S₅`), which uses no discriminant input at all.

## Out of scope

This file does **not** construct a `2.A₅`-cover, a representation `Gal → SL₂(ℂ)`, or a Maass
form; those remain the ultimate goal and are entirely out of scope here.  No Artin conjecture,
`L`-function or modularity statement is made anywhere.
-/

set_option maxHeartbeats 1000000

namespace ArtinA5Even

open Polynomial NumberField

/-! ## The quintic over `ℚ` and its splitting field -/

/-- The Doud–Moore quintic viewed over `ℚ`. -/
noncomputable def poly1951Q : ℚ[X] := poly1951.map (algebraMap ℤ ℚ)

theorem poly1951Q_monic : poly1951Q.Monic := poly1951_monic.map _

theorem poly1951Q_irreducible : Irreducible poly1951Q := poly1951_irreducible_rat

theorem poly1951Q_natDegree : poly1951Q.natDegree = 5 := by
  rw [poly1951Q, natDegree_map_eq_of_injective (algebraMap ℤ ℚ).injective_int, poly1951_natDegree]

theorem poly1951Q_separable : poly1951Q.Separable := poly1951Q_irreducible.separable

noncomputable instance : FiniteDimensional ℚ poly1951Q.SplittingField :=
  IsSplittingField.finiteDimensional _ poly1951Q

instance : NumberField poly1951Q.SplittingField where
  to_charZero := inferInstance
  to_finiteDimensional := inferInstance

instance : IsGalois ℚ poly1951Q.SplittingField :=
  IsGalois.of_separable_splitting_field (p := poly1951Q) poly1951Q_separable

/-- Reducing `f₁₉₅₁` straight into the splitting field is the same as going through `ℚ`. -/
theorem poly1951_map_splitField :
    poly1951.map (algebraMap ℤ poly1951Q.SplittingField)
      = poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField) := by
  rw [poly1951Q, Polynomial.map_map]
  congr 1

/-- `f₁₉₅₁`, as an integer polynomial, splits in the splitting field of its rational avatar. -/
theorem poly1951_splits_splitField :
    (poly1951.map (algebraMap ℤ poly1951Q.SplittingField)).Splits := by
  rw [poly1951_map_splitField]
  exact IsSplittingField.splits _ _

/-! ## `5 ∣ |Gal|` : the quintic is irreducible mod `3` -/

theorem poly1951Mod3_monic : poly1951Mod3.Monic := by unfold poly1951Mod3; monicity!

theorem poly1951Mod3_natDegree : poly1951Mod3.natDegree = 5 := by
  unfold poly1951Mod3; compute_degree!

/-- **`5` divides the order of the Galois group.**  The quintic is irreducible modulo `3`. -/
theorem five_dvd_card_gal : 5 ∣ Nat.card poly1951Q.Gal := by
  have h := natDegree_dvd_card_gal poly1951Q.SplittingField poly1951_monic
    poly1951_splits_splitField (q := 3) (by norm_num) poly1951Mod3_irreducible poly1951Mod3_monic
    (by rw [poly1951_map_three])
  rwa [poly1951Mod3_natDegree] at h

/-! ## `3 ∣ |Gal|` : an irreducible cubic factor mod `13` -/

/-- The irreducible cubic factor of `f₁₉₅₁` modulo `13`. -/
noncomputable def poly1951Mod13Cubic : (ZMod 13)[X] := X ^ 3 + 6 * X ^ 2 + 4 * X + 7

theorem poly1951Mod13Cubic_monic : poly1951Mod13Cubic.Monic := by
  unfold poly1951Mod13Cubic; monicity!

theorem poly1951Mod13Cubic_natDegree : poly1951Mod13Cubic.natDegree = 3 := by
  unfold poly1951Mod13Cubic; compute_degree!

theorem poly1951Mod13Cubic_no_root (x : ZMod 13) : poly1951Mod13Cubic.eval x ≠ 0 := by
  revert x
  simp only [poly1951Mod13Cubic, eval_add, eval_mul, eval_pow, eval_X, eval_ofNat]
  decide

/-- The cubic factor of `f₁₉₅₁ mod 13` is irreducible over `𝔽₁₃`: it has degree `3` and no root. -/
theorem poly1951Mod13Cubic_irreducible : Irreducible poly1951Mod13Cubic := by
  haveI : Fact (Nat.Prime 13) := ⟨by norm_num⟩
  rw [poly1951Mod13Cubic_monic.irreducible_iff_roots_eq_zero_of_degree_le_three
    (by rw [poly1951Mod13Cubic_natDegree]; norm_num) (by rw [poly1951Mod13Cubic_natDegree])]
  rw [Multiset.eq_zero_iff_forall_notMem]
  intro x hx
  exact poly1951Mod13Cubic_no_root x ((mem_roots poly1951Mod13Cubic_monic.ne_zero).mp hx)

/-- `f₁₉₅₁ ≡ (X² + 6X + 12)(X³ + 6X² + 4X + 7) (mod 13)`. -/
theorem poly1951_map_thirteen :
    poly1951.map (Int.castRingHom (ZMod 13))
      = (X ^ 2 + 6 * X + 12) * poly1951Mod13Cubic := by
  have e1 : (780 : (ZMod 13)[X]) = 0 := by
    rw [← Polynomial.C_ofNat, show ((780 : ZMod 13)) = 0 by decide, map_zero]
  have e2 : (1795 : (ZMod 13)[X]) = 1 := by
    rw [← Polynomial.C_ofNat, show ((1795 : ZMod 13)) = 1 by decide, map_one]
  have e3 : (3106 : (ZMod 13)[X]) = 12 := by
    rw [← Polynomial.C_ofNat, show ((3106 : ZMod 13)) = 12 by decide, Polynomial.C_ofNat]
  have e4 : (344 : (ZMod 13)[X]) = 6 := by
    rw [← Polynomial.C_ofNat, show ((344 : ZMod 13)) = 6 by decide, Polynomial.C_ofNat]
  have e13 : (13 : (ZMod 13)[X]) = 0 := by
    rw [← Polynomial.C_ofNat, show ((13 : ZMod 13)) = 0 by decide, map_zero]
  simp only [poly1951, poly1951Mod13Cubic, Polynomial.map_add, Polynomial.map_sub,
    Polynomial.map_mul, Polynomial.map_pow, Polynomial.map_X, Polynomial.map_ofNat, e1, e2, e3, e4]
  linear_combination (norm := ring_nf)
    ((X : (ZMod 13)[X]) - 3 * X ^ 3 - X ^ 4 - X ^ 3 - 8 * X ^ 2 - 7 * X - 6) * e13

/-- **`3` divides the order of the Galois group.**  Modulo `13` the quintic has an irreducible
cubic factor. -/
theorem three_dvd_card_gal : 3 ∣ Nat.card poly1951Q.Gal := by
  have h := natDegree_dvd_card_gal poly1951Q.SplittingField poly1951_monic
    poly1951_splits_splitField (q := 13) (by norm_num) poly1951Mod13Cubic_irreducible
    poly1951Mod13Cubic_monic (by rw [poly1951_map_thirteen]; exact Dvd.intro_left _ rfl)
  rwa [poly1951Mod13Cubic_natDegree] at h

/-- **`15` divides the order of the Galois group of `f₁₉₅₁`.** -/
theorem fifteen_dvd_card_gal : 15 ∣ Nat.card poly1951Q.Gal :=
  Nat.Coprime.mul_dvd_of_dvd_of_dvd (by norm_num) three_dvd_card_gal five_dvd_card_gal

/-! ## The permutation representation on the five roots -/

instance : Fact (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).Splits :=
  ⟨IsSplittingField.splits _ _⟩

theorem card_rootSet_poly1951Q :
    Fintype.card (poly1951Q.rootSet poly1951Q.SplittingField) = 5 := by
  rw [card_rootSet_eq_natDegree poly1951Q_separable (IsSplittingField.splits _ _),
    poly1951Q_natDegree]

/-- A numbering of the five roots of `f₁₉₅₁` in its splitting field. -/
noncomputable def rootEquivFin : poly1951Q.rootSet poly1951Q.SplittingField ≃ Fin 5 :=
  Fintype.equivFinOfCardEq card_rootSet_poly1951Q

/-- The action of the Galois group on the set of roots inside the splitting field, as a
permutation representation.  This is `Polynomial.Gal.galActionAux`, for which the underlying
element of the splitting field of `σ • x` is *definitionally* `σ x`. -/
noncomputable def rootAction :
    poly1951Q.Gal →* Equiv.Perm (poly1951Q.rootSet poly1951Q.SplittingField) :=
  @MulAction.toPermHom _ _ _ (Gal.galActionAux poly1951Q)

@[simp] theorem coe_rootAction (σ : poly1951Q.Gal)
    (x : poly1951Q.rootSet poly1951Q.SplittingField) :
    ((rootAction σ x : poly1951Q.rootSet poly1951Q.SplittingField) :
      poly1951Q.SplittingField) = σ (x : poly1951Q.SplittingField) := rfl

theorem rootAction_injective : Function.Injective rootAction := by
  intro a b hab
  refine Gal.ext poly1951Q fun x hx => ?_
  exact congrArg (fun π => ((π ⟨x, hx⟩ : poly1951Q.rootSet poly1951Q.SplittingField) :
    poly1951Q.SplittingField)) hab

/-- The permutation representation of the Galois group of `f₁₉₅₁` on its five roots, transported
to `Perm (Fin 5)` along `rootEquivFin`.  It is injective (`permRep1951_injective`). -/
noncomputable def permRep1951 : poly1951Q.Gal →* Equiv.Perm (Fin 5) :=
  (rootEquivFin.permCongrHom : Equiv.Perm _ ≃* Equiv.Perm (Fin 5)).toMonoidHom.comp rootAction

theorem permRep1951_injective : Function.Injective permRep1951 := fun _ _ hab =>
  rootAction_injective (rootEquivFin.permCongrHom.injective hab)

/-- The five roots of `f₁₉₅₁` in its splitting field, numbered by `rootEquivFin`. -/
noncomputable def root1951 (i : Fin 5) : poly1951Q.SplittingField :=
  (rootEquivFin.symm i : poly1951Q.rootSet poly1951Q.SplittingField)

theorem root1951_injective : Function.Injective root1951 := fun _ _ h =>
  rootEquivFin.symm.injective (Subtype.ext h)

/-- The Galois action on the roots, read through the numbering: `σ (rᵢ) = r_{π(i)}` where
`π = permRep1951 σ`. -/
theorem gal_apply_root1951 (σ : poly1951Q.Gal) (i : Fin 5) :
    σ (root1951 i) = root1951 (permRep1951 σ i) := by
  show σ (root1951 i) = ((rootEquivFin.symm (rootEquivFin
    (rootAction σ (rootEquivFin.symm i))) : poly1951Q.rootSet poly1951Q.SplittingField) :
      poly1951Q.SplittingField)
  rw [Equiv.symm_apply_apply, coe_rootAction]
  rfl

/-! ## The quintic as a product of linear factors -/

/-- `f₁₉₅₁` over the splitting field, as a product of the five linear factors. -/
theorem poly1951_eq_prod_X_sub_C :
    poly1951.map (algebraMap ℤ poly1951Q.SplittingField)
      = ∏ i, (X - C (root1951 i)) := by
  classical
  have hm : (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).Monic :=
    poly1951Q_monic.map _
  have hsplits : (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).Splits :=
    IsSplittingField.splits _ _
  have hcard : (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).roots.card = 5 := by
    rw [← hsplits.natDegree_eq_card_roots, natDegree_map_eq_of_injective
      (algebraMap ℚ poly1951Q.SplittingField).injective, poly1951Q_natDegree]
  -- the numbered roots exhaust the root multiset
  have hmem : ∀ i, root1951 i ∈ (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).roots := by
    intro i
    have hx := (rootEquivFin.symm i).2
    rw [Polynomial.mem_rootSet] at hx
    rw [mem_roots hm.ne_zero, IsRoot.def, root1951, eval_map, ← aeval_def]
    exact hx.2
  have hnodupmap : (Multiset.map root1951 Finset.univ.val).Nodup :=
    Multiset.Nodup.map root1951_injective Finset.univ.nodup
  have hle : Multiset.map root1951 Finset.univ.val
      ≤ (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).roots := by
    rw [Multiset.le_iff_subset hnodupmap]
    intro x hx
    obtain ⟨i, _, rfl⟩ := Multiset.mem_map.mp hx
    exact hmem i
  have hroots : (poly1951Q.map (algebraMap ℚ poly1951Q.SplittingField)).roots
      = Multiset.map root1951 Finset.univ.val :=
    (Multiset.eq_of_le_of_card_le hle (by simp [hcard])).symm
  rw [poly1951_map_splitField, hsplits.eq_prod_roots_of_monic hm, hroots, Multiset.map_map,
    Finset.prod_eq_multiset_prod]
  rfl

/-! ## The discriminant, and the identification of the Galois group -/

/-- **A square discriminant forces even permutations.**  Given `discr poly1951 = disc1951`,
every element of the Galois group permutes the five roots evenly.

The proof is the classical one: the Vandermonde product `δ = ∏_{i<j} (rⱼ - rᵢ)` satisfies
`δ² = discr` and `σ δ = sign(σ) δ`; as `discr = c²` with `c` an integer, `δ = ±c` is fixed by the
Galois group, and `δ ≠ 0`, so every sign is `+1`. -/
theorem even_action_of_discr (hdisc : poly1951.discr = disc1951) (σ : poly1951Q.Gal) :
    permRep1951 σ ∈ alternatingGroup (Fin 5) := by
  classical
  have hδ_ne : rootDiffProd root1951 ≠ 0 := rootDiffProd_ne_zero root1951_injective
  -- `δ² = discr f₁₉₅₁`
  have h1 : (poly1951.map (algebraMap ℤ poly1951Q.SplittingField)).discr
      = (rootDiffProd root1951) ^ 2 :=
    discr_eq_rootDiffProd_sq root1951_injective poly1951_eq_prod_X_sub_C
  have h2 : (poly1951.map (algebraMap ℤ poly1951Q.SplittingField)).discr
      = algebraMap ℤ poly1951Q.SplittingField poly1951.discr :=
    discr_map_of_monic_five poly1951_monic poly1951_natDegree _
  have hc : disc1951 = 518348075378 ^ 2 := by unfold disc1951; norm_num
  have h3 : (rootDiffProd root1951) ^ 2
      = ((518348075378 : ℤ) : poly1951Q.SplittingField) ^ 2 := by
    rw [← h1, h2, hdisc, hc, map_pow, eq_intCast]
  -- hence `δ = ±c` is fixed by `σ`
  have hfix : σ (rootDiffProd root1951) = rootDiffProd root1951 := by
    have h4 : (rootDiffProd root1951 - ((518348075378 : ℤ) : poly1951Q.SplittingField))
        * (rootDiffProd root1951 + ((518348075378 : ℤ) : poly1951Q.SplittingField)) = 0 := by
      linear_combination h3
    rcases mul_eq_zero.mp h4 with h5 | h5
    · rw [sub_eq_zero.mp h5, map_intCast]
    · rw [eq_neg_of_add_eq_zero_left h5, map_neg, map_intCast]
  -- but `σ δ = sign(σ) δ`
  have hcomp : (σ : poly1951Q.SplittingField → poly1951Q.SplittingField) ∘ root1951
      = root1951 ∘ (permRep1951 σ) := funext fun i => gal_apply_root1951 σ i
  have hperm : σ (rootDiffProd root1951)
      = ((Equiv.Perm.sign (permRep1951 σ) : ℤ) : poly1951Q.SplittingField)
        * rootDiffProd root1951 := by
    rw [map_rootDiffProd σ root1951, hcomp, rootDiffProd_comp_perm]
  rw [hfix] at hperm
  have hsign : ((Equiv.Perm.sign (permRep1951 σ) : ℤ) : poly1951Q.SplittingField) = 1 :=
    mul_right_cancel₀ hδ_ne (by rw [one_mul]; exact hperm.symm)
  have hsignZ : (Equiv.Perm.sign (permRep1951 σ) : ℤ) = 1 := by
    have : ((Equiv.Perm.sign (permRep1951 σ) : ℤ) : poly1951Q.SplittingField)
        = ((1 : ℤ) : poly1951Q.SplittingField) := by rw [hsign]; norm_num
    exact_mod_cast this
  rw [Equiv.Perm.mem_alternatingGroup]
  exact Units.ext hsignZ

/-- **Main theorem, in the conditional form.**  Given the value of the discriminant, the Galois
group of `f₁₉₅₁` is isomorphic to the alternating group `A₅`.

The inputs are: irreducibility of `f₁₉₅₁ mod 3` (giving `5 ∣ |Gal|`), the irreducible cubic
factor of `f₁₉₅₁ mod 13` (giving `3 ∣ |Gal|`), the fact that a square discriminant forces even
permutations, and the simplicity of `A₅`.  The hypothesis is discharged by
`ArtinA5Even.poly1951_discr`; see `ArtinA5Even.gal1951_equiv_alternating`. -/
theorem gal_eq_A5_of_disc (hdisc : poly1951.discr = disc1951) :
    Nonempty (poly1951Q.Gal ≃* alternatingGroup (Fin 5)) := by
  classical
  set ρ : poly1951Q.Gal →* alternatingGroup (Fin 5) :=
    permRep1951.codRestrict (alternatingGroup (Fin 5)) (even_action_of_discr hdisc)
  have hinj : Function.Injective ρ := fun a b hab =>
    permRep1951_injective (congrArg Subtype.val hab)
  have hcard : Nat.card ρ.range = Nat.card poly1951Q.Gal := by
    rw [← Nat.card_range_of_injective hinj]
    exact Nat.card_congr (Equiv.refl _)
  have h15 : 15 ∣ Nat.card ρ.range := hcard ▸ fifteen_dvd_card_gal
  have hsurj : Function.Surjective ρ :=
    MonoidHom.range_eq_top.mp (subgroup_eq_top_of_fifteen_dvd h15)
  exact ⟨MulEquiv.ofBijective ρ ⟨hinj, hsurj⟩⟩

/-- **`Gal(f₁₉₅₁) ≅ A₅`.**  The Galois group of the splitting field of the Doud–Moore quintic
`f₁₉₅₁` over `ℚ` is isomorphic to the alternating group `A₅`.  Unconditional: the discriminant
is computed in `ArtinA5Even.poly1951_discr`.

This does **not** construct a `2.A₅`-cover, a representation `Gal → SL₂(ℂ)`, or a Maass form;
those remain the ultimate goal and are out of scope. -/
theorem gal1951_equiv_alternating :
    Nonempty (poly1951Q.Gal ≃* alternatingGroup (Fin 5)) :=
  gal_eq_A5_of_disc poly1951_discr

/-- The bundling structure `EvenIcosahedral1951` of `ArtinA5Even.Field1951` is inhabited: all
four of its fields — irreducibility over `ℚ`, square discriminant, total reality and
`Gal ≅ A₅` — are now theorems. -/
theorem evenIcosahedral1951 : EvenIcosahedral1951 where
  irreducible := poly1951_irreducible_rat
  disc_sq := disc1951_isSquare
  totally_real := poly1951_totally_real
  gal_eq_A5 := gal1951_equiv_alternating

/-! ## An unconditional statement

Without any discriminant input one still gets that the Galois group contains `A₅`: it is `A₅` or
the full symmetric group `S₅`. -/

/-- **Unconditional:** the image of the Galois group of `f₁₉₅₁` in `S₅` contains `A₅`.

Equivalently: the Galois group of `f₁₉₅₁` is isomorphic to `A₅` or to `S₅`.  No discriminant
input is used; only `15 ∣ |Gal|` and the simplicity of `A₅`. -/
theorem alternating_le_range_permRep1951 :
    alternatingGroup (Fin 5) ≤ permRep1951.range := by
  refine alternating_le_of_fifteen_dvd ?_
  have hcard : Nat.card permRep1951.range = Nat.card poly1951Q.Gal := by
    rw [← Nat.card_range_of_injective permRep1951_injective]
    exact Nat.card_congr (Equiv.refl _)
  exact hcard ▸ fifteen_dvd_card_gal

end ArtinA5Even
